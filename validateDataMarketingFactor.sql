use [SRPA_DBA_20170305]
go

select 
		  [object]
				= tblSS.[name]
					+ '.'
					+ tblSO.[name]

		, tblSP.[rows]

from   sys.objects tblSO

inner join  sys.schemas tblSS

		on tblSO.schema_id = tblSS.[schema_id]

inner join sys.indexes tblSI

		on tblSO.object_id = tblSI.object_id

inner join sys.partitions tblSP

		on  tblSI.object_id = tblSP.object_id
		and tblSI.index_id = tblSP.index_id

where  tblSI.[index_id] in (0,1)

and    tblSO.[name] in
		(
			'mkt_FactorData13'
		)

SELECT  top 5 
		  [WSCode]
		, [DataDate]
		, [Value]
		--, [ValueTryParse] = TRY_PARSE([Value] as real) 
		, [ValueAsFloat] = cast([Value] as float)
		, [ValueIsNumeric] = IsNumeric([Value])
		, [Length] = len([Value])
		, [NumberofDecimalPlaces]
			= [master].dbo.fn_DecimalPlaces([Value])

from   [dbo].[mkt_FactorData13] tblMKT

cross apply [constant].[numberMax] vwCNM

where  (

			  ( [Value] <> 0.0 )
			
			/*
				WHERE col2<>0.0 
				AND (col2 < CONVERT(real,1.18E-38) OR col2 > CONVERT(real,3.40E+38)) 
				AND (col2 < CONVERT(real,-3.40E+38) OR col2 > CONVERT(real,-1.18E-38)) 
			*/

			/*
			AND 
				(
					    ( [Value] < CONVERT(real,1.18E-38) OR [Value] > CONVERT(real,3.40E+38) ) 
					AND ( [Value] < CONVERT(real,-3.40E+38) OR [Value] > CONVERT(real,-1.18E-38) )
				)

			*/

			AND 
				(
					(
							  ( [Value] <  [realNumber2Low] )
						OR    ( [Value] >  [realNumber2High] )

					)

					AND
					(
							  ( [Value] <  [realNumber1Low] )
						OR    ( [Value] >  [realNumber1High] )

					)

				)
	)		

