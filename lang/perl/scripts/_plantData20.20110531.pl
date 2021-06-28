#!/usr/bin/perl

# _device_tracker.pl
# v0.0 of our new 

use strict;
use DBI;
use Net::Telnet::Cisco; #Use for telnet to CMTS
use Mail::Sendmail;#Use to email on errors

sub telnet2cmts()
{
  my $host="172.16.30.142";
  my $userid="jbecker";
  my $password="jbecker1";
  my $db = "CST_dbo";
  my $connectionInfo="DBI:mysql:$db:$host";
  my $dbh=DBI->connect($connectionInfo,$userid,$password) or &emailnotification($DBI::errstr,"WIFI Inventory AppMaster1 Database Connect Error");
  my $sth;
  my $ref;
 

  #UBR Variables#
  my %UBRConnectionInfo;
  my $session;
  my $ubr_username = "nocctr";
  my $ubr_password = "1n2d33p1";
  my $TelnetTimeout = 300;
  my $ubrcommand;
  my @ubroutput;

  %UBRConnectionInfo = ("Host","$ubr","Timeout",$TelnetTimeout,"errmode","return");  
  #Create connection
  if ($session = Net::Telnet::Cisco->new(%UBRConnectionInfo))
  {
    #Log in to CMTS
    if ($session->login($ubr_username, $ubr_password))
    {
      #Set a 5MB buffer for the results from the UBR
      $session->max_buffer_length(1 * (1024 * 1024));  
      #Switch to enable mode
      if ($session->enable($ubr_password))
      {
        #Enable the session
        $ubrcommand = "en"; 
        $session->cmd(String => $ubrcommand, Timeout => $TelnetTimeout);
        
        #Skip printing this to the screen
        $ubrcommand = "terminal length 0"; 
        $session->cmd(String => $ubrcommand, Timeout => $TelnetTimeout);
        
        $ubrcommand = "show cable modem reg";
        @apinfo = $session->cmd(String => $ubrcommand, Timeout => $TelnetTimeout);
    
        for(my $i=1;$i<=$#apinfo;$i++)
        {
          #Write data to CST_dbo here.
        }#End for(my $i=1;$i<=$#apinfo;$i++)

        $ubrcommand = "show cable modem unreg";
        @apinfo = $session->cmd(String => $ubrcommand, Timeout => $TelnetTimeout);
    
        for(my $i=1;$i<=$#apinfo;$i++)
        {
          #Write data to CST_dbo here.
        }#End for(my $i=1;$i<=$#apinfo;$i++)

      }#End $session->enable($ubr_password)
      else
      {
        &emailnotification($session->errmsg,"Could not access enable mode on CMTS $ubr during WIFI discovery");
      }
    }#End if ($session->login($ubr_username, $ubr_password))
    else
    {
      &emailnotification($session->errmsg,"Could not log in to CMTS $ubr during WIFI discovery");
    }
  }#End if ($session = Net::Telnet::Cisco->new(%UBRConnectionInfo))
  else
  {
    &emailnotification($session->errmsg,"Could not create telnet session for $ubr during WIFI discovery");
  }
}#End sub getAPinfo

sub formatMACfromCMTS
{
  my ($macaddress) = @_;
  $macaddress =~ s/\.//g;
  $macaddress =~ s/^\s+//g;
  $macaddress =~ tr/a-f/A-F/;
  return($macaddress); 
}
sub emailnotification
{
  my ($errormessage,$subject) = @_;
  my %mail;
  my ($to,$from,$message);
  #$to = "appdev\@nymanoc.cv.net";
  $to = "ccioffi\@cablevision.com";
  $from = "WifiInventory\@nymanoc.cv.net";
  $message = "This is a critical error from the WIFI Inventory System, please investigate immediately\n Error: $errormessage";
  %mail=(To => $to, From => $from, Subject => $subject, Message => $message);

  sendmail(%mail);
  die;
}
