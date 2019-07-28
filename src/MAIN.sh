#!/bin/bash

# DECLARING REQUIRED PATH

source_path="/data/downstream/ussd_client/logs/"
zip_source_path="/data/downstream/ussd_client/logs/archived/"
script_path="/data/ops/two12_ussd/"
flag_path="/data/ops/two12_ussd/temp/"
output_path="/data/ops/two12_ussd/generatedOutput/two12_retrievedText/"
fileList="/data/ops/two12_ussd/generatedOutput/"
dump_path="/data3/ops/TwoOneTwoUssdLogParsing/generatedTextFile/"
processedFilePath="/data3/ops/TwoOneTwoUssdLogParsing/processedTextFile/dwhProcessedFileList.list"
unProcessedLogPath="/data3/ops/TwoOneTwoUssdLogParsing/unProcessedLog"


# --------------- DECLARING REQUIRED FUNCTION ----------------------- #

# writeTempLog() - extracts the desired column from main log file
writeTempLog(){
        awk '{print $1,$2,$7,$9,$12}' >> ${script_path}temp/temp_logStore.log
}

# ussdLogParser() - parses the contents from current log file or from archived log
ussdLogParser(){
        if [ "$cpd" -ne "$lpd" ]
        then
          zgrep "requested Code" ussd_client_info_${lpd}_*.log.gz | writeTempLog
        fi

        if ls -l $zip_source_path | grep $cpd;
        then
            zgrep "requested Code" ussd_client_info_${cpd}_*.log.gz | writeTempLog
        fi

        grep "requested Code" ${unzip_file} | writeTempLog

}
# generateTotalRawFile() - generates list of raw text files
generateTotalRawFile(){
        rm -f ${fileList}total_raw_list_181.txt
        ls -l ${output_path} >> ${fileList}total_raw_list_181.txt
}
# func_rsync_file() - generates the raw text files from the unprocesed list
func_rsync_file()
{
        for a in `cat ${fileList}unprocessed_list_181.txt`
        do
                cp ${output_path}${a} ${fileList}dwhUnprocessedFile/

        done
}
ACTION(){

        previous_day=`date -d "yesterday" '+%Y%m%d'`
        current_day=`date '+%Y%m%d'`
        cpt=`date -d "1 minutes ago" '+%Y%m%d%H%M'`								# cpt --> current procesing time
        lpt=$(cat ${script_path}temp/lastCheckTime.txt| awk {'print $1'})		# lpt --> last procesing time read from lastCheckTime.txt file	
        cpd=`date -d "1 minutes ago" '+%Y%m%d'`									# cpd --> current processing day
        lpd=$(cat ${script_path}temp/lastCheckTime.txt | cut -c1-8)				# lpd --> last processing day read from lastCheckTime.txt file

        unzip_file="${source_path}ussd_client_info.log"

        if [ -f ${script_path}temp/temp_logStore.log ]							# deleting if any previous temporary file exists
        then
           rm ${script_path}temp/temp_logStore.log
        fi

        ussdLogParser															# CALLING ussdLogParser() FUNCTION 
		
		
		# Next command extracts from 'temp_logStore.log' file where 'log time' is greater than last processing time and 
		# 'log time' is smaller than current processing time; then formats the space seperated column with '|' 
		# then write to a file two12_lpt_cpt.txt
		
        awk -F" " -v vlpt="$lpt" -v vcpt="$cpt" '{split($2,t,":");if ($1t[1]t[2] > vlpt && $1t[1]t[2] < vcpt) print $0}' ${script_path}temp/temp_logStore.log  | sed 's/ /|/g' >> ${output_path}two12_"${lpt}"_"${cpt}".txt


        generateTotalRawFile													# CALLING generateTotalRawFile() FUNCTION

        scp uername@xxx.yyy.z.aa:${processedFilePath} ${fileList}				# Here uername is the server usrname and xxx.yyy.z.aa - is server IP
		
        python ${script_path}two12_script/gen_new_list_181.py					# Here a python script is executed used for generating unprocessed list

        func_rsync_file															# CALLING func_rsync_file() FUNCTION 

        tar -czvf ${fileList}dwhUnprocessedFile.tar.gz ${fileList}dwhUnprocessedFile/			# MAKING tar file of the unprocessed list
        scp ${fileList}dwhUnprocessedFile.tar.gz username@xxx.yyy.z.aa:${unProcessedLogPath}	# copy tar file to destination server
        rm ${fileList}dwhUnprocessedFile.tar.gz													# DELETING tar file from source server
        rm ${fileList}unprocessed_list_181.txt
        rm ${script_path}temp/lastCheckTime.txt													# DELETING lastCheckTime.txt file
        echo $cpt >> ${script_path}temp/lastCheckTime.txt										# WRITING cpt to lastCheckTime.txt


}


##--- MAIN ---##

if [ ! -f ${flag_path}isRunning_212.txt ]; then				# IF NO 'isRunning_212.txt' FILE EXIST IN FLAG PATH
    touch ${flag_path}isRunning_212.txt						# CREATE A 'isRunning_212.txt' FILE
        ACTION												# CALL ACTION METHOD
        rm ${flag_path}isRunning_212.txt					# REMOVE 'isRunning_212.txt' FILE
fi