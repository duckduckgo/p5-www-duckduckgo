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

=encoding utf8

=head1 SYNOPSIS

  use WWW::DuckDuckGo;

  my $zci = WWW::DuckDuckGo->new->zci('duck duck go');
  
  print "Heading: ".$zci->heading if $zci->has_heading;
  
  print "The answer is: ".$zci->answer if $zci->has_answer;

=head1 DESCRIPTION

This package reflects the result of a zeroclickinfo API request.

=head1 METHODS

=method has_abstract

=method abstract

=method has_abstract_text

=method abstract_text

=method has_abstract_source

=method abstract_source

=method has_abstract_url

=method abstract_url

Gives back a URI::http

=method has_image

=method image

Gives back a URI::http

=method has_heading

=method heading

=method has_answer

=method answer

=method has_answer_type

=method answer_type

=method has_definition

=method definition

=method has_definition_source

=method definition_source

=method has_definition_url

=method definition_url

Gives back a URI::http

=method has_related_topics

=method related_topics

Gives back an array reference of L<WWW::DuckDuckGo::Link> objects.

=method has_results

=method results

Gives back an array reference of L<WWW::DuckDuckGo::Link> objects.

=method has_type

=method type

=method type_long

Gives back a longer version of the type.

=head1 SUPPORT

IRC

  Join #duckduckgo on irc.freenode.net. Highlight Getty for fast reaction :).

Repository

  http://github.com/Getty/p5-www-duckduckgo
  Pull request and additional contributors are welcome
 
Issue Tracker

  http://github.com/Getty/p5-www-duckduckgo/issues



