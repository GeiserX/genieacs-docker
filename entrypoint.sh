#!/bin/sh
# /usr/local/bin/entrypoint.sh

# When /opt is backed by a persistent volume, the image's /opt/genieacs
# directory is masked by the (possibly empty) mount.  Seed it from the
# pristine copy shipped in the image if the application is missing.
if [ ! -f /opt/genieacs/package.json ]; then
  echo "entrypoint: seeding /opt/genieacs from /usr/share/genieacs ..."
  cp -a /usr/share/genieacs /opt/genieacs
fi

# Ensure the genieacs user owns /opt/genieacs and /var/log/genieacs.
# Required when the persistent volume (e.g. NFS) does not honour fsGroup.
chown -R genieacs:genieacs /opt/genieacs /var/log/genieacs

# run cron daemon
service cron start

# Run the main container command
exec gosu genieacs "$@"
