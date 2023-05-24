#!/bin/sh

# Safety bash script options
# -e causes a bash script to exit immediately when a command fails
# -u causes the bash shell to treat unset variables as an error and exit immediately.
set -eu

get_date () {
    date +[%Y-%m-%d\ %H:%M:%S]
}

TIMESTAMP=$(date +%Y-%m-%d_%H%M%S)
UPLOAD_PATH=$NEXTCLOUD_URL$TIMESTAMP-$DEST_FILE

echo "$(get_date) ➡️ Uploading to: $UPLOAD_PATH"
curl --progress-bar -T $SOURCE_FILE -u "$NEXTCLOUD_USR:$NEXTCLOUD_PWD" $UPLOAD_PATH
echo "$(get_date) ✅ Done"
