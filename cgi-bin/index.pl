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
sub add_appointment;

# read the CGI params
my $cgi = CGI->new;
my $ajax = $cgi->param("ajax");

if ($cgi->param() && $ajax) {
	#ajax request
	my $search = $cgi->param("search");
	print $cgi->header(-type => "application/json", -charset => "utf-8");
	render_json($search);
} else {
	my $submit = $cgi->param("submit");
	my $error;
	if ($submit) {
		#form submitted
		my $date = $cgi->param("date");
		if ( $date !~ /^[-0-9]+$/ ) {
		     $error = "illigal date";
		 }
		my $time = $cgi->param("time");
		if ( $time !~ /^[:0-9]+$/ ) {
		     $error = "illigal time";
		 }
		my $desc = $cgi->param("desc");
		if ( $desc !~ /^\w+$/ ) {
		     $error = "illigal desc";
		 }
		 #validating
		if (length $error == 0) {
			add_appointment($date." ".$time.":00", $desc);
		}
	}
    
    print $cgi->header();
	render_html($error);
}

exit 0;

##
# takes datetime and description as arguments
# inserts a new record
##
sub add_appointment {
	my $dbh = get_db_handler();

	my $statement = qq{INSERT INTO `appointments`(`datetime`,`description`) VALUES(?,?)};
 	my $sth = $dbh->prepare($statement)
 	  or die $dbh->errstr;
 	$sth->execute($_[0],$_[1])
 	  or die $sth->errstr;
}

##
# returns a MySQL DB handler
##
sub get_db_handler {
	my %config = do '../config.pl';
	my $dbh = DBI->connect("DBI:mysql:database=".$config{db}.";host=".$config{dbserver}."", $config{user}, $config{password})
	  or die $DBI::errstr;
	return $dbh;
}

##
# optional parameter ERROR_MESSAGE
# renders an HTML file contains the main view
##
sub render_html($) {

	local $/;
	my $file = '../resources/main.html';
	open my $fh, '<', $file
		or die "can't open $file to read: $!";
	my $data = <$fh>;
	close $fh;

	if (length $_[0] > 0) {
		my $error_div = "<div class='error-div'>".$_[0]."</div>";
		my $error_holder = "<!--ERROR_HOLDER-->";
		$data =~ s/$error_holder/$error_div/g;
	}
	print $data;
}

##
# selects the records from the DB
# mapping the selected rows into a JSON object
##
sub render_json($) {

	my $dbh = get_db_handler();
	 
	$_[0] =~ s/ /%/g;
	my $rowsref = $dbh->selectall_hashref("SELECT `id`, `datetime`, `description` FROM `appointments` WHERE description LIKE \"%".$_[0]."%\"", q/id/);
	print JSON::XS::encode_json($rowsref);
}