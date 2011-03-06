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