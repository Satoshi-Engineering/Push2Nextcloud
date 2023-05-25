#!/bin/sh

# Safety bash script options
# -e causes a bash script to exit immediately when a command fails
set -e
set -o pipefail
# set -x # for debug

TAR_WORKING_DIR="/work"

[ -z "$SOURCE_FILE" ] && { echo "🚨 ENV: SOURCE_FILE missing!"; exit 2; }

[ -z "$DEST_FILE" ] && { echo "🚨 ENV: SOURCE_FILE missing!"; exit 2; }
[ -z "$DEST_FILE_TAR" ] && { echo "ℹ️  ENV: DEST_FILE_TAR not set. Setting to mode 'false'!"; DEST_FILE_TAR="false"; }

[ -z "$NEXTCLOUD_USR" ] && { echo "🚨 ENV: NEXTCLOUD_USR missing!"; exit 2; }
[ -z "$NEXTCLOUD_PWD" ] && { echo "🚨 ENV: NEXTCLOUD_PWD missing!"; exit 2; }
[ -z "$NEXTCLOUD_URL" ] && { echo "🚨 ENV: NEXTCLOUD_URL missing!"; exit 2; }

[ -z "$NEXTCLOUD_UPLOAD_MODE" ] && { echo "ℹ️  ENV: NEXTCLOUD_UPLOAD_MODE not set. Setting to mode 'newfile'!"; NEXTCLOUD_UPLOAD_MODE="newfile"; }

get_date () {
    date +[%Y-%m-%d\ %H:%M:%S]
}

check_file () {
  [ ! -e "$SOURCE_FILE" ] && { echo "$(get_date) 🚨 SOURCE_FILE: $SOURCE_FILE is missing or was removed!"; exit 3; }
  return 0
}

startup_checks () {
  # Check if Tar working directory does not exist
  if [ ! -d "$TAR_WORKING_DIR" ]; then
    # Take action if $DIR exists.
    echo "Creating Working directory in ${TAR_WORKING_DIR}"
    mkdir $TAR_WORKING_DIR
  fi
}

# Monitoring function
run_mode_file_change () {
  # Check if file exists
  check_file

  # Monitor File
  while true; do
      echo "$(get_date) 👀 Watching: $SOURCE_FILE"
      inotifywait $SOURCE_FILE
      echo "$(get_date) ➡️  $SOURCE_FILE has been changed!"
      check_file

      source /app/upload.sh
  done
}

echo "$(get_date) ⚙️  Mode: Watch File Change"
echo "$(get_date) ⚙️  Upload Mode: $NEXTCLOUD_UPLOAD_MODE"
echo "$(get_date) ⚙️  Tar Destination File: $DEST_FILE_TAR"

startup_checks

run_mode_file_change
