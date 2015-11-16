docker-compose run web rake db:create
docker-compose run web rake db:migrate
docker-compose \
  -e MYSQL_USER=calcaxy \
  -e MYSQL_PASSWORD=secret \
  -e MYSQL_ROOT=very_secret \
  up

