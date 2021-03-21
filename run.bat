docker stop -t 2 elixir
docker stop -t 2 postgres
docker rm elixir
docker rm postgres
docker-compose up --remove-orphans --force-recreate --build --detach
winpty docker exec -it elixir bash