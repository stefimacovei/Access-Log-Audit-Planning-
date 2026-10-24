PRAGMA foreign_keys = ON;

CREATE TABLE users (
    user_id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    team TEXT NOT NULL,
    role TEXT NOT NULL,
    manager  INTEGER REFERENCES users(user_id)  
);

CREATE TABLE datasets (
    dataset_id  INTEGER PRIMARY KEY,
    name TEXT NOT NULL UNIQUE,

    sensitivity TEXT NOT NULL
        CHECK (sensitivity IN ('PUBLIC', 'INTERNAL', 'CONFIDENTIAL', 'RESTRICTED')),
    owner_team  TEXT NOT NULL
);

CREATE TABLE access_grants (
    grant_id  INTEGER PRIMARY KEY,
    user_id  INTEGER NOT NULL REFERENCES users(user_id),
    dataset_id INTEGER NOT NULL REFERENCES datasets(dataset_id),
    granted_on TEXT NOT NULL,            
    expires_on TEXT NOT NULL,
    justification TEXT,
    approved_columns TEXT,                       
    CHECK (expires_on >= granted_on)
);

CREATE TABLE query_log (
    query_id INTEGER PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES users(user_id),
    timestamp TEXT NOT NULL,             
    dataset_id INTEGER NOT NULL REFERENCES datasets(dataset_id),
    sql_text TEXT NOT NULL,
    columns_accessed TEXT NOT NULL,             
    rows_returned INTEGER NOT NULL CHECK (rows_returned >= 0),
    source_ip TEXT NOT NULL,
    success INTEGER NOT NULL CHECK (success IN (0, 1))
);

CREATE INDEX idx_query_user_time ON query_log(user_id, timestamp);
CREATE INDEX idx_query_dataset ON query_log(dataset_id);
CREATE INDEX idx_grants_lookup ON access_grants(user_id, dataset_id);