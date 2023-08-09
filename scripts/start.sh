#!/bin/bash
docker run \
	-it \
	--rm \
	--env-file ./.env \
	--name mastodon \
	--cpus="2" \
	-m="7g" \
	-p 3000:3000 \
	-p 4000:4000 \
	--volume $(pwd)/public/system:/mastodon/public/system \
	docker.io/neetshin/mastodon-dev:latest \
	bash -c "foreman start"	

# --health-cmd "wget -q --spider --proxy=off localhost:3000/health || exit 1"	 \