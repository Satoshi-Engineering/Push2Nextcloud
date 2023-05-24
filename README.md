# Push ➡️ 2 ➡️ Nextcloud

_by the [#sathoshiengineeringcrew](https://satoshiengineering.com/)_

[![MIT License Badge](docs/img/license-badge.svg)](LICENSE)

Simple docker based backup solution for nextcloud users. It is a file change monitor that uploads the file on file change to a nextcloud share.

Source can be found on [Github](https://github.com/Satoshi-Engineering/Push2Nextcloud).

Uses cases:
* Redis Database dump
* LND Static Channel Backup

There currently two upload modes:

- New File: On File Change the date&time is appended and the file uploaded
- Overwrite Mode: The file is uploaded and overwritten

## Usage

Sadly it's not one of these out of the box projects. There are some steps that need to be done.

1. Create Nextcloud Share
2. Set Environment Variables
3. Run with docker-compose


### Create Nextcloud Share

1. Open Share view of the folder you want to use as drop off and click the `+` Symbol to create a share link.
   
<img src="docs/img/share1.png" width="300"/>

2. Open the details `...`

<img src="docs/img/share2.png" width="300"/>

3. Choose "File Drop" which means even if someone else discovers the url, the files can not be seen.
   - Also check "Hide download" and 
   - check "Password protect" and choose a good password, this will be your `NEXTCLOUD_PWD`

<img src="docs/img/share3.png" width="300"/>



4. Copy the Share link which looks like that:

`https://nextcloud.yourcompany.com/s/t321tytR5NJunoD`

The last part is the ShareId or the "user" that we need for the tool `https://nextcloud.yourcompany.com/s/<NEXTCLOUD_USR>`


<img src="docs/img/share4.png" width="300"/>

### Set Environment Variables

Let's assume the watched file will be at `../data/dump.data`

- Mount the directory of the watched file into the container e.g.  `../data:/backup:ro`
- Set the watched file `SOURCE_FILE` to `/backup/dump.data`
- The filename on nextcloud  will be generated with date & time like this `YYYY-MM-DD_HHMMSS-<DEST_FILE>`.
  Example: `DEST_FILE=dump.data` generates `2022-03-30_130059-dump.data`.
- Set `NEXTCLOUD_USR` to the last part of you share link: `https://nextcloud.yourcompany.com/s/<NEXTCLOUD_USR>`
- Set `NEXTCLOUD_PWD` to the password set in Nextcloud
- Set `NEXTCLOUD_URL` to your instance like `https://<YOUR NEXTCLOUD INSTANCE>/public.php/webdav/`

### Run with docker-compose

[Copy](docker-compose.yml) or create the docker-compose.yml

```yaml
version: "3.9"
  
services:
  push2next:
    image: "satoshiengineering/push2nextcloud:latest"
    container_name: "push2nextcloud"
    volumes:
      - ../data:/backup:ro
      
    environment:
      - SOURCE_FILE=/backup/dump.data
      - DEST_FILE=dump.data

      - NEXTCLOUD_USR=jack
      - NEXTCLOUD_PWD=secret
      - NEXTCLOUD_URL=https://<YOUR NEXTCLOUD INSTANCE>/public.php/webdav/
```

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
# either
touch path/to/file.dump

# or
docker exec -it <container_name> /scripts/upload.sh
```

If started with docker-compose file of this repository
```shell
docker exec -it push2nextcloud /scripts/upload.sh
```

### Run with Docker and .env file
```shell
docker run -d -v ./data:/backup:ro --env-file .env --name push2nextcloud satoshiengineering/push2nextcloud:latest
```

### Hints
- It should also work with a nextcloud user and password, but I think the link is different (because somehow the path must be somewhere)

# Tip us

If you like this project, why not [send some tip love?](https://legend.lnbits.com/tipjar/523)