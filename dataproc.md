ubuntu@rc1d-dataproc-m-dzilgyjrmgtyneu0:~$ sudo -u hdfs hdfs fsck /Connecting to namenode via <http://rc1d-dataproc-m-dzilgyjrmgtyneu0.mdb.yandexcloud.net:9870/fsck?ugi=hdfs&path=%2F>
FSCK started by hdfs (auth:SIMPLE) from /10.130.0.23 for path / at Wed Oct 16 08:56:47 UTC 2024
/hadoop/tmp/mapred/history/recoverystore/HistoryServerState/tokens/keys/key_1: MISSING 1 blocks of total size 17 B.
/hadoop/tmp/mapred/history/recoverystore/HistoryServerState/tokens/keys/key_2: MISSING 1 blocks of total size 17 B./hadoop/tmp/mapred/history/recoverystore/HistoryServerState/tokens/keys/key_3: MISSING 1 blocks of total size 17 B.
/hadoop/tmp/mapred/history/recoverystore/HistoryServerState/tokens/keys/key_4: MISSING 1 blocks of total size 17 B.
/user/hive/.hiveJars/hive-exec-3.1.2-7ffeef6edcdc2ed1862e2089022fb547571dc1c23eedf317ecb818af1f5c13bc.jar: MISSING 1 blocks of total size 41070225 B./user/ubuntu/hello.txt: MISSING 1 blocks of total size 12 B.
/var/log/hadoop-yarn/apps/hive/logs-tfile/application_1728242363981_0001/
11:57

rc1d-dataproc-d-8xzdwvebdptyetpp.mdb.yandexcloud.net_36227: MISSING 1 blocks of total size 71081 B./var/log/hadoop-yarn/apps/hive/logs-tfile/application_1728313681349_0001/rc1d-dataproc-d-bnhzekki8wxwg7rb.mdb.yandexcloud.net_37737: MISSING 1 blocks of total size 71082 B.
Status: CORRUPT Number of data-nodes: 0
Number of racks: 0 Total dirs: 1041
Total symlinks: 0
Replicated Blocks: Total size: 41212468 B
Total files: 8 (Files currently being written: 1) Total blocks (validated): 8 (avg. block size 5151558 B) (Total open file blocks (not validated): 1)
****************************** UNDER MIN REPL'D BLOCKS: 8 (100.0 %)
MINIMAL BLOCK REPLICATION: 1 CORRUPT FILES: 8
MISSING BLOCKS: 8 MISSING SIZE: 41212468 B
****************************** Minimally replicated blocks: 0 (0.0 %)
Over-replicated blocks: 0 (0.0 %) Under-replicated blocks: 0 (0.0 %)
Mis-replicated blocks: 0 (0.0 %) Default re
11:57

plication factor: 1
Average block replication: 0.0 Missing blocks: 8
Corrupt blocks: 0 Missing replicas: 0
Erasure Coded Block Groups:
Total size: 0 B Total files: 0
Total block groups (validated): 0 Minimally erasure-coded block groups: 0
Over-erasure-coded block groups: 0 Under-erasure-coded block groups: 0
Unsatisfactory placement block groups: 0 Average block group size: 0.0
Missing block groups: 0 Corrupt block groups: 0
Missing internal blocks: 0FSCK ended at Wed Oct 16 08:56:47 UTC 2024 in 105 milliseconds

The filesystem under path '/' is CORRUPTubuntu@rc1d-dataproc-m-dzilgyjrmgtyneu0:~$
