#!/usr/bin/env bash

set -e

rm -f Gemfile.lock

docker-compose build

echo "Copying Gemfile.lock back to repo..."
docker run -it -v $(pwd):/copy_dir data-wrangler_app cp Gemfile.lock /copy_dir/
