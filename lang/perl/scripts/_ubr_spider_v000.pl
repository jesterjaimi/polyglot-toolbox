#!/usr/bin/perl

# _ubr_spider_v000.pl
# v000 of the cable vision UBR _track_devices_v000.sql script
# this calls a new instance of each _device_tracker_argv_v000.pl
# with a distinct UBR to stash the desired stats into device_status
# within the alloted 15 minute window

# james becker, blue wolf group, created: 20110607 last updated: 20110607
use strict;
# includes
use DBI;

# debugging
my $debug = 0;
my $tty_echo = 1;
my $break_point1 = 0;
my $break_point2 = 0;
my $break_point3 = 0;
my $break_point4 = 0;
my $test_ubr = "ubr201.cmts.hcvlny";
my $job_handle = "_ubr_spider_v000_";

if ($tty_echo) {
    print _labeled_timestamp("DEVICE STATUS CAPTURE START");
}
_benchmark_job_start($job_handle);

run_threads();

_benchmark_job_stop($job_handle);

_benchmark_report();

if ($tty_echo) {
    print _labeled_timestamp("DEVICE STATUS CAPTURE END");
    print "THE PHAT LADY SINGS! LA LA!\n";
}

exit 0;

sub run_threads{
    my @l_child;
    my @l_ubrList = _init_device_list();
    foreach my $ubr (@l_ubrList) {
        my $pid = fork();
        if ($pid) {
        # parent
        if ($tty_echo) {
            print "pid is $pid, parent $$\n";
        }
        push(@l_child, $pid);
        } elsif ($pid == 0) {
                # child
                _track_device($ubr);
                exit 0;
        } else {
                die "FORK OFF: $!\n";
        }
        sleep 1;
    }
    
    foreach (@l_child) {
            my $tmp = waitpid($_, 0);
            if ($tty_echo) {
                print "done with pid $tmp\n";
            }
    }
}

sub _track_device {
        my ($p_ubr) = @_;
        if ($tty_echo) {
            print _labeled_timestamp("...UBR THREAD START >> $p_ubr");
        }
        if ($debug) {
            print "\nsystem(perl /home/jbecker/scripts/_device_tracker_argv_v000.pl $p_ubr )\n";
            sleep 5;            
        } else {
            system("perl /home/jbecker/scripts/_device_tracker_argv_v000.pl " . $p_ubr);       
        }
        if ($tty_echo) {
            print _labeled_timestamp("...UBR THREAD END >> $p_ubr");
        }
        return $p_ubr;
}

sub _init_device_list
{
  if($debug) { print "\nenter _init_device_list\n"; }
# since this is a threaded process...  
# ...mysql params need to be local to all functions
  my $host="172.16.30.245";
  my $userid="jbecker";
  my $password="jbecker1";
  my $db = "CST_dbo";
  my $connectionInfo="DBI:mysql:$db:$host";
  my $sth;
  my $ref;

  my $dbh = DBI->connect($connectionInfo,$userid,$password)
          or _emailnotification($DBI::errstr,"WIFI Inventory MySQL-1 Database Connect Error");
  #$dbh->{'mysql_auto_reconnect'} = 1;
  
  my @l_ubrs;
  
  my $ix = 0;
  my $ubrListQry = "SELECT distinct trim(DeviceName) FROM CST_dbo.ubrlist";
  if($debug) {
    $ubrListQry .= " where DeviceName = '$test_ubr'";
  } else {
    $ubrListQry .= " where DeviceName not like '%cdnt%'";
  }
  
  $ubrListQry .= " group by DeviceName";
  
  if($debug) { print "UBR Query: $ubrListQry\n"; }
  
  my $rows = $dbh->selectall_arrayref($ubrListQry);
  if ($rows) {
    foreach my $row (@$rows)
    {
      if ($debug) { print "UBR: @$row[0]\n"; }
      $l_ubrs[$ix] = @$row[0];
      $ix++;
    }    
  } else { print "MySQL Error... Unable to load ubr list.\n"; die; }

  if ($break_point2){ die; }
  
  if($debug) { print "\nexit _init_device_list\n"; }
  my $rc = $dbh->disconnect or warn $dbh->errstr;
  return @l_ubrs;
  if($debug) { print "\nexit _init_device_list\n"; }
}

sub _benchmark_job_start
{
  if($debug) { print "\nenter _benchmark_job_start\n"; }
  my ($job_handle) = @_;

  # since this is a threaded process...  
  # ...mysql params need to be local to all functions
  my $host="172.16.30.245";
  my $userid="jbecker";
  my $password="jbecker1";
  my $db = "CST_dbo";
  my $connectionInfo="DBI:mysql:$db:$host";
  my $sth;
  my $ref;

  my $dbh = DBI->connect($connectionInfo,$userid,$password)
          or _emailnotification($DBI::errstr,"WIFI Inventory MySQL-1 Database Connect Error");
  #$dbh->{'mysql_auto_reconnect'} = 1;

  my $insertQry = "INSERT INTO device_read_benchmark \n
                   (job_handle, description, start_time, stop_time) \n
                    select concat('$job_handle', year( now( ) ),  \n
                      if( length( month( now( ) ) ) < 2, concat( '0', month( now( ) ) ), month( now( ) ) ), \n
                      if(length(day(now())) < 2, concat('0', day(now())), day(now())) \n
                      ) as job_handle \n
                    ,   concat('This is the ', '$job_handle', ' benchmark.') as description \n
                    ,   now() as start_time \n
                    ,   NULL as stop_time \n";
  
  if ($debug) {
    print "$insertQry";
  }
  
  if ($break_point1){ die; }
  
  my $insertQrySth = $dbh->prepare($insertQry);
  $insertQrySth->execute();
  my $rc = $dbh->disconnect or warn $dbh->errstr;
  if($debug) { print "\nexit _benchmark_job_start\n"; }
}

sub _benchmark_job_stop
{
  if($debug) { print "\nenter _benchmark_job_stop\n"; }
  my ($job_handle) = @_;

  # since this is a threaded process...  
  # ...mysql params need to be local to all functions
  my $host="172.16.30.245";
  my $userid="jbecker";
  my $password="jbecker1";
  my $db = "CST_dbo";
  my $connectionInfo="DBI:mysql:$db:$host";
  my $sth;
  my $ref;

  my $dbh = DBI->connect($connectionInfo,$userid,$password)
          or _emailnotification($DBI::errstr,"WIFI Inventory MySQL-1 Database Connect Error");
  #$dbh->{'mysql_auto_reconnect'} = 1;

  my $updateQry;
  $updateQry = "UPDATE device_read_benchmark \n
                set stop_time = now() \n
                where job_handle like '$job_handle%' \n
                and stop_time is NULL \n";

  my $updateQrySth = $dbh->prepare($updateQry);
  $updateQrySth->execute();
  if($debug) { print "\nexit _benchmark_job_stop\n"; }
}

sub _benchmark_report
{
  if($debug) { print "\nenter _benchmark_report\n"; }

  # since this is a threaded process...  
  # ...mysql params need to be local to all functions
  my $host="172.16.30.245";
  my $userid="jbecker";
  my $password="jbecker1";
  my $db = "CST_dbo";
  my $connectionInfo="DBI:mysql:$db:$host";
  my $sth;
  my $ref;

  my $dbh = DBI->connect($connectionInfo,$userid,$password)
          or _emailnotification($DBI::errstr,"WIFI Inventory MySQL-1 Database Connect Error");
  #$dbh->{'mysql_auto_reconnect'} = 1;

  my $reportQry;
  $reportQry = "select  job_handle, \n
                        start_time, \n
                        stop_time, \n
                        subtime(time(max(stop_time)), time(min(start_time))) as benchmark \n
                from CST_dbo.device_read_benchmark \n
                group by job_handle \n
                order by stop_time desc";
# $reportQry .= "where stop_time = (select max(stop_time) from CST_dbo.device_read_benchmark)";
  my $stats = $dbh->selectall_arrayref($reportQry);

  foreach my $line_stat (@$stats) {
   my ($job_handle, $start_time, $stop_time, $benchmark) = @$line_stat;
   print "JOB: $job_handle, START: $start_time, STOP: $stop_time BENCHMARK: $benchmark\n";
  }
  my $rc = $dbh->disconnect or warn $dbh->errstr;
  if($debug) { print "\nexit _benchmark_report\n"; }
}

sub _labeled_timestamp
{
    my ($p_label) = @_;
    my $l_timestamp;

    my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);
    $year += 1900;
    
    if (length($mon) < 2) { $mon += "0"; }
    if (length($mday) < 2) { $mday += "0"; }
    if (length($hour) < 2) { $hour += "0"; }
    if (length($min) < 2) { $min += "0"; }
    if (length($sec) < 2) { $sec += "0"; }
    
    $l_timestamp = "JOB $p_label: $year-$mon-$mday $hour:$min:$sec\n";
    
    return $l_timestamp;
}

sub _emailnotification
{
  if($debug) { print "\nenter _emailnotification\n"; }
  my ($errormessage,$subject) = @_;
  my %mail;
  my ($to,$from,$message);
  #$to = "appdev\@nymanoc.cv.net";
  $to = "jesterjaimi\@gmail.com";
  $from = "WifiInventory\@nymanoc.cv.net";
  $message = "This is a TEST error from the WIFI Inventory System, please investigate immediately\n Error: $errormessage";
  %mail=(To => $to, From => $from, Subject => $subject, Message => $message);

  sendmail(%mail);
  if($debug) { print "\nexit _emailnotification\n"; }
  die;
}