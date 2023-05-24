# Development Notes

## Docker Hub

1. Change Version Label

```bash
nano Dockerbuild
```
2. build
```bash
docker build -t satoshiengineering/push2nextcloud:1.X.X .
```

3. Tag latest
```bash
docker tag satoshiengineering/push2nextcloud:1.X.X satoshiengineering/push2nextcloud
```

4. Push it, Push it

FYI: If you use `--all-tags` it will also push the old tags ... be carefull not to change old versions!

```bash
docker push tag satoshiengineering/push2nextcloud
```

## Run local in container

docker run -it --rm -v ${PWD}/../data:/backup:ro -v ${PWD}/src:/app --env-file .env alpine:3.17.3

apk update && apk add inotify-tools && apk add curl

./app/entrypoint.sh

## Nextcloud

```bash
source .env
curl -T ../data/dumb.data -u "$NEXTCLOUD_USR:$NEXTCLOUD_PWD" $NEXTCLOUD_URL/test.data


source .env; curl --progress-bar -T ../data/dumb.data -u "$NEXTCLOUD_USR:$NEXTCLOUD_PWD" $NEXTCLOUD_URL/test.data


```
