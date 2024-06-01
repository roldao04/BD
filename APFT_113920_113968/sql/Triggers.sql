USE [p5g5]
GO

--- Trigger for Player Insertion
CREATE TRIGGER trg_after_insert_players
ON Player
AFTER INSERT
AS
BEGIN
    DECLARE @club_id INT;
    DECLARE @total_players INT;
    DECLARE @total_wage DECIMAL(18, 2);
    DECLARE @total_value DECIMAL(18, 2);
    DECLARE @avg_att DECIMAL(18, 2);

    -- Get the club_id from the inserted row
    SELECT @club_id = club_id
    FROM INSERTED;

    -- Calculate the new totals
    SELECT @total_players = COUNT(*), 
           @total_wage = SUM(PC.wage), 
           @total_value = SUM(P.value)
    FROM Player P
    JOIN PlayerContract PC ON P.player_id = PC.player_id
    WHERE P.club_id = @club_id;

    -- Calculate the average attribute rating combining outfield and goalkeeper ratings
    SELECT @avg_att = AVG(CASE 
                            WHEN oa.rating IS NOT NULL THEN oa.rating 
                            ELSE ga.rating 
                          END)
    FROM Player P
    LEFT JOIN OutfieldAttributeRating oa ON P.player_id = oa.player_id
    LEFT JOIN GoalkeeperAttributeRating ga ON P.player_id = ga.player_id
    WHERE P.club_id = @club_id;

    -- Handle case where there are no players
    IF @total_players = 0 
    BEGIN
        SET @total_wage = 0;
        SET @total_value = 0;
        SET @avg_att = 0;
    END

    -- Update Club table
    UPDATE Club
    SET player_count = @total_players,
        wage_total = @total_wage,
        value_total = @total_value,
        wage_average = CASE WHEN @total_players > 0 THEN @total_wage / @total_players ELSE 0 END,
        value_average = CASE WHEN @total_players > 0 THEN @total_value / @total_players ELSE 0 END,
        avg_att = @avg_att
    WHERE club_id = @club_id;
END;
GO


--- Trigger for Player Deletion
CREATE TRIGGER trg_after_delete_players
ON Player
INSTEAD OF DELETE
AS
BEGIN
    DECLARE @player_id INT;

    -- Loop through each player to be deleted
    DECLARE deleted_player_cursor CURSOR FOR
    SELECT player_id FROM DELETED;

    OPEN deleted_player_cursor;

    FETCH NEXT FROM deleted_player_cursor INTO @player_id;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- Delete associated entries from dependent tables
        DELETE FROM Contract WHERE player_id = @player_id;
        DELETE FROM PlayerRole WHERE player_id = @player_id;
        DELETE FROM PlayerPosition WHERE player_id = @player_id;
        DELETE FROM Outfield_Player WHERE player_id = @player_id;
        DELETE FROM Goalkeeper WHERE player_id = @player_id;
        DELETE FROM OutfieldAttributeRating WHERE player_id = @player_id;
        DELETE FROM GoalkeeperAttributeRating WHERE player_id = @player_id;
        DELETE FROM StaredPlayers WHERE player_id = @player_id;

        -- Finally, delete the player record
        DELETE FROM Player WHERE player_id = @player_id;

        FETCH NEXT FROM deleted_player_cursor INTO @player_id;
    END

    CLOSE deleted_player_cursor;
    DEALLOCATE deleted_player_cursor;
END;
GO


--- Trigger for Club Deletion
CREATE TRIGGER trg_after_delete_club
ON Club
INSTEAD OF DELETE
AS
BEGIN
    DECLARE @club_id INT;

    -- Loop through each club to be deleted
    DECLARE deleted_club_cursor CURSOR FOR
    SELECT club_id FROM DELETED;

    OPEN deleted_club_cursor;

    FETCH NEXT FROM deleted_club_cursor INTO @club_id;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- Delete associated players first
        DELETE FROM Player WHERE club_id = @club_id;

        -- Finally, delete the club record
        DELETE FROM Club WHERE club_id = @club_id;

        FETCH NEXT FROM deleted_club_cursor INTO @club_id;
    END

    CLOSE deleted_club_cursor;
    DEALLOCATE deleted_club_cursor;
END;
GO


--- Trigger for League Deletion
CREATE TRIGGER trg_after_delete_league
ON League
INSTEAD OF DELETE
AS
BEGIN
    DECLARE @league_id INT;

    -- Loop through each league to be deleted
    DECLARE deleted_league_cursor CURSOR FOR
    SELECT league_id FROM DELETED;

    OPEN deleted_league_cursor;

    FETCH NEXT FROM deleted_league_cursor INTO @league_id;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- Delete associated clubs (and their players) first
        DELETE FROM Club WHERE league_id = @league_id;

        -- Finally, delete the league record
        DELETE FROM League WHERE league_id = @league_id;

        FETCH NEXT FROM deleted_league_cursor INTO @league_id;
    END

    CLOSE deleted_league_cursor;
    DEALLOCATE deleted_league_cursor;
END;
GO


--- Trigger for Nation Deletion
CREATE TRIGGER trg_after_delete_nation
ON Nation
AFTER DELETE
AS
BEGIN
    -- Declare variables
    DECLARE @nation_id INT;

    -- Loop through each deleted nation
    DECLARE deleted_nation_cursor CURSOR FOR
    SELECT nation_id FROM DELETED;

    OPEN deleted_nation_cursor;

    FETCH NEXT FROM deleted_nation_cursor INTO @nation_id;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- Delete players of the nation
        DELETE FROM Player WHERE nation_id = @nation_id;

        -- Delete the clubs of the nation
        DELETE FROM Club WHERE nation_id = @nation_id;

        -- Delete the leagues of the nation
        DELETE FROM League WHERE nation_id = @nation_id;

        -- Delete the nation
        DELETE FROM Nation WHERE nation_id = @nation_id;

        FETCH NEXT FROM deleted_nation_cursor INTO @nation_id;
    END

    CLOSE deleted_nation_cursor;
    DEALLOCATE deleted_nation_cursor;
END;
GO

