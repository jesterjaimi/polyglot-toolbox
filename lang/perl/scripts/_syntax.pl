#!/usr/bin/perl
# _syntax.pl
use strict;
use DBI;
my $debug = 1;

# global mysql configuration
my $host="172.16.30.142";
my $userid="jbecker";
my $password="jbecker1";
my $db = "CST_dbo";
my $connectionInfo="DBI:mysql:$db:$host";
my $sth;
my $ref;
my $tbl_benchmark = "CST_dbo.device_read_benchmark";

print "$connectionInfo\n";
print "$tbl_benchmark";

my $dbh=DBI->connect($connectionInfo,$userid,$password) or _emailnotification($DBI::errstr,"WIFI Inventory MySQL-1 Database Connect Error");

die;

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