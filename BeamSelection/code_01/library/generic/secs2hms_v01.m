% Modified by Dr. Cenk M. Yetis
%SECS2HMS - converts a time in seconds to a string giving the time in hours, minutes and second
%Usage TIMESTRING = SECS2HMS(TIME)]);
%Example 1: >> secs2hms(7261)
%>> ans = 2 hours, 1 min, 1.0 sec
%Example 2: >> tic; pause(61); disp(['program took ' secs2hms(toc)]);
%>> program took 1 min, 1.0 secs

function [time_string1,time_string2]=secs2hms_v01(time_in_secs)
    time_string1='';
    nhours = 0;
    nmins = 0;
    if time_in_secs >= 3600
        nhours = floor(time_in_secs/3600);
        if nhours > 1
            hour_string = ' hours, ';
        else
            hour_string = ' hour, ';
        end
        time_string1 = [num2str(nhours) hour_string];
    end
    if time_in_secs >= 60
        nmins = floor((time_in_secs - 3600*nhours)/60);
        if nmins > 1
            minute_string = ' mins, ';
        else
            minute_string = ' min, ';
        end
        time_string1 = [time_string1 num2str(nmins) minute_string];
    end
    nsecs = time_in_secs - 3600*nhours - 60*nmins;
    time_string1 = [time_string1 sprintf('%2.1f', nsecs) ' secs'];
    time_string2=seconds(time_in_secs);
    time_string2.Format = 'hh:mm:ss';
    time_string2=char(time_string2);
    x=time_in_secs-floor(time_in_secs);    
    time_string2(9)='.';
    x=sprintf('%.2f', x);
    time_string2(10:11) = x(end-1:end);
end