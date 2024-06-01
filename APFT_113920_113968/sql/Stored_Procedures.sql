USE [p5g5]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- Add Player Stored Procedure
CREATE PROCEDURE dbo.AddPlayer
    @name NVARCHAR(255),
    @age INT,
    @weight INT,
    @height INT,
    @nation NVARCHAR(255),
    @nation_league_id INT,
    @league NVARCHAR(255),
    @club NVARCHAR(255),
    @foot NVARCHAR(255),
    @value INT,
    @position NVARCHAR(255),
    @role NVARCHAR(255),
    @wage DECIMAL(18,2),
    @contract_end DATE,
    @release_clause INT,
    @attributes NVARCHAR(MAX),
    @url NVARCHAR(MAX)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @nation_id INT;
    DECLARE @league_id INT;
    DECLARE @club_id INT;
    DECLARE @player_id INT;
    DECLARE @position_id INT;
    DECLARE @role_id INT;
    DECLARE @player_type INT;

    -- Add or get Nation
    EXEC dbo.AddNation @nation = @nation;
    SELECT @nation_id = nation_id FROM Nation WHERE name = @nation;

    -- Add or get League
    EXEC dbo.AddLeague @league = @league, @nation = @nation_league_id;
    SELECT @league_id = league_id FROM League WHERE name = @league;

    -- Add or get Club
    EXEC dbo.AddClub @club = @club, @nation_id = @nation_league_id, @league_id = @league_id;
    SELECT @club_id = club_id FROM Club WHERE name = @club;

    -- Validate Position (UDF)
    SET @position_id = dbo.ValidatePosition(@position);
    IF @position_id IS NULL
    BEGIN
        RAISERROR('Position not found: %s', 16, 1, @position);
        RETURN;
    END

    -- Determine player type based on position
    IF @position = 'GK'
    BEGIN
        SET @player_type = 1;
    END
    ELSE
    BEGIN
        SET @player_type = 0;
    END

    -- Validate Role (UDF)
    SET @role_id = dbo.ValidateRole(@role);
    IF @role_id IS NULL
    BEGIN
        RAISERROR('Role not found: %s', 16, 1, @role);
        RETURN;
    END

    -- Add Base Player
    EXEC dbo.AddBasePlayer @name = @name, @age = @age, @weight = @weight, @height = @height, 
                           @nation_id = @nation_id, @club_id = @club_id, @foot = @foot, 
                           @value = @value, @player_type = @player_type, @url = @url;
    SELECT @player_id = player_id FROM Player WHERE name = @name;

    -- Add Contract
    EXEC dbo.AddContract @player_id = @player_id, @wage = @wage, @contract_end = @contract_end, @release_clause = @release_clause;

    -- Add Player Position
    EXEC dbo.AddPlayerPosition @position = @position_id, @player = @player_id;

    -- Add Player Role
    EXEC dbo.AddPlayerRole @role = @role_id, @player = @player_id;

    -- Add Player Attributes and Ratings
    IF @player_type = 0 -- Outfield Player
    BEGIN
        EXEC dbo.AddOutfieldAttributeRating @PlayerID = @player_id, @Attributes = @attributes;
    END
    ELSE -- Goalkeeper
    BEGIN
        EXEC dbo.AddGoalkeeperAttributeRating @PlayerID = @player_id, @Attributes = @attributes;
    END
END
GO


-- Add Nation Stored Procedure
CREATE PROCEDURE [dbo].[AddNation]
    @nation NVARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @nation_id INT;

    -- Check if the nation already exists
    SELECT @nation_id = nation_id FROM Nation WHERE name = @nation;
    
    -- If the nation does not exist, insert it
    IF @nation_id IS NULL
    BEGIN
        INSERT INTO Nation (name) VALUES (@nation);
        SET @nation_id = SCOPE_IDENTITY();
    END
END
GO


-- Add League Stored Procedure
create procedure [dbo].[AddLeague]
    @league nvarchar(255),
    @nation int
as
begin
    set nocount on;

    declare @nation_id int;
    declare @league_id int;

    -- Get Nation ID
    select @nation_id = nation_id from Nation where nation_id = @nation;
    if @nation_id is null
    begin
        raiserror('Nation not found: %d', 16, 1, @nation);
        return;
    end

    -- Get or insert league
    select @league_id = league_id from League where name = @league;
    if @league_id is null
    begin
        insert into League (name, nation_id) values (@league, @nation_id);
        set @league_id = scope_identity();
    end
end
go


-- Add Club Stored Procedure
CREATE PROCEDURE [dbo].[AddClub]
    @club NVARCHAR(255),
    @nation_id INT,
    @league_id INT
AS
BEGIN

   DECLARE @club_id INT;

   IF NOT EXISTS (SELECT 1 FROM League WHERE league_id = 0)
    BEGIN
        Raiserror('Nation id not valid',16,1);
    end

    SELECT @club_id = club_id FROM Club WHERE name = @club;
    IF @club_id IS NULL
    BEGIN
        INSERT INTO Club (name,league_id,nation_id) VALUES (@club, @league_id, @nation_id);
        SET @club_id = SCOPE_IDENTITY();
    END
END
GO


-- Add Base Player Stored Procedure
CREATE PROCEDURE [dbo].[AddBasePlayer]
    @name NVARCHAR(255),
    @age INT,
    @weight INT,
    @height INT,
    @nation_id INT,
    @club_id INT,
    @foot NVARCHAR(255),
    @value INT,
    @player_type INT,
    @url NVARCHAR(MAX)
AS
BEGIN
    IF EXISTS(SELECT 1 FROM Player WHERE name = @name)
    BEGIN
        Raiserror('Player Already Exists',16,1);
    END

    IF NOT EXISTS(SELECT 1 FROM Club WHERE club_id = @club_id)
    BEGIN
        Raiserror('Club Doesnt Exist',16,1);
    END

    IF NOT EXISTS(SELECT 1 FROM Nation WHERE nation_id = @nation_id)
        BEGIN
            Raiserror('Nation Doesnt Exist',16,1);
        END

    IF @height < 0 OR @age < 0 OR @weight < 0 OR @value < 0 OR @foot LIKE ''
    BEGIN
        Raiserror('Invalid Values',16,1);
    END

    DECLARE @player_id INT;

    SELECT @player_id = player_id FROM Player WHERE name = @name
    IF @player_id IS NULL
    BEGIN
        INSERT INTO Player (name, age, weight, height, nation_id, club_id, foot, value, url) VALUES (@name, @age, @weight, @height, @nation_id, @club_id, @foot, @value, @url);
        SET @player_id = SCOPE_IDENTITY();

        IF @player_type = 0
        BEGIN
            INSERT INTO Outfield_Player (player_id) VALUES (@player_id);
        end
        ELSE
        BEGIN
            INSERT INTO Goalkeeper (player_id) VALUES (@player_id);
        end
    END
END
GO


-- Add Contract Stored Procedure
CREATE PROCEDURE [dbo].[AddContract]
    @player_id INT,
    @wage decimal(18,2),
    @contract_end date,
    @release_clause INT
AS
BEGIN
    DECLARE @duration INT;
    DECLARE @currentYear INT
    DECLARE @endYear INT

    -- Get the current year
    SET @currentYear = YEAR(GETDATE())

    -- Get the year from the input date
    SET @endYear = YEAR(@contract_end)

    -- Calculate the difference
    SET @duration = @endYear - @currentYear

    IF EXISTS(SELECT 1 FROM Contract WHERE player_id = @player_id)
        BEGIN
            Raiserror('Player Already Has Contract',16,1);
        END

    IF @wage < 0 OR @release_clause < -2 OR @contract_end IS NULL
        BEGIN
            Raiserror('Invalid Values',16,1);
        END


    INSERT INTO Contract (player_id, wage, duration, contract_end, release_clause) VALUES (@player_id, @wage, @duration, @contract_end, @release_clause);
END
go


-- Add Player Position Stored Procedure
create procedure [dbo].[AddPlayerPosition]
    @position int,
    @player int
as
begin
    set nocount on;

    declare @position_id int;
    declare @player_id int;

    -- Get Position ID
    select @position_id = position_id from Position where position_id = @position;
    if @position_id is null
    begin
        raiserror('Position not found: %d', 16, 1, @position);
        return;
    end

    -- Get or insert player
    select @player_id = player_id from Player where player_id = @player;
    if @player_id is null
    begin
        raiserror('Player not found: %d', 16, 1, @player);
        return;
    end

    -- Get or insert player position
    if not exists (select * from PlayerPosition where player_id = @player_id and position_id = @position_id)
    begin
        insert into PlayerPosition (player_id, position_id) values (@player_id, @position_id);
    end
end
go

-- Add Player Role Stored Procedure
CREATE PROCEDURE [dbo].[AddPlayerRole]
    @role INT,
    @player INT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @role_id INT;
    DECLARE @player_id INT;

    -- Get Role ID
    SELECT @role_id = role_id FROM Role WHERE role_id = @role;
    IF @role_id IS NULL
    BEGIN
        RAISERROR('Role not found: %d', 16, 1, @role);
        RETURN;
    END

    -- Get Player ID
    SELECT @player_id = player_id FROM Player WHERE player_id = @player;
    IF @player_id IS NULL
    BEGIN
        RAISERROR('Player not found: %d', 16, 1, @player);
        RETURN;
    END

    -- Insert Player Role if not exists
    IF NOT EXISTS (SELECT * FROM PlayerRole WHERE player_id = @player_id AND role_position_id = @role_id)
    BEGIN
        INSERT INTO PlayerRole (player_id, role_position_id) VALUES (@player_id, @role_id);
    END
END
GO


-- Add Outfield Attribute Rating Stored Procedure
CREATE PROCEDURE dbo.AddOutfieldAttributeRating
(
    @PlayerID INT,
    @Attributes NVARCHAR(MAX)
)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;

        -- Verify and return attributes
        DECLARE @VerifiedAttributes TABLE (Attribute NVARCHAR(255), Rating INT)
        INSERT INTO @VerifiedAttributes
        SELECT Attribute, Rating
        FROM dbo.VerifyAndReturnAttributes(@Attributes) -- UDF

        -- Debugging: Print contents of @VerifiedAttributes
        PRINT 'Verified Attributes:'
        SELECT * FROM @VerifiedAttributes

        -- Ensure attributes exist in at least one of the attribute tables before inserting
        IF EXISTS (
            SELECT 1
            FROM @VerifiedAttributes AS VA
            WHERE NOT EXISTS (SELECT 1 FROM Technical_Att WHERE att_id = VA.Attribute)
              AND NOT EXISTS (SELECT 1 FROM Mental_Att WHERE att_id = VA.Attribute)
              AND NOT EXISTS (SELECT 1 FROM Physical_Att WHERE att_id = VA.Attribute)
        )
        BEGIN
            PRINT 'One or more attributes do not exist in the attribute tables.'
            ROLLBACK TRANSACTION;
            THROW 50002, 'One or more attributes do not exist in the attribute tables.', 1;
        END

        -- Insert into OutfieldAttributeRating
        INSERT INTO OutfieldAttributeRating (att_id, player_id, rating)
        SELECT Attribute, @PlayerID, Rating
        FROM @VerifiedAttributes

        -- Verify all attributes from Technical_Att, Mental_Att, and Physical_Att are present
        DECLARE @MissingTechnicalAtt TABLE (att_id NVARCHAR(255))
        DECLARE @MissingMentalAtt TABLE (att_id NVARCHAR(255))
        DECLARE @MissingPhysicalAtt TABLE (att_id NVARCHAR(255))

        -- Find missing technical attributes
        INSERT INTO @MissingTechnicalAtt
        SELECT att_id
        FROM Technical_Att
        WHERE att_id NOT IN (SELECT Attribute FROM @VerifiedAttributes)

        -- Find missing mental attributes
        INSERT INTO @MissingMentalAtt
        SELECT att_id
        FROM Mental_Att
        WHERE att_id NOT IN (SELECT Attribute FROM @VerifiedAttributes)

        -- Find missing physical attributes
        INSERT INTO @MissingPhysicalAtt
        SELECT att_id
        FROM Physical_Att
        WHERE att_id NOT IN (SELECT Attribute FROM @VerifiedAttributes)

        -- Print the contents of the missing attribute tables
        PRINT 'Missing Technical Attributes:'
        SELECT * FROM @MissingTechnicalAtt

        PRINT 'Missing Mental Attributes:'
        SELECT * FROM @MissingMentalAtt

        PRINT 'Missing Physical Attributes:'
        SELECT * FROM @MissingPhysicalAtt

        -- Check if any attributes are missing
        IF (SELECT COUNT(*) FROM @MissingTechnicalAtt) > 0
           OR (SELECT COUNT(*) FROM @MissingMentalAtt) > 0
           OR (SELECT COUNT(*) FROM @MissingPhysicalAtt) > 0
        BEGIN
            -- Display missing attributes
            SELECT 'Missing Technical Attributes' AS AttributeType, att_id AS MissingAttribute FROM @MissingTechnicalAtt
            UNION ALL
            SELECT 'Missing Mental Attributes' AS AttributeType, att_id AS MissingAttribute FROM @MissingMentalAtt
            UNION ALL
            SELECT 'Missing Physical Attributes' AS AttributeType, att_id AS MissingAttribute FROM @MissingPhysicalAtt

            ROLLBACK TRANSACTION;
            THROW 50003, 'Not all required attributes were inserted.', 1;
        END

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END
GO


-- Add Goalkeeper Attribute Rating Stored Procedure
CREATE PROCEDURE dbo.AddGoalkeeperAttributeRating
(
    @PlayerID INT,
    @Attributes NVARCHAR(MAX)
)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;

        -- Verify and return attributes
        DECLARE @VerifiedAttributes TABLE (Attribute NVARCHAR(255), Rating INT)
        INSERT INTO @VerifiedAttributes
        SELECT Attribute, Rating
        FROM dbo.VerifyAndReturnAttributes(@Attributes) -- UDF

        -- Debugging: Print contents of @VerifiedAttributes
        PRINT 'Verified Attributes:'
        SELECT * FROM @VerifiedAttributes

        -- Ensure attributes exist in at least one of the attribute tables before inserting
        IF EXISTS (
            SELECT 1
            FROM @VerifiedAttributes AS VA
            WHERE NOT EXISTS (SELECT 1 FROM Goalkeeping_ATT WHERE att_id = VA.Attribute)
              AND NOT EXISTS (SELECT 1 FROM Mental_ATT WHERE att_id = VA.Attribute)
              AND NOT EXISTS (SELECT 1 FROM Physical_ATT WHERE att_id = VA.Attribute)
        )
        BEGIN
            PRINT 'One or more attributes do not exist in the attribute tables.'
            ROLLBACK TRANSACTION;
            THROW 50002, 'One or more attributes do not exist in the attribute tables.', 1;
        END

        -- Insert into GoalkeeperAttributeRating
        INSERT INTO GoalkeeperAttributeRating (att_id, player_id, rating)
        SELECT Attribute, @PlayerID, Rating
        FROM @VerifiedAttributes

        -- Verify all attributes from Goalkeeping_ATT, Mental_ATT, and Physical_ATT are present
        DECLARE @MissingGoalkeepingAtt TABLE (att_id NVARCHAR(255))
        DECLARE @MissingMentalAtt TABLE (att_id NVARCHAR(255))
        DECLARE @MissingPhysicalAtt TABLE (att_id NVARCHAR(255))

        -- Find missing goalkeeping attributes
        INSERT INTO @MissingGoalkeepingAtt
        SELECT att_id
        FROM Goalkeeping_ATT
        WHERE att_id NOT IN (SELECT Attribute FROM @VerifiedAttributes)

        -- Find missing mental attributes
        INSERT INTO @MissingMentalAtt
        SELECT att_id
        FROM Mental_ATT
        WHERE att_id NOT IN (SELECT Attribute FROM @VerifiedAttributes)

        -- Find missing physical attributes
        INSERT INTO @MissingPhysicalAtt
        SELECT att_id
        FROM Physical_ATT
        WHERE att_id NOT IN (SELECT Attribute FROM @VerifiedAttributes)

        -- Print the contents of the missing attribute tables
        PRINT 'Missing Goalkeeping Attributes:'
        SELECT * FROM @MissingGoalkeepingAtt

        PRINT 'Missing Mental Attributes:'
        SELECT * FROM @MissingMentalAtt

        PRINT 'Missing Physical Attributes:'
        SELECT * FROM @MissingPhysicalAtt

        -- Check if any attributes are missing
        IF (SELECT COUNT(*) FROM @MissingGoalkeepingAtt) > 0
           OR (SELECT COUNT(*) FROM @MissingMentalAtt) > 0
           OR (SELECT COUNT(*) FROM @MissingPhysicalAtt) > 0
        BEGIN
            -- Display missing attributes
            SELECT 'Missing Goalkeeping Attributes' AS AttributeType, att_id AS MissingAttribute FROM @MissingGoalkeepingAtt
            UNION ALL
            SELECT 'Missing Mental Attributes' AS AttributeType, att_id AS MissingAttribute FROM @MissingMentalAtt
            UNION ALL
            SELECT 'Missing Physical Attributes' AS AttributeType, att_id AS MissingAttribute FROM @MissingPhysicalAtt

            ROLLBACK TRANSACTION;
            THROW 50003, 'Not all required attributes were inserted.', 1;
        END

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END
GO


---- Stored Procedures For StaredPlayer Table ----
-- AddStaredPlayer Stored Procedure
CREATE PROCEDURE dbo.AddStaredPlayer
(
    @PlayerID INT
)
AS
BEGIN
    SET NOCOUNT ON;

    -- Verifica se o jogador já está na lista de favoritos
    IF EXISTS (SELECT 1 FROM StaredPlayers WHERE player_id = @PlayerID)
    BEGIN
        PRINT 'Player is already in the stared players list.';
        RETURN;
    END

    -- Insere o jogador na lista de favoritos
    INSERT INTO StaredPlayers (player_id)
    VALUES (@PlayerID);

    PRINT 'Player successfully added to the stared players list.';
END;
GO


-- RemoveStaredPlayer Stored Procedure
CREATE PROCEDURE dbo.RemoveStaredPlayer
(
    @PlayerID INT
)
AS
BEGIN
    SET NOCOUNT ON;

    -- Verifica se o jogador está na lista de favoritos
    IF NOT EXISTS (SELECT 1 FROM StaredPlayers WHERE player_id = @PlayerID)
    BEGIN
        PRINT 'Player is not in the stared players list.';
        RETURN;
    END

    -- Remove o jogador da lista de favoritos
    DELETE FROM StaredPlayers
    WHERE player_id = @PlayerID;

    PRINT 'Player successfully removed from the stared players list.';
END;
GO
