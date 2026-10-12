#!/bin/sh

cd /app/client

gleam run -m lustre/dev build --no-html --outdir=../server/priv/static/

watchexec -r -e gleam,toml,mjs,js --stop-timeout 500ms -- \
  gleam run -m lustre/dev build --no-html --outdir=../server/priv/static/ &

cd /app/server
gleam run
