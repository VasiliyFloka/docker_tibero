spool create_database.log
create database "tibero"
user sys identified by tibero
maxinstances 8
maxdatafiles 100
character set UTF8
national character set UTF16
logfile
	group 1 'log001.log' size 100M,
	group 2 'log002.log' size 100M,
	group 3 'log003.log' size 100M
maxloggroups 255
maxlogmembers 8
noarchivelog
	datafile 'system001.dtf' size 100M autoextend on next 100M maxsize unlimited
	default temporary tablespace TEMP
		tempfile 'temp001.dtf' size 100M autoextend on next 100M maxsize unlimited
		extent management local autoallocate
	undo tablespace UNDO
	datafile 'undo001.dtf' size 100M autoextend on next 100M maxsize unlimited
		extent management local autoallocate;
exit;