# manage_logs
Scripts to collect logs from multiple servers and manage them.

Create Configuration file managelogs.config
Example Configuration (All Sizes in Mb):
# First Line to list all application with space seperated
apache nginx
# <your_app_name>_days for specifying days limit
apache_days=3

# <your_app_name>_size for specifying size limit in Mb
apache_size=10

nginx_days=10
nginx_size=5

Last line contain email address
email=yourname@server.com
