package FMService;

use RadioDNS::Service;

use strict;
use warnings;

our @ISA = qw{Service};

sub new {
	my ($class, $country, $pi, $frequency) = @_;
	my ($rds_cc_ecc, $iso3166_country_code);
	
	if (!defined($country)||!defined($pi)||!defined($frequency)) {die('Not enough paramaters');}
	
	if (length($country) == 2) {
		$iso3166_country_code = $country;
	} elsif ($country=~m/^[0-9A-Fa-f]{3}$/) {
		$rds_cc_ecc = $country;
	} else {
		die('Invalid country value. Must be either a ISO 3166-1 alpha-2 country code or valid hexadecimal value of a RDS Country Code concatanated with a RDS Extended Country Code (ECC).');
	}
	
	if ((!$pi=~m/^[0-9A-Fa-f]{4}$/) ||  (substr($pi, 0, 1) ne substr($rds_cc_ecc, 0, 1)) && !defined($iso3166_country_code)) {die('nvalid PI value. Must be a valid hexadecimal RDS Programme Identifier (PI) code and the first character must match the first character of the combined RDS Country Code and RDS Extended Country Code (ECC) value (if supplied).');}
	
	if (!($frequency=~m/^\d{2,3}$/) && !($frequency=~m/^\d{2,3}\.\d{1,2}$/)) {die('Invalid frequency value. Must be a valid float between the values 76.0 and 108.0.');}
	if ($frequency <76 || $frequency > 108.1) {die('Invalid frequency value. Must be a valid float between the values 76.0 and 108.0.');}
	
	my $self = { _rds_cc_ecc=>$rds_cc_ecc, _iso3166_country_code => $iso3166_country_code, _pi => $pi, _frequency => $frequency };
	return bless($self,$class);
}

sub toFQDN {
	my ($self) = @_;
	my $country;
	
	if (defined($self->{_iso3166_country_code})) {
		$country = $self->{_iso3166_country_code};
	} else {
		$country = $self->{_rds_cc_ecc};
	}
	my $fqdn = sprintf('%05d.%s.%s.fm.radiodns.org', $self->{_frequency} * 100, $self->{_pi}, $country);
	return lc($fqdn);
}

1;
__END__

=head1 NAME

RadioDNS::FMService - Implementation of RadioDNS_Service for FM Service

=head1 SYNOPSIS

use RadioDNS::FMService

RadioDNS::FMervice->new(rds_cc_ecc | iso3166_country_code, rds_pi, frequency)

I<rds_cc_ecc>: Extended Country Code (ECC) value

I<iso3166_country_code>: ISO 3166-1 alpha-2 country code value

I<rds_pi>: Programme Identification (PI) value

I<frequency>: Frequency value

=head1 DESCRIPTION

Implements RadioDNS_Service object, providing necessary functionality to
represent FM Services as a RadioDNS Service Object

=head1 METHODS

=head2 toFQDN()

Constructs the RadioDNS FQDN for an FM Service

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

