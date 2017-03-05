use [master]
go

use [SRPA_DBA_20170305]
go

if schema_id('CONSTANT') is null
begin

	exec('create schema [CONSTANT] authorization [dbo]')

end
go

if object_id('[constant].[numberMax]') is null
begin

	exec('create view [constant].[numberMax] as select [shell] = 1/0 ')

end
go

alter view [constant].[numberMax] 
with schemabinding
as 
	select 

		/*
			real
				a) - 3.40E + 38 to -1.18E - 38
				b) 0 
				c) 1.18E - 38 to 3.40E + 38	
				
				Size
					:- 4 Bytes

		*/
		  [realNumber1Low] 
			= cast(-3.40E+38 as real)
		
		, [realNumber1High] 
			= cast(-1.18E-38 as real)

		, [realNumber2Low] 
			= cast(1.18E-38 as real)

		, [realNumber2High] 
			= cast(3.40E+38 as real)

go

grant select on [constant].[numberMax] to [public]
go