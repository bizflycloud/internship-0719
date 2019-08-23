# CRON 

Cron create an efficient way to create and manage future jobs.

1. The cron that runs system jobs, schedule in `etc/crontab`

  Syntax : `minutes hours dom month dow [command]`

2. User can run their own cron job

  2.1. allow user cron job : only user that's listed in that directory have the rights to create cron jobs, stored in `etc/cron.allow`
  2.2. restrict user cron job : every users can create cron jobs except those are listed in `etc/cron.deny`
  
  **Create user cron jobs**
  
  Syntax: stay the same as create system's cron jobs but before that, must open cr`crontab -e`
  
  
  **To remove user cron jobs**
  
   open cr`crontab -e`, then find an entry and the task that need to be remove, then remove it, after that, save the file
   
   otherwise, using `crontab -r`, this will remove all the cron jobs that were stored or on a queue 
  
  # AT
  
  Using at to schedule jobs for one time
  
  **Create an "at" to schedule jobs
  
   Syntax: `at -f [filename] [time] (+) [time]`
  
      > Ex: to run a file named "filename" after now about 1 hour, type in : ` at -f filename now + 1 hour`
  
      > Ex2: To set it run on 13:09 on thursday, type in : ` at -f filename 13:09 thursday`
  
  **Show the queue of "at" jobs**
  
   Syntax: `atq`
  
  > The command will list all "at" that were created, included an entry for each one of them
  
  **To delete an "at" job**
  
   Syntax: ` at -d [entry]`
  
  
