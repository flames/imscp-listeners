# i-MSCP Listener::Postfix::Smarthost listener file
# Copyright (C) 2015 Laurent Declercq <l.declercq@nuxwin.com>
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
## Listener file allowing to configure the i-MSCP MTA (Postfix) as smarthost with SASL authentication.
#

package Listener::Postfix::Smarthost;

use iMSCP::Debug;
use iMSCP::ProgramFinder;
use iMSCP::EventManager;
use iMSCP::Execute;
use iMSCP::File;

#
## Configuration parameters
#

my $relayhost = 'relayhost.tld';
my $relayport = '587';
my $saslAuthUser = 'relayuser';
my $saslAuthPasswd = 'relaypass';
my $saslPasswdMapsPath = '/etc/postfix/relay_passwd';

# Path to Postfix configuration directory
my $postfixConfigDir = '/etc/postfix';

## Postfix main.cf ( see http://www.postfix.org/postconf.5.html )
# Hash where each pair of key/value correspond to a postfix parameter
# Please replace the entries below by your own entries
my %mainCfParameters = (
    'relayhost' => $relayhost.':'.$relayport,
    'smtp_sasl_auth_enable' => 'yes',
    'smtp_sasl_password_maps' => 'hash:'.$saslPasswdMapsPath,
    'smtp_sasl_security_options' => 'noanonymous'
);

#
## Please, don't edit anything below this line
#

#Create SMTP SASL password maps. Return int 0 on success, other on failure
sub createSaslPasswdMaps
{
    my $saslPasswdMapsFile = iMSCP::File->new('filename' => $saslPasswdMapsPath);
    $saslPasswdMapsFile->set("$relayhost:$relayport\t$saslAuthUser:$saslAuthPasswd");

    my $rs = $saslPasswdMapsFile->save();
    return $rs if $rs;

    $rs = $saslPasswdMapsFile->mode(0600);
    return $rs if $rs;

    # Schedule postmap of sasl password maps file
    Servers::mta->factory()->{'postmap'}->{$saslPasswdMapsPath} = 1;

    0;
}

#Add relayhost and SMTP SASL parameters in Postfix main.cf
sub setupMainCf
{
    if(%mainCfParameters && iMSCP::ProgramFinder::find('postconf')) {
        my @cmd = (
            'postconf',
            '-e', # Needed for Postfix < 2.8
            '-c', escapeShell($postfixConfigDir)
        );

        push @cmd, ($_ . '=' . escapeShell($mainCfParameters{$_})) for keys %mainCfParameters;

        my ($stdout, $stderr);
        my $rs = execute("@cmd", \$stdout, \$stderr);
        debug($stdout) if $stdout;
        error($stderr) if $stderr && $rs;
        return $rs if $rs;
    }

    0;
}

# Register event listeners on the event manager
my $eventManager = iMSCP::EventManager->getInstance();
$eventManager->register('afterMtaBuildConf', \&createSaslPasswdMaps);
$eventManager->register('afterMtaBuildConf', \&setupMainCf);

1;
__END__