#!/bin/bash
set -e

# Create necessary directories for the Solr core, using root privileges
mkdir -p /var/solr/data/${SOLR_CORE}/conf

# Copy configuration files into the Solr core directory
cp -r /tmp/quran/conf/* /var/solr/data/${SOLR_CORE}/conf/

# Change ownership of the core directory to the solr user
chown -R solr:solr /var/solr/data/${SOLR_CORE}

# Pre-create the Solr core as the solr user
gosu solr solr-precreate ${SOLR_CORE} /var/solr/data/${SOLR_CORE}

# Start Solr
exec solr-foreground