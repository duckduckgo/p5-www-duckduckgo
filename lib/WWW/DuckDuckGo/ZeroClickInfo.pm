package WWW::DuckDuckGo::ZeroClickInfo;
# ABSTRACT: A DuckDuckGo Zero Click Info definition

use Moo;
use WWW::DuckDuckGo::Link;
use URI;

sub by {
	my ( $class, $result ) = @_;
	my @related_topics;
	for (@{$result->{RelatedTopics}}) {
		push @related_topics, $class->_link_class->by($_) if %{$_};
	}
	my @results;
	for (@{$result->{Results}}) {
		push @results, $class->_link_class->by($_) if %{$_};
	}
	my %params;
	$params{abstract} = $result->{Abstract} if $result->{Abstract};
	$params{abstract_text} = $result->{AbstractText} if $result->{AbstractText};
	$params{abstract_source} = $result->{AbstractSource} if $result->{AbstractSource};
	$params{abstract_url} = URI->new($result->{AbstractURL}) if $result->{AbstractURL};
	$params{image} = URI->new($result->{Image}) if $result->{Image};
	$params{heading} = $result->{Heading} if $result->{Heading};
	$params{answer} = $result->{Answer} if $result->{Answer};
	$params{answer_type} = $result->{AnswerType} if $result->{AnswerType};
	$params{definition} = $result->{Definition} if $result->{Definition};
	$params{definition_source} = $result->{DefinitionSource} if $result->{DefinitionSource};
	$params{definition_url} = URI->new($result->{DefinitionURL}) if $result->{DefinitionURL};
	$params{related_topics} = \@related_topics if @related_topics;
	$params{results} = \@results if @results;
	$params{type} = $result->{Type} if $result->{Type};
	__PACKAGE__->new(%params);
}

sub _link_class { 'WWW::DuckDuckGo::Link' }

has abstract => (
	is => 'ro',
	predicate => 'has_abstract',
);

has abstract_text => (
	is => 'ro',
	predicate => 'has_abstract_text',
);

has abstract_source => (
	is => 'ro',
	predicate => 'has_abstract_source',
);

has abstract_url => (
	is => 'ro',
	predicate => 'has_abstract_url',
);

has image => (
	is => 'ro',
	predicate => 'has_image',
);

has heading => (
	is => 'ro',
	predicate => 'has_heading',
);

has answer => (
	is => 'ro',
	predicate => 'has_answer',
);

has answer_type => (
	is => 'ro',
	predicate => 'has_answer_type',
);

has definition => (
	is => 'ro',
	predicate => 'has_definition',
);

has definition_source => (
	is => 'ro',
	predicate => 'has_definition_source',
);

has definition_url => (
	is => 'ro',
	predicate => 'has_definition_url',
);

has related_topics => (
	is => 'ro',
	predicate => 'has_related_topics',
);

has results => (
	is => 'ro',
	predicate => 'has_results',
);

has type => (
	is => 'ro',
	predicate => 'has_type',
);

has type_long_definitions => (
	is => 'ro',
	lazy => 1,
	default => sub {{
		A => 'article',
		D => 'disambiguation',
		C => 'category',
		N => 'name',
		E => 'exclusive',
	}},
);

sub type_long {
	my ( $self ) = @_;
	return if !$self->type;
	$self->type_long_definitions->{$self->type};
}

1;