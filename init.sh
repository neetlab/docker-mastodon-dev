#!/bin/bash
./exec.sh "
	bundle exec rails db:create &&
	bundle exec rails db:schema:load &&
	bundle exec rails db:seed
"