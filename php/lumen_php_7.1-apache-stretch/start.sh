#!/usr/bin/env bash

set -e

role=${CONTAINER_ROLE:-app}
env=${APP_ENV:-local}
initScript=${INIT_SCRIPT}

if [ -n "$initScript" ]; then
    sh $initScript
fi

if [[ "$env" != "local" ]] && [[ "$role" == "app" ]]; then
    echo "migrate"
    (cd /var/www/html && php artisan migrate --force)
fi

if [ "$role" = "app" ]; then

    exec apache2-foreground

elif [ "$role" = "queue" ]; then

    echo "Running the queue..."
    php /var/www/html/artisan queue:work --verbose --tries=3 --timeout=90

elif [ "$role" = "scheduler" ]; then

    while [ true ]
    do
      php /var/www/html/artisan schedule:run --verbose --no-interaction &
      sleep 60
    done

elif [ "$role" = "horizon" ]; then

    echo "Running the horizon..."
    php /var/www/html/artisan horizon

else
    echo "Could not match the container role \"$role\""
    exit 1
fi