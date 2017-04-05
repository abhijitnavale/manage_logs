#!/usr/bin/sh

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

function process_app_log {
    echo "Process app log for" $1
    case $1 in
        "apache")
            echo $apache_days
            ;;
        "nginx")
            echo $nginx_size
            ;;
        esac
}

# echo ${arr[*]}
for i in "${arr[@]}"
do
    :
    process_app_log $i
done

