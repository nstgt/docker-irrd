# docker-irrd

Respect https://github.com/irrdnet/irrd


# Build

```
git clone git@github.com:nstgt/docker-irrd.git
cd docker-irrd
docker build --no-cache -t nstgt/irrd:latest .
```

# Usage

## Case.1: Use database on your hosts

Mount a directory to the container and pass `IRR_DB` env to specify which databases you use.

```
mkdir irr_database
wget ftp://ftp.radb.net/radb/dbase/radb.db.gz -P irr_database
wget ftp://ftp.nic.ad.jp/jpirr/jpirr.db.gz -P irr_database/
gzip -d irr_database/*.db.gz

docker run -d -e IRR_DB=radb,jpirr -p 4343:43 -v `pwd`/irr_database:/var/spool/irr_database nstgt/irrd:latest

whois -h localhost -p 4343 AS15169
aut-num:    AS15169
as-name:    Google
descr:      Google, Inc
import:     from AS-ANY   accept ANY AND NOT {0.0.0.0/0}
export:     to AS-ANY   announce AS-GOOGLE AND NOT {0.0.0.0/0}
admin-c:    Google Network Engineering
tech-c:     Google Network Engineering
notify:     noc@google.com
mnt-by:     MAINT-AS15169
changed:    joew@google.com 20040114
changed:    arin-contact@google.com 20070430  #21:54:13(UTC)
source:     RADB
```


## Case.2: Fetch and use fresh database every time

If you want to use fresh databses every time, you need to pass `IRR_FETCH_DB` env with FTP URLs of database, separating with `","`. You can find FTP URLs [here](http://www.irr.net/docs/list.html).

```
docker run -d -e IRR_FETCH_DB=ftp://ftp.nic.ad.jp/jpirr/jpirr.db.gz,ftp://ftp.radb.net/radb/dbase/radb.db.gz -p 4343:43 nstgt/irrd:latest

whois -h localhost -p 4343 AS15169
aut-num:    AS15169
as-name:    Google
descr:      Google, Inc
import:     from AS-ANY   accept ANY AND NOT {0.0.0.0/0}
export:     to AS-ANY   announce AS-GOOGLE AND NOT {0.0.0.0/0}
admin-c:    Google Network Engineering
tech-c:     Google Network Engineering
notify:     noc@google.com
mnt-by:     MAINT-AS15169
changed:    joew@google.com 20040114
changed:    arin-contact@google.com 20070430  #21:54:13(UTC)
source:     RADB
```

## Option
You can specify the port number which is used by IRRD. Pass `IRR_PORT` env.

```
docker run -d -e IRR_FETCH_DB=ftp://ftp.nic.ad.jp/jpirr/jpirr.db.gz,ftp://ftp.radb.net/radb/dbase/radb.db.gz -e IRR_PORT=4343 -p 4343:4343 nstgt/irrd:latest
```