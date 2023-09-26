#!/bin/sh

# Safety bash script options
# -e causes a bash script to exit immediately when a command fails
# -u causes the bash shell to treat unset variables as an error and exit immediately.
set -eu

get_date () {
  date +[%Y-%m-%d\ %H:%M:%S]
}

# tar directory
echo "$(get_date) ⚙️  Create tar for directory upload: $DIRECTORY_UPLOAD_TAR_FILE"
tar -czf $DIRECTORY_UPLOAD_TAR_FILE $SOURCE_DIRECTORY
SOURCE_FILE=DIRECTORY_UPLOAD_TAR_FILE

# upload file
source /app/upload-file.sh

# cleanup
echo "$(get_date) ⚙️  Clean up tar from directory upload: $DIRECTORY_UPLOAD_TAR_FILE"
rm $DIRECTORY_UPLOAD_TAR_FILE
