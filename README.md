# Log parser

Problem description: 
-----------------------------
In server1, at sourcePath: / / a log file is written and after a time 
content of log files are zipped as ussd_client_info_YYYYMMDD_1.log.gz. 
into sourcePath/archived/ directory.
The contents of log files are as follows:


In server2, at path: / / there is a list of files which is considered as 
Processed files.

You have to write a script that is scheduled for execution at every 5 minutes and on each run, it 
formats the log content as:

YYYYMMDD | HH:MM:SS.milisec | CX | ID | USSD CODE
into a file; file name convention: two12_lastProcessingTime_CurrentProcessingTime.txt ,e.g., two12_201907221230_201907221235.txt

Now you have to compare the file list of server1 with server2 and generate the unprocessed list, make a tar file including the 
unprocessed files, then move this tar file to the destination directory of server2.
