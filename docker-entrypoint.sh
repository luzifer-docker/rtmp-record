#!/usr/local/bin/dumb-init /bin/bash
set -euxo pipefail

# Ensure nginx can work with the /data dir
chown -R http /data
chgrp -R http /data

exec nginx -g "daemon off;"
