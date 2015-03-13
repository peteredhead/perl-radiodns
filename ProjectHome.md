# Introduction #
A port of PHP-RadioDNS for Perl.

This library facilitates the resolution of an authoritative Fully Qualified Domain Name (FQDN) from the broadcast parameters of an audio service.

From this FQDN it is then possible to discover the advertisement of IP-based applications provided in relation to the queried audio service.

For more information about RadioDNS, please see the official documentation: http://radiodns.org/docs

# Installation #
Copy the folder RadioDNS to a location on your @INC path

# Getting Started #
Perldoc documentation is included in the files and is available from the command line for each service type (AMService, DABService, FMService and HDService)
```
perldoc RadioDNS::FMService
```

# Example #
```
use RadioDNS::FMService;

my $fm_service = FMService->new("ce1","cc86","96.3");
my @srv =  $fm_service->resolveApplication('radiovis');

print "RadioVIS servers for this station:\n";
for (my $count=0; $count<scalar(@srv); $count++) {
	print "\t".$srv[$count]{'target'}." port ".$srv[$count]{'port'}."\n";
}
```

# See Also #
**[PHP-RadioDNS](http://code.google.com/p/php-radiodns/)**

