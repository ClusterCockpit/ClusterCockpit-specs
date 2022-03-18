# Overview

ClusterCockpit uses the InfluxData line-protocol for collecting the node metric
data.

```
<measurement>,<tag set> <field set> <timestamp [s]>
```

**Note**: This is a proposal for a different way to send & store the data!

# Supported measurements:
* `flops_sp`
* `flops_dp`
* `flops_any`
* `load`
* `mem_used`
* `ipc`
* `mem_bw`
* `power`
* `clock`
* ...

# Mandatory tags per measurement:
* `hostname`
* `type` in `[node, socket, cpu, (accelerator)]`
* `type-id` for further specifying the type like CPU socket or HW Thread identifier

# Optional tags depending on the measurment:
* `device` for measurement `file_bw`
* `device` for `net_bw` if splitting into `ib_bw` and `eth_bw` is not enough

# Fields per measurement:
The field key is always `value`

# Optional measurements:
If a fixed aggregation to a coarser granularity is desired, add addtional measurments to the same measurement with different tags:
```
mem_bw,hostname=X,type="socket",type-id=0 value=100.0
mem_bw,hostname=X,type="socket",type-id=1 value=200.0
```

can additionally be send/stored as:

```
mem_bw,hostname=X,type="node",type-id=0 value=300.0
```

It is discussable where the type of aggregation should be encoded if required, either by adding a tag like `agg={min,max,sum,avg}` or using different fields like:

```
mem_bw,hostname=X,type="node",type-id=0 sum=300.0,min=100.0,max=200.0,avg=150.0
```

I prefer the separate `agg` tag because commonly, only a single type of aggregation is done per measurment (mostly `sum` but some require `avg` like `ipc`)
