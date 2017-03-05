use master;
set nocount on; set XACT_ABORT on;

ALTER DATABASE [SRPA_DBA_20170305]
	SET SINGLE_USER
		WITH ROLLBACK IMMEDIATE;
GO

declare @dateBegin datetime
declare @dateDBCCCompleted datetime
declare @dateFullCompletion datetime

declare @strLog nvarchar(4000)
declare @DATE_STYLE int

declare @NUMBER_OF_COLUMNS  int
declare @CHAR_LINEBREAK		varchar(600)
declare @CHAR_HEADER		varchar(600)

set @NUMBER_OF_COLUMNS = 120
set @DATE_STYLE = 100
set @CHAR_LINEBREAK = replicate('=', @NUMBER_OF_COLUMNS)
set @CHAR_HEADER = replicate('*', @NUMBER_OF_COLUMNS)


begin tran

	print @CHAR_HEADER
	set @dateBegin = getdate()

	--set @strLog = 'SQL Server Name :- ' 
	--				+ cast(serverproperty('servername') as sysname)
	--print @strLog

	set @strLog = 'SQL Server Version :- ' 
					+ cast(@@version as sysname)
	print @strLog

	set @strLog = 'Product Level :- ' 
					+ cast(serverproperty('ProductLevel') as sysname)
	print @strLog

	set @strLog = 'Product Version :- ' 
					+ cast(serverproperty('ProductVersion') as sysname)
	print @strLog

	set @strLog = 'Edition :- ' 
					+ cast(serverproperty('edition') as sysname)
	print @strLog

	print @CHAR_HEADER

	set @strLog = 'Date DBCC Began :- ' + convert(varchar(20), @dateBegin, @DATE_STYLE)
	print @strLog

	print @CHAR_LINEBREAK

	DBCC CHECKDB
	(
			[SRPA_DBA_20170305]
		,  REPAIR_REBUILD 
	)
	with
			ALL_ERRORMSGS 
			, no_infomsgs
			, data_purity

	print @CHAR_LINEBREAK

	set @dateDBCCCompleted = getdate()
	set @strLog = 'Date DBCC Completed :- ' + convert(varchar(20), @dateDBCCCompleted, @DATE_STYLE)
	print @strLog

	print @CHAR_LINEBREAK

rollback tran

	set @dateFullCompletion = getdate()
	set @strLog = 'Date Full Completion :- ' + convert(varchar(20), @dateFullCompletion, @DATE_STYLE)
	print @strLog

	print @CHAR_LINEBREAK

go

ALTER DATABASE [SRPA_DBA_20170305]
	SET MULTI_USER
		WITH ROLLBACK IMMEDIATE;
GO


 
