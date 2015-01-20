package Listener::Named::Nameservers;

use iMSCP::EventManager;
use iMSCP::TemplateParser;

sub replaceDefaultNameservers
{

        #Define here your out-of-zone Nameservers
        my @nameservers = ("ns1.mycompany.tld", "ns2.mycompany.tld", "ns3.mycompany.tld");

        my ($wrkFile, $data) = @_;

        #remove default Nameservers (NS and A section)
        $$wrkFile =~ s/ns[0-9]\tIN\tA\t([0-9]{1,3}[\.]){3}[0-9]{1,3}\n//g;
        $$wrkFile =~ s/\@\t\tIN\tNS\tns[0-9]\n//g;

        #change your out-of-zone Nameservers
        foreach my $nameserver(@nameservers) {
                $$wrkFile .= "@         IN      NS      $nameserver.\n";
        }

        #fix SOA record
        $$wrkFile =~ s/IN\tSOA\tns1\.$data->{'DOMAIN_NAME'}\. postmaster\.$data->{'DOMAIN_NAME'}\./IN\tSOA\t$nameservers[0]\. hostmaster\.$data->{'DOMAIN_NAME'}\./g;

        0;
}

my $eventManager = iMSCP::EventManager->getInstance();
$eventManager->register('afterNamedAddDmnDb', \&replaceDefaultNameservers);

1;
__END__
