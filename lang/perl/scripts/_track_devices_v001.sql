-- \. _track_devices_v001.sql
-- v000 of the cable vision UBR _track_devices_v000.sql script
-- this calls a new instance of each _device_tracker_argv_v000.pl
-- with a distinct UBR to stash the desired stats within the alloted 15 minute window
-- james becker, blue wolf group, created: 20110531 last updated: 20110607
use CST_dbo;

\! rm -f /tmp/_trk_dev_test_final.sh
select concat('perl _device_tracker_argv_v000.pl ', DeviceName)
into outfile '/tmp/_trk_dev_test_final.sh'
from CST_dbo.ubrlist
where DeviceName not like '%cdnt%'
group by DeviceName
order by DeviceName
;

\! cat /tmp/_trk_dev_test_final.sh

delete from script_dump;
create table script_dump
(
    cmd     varchar(255)
);

load data infile '/tmp/_trk_dev_test_final.sh'
into table script_dump;

select * from script_dump;

\! chmod 755 /tmp/_trk_dev_test_final.sh
\! /tmp/_trk_dev_test_final.sh

SELECT SYSDATE( ) AS 'Pause Start',
SLEEP(240) AS 'trkdev Pause',
SYSDATE( ) AS 'Pause End';

\. _ubr_spider_benchmark.sql
