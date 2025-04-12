
## git install
```shell
docker exec -it --user root oracledb bash
dnf update
dnf install git

git clone https://github.com/namickey/oracle-try.git
cd oracle-try
```

## Execute `import.ctl`
```shell
sqlldr userid=APP/APP@database control=import.ctl log=import.log
```

