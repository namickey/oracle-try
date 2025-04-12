SET HEADING OFF;          -- カラム名を出力しない
SET FEEDBACK OFF;         -- 実行結果の行数を表示しない
SET COLSEP ',';           -- カラムの区切り文字をカンマに設定
SET LINESIZE 1000;        -- 1行の最大文字数を設定
SET TRIMSPOOL ON;         -- 行末の余分なスペースを削除
SET PAGESIZE 0;           -- ページ区切りを無効化

SPOOL kokyaku.csv;

SELECT KOKYAKU_ID, NAME, JUSHO FROM kokyaku;

SPOOL OFF;

EXIT;