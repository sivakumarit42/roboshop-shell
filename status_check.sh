  status_check(){
  if [ $1 -eq 0 ]
     then
       echo successfull
       else
         echo failure
         echo "Read the log file ${log_file} for more information about error"
         exit
         fi



  }