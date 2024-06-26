#!/bin/sh
#
# Chess
#
# chkconfig: - 64 36
# Default-Start: 2 3 4 5
# Default-Stop: 0 1 2 3 4 6
# Required-Start:
# description: Chess
# processname: chess
# pidfile: none
# lockfile: /var/lock/subsys/chess

# Source function library.
. /etc/rc.d/init.d/functions

# Source networking configuration.
. /etc/sysconfig/network

# Check that networking is up.
[ "$NETWORKING" = "no" ] && exit 0

USER="chess"
APPNAME="chess"
APPBIN="/usr/bin/chess"
APPARGS="-config config.json"
LOGFILE="/var/log/$APPNAME/error.log"
LOCKFILE="/var/lock/subsys/$APPNAME"

LOGPATH=$(dirname $LOGFILE)

start() {
        [ -x $prog ] || exit 5
        [ -d $LOGPATH ] || mkdir $LOGPATH; chown $USER:$USER $LOGPATH
        [ -f $LOGFILE ] || touch $LOGFILE; chown $USER:$USER $LOGFILE

        echo -n $"Starting $APPNAME: "
        daemon --user=$USER "$APPBIN $APPARGS >>$LOGFILE &"
        RETVAL=$?
        echo
        [ $RETVAL -eq 0 ] && touch $LOCKFILE
        return $RETVAL
}

stop() {
        echo -n $"Stopping $APPNAME: "
        killproc $APPBIN
        RETVAL=$?
        echo
        [ $RETVAL -eq 0 ] && rm -f $LOCKFILE
        return $RETVAL
}

restart() {
        stop
        start
}

rh_status() {
        status $APPNAME
}

rh_status_q() {
        rh_status >/dev/null 2>&1
}

case "$1" in
        start)
                rh_status_q && exit 0
                $1
        ;;
        stop)
                rh_status_q || exit 0
                $1
        ;;
        restart)
                $1
        ;;
        status)
                rh_status
        ;;
        *)
                echo $"Usage: $0 {start|stop|status|restart}"
                exit 2
esac
