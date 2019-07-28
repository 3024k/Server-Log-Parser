def gen_new_file_list():
        dwh_filelist = set((line.strip() for line in open('/data/ops/two12_ussd/generatedOutput/dwhProcessedFileList.list', 'r+')))
        icms_filelist=open('/data/ops/two12_ussd/generatedOutput/total_raw_list_181.txt','r+')
        unpro_list_wfh=open('/data/ops/two12_ussd/generatedOutput/unprocessed_list_181.txt','w')
        for line in icms_filelist:
                if line.strip() not in dwh_filelist:
                        unpro_list_wfh.write(line)
        icms_filelist.close()
        unpro_list_wfh.close()

if __name__=="__main__":
        gen_new_file_list()