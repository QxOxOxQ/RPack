# R Packages
use to download information about R packages

## Setup
1. `bundle`
1. setup db `rake db:setup`

## tasks 
### to refresh package
run one with bellow tasks, that after finish returns report

Logs after run task you can see here
 `tail -f lib/tmp_packages/logfile.log`
 
1. download remote file and refreshes
```bash
rake refresh:from_remote
```
2. from local file (lib/PACKAGES) refreshes
```bash
rake refresh:from_local
```

App refreshes only diffrence with present packages
So only first time it during long time

### Delete outdated packages
outdated records are marked by columns `deleted_at` if you want to delete them use this
```bash
rake refresh:delete_outdated
```
