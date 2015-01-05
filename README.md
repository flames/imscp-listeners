i-mscp-listeners
=========================

Set of listener files for i-MSCP. These listener files are only compatible with i-MSCP >= **1.2.0**.

## Listener files

Below, you can find a list of all listener files which are available in that repository, and their respective purpose.

To install a listener file, you must upload it in your **/etc/imscp/listeners.d** directory, and edit the configuration
parameters inside it. Once done, you must rerun the i-MSCP installer.

### Listener::Apache2::DualStack

The **listeners.d/15_secondarydns_zonetransfer.pl** listener file provides zone output for zone transfer to secondary DNS.

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

- none

## Author

- Arthur Mayer <mayer.arthur@gmail.com>
