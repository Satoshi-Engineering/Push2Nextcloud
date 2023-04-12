#!/bin/sh

[ -z "$SOURCE_FILE" ] && { echo "🚨 ENV: SOURCE_FILE missing!"; exit 1; }
[ -z "$DEST_FILE" ] && { echo "🚨 ENV: SOURCE_FILE missing!"; exit 1; }

[ -z "$NEXTCLOUD_USR" ] && { echo "🚨 ENV: NEXTCLOUD_USR missing!"; exit 1; }
[ -z "$NEXTCLOUD_PWD" ] && { echo "🚨 ENV: NEXTCLOUD_PWD missing!"; exit 1; }
[ -z "$NEXTCLOUD_URL" ] && { echo "🚨 ENV: NEXTCLOUD_URL missing!"; exit 1; }

get_date () {
    date +[%Y-%m-%d\ %H:%M:%S]
}

# Monitoring function
run () {
  while true; do
      echo "$(get_date) 👀 Watching: $SOURCE_FILE"
      inotifywait --event modify $SOURCE_FILE
      echo "$(get_date) ➡️ $SOURCE_FILE has been changed!"

      source /app/upload.sh
  done
}

echo "$(get_date) ⚙️ Mode: Watch File Change"

run
