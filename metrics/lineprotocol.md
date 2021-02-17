# Overview

ClusterCockpit uses the InfluxData line-protocol for collecting the node metric
data.

```
<measurement>,<tag set> <field set> <timestamp [s]>
```

Supported measurements:
* node – Tags: host, cpu
* socket – Tags: host, socket
* cpu -- Tags: host, cpu

## Supported node level fields

* `load`
* `mem_used`
* `net_bw` - split into `ib_bw` and `eth_bw` if required
* `file_bw` - split into multiple file systems if required

## Supported socket fields

All socket metrics can be aggregated to coarser granularity.

* `power`
* `mem_bw`

## Supported cpu level fields

All cpu metrics can be aggregated to coarser granularity.

* `ipc`
* `flops_any`
* `clock`
