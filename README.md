i-mscp-listeners
=========================

Set of listener files for i-MSCP. These listener files are only compatible with i-MSCP >= **1.2.0**.

## Listener files

Below, you can find a list of all listener files which are available in that repository, and their respective purpose.

### Listener::Named::Zonetransfer

The **listeners.d/15_named_zonetransfer.pl** listener file provides zone output for zone transfer to secondary DNS.

### Listener::Named::nameservers

The **listeners.d/15_named_nameservers.pl** listener file modifies the zone files, removes default nameservers and adds custom out-of-zone nameservers.

To install the listener file, upload it to **/etc/imscp/listeners.d** directory, and edit the configuration
parameters inside it. Once done, rerun the i-MSCP installer: **perl /usr/local/src/imscp-1.2.0/imscp-autoinstall -dr named** and add the slave DNS servers.

### License

	Copyright (c) 2015 Arthur Mayer <mayer.arthur@gmail.com>
	
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

 see [lgpl v2.1](http://www.gnu.org/licenses/lgpl-2.1.txt "lgpl v2.1")

## Sponsors

- Nuxwin and i-MSCP team

## Author

- Arthur Mayer <mayer.arthur@gmail.com>
