CREATE TABLE accounts(
    id          INTEGER PRIMARY KEY,
    username    TEXT UNIQUE
);
CREATE INDEX accounts_username ON accounts(username);

CREATE TABLE snapshots(
    id              INTEGER PRIMARY KEY,
    account_id      INTEGER,
    datetime        INTEGER,
    FOREIGN KEY(account_id) REFERENCES accounts(id),
    UNIQUE(account_id, datetime)
);

CREATE TABLE skills(
    id INTEGER PRIMARY KEY,
    skill_name TEXT  
);

INSERT INTO skills(skill_name) VALUES
("Attack"),
("Defence"),
("Strength"),
("Hitpoints"),
("Ranged"),
("Prayer"),
("Magic"),
("Cooking"),
("Woodcutting"),
("Fletching"),
("Fishing"),
("Firemaking"),
("Crafting"),
("Smithing"),
("Mining"),
("Herblore"),
("Agility"),
("Thieving"),
("Slayer"),
("Farming"),
("Runecraft"),
("Hunter"),
("Construction");

CREATE TABLE snapshot_skills(
    snapshot_id INTEGER,
    skill_id    INTEGER,
    xp          INTEGER,
    PRIMARY KEY(snapshot_id, skill_id),
    FOREIGN KEY(skill_id) REFERENCES skills(id)
);

ALTER TABLE snapshots ADD COLUMN overall_level INTEGER;
ALTER TABLE snapshots ADD COLUMN overall_xp INTEGER;
ALTER TABLE snapshots ADD COLUMN overall_rank INTEGER;

ALTER TABLE snapshot_skills ADD COLUMN rank INTEGER;

ALTER TABLE accounts ADD COLUMN next_scheduled_update INTEGER;
CREATE INDEX accounts_next_scheduled_update ON accounts(next_scheduled_update);
CREATE INDEX snapshots_datetime ON snapshots(datetime);