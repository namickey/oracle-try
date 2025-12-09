oracle公式のDockerイメージを使ってDB起動する。

## dockerイメージ作成
```shell
git clone https://github.com/oracle/docker-images.git
cd OracleDatabase/SingleInstance/dockerfiles
./buildContainerImage.sh -v 23.6.0 -f
```

## コンテナ起動
```shell
docker run -d --name oracledb -p 1521:1521 -e ORACLE_PWD=admin oracle/database:23.6.0-free
```

## 全てのユーザにパスワード設定
```shell
docker exec -it oracledb bash
bash setPassword.sh admin
```

## SQLPLUSでDB接続(CDBに接続)
```shell
docker exec -it oracledb sqlplus / as sysdba
```

## SQLPLUSでDB接続(PDBに接続)
```shell
docker exec -it oracledb bash
sqlplus system/admin@//localhost/FREEPDB1
```

```sql
接続しているインスタンス名（サービス名）の確認
select instance_name from V$instance;

PDBのインスタンス名（サービス名）の確認
select pdb_name from cdb_pdbs;
```

接続情報
ホスト名：localhost
ポート：1521
ユーザ：system
パスワード：admin
PDBサービス名：FREEPDB1

## APPユーザ作成
```
CREATE USER "APP" IDENTIFIED BY "APP";
ALTER USER "APP" DEFAULT TABLESPACE "USERS" TEMPORARY TABLESPACE "TEMP" ACCOUNT UNLOCK ;
GRANT CREATE SESSION TO "APP";
GRANT UNLIMITED TABLESPACE TO "APP";
GRANT CREATE TABLE TO "APP";
```

## テーブル作成
```
CREATE TABLE KOKYAKU (
    "KOKYAKU_ID"   VARCHAR2(10) NOT NULL,
    "NAME" VARCHAR2(60),
    "JUSHO" VARCHAR2(100),
    "CREATED_AT" DATE,
    CONSTRAINT "KOKYAKU_PK" PRIMARY KEY ( "KOKYAKU_ID" )
);
```


