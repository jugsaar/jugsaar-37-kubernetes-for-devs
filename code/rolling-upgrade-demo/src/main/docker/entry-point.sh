#!/bin/bash

case "$REMOTE_DEBUG" in
 on) echo "Enable REMOTE_DEBUG" && export DEBUG_OPTS=-agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=8787 ;;
 * ) echo "Disable REMOTE_DEBUG" && export DEBUG_OPTS= ;;
esac


echo
echo "Using Java Version"
java -version

echo "
Launching: $(ls /app/*.jar)
---
DEFAULT_JAVA_OPTS: $(echo $DEFAULT_JAVA_OPTS | tr -s " ")
---
JAVA_OPTS: $(echo $JAVA_OPTS | tr -s " ")
---
DEBUG_OPTS: $(echo $DEBUG_OPTS | tr -s " ")
"

exec java $DEFAULT_JAVA_OPTS $JAVA_OPTS $DEBUG_OPTS -jar /app/*.jar $@