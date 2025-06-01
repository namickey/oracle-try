## 概要

固定長ファイルのレコードを生成する

```shell
docker exec -it oracledb bash
```

## a.py
```python
f = open('a.txt', 'w', newline='\n')

# Header
f.write('120250101                    \n')

# Data
for i in range(1,1000000):
    f.write('2001pen       1'+str(i).rjust(6,'0')+'00000100\n')

# End
f.write('9end                         \n')
```

## 実行  ※1秒程度

```shell
python a.py
```