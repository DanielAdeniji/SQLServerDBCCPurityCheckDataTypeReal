use master
go

use [SRPA_DBA_20170305]
go

IF NOT EXISTS 
(
	SELECT * 
	FROM   sys.objects tblSO
	WHERE  tblSO.object_id = object_id('[dbo].[fn_DecimalPlaces]')

)
begin

	exec('create function [dbo].[fn_DecimalPlaces]() returns tinyint as begin return (-1) end ');

end

GO

ALTER FUNCTION [dbo].[fn_DecimalPlaces]
(
	@A float
)
RETURNS int
with schemabinding
AS
BEGIN

	/*
		Topic  :- Count Decimal Places
		Author :- Sergiy
		URL    :- https://www.sqlservercentral.com/Forums/Topic314390-8-1.aspx
	*/
	declare @R int

	IF ( @A IS NULL )
	begin

		RETURN NULL

	end


	set @R = 0

	while @A - str(@A, 18 + @R, @r) <> 0
	begin 

		SET @R = @R + 1

	end

	RETURN @R

END
GO

grant execute on [dbo].[fn_DecimalPlaces] to public
go
