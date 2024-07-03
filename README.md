# gentoo-overlay-bes

personal portage overlay

## Installing

add the overlay to gentoo:

```
$ emerge app-eselect/eselect-repository
$ eselect repository enable bes
```

update:

```
$ emaint sync -r bes
```

## Atoms

- dev-db/percona-xtrabackup: fix #913649: proc/sysinfo.h: No such file
- sys-cluster/csync2
- SoftEther VPN server (stalled)


