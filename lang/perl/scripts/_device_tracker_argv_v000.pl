#!/usr/bin/perl

# _device_tracker_argv_v000.pl
# v000 of the cable vision single ubr device_tracker_argv script

# james becker, blue wolf group, created: 20110531 last updated: 20110607

use strict;
# debugging
my $debug = 0;
my $break_point1 = 0;
my $break_point2 = 0;
my $break_point3 = 0;
my $break_point4 = 0;

# includes
use DBI;
use Net::Telnet::Cisco; #Use for telnet to CMTS
#email errors
#use Mail::Sendmail; # ...for *nix clients
#use Mail::Sender;# ...for windoz clients

# global cmts configuration
my $ubr = "";
#my $test_ubr = "ubr119.cmts.hcvlny";
my $test_ubr = "ubr201.cmts.hcvlny";
my $job_handle = "_device_tracker_v000_";

my $num_args = $#ARGV + 1;
if ($num_args != 1) {
  my $errmsg = "\nUsage: _device_tracker_argv_v000.pl ubr\n";
  print "$errmsg";
  print '@ARGV {\n' . @ARGV . '}\n';
  die;
} else { $ubr = $ARGV[0]; }

$ubr = _init_device();

_track_device_status($ubr);

if ($debug) {print "SAYONARA BABY!";}
exit 0;

sub _init_device
{
  #check the database to make sure we are accessing a known ubr
  if($debug) { print "\nenter _init_device\n"; }
  
  # local mysql configuration
  my $host="172.16.30.245";
  my $userid="jbecker";
  my $password="jbecker1";
  my $db = "CST_dbo";
  my $connectionInfo="DBI:mysql:$db:$host";
  my $sth;
  my $ref;
  my $tbl_benchmark = "CST_dbo.device_read_benchmark";
  my $l_ubr = "";

  my $dbh = DBI->connect($connectionInfo,$userid,$password)
          or _emailnotification($DBI::errstr,"WIFI Inventory MySQL-1 Database Connect Error");

  my $ix = 0;
  my $ubrListQry = "SELECT distinct trim(DeviceName) FROM CST_dbo.ubrlist";
  if($debug) {
    $ubrListQry .= " where DeviceName = '$test_ubr'";
  } else {
    $ubrListQry .= " where DeviceName = '$ubr' and DeviceName not like '%cdnt%'";
  }
  
  $ubrListQry .= " group by DeviceName";
  
  if($debug) { print "UBR Query: $ubrListQry\n"; }
  
  my $row = $dbh->selectrow_array($ubrListQry);
  if ($row) {
    if ($debug) { print "UBR: $row\n"; }
    $l_ubr = $row;
      
  } else { print "MySQL Error... Unable to load ubr list.\n"; die; }

  if ($break_point2){ die; }
  
  if($debug) { print "\nexit _init_device\n"; }  
  return $l_ubr;
}

sub _track_device_status
{
  if($debug) { print "\nenter _track_device_status\n"; }
  
  my ($p_ubr) = @_;
  
  if($debug) { print "UBR_LIST: $p_ubr\n"; }
  
  my %UBRConnectionInfo;
  my $session;
  my $ubr_username = "nocctr";
  my $ubr_password = "1n2d33p1";
  my $TelnetTimeout = 1000;
  my $ubrcommand;
  my @ubroutput;
  my $tbl_device_status = "CST_dbo.device_status";

  # local mysql configuration
  my $host="172.16.30.245";
  my $userid="jbecker";
  my $password="jbecker1";
  my $db = "CST_dbo";
  my $connectionInfo="DBI:mysql:$db:$host";
  my $sth;
  my $ref;
  my $tbl_benchmark = "CST_dbo.device_read_benchmark";
  my $l_ubr = "";
  
  if ($debug) {
    print "Database Credz: $connectionInfo,$userid,$password\n";
  }
  
  my $dbh = DBI->connect($connectionInfo,$userid,$password)
          or _emailnotification($DBI::errstr,"WIFI Inventory MySQL-1 Database Connect Error");
  $dbh->{'mysql_auto_reconnect'} = 1;
  
  if($p_ubr) {
    if($debug) { print "FOR UBR: $p_ubr.\n"; }
    %UBRConnectionInfo = ("Host","$p_ubr","Timeout",$TelnetTimeout,"errmode","return");
    
    if ($debug) { print "('Host',$p_ubr,'Timeout',$TelnetTimeout,'errmode','return')\n";  }
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
          my @apinforeg = $session->cmd(String => $ubrcommand, Timeout => $TelnetTimeout);
      
          if ($debug) { print "Read CMTS Reg Device Status(Line Count: $#apinforeg)\n"; }
          for(my $ix=4;$ix<=$#apinforeg;$ix++)  {
            #Write registered ubr data to CST_dbo.device_status.
            my @apline = split(" ", $apinforeg[$ix] );
            if ($debug) { print "0: $apline[0], 1: $apline[1], 2: $apline[2], 3: $apline[3], 4: $apline[4], 5: $apline[5], 6: $apline[6], 7: $apline[7], 8: $apline[8]\n"; }
            #Write registered ubr data to CST_dbo here.
            if ($apline[0]) {
              my $insertQry ="INSERT INTO $tbl_device_status (device, cmd, interface, online_state, ipaddress, macaddress)
                              VALUES(?, ?, ?, ?, ?, ?)";
              my $insertQrySth = $dbh->prepare($insertQry);
              $insertQrySth->execute($p_ubr, $ubrcommand, $apline[0], $apline[2], $apline[7], _format_mac_from_cmts($apline[8]));   
            }
          }#End for(my $i=1;$i<=$#apinfo;$i++)
  
          $ubrcommand = "show cable modem unreg";
          if ($debug) { print "Executing CMTS Command > $ubrcommand\n"; }
          my @apinfounreg = $session->cmd(String => $ubrcommand, Timeout => $TelnetTimeout);
          
          if ($debug) { print "Read CMTS Reg Device Status(Line Count: $#apinfounreg)\n"; }
          for(my $iy=4;$iy<=$#apinfounreg;$iy++) {
            #Write unregistered ubr data to CST_dbo.device_status.
            my @apline = split(" ", $apinfounreg[$iy] );
            if ($debug) { print "0: $apline[0], 1: $apline[1], 2: $apline[2], 3: $apline[3], 4: $apline[4], 5: $apline[5], 6: $apline[6], 7: $apline[7], 8: $apline[8]\n"; }
            #Write registered ubr data to CST_dbo here.
            if ($apline[0]) {
              my $insertQry ="INSERT INTO $tbl_device_status (device, cmd, interface, online_state, ipaddress, macaddress)
                              VALUES(?, ?, ?, ?, ?, ?)";
              my $insertQrySth = $dbh->prepare($insertQry);
              $insertQrySth->execute($p_ubr, $ubrcommand,  $apline[0], $apline[2], $apline[7], _format_mac_from_cmts($apline[8]));   
            }
          }#End for(my $i=1;$i<=$#apinfo;$i++)
        }#End $session->enable($ubr_password)
        else
        {
          print "$session->errmsg,'Could not access enable mode on CMTS $p_ubr during WIFI discovery'\n";
          #_emailnotification($session->errmsg,"Could not access enable mode on CMTS $p_ubr during WIFI discovery");
        }
      }#End if ($session->login($ubr_username, $ubr_password))
      else
      {
        print "$session->errmsg,'Could not log in to CMTS $p_ubr during WIFI discovery'\n";
        #_emailnotification($session->errmsg,"Could not log in to CMTS $p_ubr during WIFI discovery");
      }
    }#End if ($session = Net::Telnet::Cisco->new(%UBRConnectionInfo))
    else
    {
      #print "$session->errmsg,'Could not create telnet session for $p_ubr during WIFI discovery'\n";
      print "NULL session,'Could not create telnet session for $p_ubr during WIFI discovery'\n";
      #_emailnotification($session->errmsg,"Could not create telnet session for $p_ubr during WIFI discovery");
    } 
  }
  my $rc = $dbh->disconnect or warn $dbh->errstr;
  if($debug) {
    #print "$session->errmsg,'WTF IS HAPPENING TO THE SESSION!'\n";
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

#sub _emailnotification
#{
#  if($debug) { print "\nenter _emailnotification\n"; }
#  my ($errormessage,$subject) = @_;
#  my %mail;
#  my ($to,$from,$message);
  #$to = "appdev\@nymanoc.cv.net";
#  $to = "jesterjaimi\@gmail.com";
#  $from = "WifiInventory\@nymanoc.cv.net";
#  $message = "This is a TEST error from the WIFI Inventory System, please investigate immediately\n Error: $errormessage";
#  %mail=(To => $to, From => $from, Subject => $subject, Message => $message);

#  sendmail(%mail);
#  if($debug) { print "\nexit _emailnotification\n"; }
#  die;
#}