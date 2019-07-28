# Log parser

Problem description: 
-----------------------------
In server1, at sourcePath: "/data/downstream/ussd_client/logs/" a log file is written and after a time content of log files are zipped as  ussd_client_info_YYYYMMDD_1.log.gz. into sourcePath/archived/ directory.
The contents of log files are as follows:

<sub><sup>20190311 00:00:00.300 [INFO ] USSDHttpHandler[Grizzly-worker(12)] MSISDN: 8801878------ ID: 37184183 requested Code: *21291*12# </sup></sub><br/>
<sub><sup>20190311 00:00:00.322 [INFO ] USSDHttpHandler[Grizzly-worker(2)] MSISDN: 8801838------ ID: 6930159 requested Code: *212*020# (deferred) </sup></sub><br/>
<sub><sup>20190311 00:00:00.322 [INFO ] USSDHttpHandler[Grizzly-worker(2)] Responded with Thank you. Your request has been recorded and will be processed.</sup></sub><br/>
<sub><sup>20190311 00:00:00.350 [WARN ] OfferInformationMessageSticther[Grizzly-worker(12)] Null parameters passed as arguments !!! </sup></sub><br/>
<sub><sup>20190311 00:00:00.351 [WARN ] OfferInformationMessageSticther[Grizzly-worker(12)] Null parameters passed as arguments !!! </sup></sub><br/>
<sub><sup>20190311 00:00:00.351 [WARN ] OfferInformationMessageSticther[Grizzly-worker(12)] Null parameters passed as arguments !!! </sup></sub><br/>
<sub><sup>20190311 00:00:00.352 [INFO ] SimpleUSSDQueryHandler[Grizzly-worker(12)] Subscriber Id: 37184183 Total offers found: 3 Active offers: 2 </sup></sub><br/>
<sub><sup>20190311 00:00:00.352 [INFO ] CoreRepository[Grizzly-worker(12)] Total number of offers available = 2 </sup></sub><br/>
<sub><sup>20190311 00:00:00.352 [INFO ] LenientRobiActionWrapper[Grizzly-worker(12)] Found USSD offer for MSISDN(8801878------) matching *21291*12# </sup></sub><br/>

In server2, at path: / / there is a list of files which is considered as processed files. 

You have to write a script that is scheduled for execution at every 5 minutes and on each run, it formats the log content as:
YYYYMMDD | HH:MM:SS.milisec | CX | ID | USSD CODE
![Alt text](/img/1.PNG?raw=true "format of output log") <br/>
into a file; file name convention: two12_lastProcessingTime_CurrentProcessingTime.txt ,e.g., two12_201907221230_201907221235.txt

Now you have to compare the file list of server1 with server2 and generate the unprocessed list, make a tar file including the 
unprocessed files, then move this tar file to the destination directory of server2.
