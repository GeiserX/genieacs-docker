#!/bin/sh
# /usr/local/bin/entrypoint.sh

# Ensure the genieacs user owns /opt/genieacs and /var/log/genieacs.
# This is required when /opt is backed by a persistent volume (e.g. NFS)
# that does not honour fsGroup from the pod security context.
chown -R genieacs:genieacs /opt/genieacs /var/log/genieacs

# run cron daemon
service cron start

# Run the main container command
exec gosu genieacs "$@"
