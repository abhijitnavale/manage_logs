#!/usr/bin/sh

#LOG_FILE="mylogs.log"
#exec 3>&1 1>>${LOG_FILE} 2>&1

if [ ! -e managelogs.config ]; then
    echo "Configuration file not found"
    exit 1
else
    echo "Configuration file found."
    . $(dirname $0)/managelogs.config
fi

line=$(head -n 1 managelogs.config)

# echo $line

read -a arr <<<$line

function send_deletion_email {
    
}
function manage_files_per_size {
    for filename in "$2"*; do
        filesize=$(($( stat -c '%s' $filename) / 1024 / 1024 ))
        if [ $filesize -gt $3 ]; then
            echo $filename $filesize "size is greater than configured " $3
            echo "Deleting " $filename
            rm -f $filename
            send_deletion_email $filename $filesize $3
        else
            echo $filename "size is less than " $filesize
        fi
        
    done
}

function process_app_log {
    echo "Processing app log for" $1
    case $1 in
        "apache")
            manage_files_per_size $1 "/var/log/abhijit/apache/" $apache_size
            # manage_files_per_days
            ;;
        # "nginx")
        #     manage_files_per_size $1 "/var/log/abhijit/nginx/" $nginx_size
        #     # manage_files_per_days
        #     ;;
        esac
}

# echo ${arr[*]}
for i in "${arr[@]}"
do
    :
    process_app_log $i
done

