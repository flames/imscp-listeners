# i-MSCP Listener::Named::Powerdns::Provisioning listener file
# Copyright (C) 2019 Arthur Mayer <mayer.arthur@gmail.com>
#
# This library is free software; you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public
# License as published by the Free Software Foundation; either
# version 2.1 of the License, or (at your option) any later version.
#
# This library is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public
# License along with this library; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301 USA

#
# Listener file that creates and deltes the zones on your PowerDNS (pdns) nameserver, when they are created/deleted on your i-MSCP server
# Requires i-MSCP 1.3.8 or newer.
#
# You might need to install the Perl cURL library
#
#   apt update && apt install -y libwww-curl-perl
#

package Listener::Named::Powerdns::Provisioning;

use strict;
use warnings;
use iMSCP::EventManager;
use WWW::Curl::Easy;
use JSON;
use POSIX qw/strftime/;

my $secretkey = "secret"; # powerdns api key
my $apiurl = "http://1.1.1.1:8181/api/v1/servers/localhost/zones/"; # powerdns api server url
my @nameservers = ("ns1.yourcompany.tld.", "ns2.yourcompany.tld."); # your companys nameservers, important, don't forget the trailing dot!
my $logfile = '/var/log/30_named_powerdns_provisioning.log'; # log file path

#CREATE ZONE
iMSCP::EventManager->getInstance()->register('afterNamedAddDmn', sub {
        my ($data) = @_; # Don't forget to effectively get the $data hasref ;)

        my $ch = WWW::Curl::Easy->new;
        my $domain = $data->{'DOMAIN_NAME'}; # HOW actually get the customer domain here?
        my @headers = (
            "X-API-Key: " . $secretkey
        );
        my $body = {
            "name" => $domain . ".",
            "kind" => "Slave",
            "masters" => [
                $::imscpConfig{'BASE_SERVER_PUBLIC_IP'},
            ],
            "nameservers" => [
                @nameservers
            ],
        };
        my $jsonbody = encode_json $body;
        my $url = $apiurl;

        $ch->setopt(CURLOPT_URL, $url);
        $ch->setopt(CURLOPT_HTTPHEADER, \@headers);
        $ch->setopt(CURLOPT_CUSTOMREQUEST, "POST");
        $ch->setopt(CURLOPT_POSTFIELDS, $jsonbody);

        my $response_body = '';
        open (my $fh, ">", \$response_body);
        $ch->setopt(CURLOPT_WRITEDATA, $fh);

        my $retcode = $ch->perform();
        if($retcode != 0) {
            $response_body = 'Error happened: ' . $retcode;
        }
        my $status = $ch->getinfo(CURLINFO_HTTP_CODE);
        $fh->close();
        if($status != 201) {
            # ERROR handling later, currently don't care about the status code, so far its not 5xx
            # 201 - created = success
            # 409 - conflict = already exists (also success for me, except the zone exists already but as master instead of slave, then... fuuu, give a warning, admin has to check manually and solve conflicts, if there are)
        }

        open(my $log, ">>", $logfile) or die "Could not open file '$logfile' $!";
        print $log strftime('%Y-%m-%d %H:%M:%S',localtime) . " " . $domain . "\n";
        print $log $jsonbody . "\n" . "Status code: " . $status . "\n" . $response_body . "\n\n";
        $log->close();
        #my $json = decode_json($response_body);
        #my $token = $json->{'access_token'};

        0;
    }
);

#DELETE ZONE
iMSCP::EventManager->getInstance()->register('afterNamedDelDmn', sub {
        my ($data) = @_; # Don't forget to effectively get the $data hasref ;)

        my $ch = WWW::Curl::Easy->new;
        my $domain = $data->{'DOMAIN_NAME'}; # HOW actually get the customer domain here?
        my @headers = (
            "X-API-Key: " . $secretkey
        );
        my $url = $apiurl . "/" . $domain . ".";

        $ch->setopt(CURLOPT_URL, $url);
        $ch->setopt(CURLOPT_HTTPHEADER, \@headers);
        $ch->setopt(CURLOPT_CUSTOMREQUEST, "POST");

        my $response_body = '';
        open (my $fh, ">", \$response_body);
        $ch->setopt(CURLOPT_WRITEDATA, $fh);

        my $retcode = $ch->perform();
        if($retcode != 0) {
            $response_body = 'Error happened: ' . $retcode;
        }
        my $status = $ch->getinfo(CURLINFO_HTTP_CODE);
        $fh->close();
        if($status != 204) {
            # ERROR handling later, currently don't care about the status code, so far its not 5xx
            # 204 - no content = success
            # 404 - not found = already not existent (again, success for me, the point was to remove the zone, so when its already gone now its good, it was probably bad, before we wanted to delete it xD)
        }

        open(my $log, ">>", $logfile) or die "Could not open file '$logfile' $!";
        print $log strftime('%Y-%m-%d %H:%M:%S',localtime) . " " . $domain . "\n";
        print $log "Status code: " . $status . "\n" . $response_body . "\n\n";
        $log->close();
        #my $json = decode_json($response_body);
        #my $token = $json->{'access_token'};

        0;
    }
);

1;
__END__
