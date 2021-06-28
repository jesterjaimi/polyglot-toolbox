-- \. _plantData20.20110531.sql
use CST_dbo;

drop table device_type;
create table device_type
(
    device_type_id INT PRIMARY KEY NOT NULL AUTO_INCREMENT
,   type_code       varchar(4)
,   type_name       varchar(50)
,   description     varchar(255)
)
;

insert into device_type (type_name, description)
values('CM', 'Cable Modem', 'This is a Cable Modem.')
;

insert into device_type (type_name, description)
values('STB', 'Set Top Box', 'This is a Set Top Box.')
;

insert into device_type (type_name, description)
values('UBR', 'Universal Broadband Router', 'This is a Universal Broadband Router.')
;

insert into device_type (type_name, description)
values('CMTS', 'Cable Modem Troubleshooting System', 'This is a Cable Modem Troubleshooting System.')
;

drop table device_status;
create table device_status
(
    interface       varchar(10)     -- C5/0/0/U2
,   online_state    varchar(10)     -- init(io) 
,   ipaddress       varchar(15)     -- 000.000.000.000 
,   macaddress      varchar(14)     -- ece0.9b00.ae7b
)
;

