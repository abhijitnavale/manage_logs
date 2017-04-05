#!/usr/bin/sh

LOG_FILE="mylogs.log"
exec 3>&1 1>>${LOG_FILE} 2>&1

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
    mail -s "Log Files Deleted" $email <<< "$1 was deleted. Size was $2 which is greater than configured $3"
}

function manage_files_per_days {
    find "$2" -mindepth 1 -mtime +"$3" -delete
}

function manage_files_per_size {
    for filename in "$2"*; do
        filesize=$(($( stat -c '%s' $filename) / 1024 / 1024 ))
        if [ $filesize -gt $3 ]; then
            echo $filename $filesize "size is greater than configured " $3
            echo "Deleting " $filename
            rm -f $filename
            send_deletion_email $filename $filesize $3
        fi
        
    done
}

function process_app_log {
    echo "Processing app log for" $1
    case $1 in
        "apache")
            apache_dir = "/var/log/abhijit/apache"
            manage_files_per_size $1 $apache_dir $apache_size
            manage_files_per_days $1 $apache_dir $apache_days
            ;;
        "nginx")
            nginx_dir = "/var/log/abhijit/nginx/"
            manage_files_per_size $1 $nginx_dir $nginx_size
            manage_files_per_days $1 $nginx_dir $nginx_days
            ;;
        esac
}

# echo ${arr[*]}
for i in "${arr[@]}"
do
    :
    process_app_log $i
done

