#!/bin/sh

# The purpose of this script is for the service inside the container to use the
# same user id as the host user that owns the mounted volume. Otherwise, all
# generated files and directories (build artifacts, downloaded packages etc.)
# will belong to root and not be accessible for the host user. We dynamically
# create the matching user when starting the container, because not everyone
# will use the same uid on their system when developing, which is why we can't
# hardcode this in the image.

CMD=$1

uid="$(stat -c "%u" /app)"

if [[ "${uid}" != "0" ]]; then
  adduser -D -u ${uid} user-${uid}
  echo Running as: ${uid}
  su user-${uid} "${CMD}"
else
  "${CMD}"
fi
