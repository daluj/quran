FROM solr:8.11.1

ENV SOLR_CORE=quran

# Switch to root user to have the necessary permissions
USER root

# Download the DataImportHandler plugin
RUN mkdir -p /opt/solr/contrib \
    && cd /opt/solr/contrib \
    && wget https://repo1.maven.org/maven2/org/apache/solr/solr-dataimporthandler/8.11.1/solr-dataimporthandler-8.11.1.jar \
    && wget https://repo1.maven.org/maven2/org/apache/solr/solr-dataimporthandler-extras/8.11.1/solr-dataimporthandler-extras-8.11.1.jar \
    && cp solr-dataimporthandler-8.11.1.jar /opt/solr/server/solr-webapp/webapp/WEB-INF/lib/ \
    && cp solr-dataimporthandler-extras-8.11.1.jar /opt/solr/server/solr-webapp/webapp/WEB-INF/lib/

# Copy the entrypoint script into the Docker image
COPY entrypoint.sh /entrypoint.sh

# Copy the Solr configuration files to a temporary location
COPY ./quran /tmp/quran

# Set the entrypoint to the custom script
ENTRYPOINT ["/entrypoint.sh"]

# Expose the Solr port
EXPOSE 8983