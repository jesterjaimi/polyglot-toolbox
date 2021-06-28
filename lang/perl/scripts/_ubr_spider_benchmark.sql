-- \. _ubr_spider_benchmark.sql
-- v000 of the cable vision UBR _track_devices_v000.sql script
-- this calls a new instance of each _device_tracker_argv_v000.pl
-- with a distinct UBR to stash the desired stats within the alloted 15 minute window
-- james becker, blue wolf group, created: 20110531 last updated: 20110607
use CST_dbo;

\! rm -f _ubr_spider_benchmark.sql.report
\T _ubr_spider_benchmark.sql.report
select "
select  count(distinct device) as ubr_count
,       max(report_date) as job_start
,       min(report_date) as job_finish
-- ,       subtime(time(max(report_date)), time(min(report_date))) as benchmark
from device_status
where report_date between subdate(now(), INTERVAL 1 DAY) and now();
" as __SQL_ECHO__\G
select  count(distinct device) as ubr_count
,       min(report_date) as job_start
,       max(report_date) as job_finish
-- ,       subtime(time(max(report_date)), time(min(report_date))) as benchmark
from device_status
where report_date between subdate(now(), INTERVAL 1 DAY) and now()
;

select "
select  job_handle
,       start_time
,       stop_time
--         subtime(time(max(stop_time)), time(min(start_time))) as benchmark
from CST_dbo.device_read_benchmark
group by job_handle
order by stop_time desc;
" as __SQL_ECHO__\G
select  job_handle
,       start_time
,       stop_time
--         subtime(time(max(stop_time)), time(min(start_time))) as benchmark
from CST_dbo.device_read_benchmark
group by job_handle
order by stop_time desc;

select "
select  device
,       cmd
,       min(report_date) thread_start
,       max(report_date) thread_finish
-- ,       subtime(time(max(report_date)), time(min(report_date))) as benchmark
,       count(1) modem_count
from device_status
group by 1, 2;
" as __SQL_ECHO__\G
select  device
,       cmd
,       min(report_date) thread_start
,       max(report_date) thread_finish
-- ,       subtime(time(max(report_date)), time(min(report_date))) as benchmark
,       count(1) modem_count
from device_status
group by 1, 2;
\t