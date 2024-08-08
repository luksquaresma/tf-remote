CREATE TABLE Data (
   id    INTEGER  PRIMARY KEY,
   cid   TEXT     NOT NULL,
   loc   TEXT     NOT NULL
);

CREATE TABLE Jobs (
   id          INTEGER  PRIMARY KEY,
   data_id     INTEGER  REFERENCES Data(id),
   cid         TEXT     NOT NULL,
   params_loc  TEXT     NOT NULL,
   dynamic_opt INTEGER  NOT NULL,
   done        INTEGER  NOT NULL
);