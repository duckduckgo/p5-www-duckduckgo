package WWW::DuckDuckGo::ZeroClickInfo;
# ABSTRACT: A DuckDuckGo Zero Click Info definition

use Moo;
use WWW::DuckDuckGo::Link;
use URI;

sub by {
	my ( $class, $result ) = @_;
	my %params;
	if ($result->{RelatedTopics}) {
		$params{related_topics_sections} = {};
		if ($result->{RelatedTopics}->[0]->{Topics}) {
			for (@{$result->{RelatedTopics}}) {
				die "go to irc.freenode.net #duckduckgo and kick yegg, and also tell him your searchterm" if $_->{Name} eq '_';
				my @topics;
				for (@{$_->{Topics}}) {
					push @topics, $class->_link_class->by($_) if ref $_ eq 'HASH' and %{$_};
				}
				$params{related_topics_sections}->{$_->{Name}} = \@topics;
			}
		} else {
			my @topics;
			for (@{$result->{RelatedTopics}}) {
				push @topics, $class->_link_class->by($_) if ref $_ eq 'HASH' and %{$_};
			}
			$params{related_topics_sections}->{_} = \@topics if @topics;
		}
	}
	my @results;
	for (@{$result->{Results}}) {
		push @results, $class->_link_class->by($_) if ref $_ eq 'HASH' and %{$_};
	}
	$params{results} = \@results if @results;
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

sub default_related_topics {
	my ( $self ) = @_;
	defined $self->related_topics_sections->{_} if $self->has_related_topics_sections;
}

sub has_default_related_topics {
	my ( $self ) = @_;
	$self->has_related_topics_sections and defined $self->related_topics_sections->{_} ? 1 : 0;
}

has related_topics_sections => (
	is => 'ro',
	predicate => 'has_related_topics_sections',
);

# DEPRECATED WARN
sub related_topics {
	warn __PACKAGE__.": usage of the function related_topics is deprecated, use default_related_topics for the same functionality (also see: related_topics_sections)";
	shift->default_related_topics(@_);
}
################

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
  
  if ($zci->has_default_related_topics) {
    for (@{$zci->default_related_topics}) {
      print $_->url."\n";
    }
  }
  
  if (!$zci->has_default_related_topics and %{$zci->related_topics_sections}) {
    print "Disambiguatious Related Topics:\n";
    for (keys %{$zci->related_topics_sections}) {
      print "  Related Topics Groupname: ".$_."\n";
        for (@{$zci->related_topics_sections->{$_}}) {
          print "  - ".$_->first_url->as_string."\n" if $_->has_first_url;
        }
      }
    }
  }

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

=method has_related_topics_sections

=method related_topics_sections

Gives back a hash reference of related topics with its Name as key and as value an array reference of L<WWW::DuckDuckGo::Link> objects. If there is a specific topic, a so called default topic, which is the case in all non disambigious search results, then this topic has the name "_", but you can access it with the method I<default_related_topics> directly.

=method default_related_topics

Gives back an array reference of L<WWW::DuckDuckGo::Link> objects. Can be undef, check with I<has_default_related_topics>.

=method has_results

=method results

Gives back an array reference of L<WWW::DuckDuckGo::Link> objects. Can be undef, check with I<has_results>.

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



