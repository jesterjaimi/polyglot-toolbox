-- \. _track_devices_v000.sql
-- v000 of the cable vision UBR _track_devices_v000.sql script
-- this calls a new instance of each _device_tracker_argv_v000.pl
-- with a distinct UBR to stash the desired stats within the alloted 15 minute window
-- james becker, blue wolf group, created: 20110531 last updated: 20110607
use CST_dbo;

drop table ubr_thread_cntl;
create table ubr_thread_cntl
(
    skip_device varchar(69)
)
;

\! rm -f /tmp/_trk_dev.sql
select concat("\\! nohup perl _device_tracker_argv_v000.pl ", DeviceName, " 2>&1 & \n")
into outfile '_trk_dev.sql'
from CST_dbo.ubrlist
where DeviceName not like '%cdnt%'
group by DeviceName
order by DeviceName
limit 100
;

insert into ubr_thread_cntl (skip_device)
select DeviceName
from CST_dbo.ubrlist
where DeviceName not like '%cdnt%'
group by DeviceName
order by DeviceName
limit 100
;

SELECT SYSDATE( ) AS 'Pause Start',
SLEEP(10) AS 'trkdev Pause',
SYSDATE( ) AS 'Pause End';

-- \! cat _trk_dev.sql

-- \! rm -f _trk_dev.sql
select concat("\\! nohup perl _device_tracker_argv_v000.pl ", DeviceName, " 2>&1 & \n")
-- into outfile '_trk_dev.sql'
from CST_dbo.ubrlist
where DeviceName not like '%cdnt%'
and DeviceName not in (select skip_device from ubr_thread_cntl)
group by DeviceName
order by DeviceName
limit 100
;

insert into ubr_thread_cntl (skip_device)
select DeviceName
from CST_dbo.ubrlist
where DeviceName not like '%cdnt%'
and DeviceName not in (select skip_device from ubr_thread_cntl)
group by DeviceName
order by DeviceName
limit 100
;

SELECT SYSDATE( ) AS 'Pause Start',
SLEEP(10) AS 'trkdev Pause',
SYSDATE( ) AS 'Pause End';

-- \! cat _trk_dev.sql

-- \! rm -f _trk_dev.sql
select concat("\\! nohup perl _device_tracker_argv_v000.pl ", DeviceName, " 2>&1 & \n")
-- into outfile '_trk_dev.sql'
from CST_dbo.ubrlist
where DeviceName not like '%cdnt%'
and DeviceName not in (select skip_device from ubr_thread_cntl)
group by DeviceName
order by DeviceName
limit 100
;

insert into ubr_thread_cntl (skip_device)
select DeviceName
from CST_dbo.ubrlist
where DeviceName not like '%cdnt%'
and DeviceName not in (select skip_device from ubr_thread_cntl)
group by DeviceName
order by DeviceName
limit 100
;

SELECT SYSDATE( ) AS 'Pause Start',
SLEEP(10) AS 'trkdev Pause',
SYSDATE( ) AS 'Pause End';

select * from ubr_thread_cntl;

-- \! cat _trk_dev.sql
