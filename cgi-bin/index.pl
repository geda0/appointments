#!/usr/bin/perl

use CGI;
use DBI;
use strict;
use warnings;

sub render_html($);
sub render_json($);

# read the CGI params
my $cgi = CGI->new;
my $search = $cgi->param("search");


if ($cgi->param() && $search) {#get params
	print $cgi->header(-type => "application/json", -charset => "utf-8");
	# print $search
	render_json($cgi);
} else {
	#if POST params
	##validate
	##insert
    
    print $cgi->header();
	render_html($cgi);
}

exit 0;

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
      $cgi->td($cgi->submit(-value => 'Search')),
    );

    print $cgi->end_table;
    print $cgi->end_form;

    print $cgi->end_html;
}

sub render_json($) {
	# connect to the database ## to be used later
	my $dbh = DBI->connect("DBI:mysql:database=appointments;host=localhost;port=",  
	  "root", "1331") 
	  or die $DBI::errstr;
	 
	my $statement = qq{SELECT * FROM appointments WHERE description LIKE "%?%"};
	my $sth = $dbh->prepare($statement)
	  or die $dbh->errstr;
	$sth->execute($search)
	  or die $sth->errstr;
	my ($appointment) = $sth->fetchrow_array;
}