# Push ➡️ 2 ➡️ Nextcloud

_by the [#sathoshiengineeringcrew](https://satoshiengineering.com/)_

[![MIT License Badge](docs/img/license-badge.svg)](LICENSE)

Simple docker based backup solution for nextcloud users.

It is a file change monitor that uploads the file on file change to a nextcloud share.


## Usage

Sadily it's not one of these out of the box projects. There are some steps that need to be done.

1. Create Nextcloud Share
2. Run with docker-compose

### Create Nextcloud Share

1. Open Share view of the folder you want to use as drop off and click the `+` Symbol to create a share link.
   
<img src="docs/img/share1.png" width="300"/>

2. Open the details `...`

<img src="docs/img/share2.png" width="300"/>

3. Choose "File Drop" which means even if someone get the url, the files can not be seen.
   - Also check "Hide download" and 
   - check "Password protect" and choose a good password, this will be your `NEXTCLOUD_PWD`

<img src="docs/img/share3.png" width="300"/>

4. Copy the Share link which looks like that:

`https://nextcloud.yourcompany.com/s/t321tytR5NJunoD`

The last part is the ShareId or the "user" that we need for the tool `https://nextcloud.yourcompany.com/s/<NEXTCLOUD_USR>`


<img src="docs/img/share4.png" width="300"/>


### Run with docker-compose

[Copy](docker-compose.yml) or create the docker-compose.yml

```yaml
version: "3.9"
  
services:
  push2next:
    image: "satoshiengineering/push2nextcloud:1.0.0"
    container_name: "push2nextcloud"
    volumes:
      - ../data:/backup:ro
      
    environment:
      - SOURCE_FILE=/backup/dumb.data
      - DEST_FILE=dumb.data

      - NEXTCLOUD_USR=jack
      - NEXTCLOUD_PWD=secret
      - NEXTCLOUD_URL=https://nextcloud.yourcompany.com/public.php/webdav/
```

Let's assume the watched file will be `../data/dumb.data`

- Change the mounted the directory into the container `../data:/backup:ro`
- Edit the environment variables in the docker-compose file. An explanation of the environment variables [see here](.env.example).

Run the docker-compose file:
```shell
docker-compose up -d
```

If you wanna check the logs
```shell
docker logs -n 200 -f push2nextcloud
```

## Notes

### Trigger the Backup manually

```shell
docker exec -it <container_name> /scripts/upload.sh
```

If started with docker-compose file of this repository
```shell
docker exec -it push2nextcloud /scripts/upload.sh
```

### Run with Docker and .env file
```shell
docker run -v ./data:/backup:ro --env-file .env satoshiengineering/push2nextcloud:1.0.0 -d 
```

### Hints
- It should also work with a nextcloud user and password, but I think the link is different (because somehow the path must be somewhere)

# Tip us

If you like this project, please adapt the landingpage to your local stores, that
accept bitcoin or even extend it. Why not [send some tip love?](https://legend.lnbits.com/tipjar/523)