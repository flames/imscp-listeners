i-mscp-listeners
=========================

Set of listener files for i-MSCP. These listener files are only compatible with i-MSCP >= **1.2.0**.

## Listener files

Below, you can find a list of all listener files which are available in that repository, and their respective purpose.

### Listener::Named::Zonetransfer

The **listeners.d/10_named_zonetransfer.pl** listener file provides zone output for zone transfer to secondary DNS.

To install the listener file, upload it to **/etc/imscp/listeners.d** directory, and edit the configuration
parameters inside it. Once done, rerun the i-MSCP installer: **perl imscp-autoinstall -dr named** and add the slave DNS servers

### Listener::Named::Nameservers

The **listeners.d/10_named_nameservers.pl** listener file modifies the zone files, removes default nameservers and adds custom out-of-zone nameservers.

To install the listener file, upload it to **/etc/imscp/listeners.d** directory, and edit the configuration
parameters inside it. Once done, rerun the i-MSCP installer: **perl imscp-autoinstall -d**

### Listener::Named::Tuning

The **listeners.d/10_named_tuning.pl** listener file modifies the zone files, removes the default IN A record if a custom IN A record is added by custom DNS for the domain.

To install the listener file, upload it to **/etc/imscp/listeners.d** directory. Once done, rerun the i-MSCP installer: **perl imscp-autoinstall -d**

### Listener::Postfix::Smarthost

The **listeners.d/10_postfix_smarthost.pl** listener file allowing to configure the i-MSCP MTA (Postfix) as smarthost with SASL authentication.

To install the listener file, upload it to **/etc/imscp/listeners.d** directory, and edit the configuration
parameters inside it. Once done, rerun the i-MSCP installer: **perl imscp-autoinstall -d**

### License

	Copyright (c) 2015 Laurent Declercq <l.declercq@nuxwin.com>, Arthur Mayer <mayer.arthur@gmail.com>
	
	This library is free software; you can redistribute it and/or
	modify it under the terms of the GNU Lesser General Public
	License as published by the Free Software Foundation; either
	version 2.1 of the License, or (at your option) any later version.
	
	This library is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
	Lesser General Public License for more details.
	
	You should have received a copy of the GNU Lesser General Public
	License along with this library; if not, write to the Free Software
	Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA

See [LGPL v2.1](http://www.gnu.org/licenses/lgpl-2.1.txt "LGPL v2.1")

## Authors

- Laurent Declercq <l.declercq@nuxwin.com>
- Arthur Mayer <mayer.arthur@gmail.com>
