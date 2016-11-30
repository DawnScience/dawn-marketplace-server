#!/bin/sh
#shell script to start, stop and restart the DAWN marketplace server
#(code found on stackoverflow.com)
DIR="$( cd "$( dirname "$0" )" && pwd )"
SERVICE_NAME=DAWN_Market_Place_Server
SERVER_LOG=dawnmarket.log

case $1 in
    release)
		JAR_NAME=org.dawnsci.marketplace.server-1.0.0-RELEASE.war
    ;;
    snapshot)
		JAR_NAME=org.dawnsci.marketplace.server-1.0.0-SNAPSHOT.war
    ;;
    *)
		echo "Invalid argument: $1"
		exit 1
esac

PATH_TO_JAR=$DIR/$JAR_NAME
PID_PATH_NAME=$DIR/dawn-marketplace-server-pid
case $2 in
    start)
        echo "Starting $SERVICE_NAME ..."
        if [ ! -f $PID_PATH_NAME ]; then
            nohup java -jar $PATH_TO_JAR > $SERVER_LOG 2>>$SERVER_LOG &
                        echo $! > $PID_PATH_NAME
            echo "$SERVICE_NAME started ..."
        else
            echo "$SERVICE_NAME is already running ..."
        fi
    ;;
    stop)
        if [ -f $PID_PATH_NAME ]; then
            PID=$(cat $PID_PATH_NAME);
            echo "$SERVICE_NAME stopping ..."
            kill $PID;
            echo "$SERVICE_NAME stopped ..."
            rm $PID_PATH_NAME
        else
            echo "$SERVICE_NAME is not running ..."
        fi
    ;;
    restart)
        if [ -f $PID_PATH_NAME ]; then
            PID=$(cat $PID_PATH_NAME);
            echo "$SERVICE_NAME stopping ...";
            kill $PID;
            echo "$SERVICE_NAME stopped ...";
            rm $PID_PATH_NAME
            echo "$SERVICE_NAME starting ..."
            nohup java -jar $PATH_TO_JAR > $SERVER_LOG 2>>$SERVER_LOG &
                        echo $! > $PID_PATH_NAME
            echo "$SERVICE_NAME started ..."
        else
            echo "$SERVICE_NAME is not running ..."
        fi
    ;;
esac

