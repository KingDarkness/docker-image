#!/usr/bin/env bash

set -e

role=${CONTAINER_ROLE:-app}
env=${APP_ENV:-local}
migration=${AUTORUN_MIGRATION:-true}

initScript=${INIT_SCRIPT}

customCommand=${CUSTOM_COMMAND}

if [ -n "$initScript" ]; then
	sh $initScript
fi

if [[ "$env" != "local" ]] && [[ "$role" == "app" ]] && [[ "$migration" == "true" ]]; then
	echo "migrate"
	(cd /app && php artisan migrate --force)
fi

if [ "$role" = "app" ]; then

	exec docker-php-entrypoint --config /etc/caddy/Caddyfile --adapter caddyfile

elif [ "$role" = "queue" ]; then

	echo "Running the queue..."
	php /app/artisan queue:work --verbose --tries=3 --timeout=90 --stop-when-empty

elif [ "$role" = "scheduler" ]; then

	while [ true ]; do
		php /app/artisan schedule:run --verbose --no-interaction &
		sleep 60
	done

elif [ "$role" = "rpc-server" ]; then

	echo "Running the rpc..."
	php /app/artisan rabbit:rpc-server

elif [ "$role" = "work-queues-server" ]; then

	echo "Running the work-queues..."
	php /app/artisan rabbit:work-queues-server

elif [ "$role" = "horizon" ]; then

	echo "Running the horizon..."
	php /app/artisan horizon
elif [[ -n "$customCommand" ]] && [[ "$role" == "command" ]]; then
	$customCommand

else
	echo "Could not match the container role \"$role\""
	exit 1
fi
