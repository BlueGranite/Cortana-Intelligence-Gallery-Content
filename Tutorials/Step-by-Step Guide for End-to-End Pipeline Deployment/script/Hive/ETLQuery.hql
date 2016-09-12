set hive.vectorized.execution.enabled = true;
set hive.vectorized.execution.reduce.enabled = true;
SET hive.exec.dynamic.partition=true;
SET hive.exec.dynamic.partition.mode = nonstrict;
set hive.cli.print.header=true;
SET mapred.input.dir.recursive=true;
set hive.mapred.supports.subdirectories=true;

DROP TABLE if exists sampleinput;
CREATE EXTERNAL TABLE sampleinput (
    id int,
    var1 int,
    var2 int,
	EventProcessedUtcTime timestamp,
	PartitionId int,
	EventEnqueuedUtcTime timestamp
)
ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
STORED AS TEXTFILE LOCATION '${hiveconf:Input}/${hiveconf:CurrDate}/${hiveconf:CurrHour}/'
TBLPROPERTIES("skip.header.line.count"="1");

DROP TABLE if exists sampleoutput;
CREATE EXTERNAL TABLE sampleoutput (
    id int,
    var1 int,
    var2 int,
	var3 int,
	var4 int
)
partitioned by (date string, hour string)
ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
STORED AS TEXTFILE LOCATION '${hiveconf:Output}/';

INSERT OVERWRITE TABLE sampleoutput PARTITION(date, hour) 
select id, var1, var2, (var1+var2) as var3, (var1-var2) as var4, '${hiveconf:CurrDate}' as date, lpad('${hiveconf:CurrHour}', 2, '0') as hour
from sampleinput;