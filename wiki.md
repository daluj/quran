# Saving Data from a Docker Volume

If you're using a named Docker volume (e.g., solr_data), you can back it up and restore it as needed.

**Backing Up a Docker Volume:**

```bash
docker run --rm -v solr_data:/var/solr -v $(pwd):/backup busybox tar cvf /backup/solr_data_backup.tar /var/solr
```

**Restoring from Backup:**
```
docker run --rm -v solr_data:/var/solr -v $(pwd):/backup busybox tar xvf /backup/solr_data_backup.tar -C /
```


# Adjust Permissions on the Host Directory

Change the ownership of the ./solr directory to match the user and group IDs that Solr uses inside the container. Typically, the Solr container runs as the user solr with a UID of 8983 and a GID of 8983.

Run the following commands to set the correct ownership and permissions on your host machine:

```bash
sudo chmod -R 777 ./solr
```

# Verify the UID and GID in the Container

You can verify the user and group IDs inside the container by running:

```bash
docker run --rm solr:latest id
```

This command outputs the UID and GID that the Solr container runs with, allowing you to ensure that the host directory permissions are correctly set.
