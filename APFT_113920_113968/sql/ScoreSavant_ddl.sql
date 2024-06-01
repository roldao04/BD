CREATE TABLE [Player] (
  [player_id] integer PRIMARY KEY IDENTITY(1,1),
  [name] nvarchar(255),
  [age] integer,
  [weight] integer,
  [height] integer,
  [nation_id] integer,
  [club_id] integer,
  [foot] nvarchar(255),
  [value] integer,
  [url] nvarchar(MAX)
);
GO

CREATE TABLE [Nation] (
  [nation_id] integer PRIMARY KEY IDENTITY(1,1),
  [name] nvarchar(255)
);
GO

CREATE TABLE [League] (
  [nation_id] integer IDENTITY(1,1),
  [league_id] integer PRIMARY KEY,
  [name] nvarchar(255)
);
GO

CREATE TABLE [Club] (
  [club_id] integer PRIMARY KEY IDENTITY(1,1),
  [nation_id] integer,
  [league_id] integer,
  [name] nvarchar(255),
  [player_count] int,
  [wage_total] decimal(18, 2),
  [value_total] decimal(18, 2),
  [wage_average] decimal(18, 2),
  [value_average] decimal(18, 2),
  [avg_att] decimal (18, 2)
);
GO

CREATE TABLE [Role] (
  [role_id] integer PRIMARY KEY IDENTITY(1,1),
  [name] nvarchar(255)
);
GO

CREATE TABLE [Position] (
  [position_id] integer PRIMARY KEY IDENTITY(1,1),
  [name] nvarchar(255)
);
GO

CREATE TABLE [RolePosition] (
  [id] integer PRIMARY KEY IDENTITY(1,1),
  [position_id] integer,
  [role_position] integer
);
GO

CREATE TABLE [PlayerRole] (
  [player_id] integer,
  [role_position_id] integer,
  PRIMARY KEY ([player_id], [role_position_id])
);

CREATE TABLE [Contract] (
  [player_id] integer PRIMARY KEY,
  [wage] integer,
  [duration] integer,
  [contract_end] date,
  [release_clause] integer
);
GO

CREATE TABLE [Outfield_Player] (
  [player_id] integer PRIMARY KEY
);
GO

CREATE TABLE [Goalkeeper] (
  [player_id] integer PRIMARY KEY
);
GO

CREATE TABLE [OutfieldAttributeRating] (
  [att_id] nvarchar(255),
  [player_id] integer,
  [rating] integer,
  PRIMARY KEY ([att_id], [player_id])
);
GO

CREATE TABLE [GoalkeeperAttributeRating] (
  [att_id] nvarchar(255),
  [player_id] integer,
  [rating] integer,
  PRIMARY KEY ([att_id], [player_id])
);
GO

CREATE TABLE [Attribute] (
  [name] nvarchar(255) PRIMARY KEY
);
GO

CREATE TABLE [KeyAttributes] (
  [role_id] integer,
  [attribute_id] nvarchar(255),
  PRIMARY KEY ([role_id], [attribute_id])
);
GO

CREATE TABLE [Technical_Att] (
  [att_id] nvarchar(255) PRIMARY KEY
);
GO

CREATE TABLE [Mental_Att] (
  [att_id] nvarchar(255) PRIMARY KEY
);
GO

CREATE TABLE [Physical_Att] (
  [att_id] nvarchar(255) PRIMARY KEY
);
GO

CREATE TABLE [Goalkeeping_Att] (
  [att_id] nvarchar(255) PRIMARY KEY
);
GO

CREATE TABLE [PlayerPosition] (
  [player_id] integer,
  [position_id] integer,
  PRIMARY KEY ([player_id], [position_id]),
  FOREIGN KEY ([player_id]) REFERENCES [Player] ([player_id]),
  FOREIGN KEY ([position_id]) REFERENCES [Position] ([position_id])
);
GO

CREATE TABLE StaredPlayers (
    player_id INT PRIMARY KEY
);
GO

-- Foreign key constraints
ALTER TABLE [Player] ADD FOREIGN KEY ([nation_id]) REFERENCES [Nation] ([nation_id]);
GO

ALTER TABLE [League] ADD FOREIGN KEY ([nation_id]) REFERENCES [Nation] ([nation_id]);
GO

ALTER TABLE [Player] ADD FOREIGN KEY ([club_id]) REFERENCES [Club] ([club_id]);
GO

ALTER TABLE [Contract] ADD FOREIGN KEY ([player_id]) REFERENCES [Player] ([player_id]);
GO

ALTER TABLE [Club] ADD FOREIGN KEY ([nation_id]) REFERENCES [Nation] ([nation_id]);
GO

ALTER TABLE [Club] ADD FOREIGN KEY ([league_id]) REFERENCES [League] ([league_id]);
GO

ALTER TABLE [RolePosition] ADD FOREIGN KEY ([position_id]) REFERENCES [Position] ([position_id]);
GO

ALTER TABLE [RolePosition] ADD FOREIGN KEY ([role_position]) REFERENCES [Role] ([role_id]);
GO

ALTER TABLE [PlayerRole] ADD FOREIGN KEY ([player_id]) REFERENCES [Player] ([player_id]);
GO

ALTER TABLE [PlayerRole] ADD FOREIGN KEY ([role_position_id]) REFERENCES [RolePosition] ([id]);
GO

ALTER TABLE [Outfield_Player] ADD FOREIGN KEY ([player_id]) REFERENCES [Player] ([player_id]);
GO

ALTER TABLE [Goalkeeper] ADD FOREIGN KEY ([player_id]) REFERENCES [Player] ([player_id]);
GO

ALTER TABLE [OutfieldAttributeRating] ADD FOREIGN KEY ([att_id]) REFERENCES [Attribute] ([name]);
GO

ALTER TABLE [GoalkeeperAttributeRating] ADD FOREIGN KEY ([att_id]) REFERENCES [Attribute] ([name]);
GO

ALTER TABLE [KeyAttributes] ADD FOREIGN KEY ([role_id]) REFERENCES [Role] ([role_id]);
GO

ALTER TABLE [KeyAttributes] ADD FOREIGN KEY ([attribute_id]) REFERENCES [Attribute] ([name]);
GO

ALTER TABLE [Technical_Att] ADD FOREIGN KEY ([att_id]) REFERENCES [Attribute] ([name]);
GO

ALTER TABLE [Mental_Att] ADD FOREIGN KEY ([att_id]) REFERENCES [Attribute] ([name]);
GO

ALTER TABLE [Physical_Att] ADD FOREIGN KEY ([att_id]) REFERENCES [Attribute] ([name]);
GO

ALTER TABLE [Goalkeeping_Att] ADD FOREIGN KEY ([att_id]) REFERENCES [Attribute] ([name]);
GO
