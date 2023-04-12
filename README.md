# Push2Nextcloud

Simple docker based backup solution for nextcloud users.

## Environment Variables
```
# Source file that should be watched (in the docker container)
SOURCE_FILE=/data/dumb.data

# Filename on nextcloud
DEST_FILE=dumb.data

# Nextcloud User
NEXTCLOUD_USR=jack
NEXTCLOUD_PWD=secret
NEXTCLOUD_URL=https://nextcloud.yourcompany.com/public.php/webdav/
```

## Create Nextcloud Share

You have two options:
1. Create a share with password
2. Use a nextcloud user

### 1. Create a share with password





```
docker run -v /etc/nginx:/data 
```
