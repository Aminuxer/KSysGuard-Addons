#!/usr/bin/perl -w

# act as a KSysGuard sensor
# provides Nut info via `upsc $ups@localhost`

# Usage (e.g. add temperature/voltage sensor)
# 1. save this file, make sure it has a exec permission
# 2. in KSysGuard's menu, open `File` -> `Monitor Remote Machine`
# 3.1 in new dialog, type `Host` whatever you want
# 3.2 set `Connection Type` to `Custom command`
# 3.3 set `Command` like `path/to/this-sensor.pl`
# 4. click `OK`, now you can find new sensor named `ups*`
#    which is provides temperature/voltage

# NetworkUpsTools (nut) and nutdrvctl must be configured, upsc needed

# See Also
# https://techbase.kde.org/Development/Tutorials/Sensors


$|=1;

print "ksysguardd 1.2.0\n";
print "ksysguardd> ";

$ups=`upsc -l 2>/dev/null | head -n 1 | tr -d '\n'`;   # Only first UPS monitored by default

while(<>){
    if(/monitors/){
        print "ups_temp\tinteger\n";
        print "ups_load\tinteger\n";
        print "battery_charge\tinteger\n";
        print "battery_voltage\tinteger\n";
        print "input_frequency\tinteger\n";
        print "input_voltage\tinteger\n";
        print "output_voltage\tinteger\n";
    }
    if(/ups_temp/){
        if(/\?/){
            print "Temp\t0\t100\t°C\n";
        }else{
            print `upsc $ups 2>/dev/null | grep ups.temperature | cut -d ':' -f 2 | cut -d ' ' -f 2`;
        }
    }
    if(/ups_load/){
        if(/\?/){
            print "Load\t0\t100\t%\n";
        }else{
            print `upsc $ups 2>/dev/null | grep ups.load | cut -d ':' -f 2 | cut -d ' ' -f 2`;
        }
    }
    if(/battery_charge/){
        if(/\?/){
            print "Batt.Charge\t0\t100\t%\n";
        }else{
            print `upsc $ups 2>/dev/null | grep battery.charge | cut -d ':' -f 2 | cut -d ' ' -f 2`;
        }
    }
    if(/battery_voltage/){
        if(/\?/){
            print "V (Battery)\t0\t0\tV\n";
        }else{
            print `upsc $ups 2>/dev/null | grep 'battery.voltage:' | cut -d ':' -f 2 | cut -d ' ' -f 2`;
        }
    }
    if(/input_frequency/){
        if(/\?/){
            print "Frequency\t0\t0\tHz\n";
        }else{
            print `upsc $ups 2>/dev/null | grep 'input.frequency:' | cut -d ':' -f 2 | cut -d ' ' -f 2`;
        }
    }
    if(/input_voltage/){
        if(/\?/){
            print "V (In)\t0\t0\tV\n";
        }else{
            print `upsc $ups 2>/dev/null | grep 'input.voltage:' | cut -d ':' -f 2 | cut -d ' ' -f 2`;
        }
    }
    if(/output_voltage/){
        if(/\?/){
            print "V (Out)\t0\t0\tV\n";
        }else{
            print `upsc $ups 2>/dev/null | grep 'output.voltage:' | cut -d ':' -f 2 | cut -d ' ' -f 2`;
        }
    }
    print "ksysguardd> ";
}
