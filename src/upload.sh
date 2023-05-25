#!/bin/sh

# Safety bash script options
# -e causes a bash script to exit immediately when a command fails
# -u causes the bash shell to treat unset variables as an error and exit immediately.
set -eu

get_date () {
    date +[%Y-%m-%d\ %H:%M:%S]
}

UPLOAD_SOURCE=$SOURCE_FILE

# Upload Mode
case $NEXTCLOUD_UPLOAD_MODE in
  overwrite)
    UPLOAD_PATH=$NEXTCLOUD_URL$DEST_FILE
    ;;

  # Default Upload Mode --> New File
  *)
    TIMESTAMP=$(date +%Y-%m-%d_%H%M%S)
    UPLOAD_PATH=$NEXTCLOUD_URL$TIMESTAMP-$DEST_FILE
    ;;
esac

# Tar
if [ "$DEST_FILE_TAR" == "true" ]; then
  UPLOAD_SOURCE="$TAR_WORKING_DIR/tared_file.tar.gz"

  echo "$(get_date) ⚙️  Create Tar at: $UPLOAD_SOURCE"

  # Tar file
  tar -czf $UPLOAD_SOURCE $SOURCE_FILE

  # Set Desitnation
  UPLOAD_PATH=$UPLOAD_PATH.tar.gz
fi

echo "$(get_date) ➡️  Uploading to: $UPLOAD_PATH"
curl -T $UPLOAD_SOURCE -u "$NEXTCLOUD_USR:$NEXTCLOUD_PWD" -H 'X-Method-Override: PUT' $UPLOAD_PATH

if [ "$DEST_FILE_TAR" == "true" ]; then
    echo "$(get_date) ⚙️  Clean up Tar at: $UPLOAD_SOURCE"

  rm $UPLOAD_SOURCE
fi

echo "$(get_date) ✅ Done"
