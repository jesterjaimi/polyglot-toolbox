#!/usr/bin/perl

#######################################################################
#                                                                     #
#                                                                     #
#  Script Name: controllerInventory.pl                                #
#  Description: Collect radios from controllers and update radio      #
#               inventory table                                       #
#                                                                     #
#  Author: Chris Cioffi                                               #
#                                                                     #
#  Date: 5/13/09                                                      #
#                                                                     #
#  NOC APPLICATION DEVELOPMENT TEAM                                   #
#                                                                     #
#######################################################################

#Library Declarations
use strict;
use DBI;
use Net::SNMP;

my %controllers;
 
&GetControllers;
&snmpControllers;

sub GetControllers
{
  my $MySQL_host = '172.16.30.77';
  my $MySQL_db = 'WIFI';
  my $MySQL_username = 'radios';
  my $DSN = sprintf("DBI:mysql:%s:host=%s",$MySQL_db,$MySQL_host);
  my $MySQL_dbh = DBI->connect($DSN,$MySQL_username,$MySQL_password);
  my $controllersth;
  my $query;
  my $ref;
   
  $controllersth = $MySQL_dbh->prepare("SELECT controllerIndex,controllerIP FROM tbl_ControllerInventory;");
  $controllersth->execute();

  while($ref = $controllersth->fetchrow_hashref) 
  {
    $controllers{$ref->{'controllerIndex'}} = $ref->{'controllerIP'};	
  }
}

sub snmpControllers
{
  my $session;
  my $error;
  my $result;
  my $controllerindex;
  my $community_string = "n0ccTr";
  my $tableoid;
  my $SNMPport = 161;
  my $key;
  my $value;
  my $varbind;
  my $apmac;
 
  open(OUTPUT,">>controllermacs.csv");
 
  foreach $controllerindex(keys(%controllers))
  {
    if((($controllerindex >= 57)&&($controllerindex <= 63))||(($controllerindex == 32) || ($controllerindex == 33) || ($controllerindex ==36)))
    {
      $tableoid = "1.3.6.1.4.1.14179.2.2.1.1.33";
    }
    {
      $tableoid = "1.3.6.1.4.1.14179.2.2.1.1.1";
    }
    print "$controllers{$controllerindex}\n";
    ($session, $error) = Net::SNMP->session(-hostname=>$controllers{$controllerindex},-community=>$community_string,-port=>$SNMPport,-version=>'2c');
    if (defined($session))
    {
    	$result = $session->get_table(-baseoid => $tableoid);
    }
    else
    {
    	print "SNMP session failed for $controllerindex\n";
    }
    if(defined($result))
    {
    	foreach $varbind (keys(%{$result}))
    	{
    	  $apmac = $result->{$varbind};
    	  $apmac=~s/0x//g;
    	  $apmac=~tr/[a-z]/[A-Z]/;
    	  print OUTPUT "$apmac\n";
    	}
    }
    else
    {
    	print "No result for $controllerindex\n";
    }
  }
}
