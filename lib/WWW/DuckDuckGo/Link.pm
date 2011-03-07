package WWW::DuckDuckGo::Link;
# ABSTRACT: A DuckDuckGo Link definition

use Moo;
use WWW::DuckDuckGo::Icon;
use URI;

sub by {
	my ( $class, $link_result ) = @_;
	my %params;
	$params{result} = $link_result->{Result} if $link_result->{Result};
	$params{first_url} = URI->new($link_result->{FirstURL}) if $link_result->{FirstURL};
	$params{icon} = $class->_icon_class->by($link_result->{Icon}) if %{$link_result->{Icon}};
	$params{text} = $link_result->{Text} if $link_result->{Text};
	__PACKAGE__->new(%params);
}

sub _icon_class { 'WWW::DuckDuckGo::Icon' }

has result => (
	is => 'ro',
	predicate => 'has_result',
);

has first_url => (
	is => 'ro',
	predicate => 'has_first_url',
);

has icon => (
	is => 'ro',
	predicate => 'has_icon',
);

has text => (
	is => 'ro',
	predicate => 'has_text',
);

1;

=encoding utf8

=head1 SYNOPSIS

  use WWW::DuckDuckGo;

  my $zci = WWW::DuckDuckGo->new->zci('duck duck go');
  
  for (@{$zci->related_topics}) {
    print "Related Topic URL: ".$_->first_url."\n" if $_->has_first_url;
  }

=head1 DESCRIPTION

This package reflects the result of a zeroclickinfo API request.

=head1 METHODS

=method has_result

=method result

=method has_first_url

=method first_url

Gives back a URI::http

=method has_icon

=method icon

Gives back an L<WWW::DuckDuckGo::Icon> object.

=method has_text

=method text

=head1 SUPPORT

IRC

  Join #duckduckgo on irc.freenode.net. Highlight Getty for fast reaction :).

Repository

  http://github.com/Getty/p5-www-duckduckgo
  Pull request and additional contributors are welcome
 
Issue Tracker

  http://github.com/Getty/p5-www-duckduckgo/issues

  
  
