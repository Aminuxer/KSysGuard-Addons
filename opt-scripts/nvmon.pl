#!/usr/bin/perl -w

# act as a KSysGuard sensor
# provides NVIDIA GPU info via `nvidia-settings`

# Usage (e.g. add gpu temperature sensor)
# 1. save this file, make sure it has a exec permission
# 2. in KSysGuard's menu, open `File` -> `Monitor Remote Machine`
# 3.1 in new dialog, type `Host` whatever you want
# 3.2 set `Connection Type` to `Custom command`
# 3.3 set `Command` like `path/to/this-sensor.pl`
# 4. click `OK`, now you can find new sensor named `gpu_temp`
#    which is provides GPU temperature
# combined from https://gist.github.com/frantic1048/41f56fd6328fa83ce6ad5acb3a4c0336
#             + https://gist.github.com/Sporif/4ce63f7b6eea691bdbb18905a9589169

# See Also
# https://techbase.kde.org/Development/Tutorials/Sensors


$|=1;

print "ksysguardd 1.2.0\n";
print "ksysguardd> ";

while(<>){
    if(/monitors/){
        print "gpu_temp\tinteger\n";
        print "gpu_graphics\tinteger\n";
        print "gpu_memory\tinteger\n";
        print "gpu_video_engine\tinteger\n";
        print "gpu_fan_speed\tinteger\n";
        print "gpu_core_usage\tinteger\n";
        print "gpu_core_clock\tinteger\n";
        print "gpu_mem_mib\tinteger\n";
        print "gpu_mem_clock\tinteger\n";
        print "gpu_video_decode\tinteger\n";
        print "gpu_video_encode\tinteger\n";
    }
    if(/gpu_temp/){
        if(/\?/){
            print "GPU Temp\t0\t100\t°C\n";
        }else{
            print `nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader`;
        }
    }
    if(/gpu_graphics/){
        if(/\?/){
            print "GPU\t0\t0\n";
        }else{
            print `nvidia-settings -tq [gpu:0]/GPUUtilization | awk -F"," '{print(substr(\$1,index(\$1,"=")+1))}'`;
        }
    }
    if(/gpu_memory/){
        if(/\?/){
            print "GPU Memory\t0\t0\n";
        }else{
            print `nvidia-settings -tq [gpu:0]/GPUUtilization | awk -F"," '{print(substr(\$2,index(\$2,"=")+1))}'`;
        }
    }
    if(/gpu_video_engine/){
        if(/\?/){
            print "Video Engine\t0\t0\n";
        }else{
            print `nvidia-settings -tq [gpu:0]/GPUUtilization | awk -F"," '{print(substr(\$3,index(\$3,"=")+1))}'`;
        }
    }

    if(/gpu_fan_speed/){
        if(/\?/){
            print "GPU Fan Speed\t0\t100\t%\n";
        }else{
            print `nvidia-smi --query-gpu=fan.speed --format=csv,noheader,nounits`;
        }
    }
    if(/gpu_core_usage/){
        if(/\?/){
            print "GPU Core Usage\t0\t100\t%\n";
        }else{
            print `nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits`;
        }
    }
    if(/gpu_core_clock/){
        if(/\?/){
            print "GPU Core Clock\t0\t2500\tMhz\n";
        }else{
            print `nvidia-smi --query-gpu=clocks.current.graphics --format=csv,noheader,nounits`;
        }
    }
    if(/gpu_mem_mib/){
        if(/\?/){
            print "GPU Memory Usage\t0\t".`lsmod | grep -q nvidia && nvidia-smi --query-gpu=memory.total --format=csv,noheader,nounits | perl -pe 'chomp'`."\tMiB\n";
        }else{
            print `nvidia-smi --query-gpu=memory.used --format=csv,noheader,nounits`;
        }
    }
    if(/gpu_mem_clock/){
        if(/\?/){
            print "GPU Memory Clock\t0\t8000\tMhz\n";
        }else{
            print `nvidia-smi --query-gpu=clocks.current.memory --format=csv,noheader,nounits`;
        }
    }
    if(/gpu_video_decode/){
        if(/\?/){
            print "GPU Decoding\t0\t100\t%\n";
        }else{
            print `nvidia-smi dmon -c 1 -s u | sed s/#// | awk '{print \$5}' | tail -n 1`;
        }
    }
    if(/gpu_video_encode/){
        if(/\?/){
            print "GPU Encoding\t0\t100\t%\n";
        }else{
            print `nvidia-smi dmon -c 1 -s u | sed s/#// | awk '{print \$4}' | tail -n 1`;
        }
    }
    print "ksysguardd> ";
}
