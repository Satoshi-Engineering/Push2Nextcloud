# Development Notes

## Docker Hub

1. Change Version Label
```bash
nano Dockerbuild
```

2. build
```bash
docker build -t satoshiengineering/push2nextcloud:1.0.4 .
```

3. Tag latest
```bash
docker tag satoshiengineering/push2nextcloud:1.0.4 satoshiengineering/push2nextcloud
```

4. Push it, Push it
```bash
docker push satoshiengineering/push2nextcloud:1.0.4
docker push satoshiengineering/push2nextcloud
```

FYI: If you use `--all-tags` it will also push the old tags ... be carefull not to change old versions!

```bash
docker push --all-tags satoshiengineering/push2nextcloud
```

## Run local in container

docker run -it --rm -v ${PWD}/../data:/backup:ro -v ${PWD}/src:/app --env-file .env alpine:3.17.3

apk update && apk add inotify-tools && apk add curl

./app/entrypoint.sh

## Nextcloud

```bash
source .env
curl -T ../data/dumb.data -u "$NEXTCLOUD_USR:$NEXTCLOUD_PWD" $NEXTCLOUD_URL/test.data

# Overwrite --> Need permissions
curl --progress-bar -T ../data/dumb.data -u "$NEXTCLOUD_USR:$NEXTCLOUD_PWD" -H 'X-Method-Override: PUT' $NEXTCLOUD_URL/test.data

# Delete
curl --progress-bar -X DELETE -u "$NEXTCLOUD_USR:$NEXTCLOUD_PWD" $NEXTCLOUD_URL/test.data

# Get Props
curl -X PROPFIND -u "$NEXTCLOUD_USR:$NEXTCLOUD_PWD" $NEXTCLOUD_URL/test.data
```

```xml
<?xml version="1.0"?>
<d:multistatus xmlns:d="DAV:" xmlns:s="http://sabredav.org/ns" xmlns:oc="http://owncloud.org/ns" xmlns:nc="http://nextcloud.org/ns">
    <d:response>
        <d:href>/public.php/webdav/bigfile.mp4</d:href>
        <d:propstat>
            <d:prop>
                <d:getlastmodified>Wed, 24 May 2023 11:13:54 GMT</d:getlastmodified>
                <d:getcontentlength>85964220</d:getcontentlength>
                <d:resourcetype/>
                <d:getetag>&quot;acefef27a0e0c3c53c5c7dd736b4dd3d&quot;</d:getetag>
                <d:getcontenttype>video/mp4</d:getcontenttype>
            </d:prop>
            <d:status>HTTP/1.1 200 OK</d:status>
        </d:propstat>
    </d:response>
</d:multistatus>
```

- Overwriting is only with write permissions https://help.nextcloud.com/t/curl-upload-no-overwrite-possible/69970
- Storage Quota & Versioned Files: https://docs.nextcloud.com/server/latest/user_manual/ar/files/quota.html
> When version control is enabled, the older file versions are not counted against quotas.
> 
> If you create a public share via URL and allow uploads, any uploaded files count against your quota
> 
> Deleted files that are still in the trash bin do not count against quotas. The trash bin is set at 50% of quota. Deleted file aging is set at 30 days. When deleted files exceed 50% of quota then the oldest files are removed until the total is below 50%.

## Notes