/*
Hello Jaimi;

I would like to convert the following time stamp "Jun 06 2011 10:35:37" into

"YYYY-MM-DD HH:MM" format.\

Regards,

Lewis Yung
*/

select DATE_FORMAT(now(), '%b %d %Y %h:%i:%s') as _ORIGINAL_FORMAT_;
select DATE_FORMAT(now(), '%Y-%m-%d %h:%i') as _DESIRED_FORMAT_;

\! rm -f /home/jbecker/scripts/foo.txt
select 'foo' into outfile '/home/jbecker/scripts/foo.txt';
\! ls /home/jbecker/scripts/foo*

select  job_handle,
        start_time,
        stop_time,
        subtime(time(max(stop_time)), time(min(start_time))) as benchmark
from CST_dbo.device_read_benchmark
group by job_handle
order by stop_time desc;


FL IA WI