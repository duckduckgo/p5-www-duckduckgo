package WWW::DuckDuckGo;
# ABSTRACT: Access to the DuckDuckGo APIs

use Moo;

use LWP::UserAgent;
use HTTP::Request;
use WWW::DuckDuckGo::ZeroClickInfo;
use JSON;
use URI;
use URI::QueryParam;

our $VERSION ||= '0.0development';

has _duckduckgo_api_url => (
	is => 'ro',
	lazy => 1,
	default => sub { 'http://api.duckduckgo.com/' },
);

has _zeroclickinfo_class => (
	is => 'ro',
	lazy => 1,
	default => sub { 'WWW::DuckDuckGo::ZeroClickInfo' },
);

has _http_agent => (
	is => 'rw',
	lazy => 1,
	default => sub {
		my $self = shift;
		my $ua = LWP::UserAgent->new;
		$ua->agent(__PACKAGE__.'/'.$VERSION);
		return $ua;
	},
);

sub zci { shift->zeroclickinfo(@_) }

sub zeroclickinfo {
	my ( $self, @query_fields ) = @_;
	return if !@query_fields;
	my $query = join(' ',@query_fields);
	my $uri = URI->new($self->_duckduckgo_api_url);
	$uri->query_param( q => $query );
	$uri->query_param( o => 'json' );
	my $req = HTTP::Request->new(GET => $uri->as_string);
	my $res = $self->_http_agent->request($req);
	if ($res->is_success) {
		my $result = decode_json($res->content);
		return $self->_zeroclickinfo_class->by($result);
	} else {
		die __PACKAGE__.': '.$res->status_line, "\n";
	}
}

1;

=encoding utf8

=head1 SYNOPSIS

  use WWW::DuckDuckGo;

  my $duck = WWW::DuckDuckGo;
  
  # request the Zero Click Info, you can also use ..->zci('getty')
  my $zeroclickinfo = $duck->zeroclickinfo('getty');

=head1 DESCRIPTION

This distribution gives you an easy access to the DuckDuckGo Zero Click Info API. (Documentation on the TODO, or do you wanna help?)

=head1 SUPPORT

IRC

  Join #duckduckgo on irc.freenode.net. Highlight Getty for fast reaction :).

Repository

  http://github.com/Getty/p5-www-duckduckgo
  Pull request and additional contributors are welcome
 
Issue Tracker

  http://github.com/Getty/p5-www-duckduckgo/issues

=cut
