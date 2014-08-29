centrify
========

Table of Contents
------------------

1. [Overview - What is the Centrify module?](#overview)
2. [Module Description - What does the module do?](#module-description)
3. [Setup - The basics of getting started with Centrify module](#setup)
4. [Usage - How to use the module for various tasks](#usage)
5. [Upgrading - Guide for upgrading from older revisions of this module](#upgrading)
6. [Limitations - OS compatibility, etc.](#limitations)
7. [Development - Guide for contributing to the module](#development)
8. [Disclaimer](#disclaimer)
9. [Contributors - List of module contributors](#contributors)

Overview
---------

The Centrify module allows you to authenticate users with Active Directory using Centrify.

Module Description
------------------

Centrify allows you to authenticate users on *NIX machines with a current Active Directory system, which provides single-sign-on (SSO) with an existing windows environment. The centrify module allows you to install and configure the centrify packages and services and allows a machine to auto join a network (with the correct settings on the Active Directory system). This will also control ssh through use of an openssh package from centrify that will allow Active Directory authentication with ssh.

Setup 
-----

**Pre-Setup Requirements**

* You must have a current Active Directory environment, there are no special schema changes necessary
* You must have a user that is able to join computers to the domain
	* It is reccomended that the user be deligated only the rights to add computer to the domain
* You must have the deb or rpm packages provided by centrify in a repo that is accessable 
* The repo (mentioned above) must be added to the system before the centrify module is run

Usage
-----

**Required Options**

* auth_servers: an array of DNS server names that are Active Directory servers to authenticate against
* users_allow: an array of users that are allowed to log into the linux server that this is being run on
	* note: groups\_allow can be used in place of users_allow 
* adjoin_user: The username of the user that has rights to join computers to the domain
* adjoin_password: The password of the user that is used to join to the computer to the domain (this must be in plain text)
* adjoin_server: The DNS server name that is used to join the computer to the domain
* adjoin_domain: the domain name that the computer will be joined too

example usage with required options:
	
	class { 'centrify':
	 auth_servers    => ["ad1.example.com', 'ad2.example.com'],
	 users_allow     => ['username1', 'username2'],
	 adjoin_user     => 'joinuser',
	 adjoin_password => 'joinpass123',
	 adjoin_server   => 'ad1.example.com',
	 adjoin_domain   => 'example.com',
	}

**Optional Options**

Some of these options should not need to be changed from the default however if there are changes in the package/service names they may need to be changed. Other options are related to ssh, in some environments these may need to be changed to suit security compliance for that environment.

Below is a list of optional options and the default values:

* dc\_package\_name: the name of the centrifydc package, there is a default of *CentrifyDC*
* dc\_package\_ensure: the ensure of the centrifydc package, there is a default of *present*
* dc\_service\_name: the name of the centrifydc service, there is a default of *centrifydc*
* dc\_service\_enable: to enable or disable the centrifydc service, the default is *true*
* dc\_service\_ensure: the ensure for the centrifydc service, the default is *running*
* ssh\_package\_name: the package name for the centrify ssh package, the default is *CentrifyDC-openssh*
* ssh\_package\_ensure: the ensure for the ssh package, the default is *present*
* ssh\_service\_name: the name for the ssh service, the default is *centrify-sshd*
* ssh\_service\_enable: to enable or disable the ssh service, the default is *true*
* ssh\_service\_ensure: the ensure for the ssh service, the default is *running*
* ssh\_permit\_root: to permit root access via ssh, the default is *no*
* ssh\_port: the port for ssh (note this port must be open on the firewall), the default is *22*
* ssh\_x11: x11 forwarding for ssh, the default is *no*
* ssh\_banner: the banner location for ssh, the default is */etc/motd*
* auto\_join: to autojoin or not to a domain, the default is true
* primary\_gid: the auto.schema primary gid, the default is none
* private\_group: the auto.schema private group setting, the default is true
* maximum\_password\_age: the maximum age of a password
* minimum\_password\_age: the minimum age of a password
* lockout\_duration: the duration of a lockout
* lockout\_bad\_count: the bad count that would cause a lockout
* merge\_groups: merge local group setting 

Upgrading
---------

The upgrades since 0.1.0 have been minor and should not require any changes since the default behavior will have the same settings as the did before the addition of those options

Limitations
-----------

works with all current versions of centrify express

currently only tested on:
* CentOS 5.x and 6.x and related distros
* modern ubuntu versions (this should work on debian as well)

Although patches are welcome for making it work with other OS distros, it is considered best effort.

Development
-----------

Contributions and pull requests are welcome to making this module the best that it can be.

**Tests**

Currently the only testing for the module is with vagrant, due to the nature of the module and very specific environment needs there is no testing included in the module.

Disclaimer
----------

This module is provided without warranty of any kind, the creator(s) and contributors do their best to ensure stablity but can make no warranty about the stability of this module in different environments. The creator(s) and contributors reccomend that you test this module and all future releases of this module in your environment before use.

Contributors
------------

* [Diego Gutierrez](https://github.com/dgutierrez1287) ([@diego_g](https://twitter.com/diego_g))
* [xalimar](https://github.com/xalimar)

