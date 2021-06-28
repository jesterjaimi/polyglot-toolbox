-- \. _ubr_spider_benchmark_report.sql
-- v000 of the cable vision UBR _track_devices_v000.sql script
-- this calls a new instance of each _device_tracker_argv_v000.pl
-- with a distinct UBR to stash the desired stats within the alloted 15 minute window
-- james becker, blue wolf group, created: 20110531 last updated: 20110607
use CST_dbo;

\! rm -f _device_tracker_trial_run_report.sql.out
\T _device_tracker_trial_run_report.sql.out
select "
select  count(distinct device)
,       min(report_date)
,       max(report_date)
,       subtime(time(min(report_date)), time(max(report_date))) as benchmark
from device_status;
" as __SQL_ECHO__\G
select  count(distinct device)
,       max(report_date)
,       min(report_date)
,       subtime(time(min(report_date)), time(max(report_date))) as benchmark
from device_status;

select "
select device, cmd, min(report_date), max(report_date), count(1) from device_status group by 1, 2;
" as __SQL_ECHO__\G
select device, cmd, min(report_date), max(report_date), count(1) from device_status group by 1, 2;
\t