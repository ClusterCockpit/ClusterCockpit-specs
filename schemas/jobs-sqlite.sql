CREATE TABLE tag (
id       INTEGER PRIMARY KEY,
tag_type VARCHAR(255) NOT NULL,
tag_name VARCHAR(255) NOT NULL,
insert_ts TEXT DEFAULT CURRENT_TIMESTAMP,
UNIQUE (tag_type, tag_name));

CREATE TABLE jobtag (
job_id INTEGER,
tag_id INTEGER,
insert_ts TEXT DEFAULT CURRENT_TIMESTAMP,
PRIMARY KEY (job_id, tag_id),
FOREIGN KEY (job_id) REFERENCES job (id) ON DELETE CASCADE,
FOREIGN KEY (tag_id) REFERENCES tag (id) ON DELETE CASCADE);

CREATE TABLE user (
username varchar(255) PRIMARY KEY NOT NULL,
password varchar(255) DEFAULT NULL,
ldap     tinyint      NOT NULL DEFAULT 0, /* col called "ldap" for historic reasons, fills the "AuthSource" */
name     varchar(255) DEFAULT NULL,
roles    varchar(255) NOT NULL DEFAULT "[]",
email    varchar(255) DEFAULT NULL,
projects varchar(255) NOT NULL DEFAULT "[]");

CREATE TABLE configuration (
username varchar(255),
confkey  varchar(255),
value    varchar(255),
PRIMARY KEY (username, confkey),
FOREIGN KEY (username) REFERENCES user (username) ON DELETE CASCADE ON UPDATE NO ACTION);

CREATE TABLE job (
id                INTEGER PRIMARY KEY,
job_id            BIGINT NOT NULL,
cluster           VARCHAR(255) NOT NULL,
subcluster        VARCHAR(255) NOT NULL,
start_time        BIGINT NOT NULL, -- Unix timestamp
user              VARCHAR(255) NOT NULL,
project           VARCHAR(255) NOT NULL,
partition         VARCHAR(255),
array_job_id      BIGINT,
duration          INT NOT NULL,
walltime          INT NOT NULL,
job_state         VARCHAR(255) NOT NULL
CHECK(job_state IN ('running', 'completed', 'failed', 'cancelled', 'stopped', 'timeout', 'preempted', 'out_of_memory')),
meta_data         TEXT,          -- JSON
resources         TEXT NOT NULL, -- JSON
num_nodes         INT NOT NULL,
num_hwthreads     INT,
num_acc           INT,
smt               TINYINT NOT NULL DEFAULT 1 CHECK(smt               IN (0, 1   )),
exclusive         TINYINT NOT NULL DEFAULT 1 CHECK(exclusive         IN (0, 1, 2)),
monitoring_status TINYINT NOT NULL DEFAULT 1 CHECK(monitoring_status IN (0, 1, 2, 3)),
mem_used_max        REAL NOT NULL DEFAULT 0.0,
flops_any_avg       REAL NOT NULL DEFAULT 0.0,
mem_bw_avg          REAL NOT NULL DEFAULT 0.0,
load_avg            REAL NOT NULL DEFAULT 0.0,
net_bw_avg          REAL NOT NULL DEFAULT 0.0,
net_data_vol_total  REAL NOT NULL DEFAULT 0.0,
file_bw_avg         REAL NOT NULL DEFAULT 0.0,
file_data_vol_total REAL NOT NULL DEFAULT 0.0,
UNIQUE (job_id, cluster, start_time));

CREATE INDEX job_stats        ON job (cluster,subcluster,user);
CREATE INDEX job_by_user      ON job (user);
CREATE INDEX job_by_starttime ON job (start_time);
CREATE INDEX job_by_job_id    ON job (job_id, cluster, start_time);
CREATE INDEX job_list         ON job (cluster, job_state);
CREATE INDEX job_list_user    ON job (user, cluster, job_state);
CREATE INDEX job_list_users   ON job (user, job_state);
CREATE INDEX job_list_users_start ON job (start_time, user, job_state);
