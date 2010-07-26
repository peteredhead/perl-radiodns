package Service;

use Net::DNS;

use strict;
use warnings;

sub resolveAuthorativeFQDN() {
	my ($self) = @_;

	if ( !defined( $self->{_dnsResolver} ) ) {
		$self->{_dnsResolver} = Net::DNS::Resolver->new();
	}

	my $query = $self->{_dnsResolver}->search( $self->toFQDN(), 'CNAME' );
	if ($query) {
		my $rr;
		foreach $rr ( $query->answer ) {
			next unless $rr->type eq "CNAME";
			$self->{_cachedAuthorativeFQDN} = $rr->cname or die "Error: $!";
		}
	}
	else {
		die "Query failed: ", $self->{_dnsResolver}->errorstring;
	}
	return $self->{_cachedAuthorativeFQDN};

}

sub resolveApplication() {
	my ($self, $application_id, $transport_protocol) = @_;
	
	if (!defined($application_id)) {die('No application ID specified');}
	if (!defined($transport_protocol)) {$transport_protocol ='TCP';}
	
	my $authorative_fqdn;
	
	if (defined($self->{_cachedAuthorativeFQDN})) {
		$authorative_fqdn = $self->{_cachedAuthorativeFQDN}
	} else {
		$authorative_fqdn = $self->resolveAuthorativeFQDN;
	}
	if (!defined($authorative_fqdn)) {die('No authorative FQDN found for this service');}
	
	if ( !defined( $self->{_dnsResolver} ) ) {
		$self->{_dnsResolver} = Net::DNS::Resolver->new();
	}
	
	my $application_fqdn = sprintf('_%s._%s.%s', lc($application_id), lc($transport_protocol), $authorative_fqdn);
	
	my @results;
	
	my $query = $self->{_dnsResolver}->search( $application_fqdn, 'SRV');
	if ($query) {
		my $rr;
		foreach $rr ( $query->answer ) {
			next unless $rr->type eq "SRV";

			my %result = ('target'=> $rr->target,
							'port'=> $rr->port,
							'priority'=> $rr->priority, 
							'weight'=> $rr->weight);
			push(@results, \%result);
			
			
		}
	}
	else {
		die "Query failed: ", $self->{_dnsResolver}->errorstring;
	}
	return @results;	
}

1;
__END__

=head1 NAME

perl RadioDNS::Service

=head1 SYNOPSIS

Abstract class to provide core functions for all RadioDNS Service objects

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

