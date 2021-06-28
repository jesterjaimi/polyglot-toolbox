#!/usr/bin/perl

print _labeled_timestamp();

sub _labeled_timestamp
{
    my ($p_label) = @_;
    my $l_timestamp;

    my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);
    $year += 1900;
    $l_timestamp = "JOB $p_label: $year-$mon-$yday $hour:$min:$sec\n";
    
    return $l_timestamp;
}
