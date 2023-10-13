#!/usr/bin/env bash

set -e

role=${CONTAINER_ROLE:-app}
env=${APP_ENV:-local}
port=${APP_PORT:-8000}

initScript=${INIT_SCRIPT}

if [ -n "$initScript" ]; then
    sh $initScript
fi

if [[ "$env" != "local" ]] && [[ "$role" == "app" ]]; then
    echo "migrate"
    (cd /var/www/html && php artisan migrate --force)
    (cd /var/www/html && php artisan octane:start --port="$port" --host=0.0.0.0)
fi

if [ "$role" = "app" ]; then

    (cd /var/www/html && php artisan octane:start --port="$port" --host=0.0.0.0)

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

else
    echo "Could not match the container role \"$role\""
    exit 1
fi
