#!/usr/bin/env bash
set -e

mkdir -p "$DB_BACKUP_DIRECTORY" && cd "$DB_BACKUP_DIRECTORY"

dumpFileName="$1-$(date +%F_%R).sql"

echo -e "${GREEN}mysqldump -u root -proot $1 > $dumpFileName${NONE}"

# Check for Linux machines
/usr/local/mysql/bin/mysqldump -u root -proot $1 > ${dumpFileName}
