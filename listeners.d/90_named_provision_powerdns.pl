package Listener::Bind9::Localnets;

use strict;
use warnings;
use iMSCP::EventManager;
use WWW::Curl::Easy;
use JSON;

my $secretkey = "blarg";
my $apiurl = "http://127.0.0.1:7171/api/v1/servers/localhost/zones/";
my $nameservertld = "mycompany.tld";

#CREATE ZONE
iMSCP::EventManager->getInstance()->register('afterNamedAddDmn', sub {
        my $ch = WWW::Curl::Easy->new;
        my $domain = $data->{'DOMAIN_NAME'}; # HOW actually get the customer domain here?
        my @headers = (
            "X-API-Key: " . $secretkey
        );
        my %data = (
            "name" => $domain . ".",
            "kind" => "Slave",
            "masters" => {
                "imscp.srv.ip.addr"
            },
            "nameservers" => {
                "ns1." . $nameservertld . ".",
                "ns2." . $nameservertld . "."
            }
        );
        my $url = $apiurl;

        $ch->setopt(CURLOPT_URL, $url);
        $ch->setopt(CURLOPT_HTTPHEADER, \@headers);
        $ch->setopt(CURLOPT_CUSTOMREQUEST, "POST");
        $ch->setopt(CURLOPT_POSTFIELDS, join('&', @data));
        $ch->setopt(CURLOPT_RETURNTRANSFER, true);

        my $result = '';
        open (my $fh, ">", \$result);
        $ch->setopt(CURLOPT_WRITEDATA, $fh);
        if( $ch->perform() != 0 ) {
            # ERROR handling later, currently don't care it
        }
        my $status = $ch->getinfo(CURLINFO_HTTP_CODE);
        $ch->close();
        if( $status != 200 ) {
            # ERROR handling later, currently don't care about the status code, so far its not 5xx
            # 201 - created = success
            # 409 - conflict = already exists (also success for me, except the zone exists already but as master instead of slave, then... fuuu, give a warning, admin has to check manually and solve conflicts, if there are)
        }
        my $json = decode_json($result);
        my $token = $json->{'access_token'};
        0;
    }
);

#DELETE ZONE
iMSCP::EventManager->getInstance()->register('afterNamedDelDmn', sub {
        my $ch = WWW::Curl::Easy->new;
        my $domain = $data->{'DOMAIN_NAME'}; # HOW actually get the customer domain here?
        my @headers = (
            "X-API-Key: " . $secretkey
        );
        my $url = $apiurl . $domain . ".";

        $ch->setopt(CURLOPT_URL, $url);
        $ch->setopt(CURLOPT_HTTPHEADER, \@headers);
        $ch->setopt(CURLOPT_CUSTOMREQUEST, "POST");
        $ch->setopt(CURLOPT_POSTFIELDS, join('&', @data));
        $ch->setopt(CURLOPT_RETURNTRANSFER, true);

        my $result = '';
        open (my $fh, ">", \$result);
        $ch->setopt(CURLOPT_WRITEDATA, $fh);
        if( $ch->perform() != 0 ) {
            # ERROR handling later, currently don't care about it
        }
        my $status = $ch->getinfo(CURLINFO_HTTP_CODE);
        $ch->close();
        if( $status != 200 ) {
            # ERROR handling later, currently don't care about the status code, so far its not 5xx
            # 204 - no content = success
            # 404 - not found = already not existent (again, success for me, the point was to remove the zone, so when its already gone now its good, it was probably bad, before we wanted to delete it xD)
        }
        my $json = decode_json($result);
        my $token = $json->{'access_token'};
        0;
    }
);

1;
__END__
