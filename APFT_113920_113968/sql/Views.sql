USE [p5g5]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--- View to get RandomPlayer
CREATE VIEW RandomPlayer AS
SELECT TOP 1 
    p.player_id, 
    p.name AS player_name, 
    p.nation_id, 
    n.name AS nation_name, 
    p.club_id, 
    c.name AS club_name,
    p.url AS player_url
FROM 
    Player p
JOIN 
    Nation n ON p.nation_id = n.nation_id
JOIN 
    Club c ON p.club_id = c.club_id
ORDER BY 
    NEWID();
GO


--- View to get Specific Attribute Types
CREATE VIEW [dbo].[GetTechnicalAtt]
AS
SELECT
    ta.att_id AS AttributeID
FROM
    TechnicalAttribute ta
GO

CREATE VIEW [dbo].[GetPhysicalAtt]
AS
SELECT
    pa.att_id AS AttributeID
FROM
    Physical_Att pa
GO

CREATE VIEW [dbo].[GetMentalAtt]
AS
SELECT
    ma.att_id AS AttributeID
FROM
    Mental_Att ma
GO

CREATE VIEW [dbo].[GetGoalkeepingAtt]
AS
SELECT
    ga.att_id AS AttributeID
FROM
    Goalkeeping_Att ga
GO


--- View Top 5 Players for each League
CREATE VIEW [dbo].[Top5PlayersForEachLeague]
AS
WITH RankedPlayers AS
(
    SELECT
        p.player_id AS PlayerID,
        p.name AS PlayerName,
        p.url AS Url,
        l.league_id AS LeagueID,
        l.name AS LeagueName,
        cl.name AS ClubName,
        c.wage AS Wage,
        p.value AS Value,
        pos.name AS Position,
        ROW_NUMBER() OVER (PARTITION BY l.league_id ORDER BY p.player_id) AS RowNum
    FROM
        Player p
    INNER JOIN
        Club cl ON p.club_id = cl.club_id
    INNER JOIN
        League l ON cl.league_id = l.league_id
    INNER JOIN
        Contract c ON p.player_id = c.player_id
    INNER JOIN
        PlayerPosition pp ON p.player_id = pp.player_id
    INNER JOIN
        Position pos ON pp.position_id = pos.position_id
)
SELECT
    PlayerID,
    PlayerName,
    LeagueID,
    LeagueName,
    ClubName,
    Wage,
    Value,
    Position
FROM
    RankedPlayers
WHERE
    RowNum <= 5
GO
