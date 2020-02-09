# KSysGuard-Addons
Some tweaks amd scripts for KSysGuard - Local monitoring application for KDE

Some code for add monitoring UPS, GPU and SNMP-Switches in KSysGuard.

# Installation

* Perl must be installed for use .pl scripts

Download scripts to some path, ex in /opt
* Run ksysguard, create new tab, swith to this and call menu File - Monitoring remote host
* Type as computer name any string, ex "My UPS", use connection type = "another command"
* In command field type "perl /opt/ups.pl"
* Edit script - write your options like IP / UPS name / other
* Use sgrd-template for create grapth tab or create this manually.

