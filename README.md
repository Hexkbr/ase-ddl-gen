# ase-ddl-gen
Tiny DDL scripts for Sybase ASE (import/export procedures, tables, triggers, views).

### export.sh
Script for export DDL from Sybase database to text files.
<br/>Format:
```sh
$ export.sh [user] [server] [database name]
```
Usage:
```sh
$ export.sh admin 10.1.100.500:9090 accounts
```

### import.sh
Script for creating structures in the database.
<br/>Format:
```sh
$ import.sh [user] [server] [*source database name] [target database name]
```
Usage:
```sh
$ import.sh admin 10.1.100.500:9090 accounts accounts
```
*Source database name = folder name with already generated ddl.

### Check results
```sql
select type,count(*) 
   from sysobjects 
   where type in ('U','RI','P','TR','V')
         and name not like 'sys%' 
         and name not like 'rs_%'
group by type

```

