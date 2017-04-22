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
my $submit = $cgi->param("submit");

if ($cgi->param() && $submit) {
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
    my ($cgi) = @_;
    print $cgi->start_html(
        -title => 'Appointments',
        -bgcolor => 'white');

    print $cgi->start_form(
        -name => 'main',
        -method => 'POST',
    );

    print $cgi->start_table;
    print $cgi->Tr(
      $cgi->td(
        $cgi->textfield(-name => "search", -size => 50)
      ),
      $cgi->td($cgi->submit(-name => "submit", -value => 'Search')),
    );

    print $cgi->end_table;
    print $cgi->end_form;

    print $cgi->end_html;
}

sub render_json($) {

	my $dbh = get_db_handler();
	 
	# @TODO replace all spaces with % in $search
	my $rowsref = $dbh->selectall_hashref("SELECT `id`, `datetime`, `description` FROM `appointments` WHERE description LIKE \"%".$_[0]."%\"", q/id/);
	print JSON::XS::encode_json($rowsref);
}