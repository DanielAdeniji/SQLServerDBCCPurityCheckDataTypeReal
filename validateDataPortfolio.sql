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
			'usr_Portfolio_Dirty_Data'
		)

SELECT
		top 15
		  [Holding]
		--, [HoldingTryParse] = TRY_PARSE([Holding] as real) 
		, [HoldingAsFloat] = cast([Holding] as float)
		, [Length] = len([Holding])
		, [NumberofDecimalPlaces]
			= dbo.fn_DecimalPlaces([Holding])

from   [dbo].[usr_Portfolio_Dirty_Data] tblPDD

cross apply [constant].[numberMax] vwCNM

where  (

			  ( [Holding] <> 0.0 )

		/*
			AND 
				(
					    ( [Holding] < CONVERT(real,1.18E-38) OR [Holding] > CONVERT(real,3.40E+38) ) 
					AND ( [Holding] < CONVERT(real,-3.40E+38) OR [Holding] > CONVERT(real,-1.18E-38) )
				)

		*/

			AND 
				(
					(
							  ( [Holding] <  convert(real, [realNumber2Low]) )
						OR    ( [Holding] >  convert(real, [realNumber2High]) )

					)

					AND
					(
							  ( [Holding] <  convert(real, [realNumber1Low]) )
						OR    ( [Holding] >  convert(real, [realNumber1High]) )

					)

				)

	)		

