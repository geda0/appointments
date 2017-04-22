#!/usr/bin/perl

use CGI;
use CGI::Carp 'fatalsToBrowser';#for perl beginners like me...
use DBI;
use JSON::XS;
use strict;
use warnings;
sub render_html($);
sub render_json($);
sub get_db_handler;

# read the CGI params
my $cgi = CGI->new;
my $ajax = $cgi->param("ajax");

if ($cgi->param() && $ajax) {
	my $search = $cgi->param("search");
	print $cgi->header(-type => "application/json", -charset => "utf-8");
	render_json($search);
} else {
	#if POST params
	##validate
	##insert
    
    print $cgi->header();
	render_html($cgi);
}

exit 0;

sub get_db_handler {
	my %config = do '../config.pl';
	my $dbh = DBI->connect("DBI:mysql:database=".$config{db}.";host=".$config{dbserver}."", $config{user}, $config{password})
	  or die $DBI::errstr;
	return $dbh;
}

sub render_html($) {
	local $/;
	my $file = '../resources/main.html';
	open my $fh, '<', $file
	or die "can't open $file to read: $!";
	my $data = <$fh>;
	close $fh
	or die "cannot close $file: $!";
	print $data;
}

sub render_json($) {

	my $dbh = get_db_handler();
	 
	# @TODO replace all spaces with % in $search
	my $rowsref = $dbh->selectall_hashref("SELECT `id`, `datetime`, `description` FROM `appointments` WHERE description LIKE \"%".$_[0]."%\"", q/id/);
	print JSON::XS::encode_json($rowsref);
}