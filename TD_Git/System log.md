# System Log

> Syslog is an software package in Linux system used to record "log" of the system like in kernel, deamon, cron, auth, http, dns, dhcp, ntp,..

**_Log usage_**
- Analyze the root of an event
- Provide faster solution when the system meets problem
- Discover and predict an event's gonna happen to the system
- ...

**_syslogd syntax_**

> `syslogd + option`

Options:

1. `-f` Specify an alternative configuration file instead of /etc/syslog.conf, which is the default.
2. `-h` By default, syslogd will not forward messages it receives from remote hosts. Specifying this switch on the command line will cause the log daemon to forward any remote messages it receives to forwarding hosts which have been defined.
3. `-l` Specify a hostname that should be logged only with its simple hostname and not the fqdn. Multiple hosts may be specified using the colon (``:'') separator.
4. `-m` (interval) The syslogd logs a mark timestamp regularly. The default interval between two -- MARK --lines is 20 minutes. This can be changed with this option and, setting the interval to zero turns it off entirely.
5. `-r` Used to allow receipt of network messages.

Syslog configuration file stored in `/etc/rsyslog.conf`

- syslog file has 2 parts:
  - part 1: Seletor
    - Log Sources
  
    |Sources| Meaning |
    |--------------|---------|
    |kernel | Logs created by kernel |
    |auth or authpriv | Logs created by accounts authentication |
    |mail | Mail logs |
    |cron | Logs created by cron process |
    |user | Logs created from user applications |
    |lpr | Logs from printing |
    |deamon | Logs created by background process |
    |ftp | Logs created by ftp | 
    |local 0 -> local 7 | Log generate in local |

    - Level of Alert

    | Alert Levels | Meaning |
    |--------------|---------|
    |emerg | Emergency |
    |alert | Needs interfere right about time |
    |crit | Critical situation |
    |error | Errors Notifications |
    |warn | Warning level |
    |notice | Noticable to System |
    |info | Info of the System |
    |debug | Debugging of the System |
    
 - part 2: Action shows the directory of where logs are saved
  
# Rotating Log

