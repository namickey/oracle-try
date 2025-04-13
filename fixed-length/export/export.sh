#!/bin/bash

# SQL*Plus を実行して SQL ファイルを実行
sqlplus APP/APP@//localhost/FREEPDB1 @data-spool.sql
