
## git install
```shell
docker exec -it --user root oracledb bash
dnf update
dnf install git
```

## SQLPLUSでDB接続(PDBに接続)
```shell
docker exec -it oracledb bash
git clone https://github.com/namickey/oracle-try.git
cd oracle-try

sqlplus APP/APP@//localhost/FREEPDB1
```

## Execute `import.ctl`
```shell
sqlldr userid=APP/APP@database control=import.ctl log=import.log
```

