USE [p5g5]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

---- UDFs for addPlayer Stored Procedure ----
--- ValidatePosition Function
CREATE FUNCTION [dbo].[ValidatePosition]
(
    @position NVARCHAR(255)
)
RETURNS INT
AS
BEGIN
    DECLARE @position_id INT;

    -- Validate position
    SELECT @position_id = position_id FROM Position WHERE name = @position;

    -- Return position_id (NULL if not found)
    RETURN @position_id;
END
GO


--- ValidateRole Function
CREATE FUNCTION [dbo].[ValidateRole]
(
    @role NVARCHAR(255)
)
RETURNS INT
AS
BEGIN
    DECLARE @role_id INT;

    -- Validate role
    SELECT @role_id = role_id FROM Role WHERE name = @role;

    -- Return role_id (NULL if not found)
    RETURN @role_id;
END
GO


--- Validate and Return Attributes
CREATE FUNCTION dbo.VerifyAndReturnAttributes
(
    @Attributes NVARCHAR(MAX)
)
RETURNS @Result TABLE (Attribute NVARCHAR(255), Rating INT)
AS
BEGIN
    DECLARE @Pairs TABLE (Pair NVARCHAR(255))
    INSERT INTO @Pairs
    SELECT Item FROM dbo.SplitString(@Attributes, ',')

    DECLARE @Pair NVARCHAR(255), @Attribute NVARCHAR(255), @Rating INT

    DECLARE pair_cursor CURSOR FOR
    SELECT Pair FROM @Pairs

    OPEN pair_cursor
    FETCH NEXT FROM pair_cursor INTO @Pair

    WHILE @@FETCH_STATUS = 0
    BEGIN
        SET @Attribute = SUBSTRING(@Pair, 1, CHARINDEX(':', @Pair) - 1)
        SET @Rating = CAST(SUBSTRING(@Pair, CHARINDEX(':', @Pair) + 1, LEN(@Pair) - CHARINDEX(':', @Pair)) AS INT)

        IF EXISTS (SELECT 1 FROM Attribute WHERE name = @Attribute)
        BEGIN
            INSERT INTO @Result (Attribute, Rating)
            VALUES (@Attribute, @Rating)
        END

        FETCH NEXT FROM pair_cursor INTO @Pair
    END

    CLOSE pair_cursor
    DEALLOCATE pair_cursor

    RETURN
END
GO


--- SplitString Function
CREATE FUNCTION dbo.SplitString
(
    @Input NVARCHAR(MAX),
    @Delimiter CHAR(1)
)
RETURNS @Output TABLE (Item NVARCHAR(255))
AS
BEGIN
    DECLARE @Start INT, @End INT
    SELECT @Start = 1, @End = CHARINDEX(@Delimiter, @Input)
    WHILE @Start < LEN(@Input) + 1 BEGIN
        IF @End = 0  
            SET @End = LEN(@Input) + 1
        INSERT INTO @Output (Item)  
        VALUES(SUBSTRING(@Input, @Start, @End - @Start))
        SET @Start = @End + 1
        SET @End = CHARINDEX(@Delimiter, @Input, @Start)
    END
    RETURN
END
GO



---- UDFs to Get Information ----
--- GetPlayerById Function
CREATE FUNCTION dbo.GetPlayerById
(
    @player_id INT
)
RETURNS TABLE
RETURN
    (
        SELECT
        p.*,
        c.wage,
        c.contract_end,
        c.duration,
        c.release_clause,

        cl.name AS club_name,

        n.name AS nation_name,

        l.name AS league_name

    FROM
        Player p
    INNER JOIN
        Contract c ON p.player_id = c.player_id
    INNER JOIN
        Club cl ON p.club_id = cl.club_id
    INNER JOIN
        Nation n ON p.nation_id = n.nation_id
    INNER JOIN
        League l ON cl.league_id = l.league_id
    WHERE
        p.player_id = @player_id
    )
GO


--- GetPlayerAttributes Function
CREATE FUNCTION dbo.GetPlayerAttributes(
    @player_id INT
)
RETURNS @PlayerAttributes TABLE (
    att_id INT,
    rating INT
)
AS
BEGIN
    -- Insert into the return table from OutfieldAttributeRating
    INSERT INTO @PlayerAttributes (att_id, rating)
    SELECT
        our.att_id,
        our.rating
    FROM OutfieldAttributeRating our
    INNER JOIN Attribute attributes ON
        attributes.name = our.att_id
    WHERE our.player_id = @player_id;

    -- If the OutfieldAttributeRating selection is null, insert from GoalkeeperAttributeRating
    IF NOT EXISTS (SELECT 1 FROM @PlayerAttributes)
    BEGIN
        INSERT INTO @PlayerAttributes (att_id, rating)
        SELECT
            gar.att_id,
            gar.rating
        FROM GoalkeeperAttributeRating gar
        INNER JOIN Attribute attributes ON
            attributes.name = gar.att_id
        WHERE gar.player_id = @player_id;
    END

    RETURN;
END
GO


--- GetClubById Function
CREATE FUNCTION dbo.GetClubByID
(
    @ClubID INT
)
RETURNS TABLE
AS
RETURN
(
    SELECT
        c.club_id,
        c.name AS club_name,
        l.name AS league_name,
        n.name AS nation_name,
        c.player_count,
        c.value_total,
        c.wage_total,
        c.value_average,
        c.wage_average,
        c.avg_att
    FROM
        Club c
    INNER JOIN
        League l ON c.league_id = l.league_id
    INNER JOIN
        Nation n ON c.nation_id = n.nation_id
    WHERE
        c.club_id = @ClubID
)
GO


--- GetLeagueById Function
CREATE FUNCTION dbo.getLeagueById
(
    @LeagueID INT
)
RETURNS TABLE
AS
RETURN
(
    SELECT
        l.league_id,
        l.name AS league_name,
        n.name AS nation_name,
        COUNT(DISTINCT c.club_id) AS total_clubs,
        COUNT(DISTINCT p.player_id) AS total_players,
        SUM(c.value_total) AS total_value,
        SUM(c.wage_total) AS total_wage,
        AVG(c.avg_att) AS avg_att
    FROM
        League l
        INNER JOIN Club c ON l.league_id = c.league_id
        INNER JOIN Player p ON c.club_id = p.club_id
        INNER JOIN Nation n ON l.nation_id = n.nation_id
    WHERE
        l.league_id = @LeagueID
    GROUP BY
        l.league_id,
        l.name,
        n.name
)
GO


--- GetNationById Function
CREATE FUNCTION dbo.GetNationByID
(
    @NationID INT
)
RETURNS @Result TABLE
(
    nation_id INT,
    nation_name NVARCHAR(255),
    total_leagues INT,
    league_names NVARCHAR(MAX),
    total_player_value DECIMAL(18, 2)
)
AS
BEGIN
    -- Insert aggregated results into the result table
    INSERT INTO @Result
    SELECT
        n.nation_id,
        n.name AS nation_name,
        COUNT(DISTINCT l.league_id) AS total_leagues,
        COALESCE(
            (
                SELECT STRING_AGG(name, ', ') AS league_names
                FROM (
                    SELECT DISTINCT l.name
                    FROM League l
                    WHERE l.nation_id = n.nation_id
                ) AS sub
            ), 
            ''
        ) AS league_names,
        SUM(p.value) AS total_player_value
    FROM
        Nation n
    LEFT JOIN
        League l ON n.nation_id = l.nation_id
    LEFT JOIN
        Player p ON p.nation_id = n.nation_id
    WHERE
        n.nation_id = @NationID
    GROUP BY
        n.nation_id, n.name;

    RETURN;
END;
GO


--- GetRoleByPlayerId Function
CREATE FUNCTION dbo.GetRoleByPlayerID
(
    @PlayerID INT
)
RETURNS TABLE
AS
RETURN
(
    SELECT
        r.role_id AS RoleID,
        r.name AS RoleName
    FROM
        Player p
    INNER JOIN
        PlayerRole playrole ON playrole.player_id = p.player_id
    INNER JOIN
        Role r ON r.role_id = playrole.role_position_id
    WHERE
        p.player_id = @PlayerID
)
GO


--- GetRolesByPositionID Function
CREATE FUNCTION dbo.GetRolesByPositionID
(
    @position_id INT
)
RETURNS TABLE
AS
RETURN
(
    SELECT DISTINCT
        r.role_id AS RoleID,
        r.name AS RoleName
    FROM
        RolePosition rp
    INNER JOIN
        ROLE r ON rp.role_position = r.role_id
    WHERE
        rp.position_id = @position_id
)
GO


--- GetPositionByPlayerID Function
CREATE FUNCTION dbo.GetPositionByPlayerID
(
    @PlayerID INT
)
RETURNS TABLE
AS
RETURN
(
    SELECT
        pos.position_id AS PositionID,
        pos.name AS PositionName
    FROM
        Player p
    INNER JOIN
        PlayerPosition playpos ON playpos.player_id = p.player_id
    INNER JOIN
        Position pos ON pos.position_id = playpos.position_id
    WHERE
        p.player_id = @PlayerID
)
GO


--- GetKeyAttByRoleID Function
CREATE FUNCTION dbo.GetKeyAttributesByRoleID
(
    @role_id INT
)
RETURNS TABLE
AS
RETURN
(
    SELECT
        ka.role_id AS RoleID,
        ka.attribute_id AS KeyAttributeID
    FROM
        KeyAttributes ka
    WHERE
        ka.role_id = @role_id
)
GO



---- UDFs for Pagination ----
--- GetPlayersWithPagination Function
CREATE FUNCTION dbo.GetPlayersWithPagination
(
    @PageNumber INT,
    @PageSize INT,
    @OrderBy NVARCHAR(50) = NULL,
    @OrderDirection NVARCHAR(4) = NULL,
    @SearchPlayerName NVARCHAR(255) = NULL,
    @SearchClubName NVARCHAR(255) = NULL,
    @SearchPositionName NVARCHAR(255) = NULL,
    @SearchNationName NVARCHAR(255) = NULL,
    @SearchLeagueName NVARCHAR(255) = NULL,
    @MinWage DECIMAL(18,2) = NULL,
    @MaxWage DECIMAL(18,2) = NULL,
    @MinValue DECIMAL(18,2) = NULL,
    @MaxValue DECIMAL(18,2) = NULL,
    @MinAge INT = NULL,
    @MaxAge INT = NULL,
    @MinReleaseClause DECIMAL(18,2) = NULL,
    @MaxReleaseClause DECIMAL(18,2) = NULL
)
RETURNS TABLE
AS
RETURN
(
    SELECT 
        PlayerID,
        PlayerName,
        Position,
        Club,
        Wage,
        Value,
        Nation,
        League,
        Age,
        ReleaseClause
    FROM
    (
        SELECT
            p.player_id AS PlayerID,
            p.name AS PlayerName,
            pos.name AS Position,
            cl.name AS Club,
            c.wage AS Wage,
            p.value AS Value,
            n.name AS Nation,
            l.name AS League,
            p.age AS Age,
            c.release_clause AS ReleaseClause,
            ROW_NUMBER() OVER (
                ORDER BY
                    CASE WHEN @OrderBy = 'PlayerName' AND @OrderDirection = 'ASC' THEN p.name END ASC,
                    CASE WHEN @OrderBy = 'PlayerName' AND @OrderDirection = 'DESC' THEN p.name END DESC,
                    CASE WHEN @OrderBy = 'Age' AND @OrderDirection = 'ASC' THEN p.age END ASC,
                    CASE WHEN @OrderBy = 'Age' AND @OrderDirection = 'DESC' THEN p.age END DESC,
                    CASE WHEN @OrderBy = 'Position' AND @OrderDirection = 'ASC' THEN pos.name END ASC,
                    CASE WHEN @OrderBy = 'Position' AND @OrderDirection = 'DESC' THEN pos.name END DESC,
                    CASE WHEN @OrderBy = 'Club' AND @OrderDirection = 'ASC' THEN cl.name END ASC,
                    CASE WHEN @OrderBy = 'Club' AND @OrderDirection = 'DESC' THEN cl.name END DESC,
                    CASE WHEN @OrderBy = 'Wage' AND @OrderDirection = 'ASC' THEN c.wage END ASC,
                    CASE WHEN @OrderBy = 'Wage' AND @OrderDirection = 'DESC' THEN c.wage END DESC,
                    CASE WHEN @OrderBy = 'Value' AND @OrderDirection = 'ASC' THEN p.value END ASC,
                    CASE WHEN @OrderBy = 'Value' AND @OrderDirection = 'DESC' THEN p.value END DESC,
                    CASE WHEN @OrderBy = 'Nation' AND @OrderDirection = 'ASC' THEN n.name END ASC,
                    CASE WHEN @OrderBy = 'Nation' AND @OrderDirection = 'DESC' THEN n.name END DESC,
                    CASE WHEN @OrderBy = 'League' AND @OrderDirection = 'ASC' THEN l.name END ASC,
                    CASE WHEN @OrderBy = 'League' AND @OrderDirection = 'DESC' THEN l.name END DESC,
                    -- Default order
                    p.player_id
            ) AS RowNum
        FROM
            Player p
        INNER JOIN
            PlayerPosition playpos ON playpos.player_id = p.player_id
        INNER JOIN
            Position pos ON pos.position_id = playpos.position_id
        INNER JOIN
            Club cl ON p.club_id = cl.club_id
        INNER JOIN
            Contract c ON p.player_id = c.player_id
        INNER JOIN
            Nation n ON p.nation_id = n.nation_id
        INNER JOIN
            League l ON cl.league_id = l.league_id
        WHERE
            (@SearchPlayerName IS NULL OR p.name LIKE '%' + @SearchPlayerName + '%')
            AND (@SearchClubName IS NULL OR cl.name LIKE '%' + @SearchClubName + '%')
            AND (@SearchPositionName IS NULL OR pos.name LIKE '%' + @SearchPositionName + '%')
            AND (@SearchNationName IS NULL OR n.name LIKE '%' + @SearchNationName + '%')
            AND (@SearchLeagueName IS NULL OR l.name LIKE '%' + @SearchLeagueName + '%')
            AND (@MinWage IS NULL OR c.wage >= @MinWage)
            AND (@MaxWage IS NULL OR c.wage <= @MaxWage)
            AND (@MinValue IS NULL OR p.value >= @MinValue)
            AND (@MaxValue IS NULL OR p.value <= @MaxValue)
            AND (@MinAge IS NULL OR p.age >= @MinAge)
            AND (@MaxAge IS NULL OR p.age <= @MaxAge)
            AND (@MinReleaseClause IS NULL OR c.release_clause >= @MinReleaseClause)
            AND (@MaxReleaseClause IS NULL OR c.release_clause <= @MaxReleaseClause)
    ) AS PlayersWithRowNum
    WHERE
        RowNum > (@PageNumber - 1) * @PageSize
        AND RowNum <= @PageNumber * @PageSize
)
GO
       

--- GetClubsWithPagination Function
CREATE FUNCTION dbo.GetClubsWithPagination
(
    @PageNumber INT,
    @PageSize INT,
    @OrderBy NVARCHAR(50) = NULL,
    @OrderDirection NVARCHAR(4) = NULL,
    @SearchClubName NVARCHAR(255) = NULL,
    @SearchLeagueName NVARCHAR(255) = NULL,
    @SearchNationName NVARCHAR(255) = NULL,
    @MinPlayerCount INT = NULL,
    @MaxPlayerCount INT = NULL,
    @MinWageTotal DECIMAL(18,2) = NULL,
    @MaxWageTotal DECIMAL(18,2) = NULL,
    @MinValueTotal DECIMAL(18,2) = NULL,
    @MaxValueTotal DECIMAL(18,2) = NULL
)
RETURNS TABLE
AS
RETURN
(
    SELECT 
        ClubID,
        ClubName,
        Nation,
        League,
        PlayerCount,
        WageTotal,
        ValueTotal
    FROM
    (
        SELECT
            c.club_id AS ClubID,
            c.name AS ClubName,
            n.name AS Nation,
            l.name AS League,
            c.player_count AS PlayerCount,
            c.wage_total AS WageTotal,
            c.value_total AS ValueTotal,
            ROW_NUMBER() OVER (
                ORDER BY
                    CASE WHEN @OrderBy = 'ClubName' AND @OrderDirection = 'ASC' THEN c.name END ASC,
                    CASE WHEN @OrderBy = 'ClubName' AND @OrderDirection = 'DESC' THEN c.name END DESC,
                    CASE WHEN @OrderBy = 'Nation' AND @OrderDirection = 'ASC' THEN n.name END ASC,
                    CASE WHEN @OrderBy = 'Nation' AND @OrderDirection = 'DESC' THEN n.name END DESC,
                    CASE WHEN @OrderBy = 'League' AND @OrderDirection = 'ASC' THEN l.name END ASC,
                    CASE WHEN @OrderBy = 'League' AND @OrderDirection = 'DESC' THEN l.name END DESC,
                    CASE WHEN @OrderBy = 'PlayerCount' AND @OrderDirection = 'ASC' THEN c.player_count END ASC,
                    CASE WHEN @OrderBy = 'PlayerCount' AND @OrderDirection = 'DESC' THEN c.player_count END DESC,
                    CASE WHEN @OrderBy = 'WageTotal' AND @OrderDirection = 'ASC' THEN c.wage_total END ASC,
                    CASE WHEN @OrderBy = 'WageTotal' AND @OrderDirection = 'DESC' THEN c.wage_total END DESC,
                    CASE WHEN @OrderBy = 'ValueTotal' AND @OrderDirection = 'ASC' THEN c.value_total END ASC,
                    CASE WHEN @OrderBy = 'ValueTotal' AND @OrderDirection = 'DESC' THEN c.value_total END DESC,
                    -- Default order
                    c.club_id
            ) AS RowNum
        FROM
            Club c
        INNER JOIN
            Nation n ON c.nation_id = n.nation_id
        INNER JOIN
            League l ON c.league_id = l.league_id
        WHERE
            (@SearchClubName IS NULL OR c.name LIKE '%' + @SearchClubName + '%')
            AND (@SearchLeagueName IS NULL OR l.name LIKE '%' + @SearchLeagueName + '%')
            AND (@SearchNationName IS NULL OR n.name LIKE '%' + @SearchNationName + '%')
            AND (@MinPlayerCount IS NULL OR c.player_count >= @MinPlayerCount)
            AND (@MaxPlayerCount IS NULL OR c.player_count <= @MaxPlayerCount)
            AND (@MinWageTotal IS NULL OR c.wage_total >= @MinWageTotal)
            AND (@MaxWageTotal IS NULL OR c.wage_total <= @MaxWageTotal)
            AND (@MinValueTotal IS NULL OR c.value_total >= @MinValueTotal)
            AND (@MaxValueTotal IS NULL OR c.value_total <= @MaxValueTotal)
    ) AS ClubsWithRowNum
    WHERE
        RowNum > (@PageNumber - 1) * @PageSize
        AND RowNum <= @PageNumber * @PageSize
)
GO


--- GetLeaguesWithPagination Function
CREATE FUNCTION dbo.GetLeaguesWithPagination
(
    @PageNumber INT,
    @PageSize INT,
    @OrderBy NVARCHAR(50) = NULL,
    @OrderDirection NVARCHAR(4) = NULL,
    @SearchLeagueName NVARCHAR(255) = NULL,
    @SearchNationName NVARCHAR(255) = NULL,
    @MinValueTotal DECIMAL(18,2) = NULL,
    @MaxValueTotal DECIMAL(18,2) = NULL
)
RETURNS TABLE
AS
RETURN
(
    SELECT 
        LeagueID,
        LeagueName,
        Nation,
        ValueTotal
    FROM
    (
        SELECT
            l.league_id AS LeagueID,
            l.name AS LeagueName,
            n.name AS Nation,
            SUM(c.value_total) AS ValueTotal,
            ROW_NUMBER() OVER (
                ORDER BY
                    CASE WHEN @OrderBy = 'LeagueName' AND @OrderDirection = 'ASC' THEN l.name END ASC,
                    CASE WHEN @OrderBy = 'LeagueName' AND @OrderDirection = 'DESC' THEN l.name END DESC,
                    CASE WHEN @OrderBy = 'Nation' AND @OrderDirection = 'ASC' THEN n.name END ASC,
                    CASE WHEN @OrderBy = 'Nation' AND @OrderDirection = 'DESC' THEN n.name END DESC,
                    CASE WHEN @OrderBy = 'ValueTotal' AND @OrderDirection = 'ASC' THEN SUM(c.value_total) END ASC,
                    CASE WHEN @OrderBy = 'ValueTotal' AND @OrderDirection = 'DESC' THEN SUM(c.value_total) END DESC,
                    -- Default order
                    l.league_id
            ) AS RowNum
        FROM
            League l
        INNER JOIN
            Nation n ON l.nation_id = n.nation_id
        LEFT JOIN
            Club c ON l.league_id = c.league_id
        WHERE
            (@SearchLeagueName IS NULL OR l.name LIKE '%' + @SearchLeagueName + '%')
            AND (@SearchNationName IS NULL OR n.name LIKE '%' + @SearchNationName + '%')
        GROUP BY
            l.league_id, l.name, n.name
        HAVING
            (@MinValueTotal IS NULL OR SUM(c.value_total) >= @MinValueTotal)
            AND (@MaxValueTotal IS NULL OR SUM(c.value_total) <= @MaxValueTotal)
    ) AS LeaguesWithRowNum
    WHERE
        RowNum > (@PageNumber - 1) * @PageSize
        AND RowNum <= @PageNumber * @PageSize
)
GO


--- GetNationsWithPagination Function
CREATE FUNCTION dbo.GetNationsWithPagination
(
    @PageNumber INT,
    @PageSize INT,
    @OrderBy NVARCHAR(50) = NULL,
    @OrderDirection NVARCHAR(4) = NULL,
    @SearchNationName NVARCHAR(255) = NULL,
    @MinValueTotal DECIMAL(18,2) = NULL,
    @MaxValueTotal DECIMAL(18,2) = NULL
)
RETURNS TABLE
AS
RETURN
(
    SELECT 
        NationID,
        NationName,
        ValueTotal
    FROM
    (
        SELECT
            n.nation_id AS NationID,
            n.name AS NationName,
            SUM(p.value) AS ValueTotal,
            ROW_NUMBER() OVER (
                ORDER BY
                    CASE WHEN @OrderBy = 'NationName' AND @OrderDirection = 'ASC' THEN n.name END ASC,
                    CASE WHEN @OrderBy = 'NationName' AND @OrderDirection = 'DESC' THEN n.name END DESC,
                    CASE WHEN @OrderBy = 'ValueTotal' AND @OrderDirection = 'ASC' THEN SUM(p.value) END ASC,
                    CASE WHEN @OrderBy = 'ValueTotal' AND @OrderDirection = 'DESC' THEN SUM(p.value) END DESC,
                    -- Default order
                    n.nation_id
            ) AS RowNum
        FROM
            Nation n
        LEFT JOIN
            Player p ON p.nation_id = n.nation_id
        WHERE
            (@SearchNationName IS NULL OR n.name LIKE '%' + @SearchNationName + '%')
        GROUP BY
            n.nation_id, n.name
        HAVING
            (@MinValueTotal IS NULL OR SUM(p.value) >= @MinValueTotal)
            AND (@MaxValueTotal IS NULL OR SUM(p.value) <= @MaxValueTotal)
    ) AS NationsWithRowNum
    WHERE
        RowNum > (@PageNumber - 1) * @PageSize
        AND RowNum <= @PageNumber * @PageSize
)
GO


--- GetStaredPlayersWithPagination Function
CREATE FUNCTION dbo.GetStaredPlayersWithPagination
(
    @PageNumber INT,
    @PageSize INT
)
RETURNS TABLE
AS
RETURN
(
    SELECT 
        PlayerID,
        PlayerName,
        Url,
        Position,
        Club,
        Wage,
        Value,
        Nation,
        League,
        Age,
        ReleaseClause
    FROM
    (
        SELECT
            p.player_id AS PlayerID,
            p.name AS PlayerName,
            p.url AS Url,
            pos.name AS Position,
            cl.name AS Club,
            c.wage AS Wage,
            p.value AS Value,
            n.name AS Nation,
            l.name AS League,
            p.age AS Age,
            c.release_clause AS ReleaseClause,
            ROW_NUMBER() OVER (
                ORDER BY
                    p.player_id
            ) AS RowNum
        FROM
            StaredPlayers sp
        INNER JOIN
            Player p ON sp.player_id = p.player_id
        INNER JOIN
            PlayerPosition playpos ON playpos.player_id = p.player_id
        INNER JOIN
            Position pos ON pos.position_id = playpos.position_id
        INNER JOIN
            Club cl ON p.club_id = cl.club_id
        INNER JOIN
            Contract c ON p.player_id = c.player_id
        INNER JOIN
            Nation n ON p.nation_id = n.nation_id
        INNER JOIN
            League l ON cl.league_id = l.league_id
    ) AS StaredPlayersWithRowNum
    WHERE
        RowNum > (@PageNumber - 1) * @PageSize
        AND RowNum <= @PageNumber * @PageSize
)
GO
