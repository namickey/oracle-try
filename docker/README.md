oracle公式のDockerイメージを使ってDB起動する。

```shell
dockerイメージ作成
git clone https://github.com/oracle/docker-images.git
cd OracleDatabase/SingleInstance/dockerfiles
./buildContainerImage.sh -v 23.6.0 -f
```

```shell
コンテナ起動
docker run -d --name oracledb -p 1521:1521 -e ORACLE_PWD=admin oracle/database:23.6.0-free
```

```shell
全てのユーザにパスワード設定
docker exec -it oracledb bash
bash setPassword.sh admin
```

```shell
SQLPLUSでDB接続(CDBに接続)
docker exec -it oracledb sqlplus / as sysdba

SQLPLUSでDB接続(PDBに接続)
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

