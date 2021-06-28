-- \. _device_mart.sql
-- v000 of the cable vision single ubr device_tracker_argv script
-- james becker, blue wolf group, created: 20110531 last updated: 20110603
use CST_dbo;

drop table device_read_benchmark;
create table device_read_benchmark
(
    job_handle      varchar(50)
,   description     varchar(255)
,   start_time      datetime
,   stop_time       datetime 
)
;

insert into device_read_benchmark
(job_handle, description, start_time, stop_time)
select concat("TEST_HANDLE_", year( now( ) ),
            if( length( month( now( ) ) ) < 2, concat( "0", month( now( ) ) ), month( now( ) ) ),
            if(length(day(now())) < 2, concat("0", day(now())), day(now()))
    ) as source_code
,   "This is the TEST_HANDLE benchmark" as description
,   now() as start_time
,   NULL as stop_time
;

select * from device_read_benchmark\G

SELECT SYSDATE( ) AS 'dev_read_bm start',
SLEEP(5) AS 'dev_read_bm pause',
SYSDATE( ) AS 'dev_read_bm end';

update device_read_benchmark
set stop_time = now()
where job_handle like 'TEST_HANDLE%'
and stop_time is NULL;

select * from device_read_benchmark\G

drop table device_type;
create table device_type
(
    device_type_id INT PRIMARY KEY NOT NULL AUTO_INCREMENT
,   type_code       varchar(4)
,   type_name       varchar(50)
,   description     varchar(255)
)
;

insert into device_type (type_code, type_name, description)
values('CM', 'Cable Modem', 'This Device is a Cable Modem.')
;

insert into device_type (type_code, type_name, description)
values('STB', 'Set Top Box', 'This Device is a Set Top Box.')
;

insert into device_type (type_code, type_name, description)
values('UBR', 'Universal Broadband Router', 'This Device is a Universal Broadband Router.')
;

insert into device_type (type_code, type_name, description)
values('CMTS', 'Cable Modem Termination System', 'This Device is a Cable Modem Termination System.')
;

drop table device_status;
create table device_status
(
    device          varchar(100)
,   cmd             varchar(255)
,   interface       varchar(10)     -- C5/0/0/U2
,   online_state    varchar(10)     -- init(io) 
,   ipaddress       varchar(15)     -- 000.000.000.000 
,   macaddress      varchar(14)     -- ece0.9b00.ae7b
,   report_date     timestamp default current_timestamp
)
;

select "mysql> select * from device_type;" as __SQL_ECHO__;
select * from device_type;

select 'mysql> desc device_read_benchmark;' as __DESC_REPORT__;
desc device_read_benchmark;

select 'mysql> desc device_type;' as __DESC_REPORT__;
desc device_type;

select 'mysql> desc device_status;' as __DESC_REPORT__;
desc device_status;


