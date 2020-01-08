# image info
- lang UTF-8
- timezone Asia/Ho_Chi_Minh
- php7.3
  + upload_max_filesize = 10M
  + memory_limit = 3072M
  + max_execution_time = 90s
  + post_max_size = 15M
  + pdo
  + zip
  + pdo_mysql
  + gd
  + composer
  + phpdbg
- apache2
  + rewrite
  

## docker-compose 
```yaml
version: "3"
services:
  app:
    image: kingdarkness/lumen-php:7.3-apache-stretch
    volumes:
      - ./app:/var/www/html
    environment:
      CONTAINER_ROLE: app
```

environment

## CONTAINER_ROLE:
- app: apache2-foreground
- scheduler: php /var/www/html/artisan schedule:run --verbose --no-interaction
- queue: php /var/www/html/artisan queue:work --verbose --tries=3 --timeout=90