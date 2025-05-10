#!/bin/bash

sqlplus APP/APP@//localhost/FREEPDB1 @trancate.sql

sqlplus APP/APP@//localhost/FREEPDB1 @transport.sql

sqlplus APP/APP@//localhost/FREEPDB1 @header-spool.sql

sqlplus APP/APP@//localhost/FREEPDB1 @data-spool.sql

sqlplus APP/APP@//localhost/FREEPDB1 @end-spool.sql
