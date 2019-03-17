# Snapshot

A Linux backup utility built on rsync.

This was created for backing up Linux boxes to a removable hard-drive,
although backing up to a NAS should also work.

This isn't primarily intended for backing up the entire box, rather for
backing up specific directories such as /home and /etc.

In addition to backing up specific directories this also attempts to
backup a list of the software packages that are installed on the box.
Currently deb, rpm, and snap packages are supported.

## Setup

 1. Format a removable drive using ext3, ext4, or some other linux native filesystem.

 2. Give the removable drive an appropriate label such as "Backups"

 3. Place the files/directories for Snapshot in the root of the removable drive.

## Directories and files

 * **autosnap**: Checks the most recent backup and compares to the
 configuration to determine if it is time to perform another backup.

 * **ck_snap.sh**: An experimental/sample script for running autosnap from cron.

 * **lib**: Directory containing common code used by both autosnap and mksnapshot.

 * **mksnapshot**: Performs a backup using rsync.

 * **snapshot.config**: The configuration file for performing snapshots.

## Limitations

 * This does not attempt to follow symlinks. If the symlinked
 file/directory is outside the data that is being backed up then it
 will not be backed up.
