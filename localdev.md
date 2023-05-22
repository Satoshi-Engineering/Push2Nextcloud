### Notes

docker run -it --rm -v ${PWD}/../data:/backup:ro -v ${PWD}/src:/app --env-file .env alpine:3.17.3

apk update && apk add inotify-tools && apk add curl

./app/entrypoint.sh