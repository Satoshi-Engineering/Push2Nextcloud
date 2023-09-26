#!/bin/sh

# Safety bash script options
# -e causes a bash script to exit immediately when a command fails
set -e
set -o pipefail
# set -x # for debug

TAR_WORKING_DIR="/work"
DIRECTORY_UPLOAD_TAR_FILE="${TAR_WORKING_DIR}/tmp.tar.gz"

# check watch mode
WATCH_MODE=
if [ ! -z "$SOURCE_FILE" ] && [ ! -z "$SOURCE_DIRECTORY" ]; then
  echo "🚨 ENV: SOURCE_FILE and SOURCE_DIRECTORY set, set exactly one!"
  exit 2
elif [ -z "$SOURCE_FILE" ] && [ -z "$SOURCE_DIRECTORY" ]; then
  echo "🚨 ENV: SOURCE_FILE and SOURCE_DIRECTORY missing, set exactly one!"
  exit 2
elif [ ! -z "$SOURCE_FILE" ]; then
  WATCH_MODE=File
else
  WATCH_MODE=Directory
fi

# check tar of uploaded file, prevent for directory upload (directory is tar anyways)
if [ $WATCH_MODE == "Directory" ] && [ "$DEST_FILE_TAR" == "true" ]; then
  DEST_FILE_TAR="false"
elif [ -z "$DEST_FILE_TAR" ]; then
  echo "ℹ️  ENV: DEST_FILE_TAR not set. Setting to mode 'false'!"
  DEST_FILE_TAR="false"
fi

# check nextcloud config
[ -z "$DEST_FILE" ] && { echo "🚨 ENV: DEST_FILE missing!"; exit 2; }
[ -z "$NEXTCLOUD_USR" ] && { echo "🚨 ENV: NEXTCLOUD_USR missing!"; exit 2; }
[ -z "$NEXTCLOUD_PWD" ] && { echo "🚨 ENV: NEXTCLOUD_PWD missing!"; exit 2; }
[ -z "$NEXTCLOUD_URL" ] && { echo "🚨 ENV: NEXTCLOUD_URL missing!"; exit 2; }
[ -z "$NEXTCLOUD_UPLOAD_MODE" ] && { echo "ℹ️  ENV: NEXTCLOUD_UPLOAD_MODE not set. Setting to mode 'newfile'!"; NEXTCLOUD_UPLOAD_MODE="newfile"; }

get_date () {
    date +[%Y-%m-%d\ %H:%M:%S]
}

check_file () {
  [ $WATCH_MODE == "File" ] && [ ! -e "$SOURCE_FILE" ] && { echo "$(get_date) 🚨 SOURCE_FILE: $SOURCE_FILE is missing or was removed!"; exit 3; }
  [ $WATCH_MODE == "Directory" ] && [ ! -d "$SOURCE_DIRECTORY" ] && { echo "$(get_date) 🚨 SOURCE_DIRECTORY: $SOURCE_DIRECTORY is missing or was removed!"; exit 3; }
  return 0
}

startup_checks () {
  # Check if Tar working directory does not exist
  if ([ "$DEST_FILE_TAR" == "true" ] || [ $WATCH_MODE == "Directory" ]) && [ ! -d "$TAR_WORKING_DIR" ]; then
    # Take action if $DIR exists.
    echo "ℹ️  SETUP: Creating Working directory inside container: ${TAR_WORKING_DIR}"
    mkdir $TAR_WORKING_DIR
  fi
}

# Monitoring function
run_mode_file_change () {
  # Check if file exists
  check_file

  if [ $WATCH_MODE == "File" ]; then
    # Monitor File
    while true; do
      echo "$(get_date) 👀 Watching: $SOURCE_FILE"
      inotifywait $SOURCE_FILE
      echo "$(get_date) ➡️  $SOURCE_FILE has been changed!"
      check_file

      source /app/upload-file.sh
    done
  elif [ $WATCH_MODE == "Directory" ]; then
    # Monitor Directory
    while true; do
      echo "$(get_date) 👀 Watching: $SOURCE_DIRECTORY"
      inotifywait $SOURCE_DIRECTORY
      echo "$(get_date) ➡️  $SOURCE_DIRECTORY has been changed!"
      check_file

      source /app/upload-directory.sh
    done
  fi
}

startup_checks

echo "$(get_date) ⚙️  Mode: Watch $WATCH_MODE Change"
echo "$(get_date) ⚙️  Upload Mode: $NEXTCLOUD_UPLOAD_MODE"
echo "$(get_date) ⚙️  Tar Destination File: $DEST_FILE_TAR"

run_mode_file_change
