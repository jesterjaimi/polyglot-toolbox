#!/usr/bin/perl

# _device_tracker.pl
# v0.0 of the new cable vision device_tracker script
# james becker, blue wolf group, created: 20110531 last updated: 20110603

#use strict;
# debugging
my $debug = 1;
my $break_point1 = 0;
my $break_point2 = 0;
my $break_point3 = 0;
my $break_point4 = 0;

# includes
use DBI;
use Net::Telnet::Cisco; #Use for telnet to CMTS
use Mail::Sendmail;#Use to email on errors
#use Mail::Sender;#Use to email on errors

# global mysql configuration
my $host="172.16.30.142";
my $userid="jbecker";
my $password="jbecker1";
my $db = "CST_dbo";
my $connectionInfo="DBI:mysql:$db:$host";
my $sth;
my $ref;
my $tbl_benchmark = "CST_dbo.device_read_benchmark";

# global cmts configuration
my @ubrs;
#my $test_ubr = "ubr119.cmts.hcvlny";
my $test_ubr = "ubr201.cmts.hcvlny";
my $job_handle = "_device_tracker_v0_";

if ($debug) {
  print "$connectionInfo\n";
  print "$tbl_benchmark\n";  
}

my $dbh = DBI->connect($connectionInfo,$userid,$password) or _emailnotification($DBI::errstr,"WIFI Inventory MySQL-1 Database Connect Error");

_benchmark_job_start($job_handle);

@ubrs = _init_device_list();

_track_device_status(@ubrs);

_benchmark_job_stop($job_handle);

_benchmark_report();

$dbh->disconnect();

sub _init_device_list
{
  if($debug) { print "\nenter _init_device_list\n"; }
  my @l_ubrs;
  
  my $ix = 0;
  my $ubrListQry = "SELECT distinct trim(DeviceName) FROM CST_dbo.ubrlist";
  if(!$debug) {
    $ubrListQry .= " where DeviceName = '$test_ubr'";
  } else {
    $ubrListQry .= " where DeviceName not like '%cdnt%'";
  }
  
  if($debug) { print "UBR Query: $ubrListQry\n"; }
  
  my $rows = $dbh->selectall_arrayref($ubrListQry);
  if ($rows) {
    foreach my $row (@$rows)
    {
      if ($debug) { print "UBR: @$row[0]\n"; }
      @l_ubrs[$ix] = @$row[0];
      $ix++;
    }    
  } else { print "MySQL Error... Unable to load ubr list.\n"; die; }

  if ($break_point2){ die; }
  
  if($debug) { print "\nexit _init_device_list\n"; }  
  return @l_ubrs;
}

sub _track_device_status
{
  if($debug) { print "\nenter _track_device_status\n"; }
  
  my @ubr_list = @_;
  
  if($debug) { print "UBR_LIST: $ubr_list\n"; }
  
  my %UBRConnectionInfo;
  my $session;
  my $ubr_username = "nocctr";
  my $ubr_password = "1n2d33p1";
  my $TelnetTimeout = 1000;
  my $ubrcommand;
  my @ubroutput;
  my $tbl_device_status = "CST_dbo.device_status";
  
  foreach my $ubr (@ubr_list) {
    if($debug) { print "FOR UBR $ubr  .\n"; }
    %UBRConnectionInfo = ("Host","$ubr","Timeout",$TelnetTimeout,"errmode","return");
    
    if ($debug) { print "('Host',$ubr,'Timeout',$TelnetTimeout,'errmode','return')\n";  }
    #Create connection
    
    if($debug) { print "Connecting to UBR.\n"; }
    if ($session = Net::Telnet::Cisco->new(%UBRConnectionInfo))
    {
      #Log in to CMTS
      if ($debug) { print "Logging in to CMTS<$ubr_username, $ubr_password>.\n"; }
      if ($session->login($ubr_username, $ubr_password))
      {
        #Set a 5MB buffer for the results from the UBR
        $session->max_buffer_length(5 * (1024 * 1024));  
        #Switch to enable mode
        if ($debug) { print "Enabling CMTS Session.\n"; }
        if ($session->enable($ubr_password))
        {
          #Enable the session
          if ($debug) { print "Enabled CMTS Session.\n"; }
          #$ubrcommand = "en"; 
          #$session->cmd(String => $ubrcommand, Timeout => $TelnetTimeout);
          #$session->login($ubr_username, $ubr_password);
          
          #Skip printing this to the screen
          $ubrcommand = "terminal length 0"; 
          $session->cmd(String => $ubrcommand, Timeout => $TelnetTimeout);
                  
          $ubrcommand = "show cable modem reg";
          if ($debug) { print "Executing CMTS Command > $ubrcommand\n"; }
          my @apinfo = $session->cmd(String => $ubrcommand, Timeout => $TelnetTimeout);
      
          if ($debug) { print "Read CMTS Reg Device Status(Line Count: $#apinfo)\n"; }
          for(my $ix=4;$ix<=$#apinfo;$ix++)  {
            #Write registered ubr data to CST_dbo.device_status.
            my @apline = split(" ", @apinfo[$ix] );
            if ($debug) { print "0: @apline[0], 1: @apline[1], 2: @apline[2], 3: @apline[3], 4: @apline[4], 5: @apline[5], 6: @apline[6], 7: @apline[7], 8: @apline[8]\n"; }
            #Write registered ubr data to CST_dbo here.
            if (@apline[0]) {
              my $insertQry ="INSERT INTO $tbl_device_status (device, cmd, interface, online_state, ipaddress, macaddress)
                              VALUES(?, ?, ?, ?, ?, ?)";
              my $insertQrySth = $dbh->prepare($insertQry);
              $insertQrySth->execute($ubr, $ubrcommand, @apline[0], @apline[2], @apline[7], _format_mac_from_cmts(@apline[8]));   
            }
          }#End for(my $i=1;$i<=$#apinfo;$i++)
  
          $ubrcommand = "show cable modem unreg";
          if ($debug) { print "Executing CMTS Command > $ubrcommand\n"; }
          my @apinfo = $session->cmd(String => $ubrcommand, Timeout => $TelnetTimeout);
          
          if ($debug) { print "Read CMTS Reg Device Status(Line Count: $#apinfo)\n"; }
          for(my $iy=4;$iy<=$#apinfo;$iy++) {
            #Write unregistered ubr data to CST_dbo.device_status.
            my @apline = split(" ", @apinfo[$iy] );
            if ($debug) { print "0: @apline[0], 1: @apline[1], 2: @apline[2], 3: @apline[3], 4: @apline[4], 5: @apline[5], 6: @apline[6], 7: @apline[7], 8: @apline[8]\n"; }
            #Write registered ubr data to CST_dbo here.
            if (@apline[0]) {
              my $insertQry ="INSERT INTO $tbl_device_status (device, cmd, interface, online_state, ipaddress, macaddress)
                              VALUES(?, ?, ?, ?, ?, ?)";
              my $insertQrySth = $dbh->prepare($insertQry);
              $insertQrySth->execute($ubr, $ubrcommand,  @apline[0], @apline[2], @apline[7], _format_mac_from_cmts(@apline[8]));   
            }
          }#End for(my $i=1;$i<=$#apinfo;$i++)
        }#End $session->enable($ubr_password)
        else
        {
          print "$session->errmsg,'Could not access enable mode on CMTS $ubr during WIFI discovery'\n";
          _emailnotification($session->errmsg,"Could not access enable mode on CMTS $ubr during WIFI discovery");
        }
      }#End if ($session->login($ubr_username, $ubr_password))
      else
      {
        print "$session->errmsg,'Could not log in to CMTS $ubr during WIFI discovery'\n";
        _emailnotification($session->errmsg,"Could not log in to CMTS $ubr during WIFI discovery");
      }
    }#End if ($session = Net::Telnet::Cisco->new(%UBRConnectionInfo))
    else
    {
      print "$session->errmsg,'Could not create telnet session for $ubr during WIFI discovery'\n";
      _emailnotification($session->errmsg,"Could not create telnet session for $ubr during WIFI discovery");
    } 
  }
  if($debug) {
    print "$session->errmsg,'WTF IS HAPPENING TO THE SESSION!'\n";
    print "\nexit _track_device_status\n";
  }
}#End sub _track_device_status

sub _format_mac_from_cmts
{
  if($debug) { print "\nenter _format_mac_from_cmts\n"; }
  
  my ($macaddress) = @_;
  if($macaddress) {
    $macaddress =~ s/\.//g;
    $macaddress =~ s/^\s+//g;
    $macaddress =~ tr/a-f/A-F/;
    return($macaddress);
  } else { return ""; }
  if($debug) { print "\nexit _format_mac_from_cmts\n"; }
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

sub _benchmark_job_start
{
  if($debug) { print "\nenter _benchmark_job_start\n"; }

  my ($job_handle) = @_;
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
  if($debug) { print "\nexit _benchmark_job_start\n"; }
}

sub _benchmark_job_stop
{
  if($debug) { print "\nenter _benchmark_job_stop\n"; }

  my ($job_handle) = @_;
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

  my $reportQry;
  $reportQry = "select job_handle, start_time, stop_time \n
                from CST_dbo.device_read_benchmark 
                order by stop_time desc";
  # $reportQry .= "where stop_time = (select max(stop_time) from CST_dbo.device_read_benchmark)";
  my $stats = $dbh->selectall_arrayref($reportQry);

  foreach my $stat (@$stats) {
   my ($job_handle, $start_time, $stop_time) = @$stat;
   print "JOB: $job_handle, START: $start_time, STOP: $stop_time \n";
  }
  if($debug) { print "\nexit _benchmark_report\n"; }
}