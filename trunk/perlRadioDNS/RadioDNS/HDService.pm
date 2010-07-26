package HDService;

use RadioDNS::Service;

use strict;
use warnings;

our @ISA = qw{Service};

sub new {
	my ($class, $cc, $tx) = @_;
	
	if (!defined($cc)||!defined($tx)) {die('Not enough paramaters');}
	
	if (!($cc=~m/^[0-9A-Fa-f]{3}$/)) {die('Invalid Country Code (CC) value. Must be a valid 3-character hexadecimal Country Code.');}
	if (!($tx=~m/^[0-9A-Fa-f]{5}$/)) {die('Invalid Transmitter Identifier (TX) value. Must be a valid 5-character hexadecimal.');}
	
	my $self = { _cc => $cc, _tx => $tx };
	return bless($self,$class);
}

sub toFQDN {
	my ($self) = @_;
	
	my $fqdn = sprintf('%s.%s.hd.radiodns.org', $self->{_tx}, $self->{_cc});
	return lc($fqdn);
}	

1;
__END__

=head1 NAME

RadioDNS::HDService - Implementation of RadioDNS_Service for HD Service

=head1 SYNOPSIS

use RadioDNS::HDService

RadioDNS::HDervice->new(cc, tx)

I<cc>: Country code value

I<tx>: Transmiter identifier value

=head1 DESCRIPTION

Implements RadioDNS_Service object, providing necessary functionality to 
represent HD Radio Services (both DRM and AMSS) as a RadioDNS Service Object

=head1 METHODS

=head2 toFQDN()

Constructs the RadioDNS FQDN for an HD Service

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

