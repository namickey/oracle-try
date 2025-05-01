-- カラム名を出力しない
SET HEADING OFF
-- 実行結果の行数を表示しない
SET FEEDBACK OFF
-- 1行の最大文字数を設定
SET LINESIZE 22
-- 行末の余分なスペースを削除
SET TRIMSPOOL OFF
-- ページ区切りを無効化
SET PAGESIZE 0
-- スクリプト実行中の出力を抑制
SET TERMOUT OFF

SPOOL item.txt APPEND;

SELECT 'aa' || LPAD('',22, ' ') FROM header;

SPOOL OFF;

EXIT;