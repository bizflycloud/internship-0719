# CRON 

Cron create an efficient way to create and manage future jobs.

1. The cron that runs system jobs, schedule in `etc/crontab`

  Syntax : `minutes hours dom month dow [command]`

2. User can run their own cron job

  2.1. allow user cron job : only user that's listed in that directory have the rights to create cron jobs, stored in `etc/cron.allow`
  2.2. restrict user cron job : every users can create cron jobs except those are listed in `etc/cron.deny`
  
  **Create user cron jobs**
  
  Syntax: stay the same as create system's cron jobs but before that, must open cr`crontab -e`
