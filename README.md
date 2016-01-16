# bahler-yogy
A web-based resource for orthologous proteins of eukaryotic organisms.

# update yogy

## requirement
```
r-base, mysql, perl
```

1. new mysql user (yogyrw)
```mysql
CREATE USER 'yogyrw'@'localhost' IDENTIFIED BY '[password]'
GRANT ALL PRIVILEGES ON *.* TO 'yogyrw'@'localhost'
```

2. make


Notes:

1. If you don't know the root password of the mysql server,
you can do the following,

```bash
mysqld_safe --skip-grant-tables
use mysql;
update user set password=PASSWORD("NEW-ROOT-PASSWORD") where User='root';
flush privileges;
quit
```
