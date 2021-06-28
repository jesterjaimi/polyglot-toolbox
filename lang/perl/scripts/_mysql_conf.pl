# global mysql configuration
my $host="172.16.30.142";
my $userid="jbecker";
my $password="jbecker1";
my $db = "CST_dbo";
my $connectionInfo="DBI:mysql:$db:$host";
my $sth;
my $ref;
my $tbl_benchmark = "CST_dbo.device_read_benchmark";