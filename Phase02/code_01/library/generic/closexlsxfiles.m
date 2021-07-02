function closexlsxfiles
% Closing all excel files
[~, taskmsge] = system('tasklist|findstr "EXCEL.EXE"');
[~, taskmsgl] = system('tasklist|findstr "SOFFICE.BIN"');
excelopen=~isempty(taskmsge);
libreopen=~isempty(taskmsgl);
if excelopen || libreopen
    if excelopen
        [statuse, ~] = system('taskkill /F /IM EXCEL.EXE');
        if statuse
            errormsg = strcat('Could not close all excel files. Please click OK after you save and exit them.');
            waitfor(msgbox(errormsg,'Error'));
        end
    elseif libreopen
        [statusl, ~] = system('taskkill /F /IM SOFFICE.BIN'); % If the code is 128, the exe is just not found
        if statusl
            errormsg = strcat('Could not close all excel files. Please click OK after you save and exit them.');
            waitfor(msgbox(errormsg,'Error'));
        end
    end
end