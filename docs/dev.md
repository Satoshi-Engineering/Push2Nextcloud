# Development Notes

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
docker push tag satoshiengineering/push2nextcloud --all-tags
```
