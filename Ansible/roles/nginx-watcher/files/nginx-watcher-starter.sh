#!/bin/bash

case "$1" in 
start)
   /etc/nginx-watcher/nginx-watcher.sh &
   echo $!>/var/run/nginx-watcher.pid
   ;;
stop)
   kill `cat /var/run/nginx-watcher.pid`
   rm /var/run/nginx-watcher.pid
   ;;
restart)
   $0 stop
   $0 start
   ;;
status)
   if [ -e /var/run/nginx-watcher.pid ]; then
      echo nginx-watcher.sh is running, pid=`cat /var/run/nginx-watcher.pid`
   else
      echo nginx-watcher.sh is NOT running
      exit 1
   fi
   ;;
*)
   echo "Usage: $0 {start|stop|status|restart}"
esac

exit 0 