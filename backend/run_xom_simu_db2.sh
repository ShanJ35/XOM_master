#!/bin/bash

file_name_db=run_numbers_simu_db.txt
file_name_new_process=new_process_run_numbers.txt
start_time="$(date -u +%s)"
#while read run_info
#do
    # get all the infos inside the file, line by line
#    IFS=" " read -r  data_type data_source run_name run_number context_version <<<"$run_info"   
#    if [ -z "$context_version" ]
#    then
#	context_version=v2.0
#    fi
#    echo "the run number is: $run_number"
	
    #assign the outputfolder
#    outputfolder=/home/sj2538/scratch-midway2/$context_version/$run_number
    # here we run the process manager
#    python processManager --dataType $data_type --source $data_source --runName $run_name --runId $run_number --outFolder $outputfolder
#    if [[ $? -ne 0 ]]
#	then

#	echo "the process manager crashes" |  mail -s "fail syncing the run $run_number" mlb20@nyu.edu
#	fi
	
 #   rsync -avz   /scratch/midway2/mlotfi/$context_version  xom@xe1t-offlinemon.lngs.infn.it:/home/xom/data/xom
    #now we can delete the whole directory, but only if the rsync is succefull
#    if [[ $? -gt 0 ]]
#    then
    #send an email for failure of the rsync
#	echo "The run number: $run_number failed to sync with context version $context_version" |  mail -s "fail syncing the run $run_number" mlb20@nyu.edu
#	echo "There is problem syncing the run $run_number"
#    else
#	echo "I don't remove it yet waiting"
	#rm -rf /scratch/midway2/mlotfi/$context_version/
#    fi
	
    # now lets sleep 5 minutes before we go for the next run
    #sleep 90
    
#done<$file_name_db
current_run_number="8428"
last_new_run=""
while IFS=" " read -r line
do
    last_new_run=$line
done<$file_name_new_process

end_first="$(date -u +%s)"
time_first="$(($end_first-$start_time))"
end_time=$((SECONDS+600))
end_time=$(($end_time-$time_first))

while [ $SECONDS -lt $end_time ] && [ $last_new_run -lt $current_run_number ]
do
    python processManager --dataType calibration --source kr --runName 170403_1418 --runId $last_new_run --outFolder /home/sj2538/scratch-midway2/v1.0/$last_new_run --onlyNew True
    last_new_run=$((last_new_run+1))
done

echo "$last_new_run" > "$file_name_new_process"
