README FILE FOR: _ubr_spider*.pl, _device_tracker*.pl & _track_devices*.sql
Author: James Becker, Consultant, Blue Wolf Group

Summary
=======
The ubr spider and related scripts are a multi-threaded perl rewrite of the Cable Vision plandData20.pl script.

The purpose of this rewrite was to create a lightweight ubr stats gathering engine to replace the SAS infrastructure and runs within a 15 minute time window.
Initial testing returns Benchmark times between 6-10 minutes, satisfying the desired requirements.

Servers
=======
CVDev1:(172.16.30.196)
CVProd1/public1:(172.16.30.245)


Home Directory: /home/jbecker/scripts

Relevant Scripts
================
_device_tracker_v000.pl
(First Version... Single Threaded)

_ubr_spider_v000.pl
(First Version... Multi-Threaded)

_device_tracker_argv_v000.pl
(Second Iteration Tracks Single ubr, helper script used by _ubr_spider_v000.pl)

_ubr_spider_v001.pl
(Second Iteration... Variable Buffering, Written but not tested.)

_device_tracker_argv_v001.pl
(Second Iteration... Variable Buffering, NOBUF and FILE, Written but not tested, helper script used by _ubr_spider_v001.pl)

_device_mart.sql
(Creates the device_mart RDBMS namespace to store ubr stats)

_ubr_spider_benchmark.sql
(Queries CST_dbo.device_status to validate stats capture and benchmark performance)

_ubr_spider_benchmark.sql.report
(Benchmark report output from _ubr_spider_benchmark.sql)

_track_devices_v001.sql
(An initial attempt to directly generate the _device_tracker_argv_v000.pl system calls and bulk load ubr stats directly into MySQL)
This pure sql script currently performs slower than _ubr_spider_v001.pl. It appears that perl DBI handles table contention better than
MySQL does internally. This could be easily modified to generate scratch tables on the fly and then merge the results, which should
drastically improve performance. Consider this a homework assignment for those who are interested in extending this work.




