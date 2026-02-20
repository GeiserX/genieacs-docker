#!/bin/sh
# /opt/entrypoint.sh

# run cron daemon
service cron start

# Run the main container command
exec gosu genieacs "$@"
