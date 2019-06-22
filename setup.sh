#!/bin/bash

#
# functions
#
function fetch_irr_data {
    cd /var/spool/irr_database
    IFS=,
    for d in $1
    do
        # ex) radb
        db_name=`echo ${d} | sed -r 's/^.+\/(.+)\.db\.gz$/\1/'`
        # ex) radb.db.gz
        file_name=`echo ${d} | sed -r 's/^.+\/(.+?)$/\1/'`

        write_irr_database_config ${db_name}

        # download and unzip db file
        wget "${d}" &> /dev/null
        gzip -d "${file_name}"
    done
}

function use_mounted_irr_data {
    IFS=,
    for d in $1
    do
        write_irr_database_config ${d}
    done
}

function write_irr_database_config {
    # add db name to configuration
    echo "irr_database $1" >> /root/irrd.conf

    # if db name is "ripe", add following line to avoid error
    if [[ "$1" = "ripe" ]]; then
        echo "irr_database ripe filter routing-registry-objects|route6" >> /root/irrd.conf
    fi
}

#
# main
#
if [[ -z "${IRR_PORT}" ]]; then
    IRR_PORT=43
fi

cat > /root/irrd.conf <<EOF
uii_port 5673
debug all /var/log/irrd
irr_directory /var/spool/irr_database
irr_port ${IRR_PORT}
EOF

# if env IRR_FETCH_DB is set, then fetch IRR data from ftp site
if [[ -n "${IRR_FETCH_DB}" ]]; then
    fetch_irr_data ${IRR_FETCH_DB}
else
    if [[ -z "${IRR_DB}" ]]; then
        echo "error: must pass at least one of environments, IRR_DB or IRR_FETCH_DB" 1>&2
        exit 1
    fi
    use_mounted_irr_data ${IRR_DB}
fi

irrd -n -f /root/irrd.conf
