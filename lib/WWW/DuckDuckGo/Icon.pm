package WWW::DuckDuckGo::Icon;
# ABSTRACT: A DuckDuckGo Icon definition

use Moo;
use URI;

sub by {
	my ( $class, $icon_result ) = @_;
	my %params;
	$params{url} = URI->new($icon_result->{URL}) if $icon_result->{URL};
	$params{height} = $icon_result->{Height} if $icon_result->{Height};
	$params{width} = $icon_result->{Width} if $icon_result->{Width};
	__PACKAGE__->new(%params);
}

has url => (
	is => 'ro',
	predicate => 'has_url',
);

has width => (
	is => 'ro',
	predicate => 'has_width',
);

has height => (
	is => 'ro',
	predicate => 'has_height',
);

1;

=encoding utf8

=head1 SYNOPSIS

  use WWW::DuckDuckGo;

  my $zci = WWW::DuckDuckGo->new->zci('duck duck go');
  
  for (@{$zci->results}) {
    print "Result URL: ".$_->first_url->as_string."\n" if $_->has_first_url;
    print "Result Icon: ".$_->icon->url->as_string."\n" if $_->has_icon and $_->icon->has_url;
  }

=head1 DESCRIPTION

This package reflects the result of a zeroclickinfo API request.

=head1 METHODS

=method has_url

=method url

Gives back a URI::http

=method has_width

=method width

=method has_height

=method height

=head1 SUPPORT

IRC

  Join #duckduckgo on irc.freenode.net. Highlight Getty for fast reaction :).

Repository

  http://github.com/Getty/p5-www-duckduckgo
  Pull request and additional contributors are welcome
 
Issue Tracker

  http://github.com/Getty/p5-www-duckduckgo/issues

  
