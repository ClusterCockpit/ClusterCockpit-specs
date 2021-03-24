CREATE TABLE job ( id INTEGER PRIMARY KEY,
 job_id TEXT NOT NULL, user_id TEXT NOT NULL, project_id TEXT NOT NULL, cluster_id TEXT NOT NULL,
 start_time INTEGER NOT NULL, duration INTEGER NOT NULL,
 walltime INTEGER, job_state TEXT,
 num_nodes INTEGER NOT NULL, node_list TEXT NOT NULL, has_profile INTEGER NOT NULL,
 mem_used_max REAL, flops_any_avg REAL, mem_bw_avg REAL, load_avg REAL, net_bw_avg REAL, file_bw_avg REAL);
CREATE TABLE tag ( id INTEGER PRIMARY KEY, tag_type TEXT, tag_name TEXT);
CREATE TABLE jobtag ( job_id INTEGER, tag_id INTEGER, PRIMARY KEY (job_id, tag_id),
 FOREIGN KEY (job_id) REFERENCES job (id)  ON DELETE CASCADE ON UPDATE NO ACTION,
 FOREIGN KEY (tag_id) REFERENCES tag (id)  ON DELETE CASCADE ON UPDATE NO ACTION );
