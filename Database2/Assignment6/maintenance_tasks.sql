/*
	Procedure 
	Use Ola Hallengren Scripts Setup.docx to demonstrate to class how easy it is to setup maintenance tasks and setup jobs utilizing this script

	
	Database Maintenance Tasks typically include:
	
	1. Backup and RECOVERY
	2. Rebuild INDEXES
	3. Clean-up unnessary files e.g. c:\temp
	
	1. Some background information Backup and RECOVERY
	
	Recovery model determines the type of backups allowed to be performed on a DATABASE
	
	To see what recovery model the database is set to...
	
	1. Right mouse click on database, then click on properties,  then click options
	Recovery model: Full, Bulk-Logged, Simple
	
		A. Simple Recovery modle  - full database backup performed, no log backup. Can only recover data based upon last full backup
		B. Full Recovery model  - all backup types options available: full, differential, incremental, and log backups; can recovery 
		to point in time providing backups are complete and good
		
		Backup types
		1. Full - makes a backup of entire database;
		2. Differential - makes a backup of only the changes that occurred since last full backup; backup bit not reset, resulting in larger backup compared to incremental
		3. Incremental - makes a backup of only the changes since the last backup; backup bit reset each time incremental backup performed, resulting in smaller backup FILE
		compared to differential
		
	
	Backup PROCEDURE
	1. perform a full database BACKUP
	2. perform differential or incremental backups on some type of schedule
	e.g. full database backup weekly
	differential backup daily
	incremental hourly
	
	

	
	
 */
 
 /* 
	Instead of going through this process manually, let's leverage an existing maintenance solution
	
	Ola Hallengren
	https://ola.hallengren.com
	
	Supported versions: SQL Server 2008, SQL Server 2008 R2, SQL Server 2012, SQL Server 2014, SQL Server 2016, SQL Server 2017, 
	SQL Server 2019, Azure SQL Database, and Azure SQL Database Managed Instance.
	
	Speaking notes: Explore https://ola.hallengren.com with students.
	
	The sql scripts are available in downloads section.
	
	NOTE: MaintenanceSolution.sql includes sprocs and jobs for all maintenance tasks: backup, integrity checks, index rebuilds
	
	Alternatively, objects can be downloaded in separate scripts:
	
	1. DatabaseBackup.sql 				- sprocs to backup databases
	2. DatabaseIntegrityCheck.sql 		- sproc to check the integrity of databases
	3. IndexOptimize.sql 				- sproc to rebuild and reorganize indexes and update statistics
	4. CommandExecute.sql				- sproc to execute and log commands
	5. CommandLog.sql 					- table to log commands
	6. queue.sql 						- table for processing databases in PARALLEL
	7. QueueDatabase.SQLCODE			- table for processing databases in PARALLEL
	
	CommandExecute is need to run to DatabaseBackup, DatabaseIntegrityCheck and IndexOptimize
	
	
	See ola_scripts_setup.docx
	
	After Ola Hallengren maintenance script run, and jobs configured
	
	Talk about indexes and why their important. Perhaps use PowerPoint for this?
	
	Clustered index - when a PK is created a clustered index is automatically created by database engine
	determines the physically sorting of records on disk
	
	unclustered index - used to complement clustered index and improve performance when querying DATABASE
	
	Basically, an index in simplest terms is something the speeds up data retrieval 
	
	Possible give analogy of using an index back of book is much like a Clustered index ie. it refers you to a page usually by page number
	nonclustered index is additional information that gets the record more quickly e.g. page scan
	
  */