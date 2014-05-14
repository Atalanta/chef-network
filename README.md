Description
===========

This cookbook provides an LWRP for generating Redhat-style network scripts.

Requirements
============

## Platforms

Should work on any Redhat-derived platform.

## Cookboooks

No specific dependencies.

Attributes
==========

No attributes used.

Recipes
=======

default
-------

This is a stub recipe which simply makes the provider available.

Resources/Providers
===================

Config
------

This LWRP renders network scripts for Redhat-style configuration.  At present it only supports DHCP.  If the `dhcp` attribute is set to false, an exception will be raised.

### Example

network_config "p4p1" do
  action :create
  dhcp true
end

### Attributes

- `:action` - what to do - this LWRP only creates config files.
- `:dhcp` - true or false - does this interface use DHCP? 
- `:hwaddr` - should we specify the mac address? true or false Default is true
- `:onboot` - true or false - should this interface be enabled at boot time? Default is true

Usage
=====

Document usage about the cookbook. If it needs special roles or data bags, discuss them. Extended or complex examples should use the section below.

Examples
--------

In metadata.rb ensure you have:

    depends network

And then in the cookbook where you wish to use the LWRP, ensure you have:

    include_recipe "network"

Roadmap
=======

- Unknown

License and Author
==================

Author:: Atalanta Systems Engineering (<cookbooks@atalanta-systems.com>)

Copyright:: 2012-2013, Atalanta Systems Ltd

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
