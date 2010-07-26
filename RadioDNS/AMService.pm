package AMService;

use RadioDNS::Service;

use strict;
use warnings;

our @ISA = qw{Service};

sub new {
	my ($class, $type, $sid) = @_;

	if (!defined($type)||!defined($sid)) {die ('Invalid type value. Must be either \'drm\' (Digital Radio Mondiale) or \'amss\' (AM Signalling System).');}
	if (!($sid=~m/^[0-9A-F]{6}$/)) {die('Invalid Service Identifier (SId) value. Must be a valid 6-character hexadecimal.');}

	my $self = { _type => $type, _sid => $sid };	
	return bless($self,$class);
}
	
sub toFQDN {
	my ($self) = @_;
	my $fqdn = sprintf('%s.%s.radiodns.org', $self->{_sid}, $self->{_type});
	return lc($fqdn);	
}	

1;
__END__

=head1 NAME

RadioDNS::AMService - Implementation of RadioDNS_Service for AM Service

=head1 SYNOPSIS

use RadioDNS::AMService

RadioDNS::AMService->new(type, sid)

I<type>: Type of AM Service (either 'drm' or 'amss')

I<sid>: SID value for the AM Service

=head1 DESCRIPTION

Implements RadioDNS_Service object, providing necessary functionality to 
represent AM Services (both DRM and AMSS) as a RadioDNS Service Object

=head1 METHODS

=head2 toFQDN()

Constructs the RadioDNS FQDN for a AM Service

=head2 resolveAuthorativeFQDN()

Performs a CNAME DNS record lookup request using Net::DNS::Resolver 
to return the authorative FQDN for a service. The retrieved value is
also held for future requests.

=head2 resolveApplication(application_id,transport_protocol)

I<application_id>: Application ID (eg radiovis)

I<transport_protocol>: Transport protocol. If left blank, assumes the
protocol is TCP.

This function returns an array of hashes - one per SRV record.
Each hash has the keys target, port, priority and weight.

=head1 AUTHOR

Pete Redhead, C<< <pete.redhead at googlemail.com> >>

Based on phpRadioDNS by Andy Buckingham

=head1 COPYRIGHT & LICENSE

Copyright 2010 Global Radio UK Limited
 
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

  http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    
See the License for the specific language governing permissions and 
limitations under the License.

