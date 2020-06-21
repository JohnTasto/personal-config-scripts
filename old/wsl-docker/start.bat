docker build^
 --tag remote-tls-api^
 .

docker run^
 --name remote-tls-api^
 --detach^
 --rm^
 --publish 2375:443^
 --mount type=bind,source=/var/run/docker.sock,target=/var/run/docker.sock,readonly^
 remote-tls-api
