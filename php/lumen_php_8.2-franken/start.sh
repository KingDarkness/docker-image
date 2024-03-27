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
	(cd /var/www/html && php artisan migrate --force)
fi

if [ "$role" = "app" ]; then

	exec docker-php-entrypoint --config /etc/caddy/Caddyfile --adapter caddyfile

elif [ "$role" = "queue" ]; then

	echo "Running the queue..."
	php /var/www/html/artisan queue:work --verbose --tries=3 --timeout=90 --stop-when-empty

elif [ "$role" = "scheduler" ]; then

	while [ true ]; do
		php /var/www/html/artisan schedule:run --verbose --no-interaction &
		sleep 60
	done

elif [ "$role" = "rpc-server" ]; then

	echo "Running the rpc..."
	php /var/www/html/artisan rabbit:rpc-server

elif [ "$role" = "work-queues-server" ]; then

	echo "Running the work-queues..."
	php /var/www/html/artisan rabbit:work-queues-server

elif [ "$role" = "horizon" ]; then

	echo "Running the horizon..."
	php /var/www/html/artisan horizon
elif [[ -n "$customCommand" ]] && [[ "$role" == "command" ]]; then
	$customCommand

else
	echo "Could not match the container role \"$role\""
	exit 1
fi
