-- カラム名を出力しない
SET HEADING OFF
-- 実行結果の行数を表示しない
SET FEEDBACK OFF
-- 1行の最大文字数を設定
SET LINESIZE 25
-- 行末の余分なスペースを削除
SET TRIMSPOOL OFF
-- ページ区切りを無効化
SET PAGESIZE 0
-- スクリプト実行中の出力を抑制
SET TERMOUT OFF

SPOOL send-result.txt APPEND;

SELECT 'END' || LPAD(' ',21, ' ') || CHR(13) FROM CHECK_RESULT_SEND where rownum = 1;

SPOOL OFF;

EXIT;