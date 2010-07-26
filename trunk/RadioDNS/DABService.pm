package DABService;

use RadioDNS::Service;

use strict;
use warnings;

our @ISA = qw{Service};

sub new {
	my ($class, $ecc, $eid, $sid, $scids, $data) = @_;
	my ($xpad, $pa);
	if (!defined($ecc)||!defined($eid)||!defined($sid)||!defined($scids)||!defined($data)) {die('Not enough paramaters');}
	if (!($ecc=~m/^[0-9A-Fa-f]{3}$/)) {die('Invalid Extended Country Code (ECC) value. Must be a valid 3-character hexadecimal.');}
	if (!($eid=~m/^[0-9A-Fa-f]{4}$/)) {die('Invalid Ensembled Identifier (EId) value. Must be a valid 4-character hexadecimal.');}
	if (!($sid=~m/^[0-9A-Fa-f]{4}$|^[0-9A-Fa-f]{8}/)) {die('Invalid Service Identifier (SId) value. Must be a valid 4 or 8-character hexadecimal.');}
	if (!($scids=~m/^[0-9A-Fa-f]{1}$|^[0-9A-Fa-f]{3}$/)) {die('Invalid Service Component Identifer within the Service (SCIdS) value. Must be a valid 3-character hexadecimal.')}
	if (!($data=~m/^[0-9A-Fa-f]{2}-[0-9A-Fa-f]{3}$/) && (!($data=~m/^\d+$/))) {die('Invalid data value. Must be either a valid X-PAD Applicaton Type (AppTy) and User Applicaton type (UAtype) hexadecimal or Packet Address integer.');}
	
	if ($data=~m/^\d+$/) { 
		if ($data < 0 || $data > 1023) {
			die('Packet Address integer must be between 0 and 1023');
		} else {
			$pa = $data;	
		}
	} else { $xpad = $data; }
	
	my $self = { _ecc => $ecc, _eid => $eid, _sid => $sid, _scids => $scids, _xpad => $xpad, _pa => $pa };
	return bless($self,$class);
}

sub toFQDN {
	my ($self) = @_;
	
	my $fqdn = sprintf('%s.%s.%s.%s.dab.radiodns.org', $self->{_scids}, $self->{_sid}, $self->{_eid}, $self->{_ecc});
	if(defined($self->{_xpad})) {
		$fqdn = sprintf('%s.%s', $self->{_xpad}, $fqdn);
	} else {
		$fqdn = sprintf('%s.%s', $self->{_pa}, $fqdn);
	}
	return lc($fqdn);	
}	

1;
__END__

=head1 NAME

RadioDNS::DABService - Implementation of RadioDNS_Service for DAB Service

=head1 SYNOPSIS

use RadioDNS::DABService

RadioDNS::DABService->new(ecc, eid, sid, scids, xpad | pa)

I<ecc>: Extended Country Code (ECC) value

I<eid>: Ensemble Identifier (EId) value

I<sid>: Service Identifer (SId) value

I<scids>: Service Component Identifer within the Service (SCIdS) value

I<xpad>: X-PAD Applicaton Type (AppTy) and User Applicaton type value

I<pa>: Packet Address (PA) value

=head1 DESCRIPTION

Implements RadioDNS_Service object, providing necessary functionality to 
represent DAB Digital Radio Services (including data services) as a RadioDNS
Service Object

=head1 METHODS

=head2 toFQDN()

Constructs the RadioDNS FQDN for a DAB Service

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

