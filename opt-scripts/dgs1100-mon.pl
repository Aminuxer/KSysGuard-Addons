#!/usr/bin/perl -w

# act as a KSysGuard sensor
# provides data from SNMP `snmpwalk ...`

# Usage (e.g. add data sensor)
# 1. save this file, make sure it has a exec permission
# 2. in KSysGuard's menu, open `File` -> `Monitor Remote Machine`
# 3.1 in new dialog, type `Host` whatever you want
# 3.2 set `Connection Type` to `Custom command`
# 3.3 set `Command` like `path/to/this-sensor.pl`
# 4. click `OK`, now you can find new sensor
#    which is provides data

# See Also
# https://techbase.kde.org/Development/Tutorials/Sensors


$|=1;

$ip1 = '192.168.0.2';      # IP address of switch
$community1 = 'public';    # readonly SNP community
$ports = 10;               # number of ports

print "ksysguardd 1.2.0\n";
print "ksysguardd> ";


while(<>){
    if(/monitors/){
        for($n=1; $n<=$ports; $n++) {
            print "port-$n-in-data-\tinteger\n";
            print "port-$n-out-data-\tinteger\n";
            print "port-$n-in-err-\tinteger\n";
            print "port-$n-out-err-\tinteger\n";
        }
    }

    if(/port/){
        my ($cmd1, $port, $dir, $type) = split('-');
        if(/\?/){
            print substr($cmd, 1)." $port $type $dir\t0\t0\n";
        }else{
            if ($type eq 'data' and $dir eq 'in') { $oid = 'IF-MIB::ifHCInOctets'; }
            if ($type eq 'data' and $dir eq 'out') { $oid = 'IF-MIB::ifHCOutOctets'; }
            if ($type eq 'err' and $dir eq 'in') { $oid = 'IF-MIB::ifInErrors'; }
            if ($type eq 'err' and $dir eq 'out') { $oid = 'IF-MIB::ifOutErrors'; }
            if ($oid) { print `snmpwalk -v2c -c $community1 $ip1 $oid.$port | cut -d ' ' -f 4`; }
        }
    }
    print "ksysguardd> ";
}
