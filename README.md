# Snapshot

A Linux backup utility built on rsync

## Files

### autosnap

Checks the most recent backup and compares to the configuration to determine if it is time to perform another backup.

### ck_snap.sh

Sample script for running autosnap from cron

### mksnapshot

Performs a backup using rsync

### snapshot.config

The configuration file for performing snapshots
