#!/bin/bash

sqlldr userid=APP/APP@//localhost/FREEPDB1 control=data-import.ctl log=data-import.log

sqlldr userid=APP/APP@//localhost/FREEPDB1 control=header-import.ctl log=header-import.log
