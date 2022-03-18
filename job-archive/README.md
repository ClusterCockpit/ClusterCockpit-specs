# File based archive specification for HPC jobs

This is a json files based exchange format for HPC job meta and performance metric data.

It consists of two parts:
* a sqlite database schema for job meta data and performance statistics
* a json file format together with a directory hierarchy specification

By using an open, portable and simple specification based on files it is
possible to exchange job performance data for research and analysis purposes as
well as a robust way for archiving job performance data on disk.

## Directory hierarchy and file specification

The job archive has top-level directories named after the clusters. In every
cluster directory there must be one file named `cluster.json` describing the
cluster. The json schema for this file is described here. Within this directory
a three-level directory tree is used to organize job files.

To manage the number of directories within a single directory a tree approach
is used splitting the integer job ID. The job id is split in junks of 1000
each.

For a 2 layer schema this can be achieved with (code example in Perl):

```perl
$level1 = $jobID/1000;
$level2 = $jobID%1000;
$dstPath = sprintf("%s/%s/%d/%03d", $trunk, $destdir, $level1, $level2);

```

The last directory level is the unix epoch timestamp in seconds to allow for
overflowing job ids.

Example:

For the job ID 1034871 the directory path is ./1034/871/<timestamp>/.

The job data consists of two files:

* meta.json: Contains job meta information and job statistics.
* data.json: Contains complete job data with time series

The description of the json format specification is available as json schema.

Metric time series data is stored with fixed time step. The time step can be
set per metric. If no value is available for a metric time series data
timestamp null must be entered.
