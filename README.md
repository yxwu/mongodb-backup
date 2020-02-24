# mongodb-backup

# Changelog
## 0.1.2 (2020-02-24)
### Changes
1. 在 Dockerfile 中指定 `ENV TZ="America/Los_Angeles"`，使得备份文件名字中的时间为本地时间

## 0.1.1 (2020-02-24)
### Changes
1. Dockerfile 中用 `ENTRYPOINT ["/run.sh"]` 取代 `CMD ["/run.sh"]`，因为做 RESTORE_ONLY 的时候，需要 cmd line 指定 file_name，用 ENTRYPOINT 会把该 file_name 附加到 `/run.sh` 之后。（如果用 CMD，cmd line 中可能需要 `/run.sh file_name`）
2. run.sh 中增加了 `RESTORE_ONLY` 的支持，指定该 ENV 之后，仅做 restore 动作。
3. 如果 ENV 的 CRON_TIME 为 "null"，则 run.sh 不启动 cron job。
### Use cases
1. soh-mob-server 之 backupMongoDb 在保存 mongo 到 ./mongo-backup 目录之后退出
   - script 定义
     ```
     docker run --rm 
     --env MONGODB_HOST=host.docker.internal 
     --env MONGODB_PORT=27017 
     --env MONGODB_DB=strapi 
     --env INIT_BACKUP=1 
     --env CRON_TIME=null 
     --volume $(pwd)/mongo-backup:/backup 
     mongo_backup:0.1.1
     ```
   - 使用
     运行：`$ ./backupMongoDb`

2. soh-mob-server 之 restoreMongoDb 在从 ./mongo-backup/2020.02.24.183857.gz 恢复 mongo 之后退出
   - script 定义
     ```
     docker run --rm 
     --env MONGODB_HOST=host.docker.internal 
     --env MONGODB_PORT=27017 
     --env MONGODB_DB=strapi 
     --env RESTORE_ONLY=1 
     --volume $(pwd)/mongo-backup:/backup 
     mongo_backup:0.1.1 $1
     ```
   - 使用
     运行：`$ ./restoreMongoDb 2020.02.24.183857.gz`



  


[![Deploy to Tutum](https://s.tutum.co/deploy-to-tutum.svg)](https://dashboard.tutum.co/stack/deploy/)

This image runs mongodump to backup data using cronjob to folder `/backup`

## Usage:

    docker run -d \
        --env MONGODB_HOST=mongodb.host \
        --env MONGODB_PORT=27017 \
        --env MONGODB_USER=admin \
        --env MONGODB_PASS=password \
        --volume host.folder:/backup
        tutum/mongodb-backup

Moreover, if you link `tutum/mongodb-backup` to a mongodb container(e.g. `tutum/mongodb`) with an alias named mongodb, this image will try to auto load the `host`, `port`, `user`, `pass` if possible.

    docker run -d -p 27017:27017 -p 28017:28017 -e MONGODB_PASS="mypass" --name mongodb tutum/mongodb
    docker run -d --link mongodb:mongodb -v host.folder:/backup tutum/mongodb-backup

## Parameters

    MONGODB_HOST    the host/ip of your mongodb database
    MONGODB_PORT    the port number of your mongodb database
    MONGODB_USER    the username of your mongodb database. If MONGODB_USER is empty while MONGODB_PASS is not, the image will use admin as the default username
    MONGODB_PASS    the password of your mongodb database
    MONGODB_DB      the database name to dump. If not specified, it will dump all the databases
    EXTRA_OPTS      the extra options to pass to mongodump command
    CRON_TIME       the interval of cron job to run mongodump. `0 0 * * *` by default, which is every day at 00:00
    MAX_BACKUPS     the number of backups to keep. When reaching the limit, the old backup will be discarded. No limit, by default
    INIT_BACKUP     if set, create a backup when the container launched

## Restore from a backup

See the list of backups, you can run:

    docker exec tutum-backup ls /backup

To restore database from a certain backup, simply run:

    docker exec tutum-backup /restore.sh /backup/2015.08.06.171901
