USE Demo
GO

/****** Object:  Table dbo.DimDate    Script Date: 2/22/2013 8:54:28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON

GO

CREATE TABLE dbo.DimDate
	(
		 DateID                 INT NOT NULL
		 ,FullDateAlternateKey  DATE NOT NULL
		 ,DayNumberOfWeek       TINYINT NOT NULL
		 ,DayNameOfWeek         VARCHAR(10) NOT NULL
		 ,DayNameAbbreviation   CHAR(3) NOT NULL
		 ,DayNumberOfMonth      TINYINT NOT NULL
		 ,DayNumberOfYear       SMALLINT NOT NULL
		 ,WeekNumberOfYear      TINYINT NOT NULL
		 ,MonthNameFull         VARCHAR(10) NOT NULL
		 ,MonthNameAbbreviation CHAR(3) NOT NULL
		 ,MonthNumberOfYear     TINYINT NOT NULL
		 ,CalendarQuarter       TINYINT NOT NULL
		 ,CalendarYear          SMALLINT NOT NULL
		 ,MonthNumberOfQuarter  TINYINT NOT NULL
		 ,WeekNumberOfQuarter   SMALLINT NOT NULL
		 ,WeekNumberOfMonth     TINYINT NOT NULL
		 ,DayNumberOfQuarter    SMALLINT NOT NULL,
		 CONSTRAINT [PK_DimDate_DateKey] PRIMARY KEY CLUSTERED 
(
	DateID ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [AK_DimDate_FullDateAlternateKey] UNIQUE NONCLUSTERED 
(
	[FullDateAlternateKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO


WITH cteDates
	 AS (SELECT Cast ('2010-01-01' AS DATETIME) Date --Start Date 
		 UNION ALL
		 SELECT Dateadd(dd, 1, Date) --dateadd(mi, 30, Date) --Date + 1 
		 FROM   cteDates
		 WHERE  Dateadd(mi, 30, Date) <= '2013-12-31' --Date + 1 < = '2010-12-31' --End date 
		)
SELECT --Row_Number() OVER (ORDER BY Date) as DateId 
    (Year(Date) - 1900) * 10000 + Month(Date) * 100 + Day(Date) AS datekey
    ,Date                                                       AS FullDateAlternateKey
    ,Datepart (dw, date)                                        AS DayNumberOfWeek
    ,Datename (dw, date)                                        AS DayNameOfWeek
    ,LEFT (Datename (dw, date), 3)                              AS DayNameAbbreviation
    ,Day (date)                                                 AS DayNumberOfMonth
    ,Datepart (dy, date)                                        AS DayNumberOfYear
    ,Datepart (wk, Date)                                        AS WeekNumberOfYear
    ,Datename (mm, date)                                        AS MonthNameFull
    ,Month (date)                                               AS MonthNumberOfYear
    ,LEFT (Datename (mm, date), 3)                              AS MonthNameAbbreviation
    ,Datepart (qq, date)                                        AS CalendarQuarter
    ,Year (date)                                                AS CalendarYear
    ,Datediff(mm, Dateadd(qq, Datediff(qq, 0, date), 0), date)
	   + 1                                                     AS MonthNumberOfQuarter
    ,Datediff(wk, Dateadd(qq, Datediff(qq, 0, date), 0), date)
	   + 1                                                     AS WeekNumberOfQuarter
    ,Datediff(wk, Dateadd(mm, Datediff(mm, 0, date), 0), date)
	   + 1                                                     AS WeekNumberOfMonth
    ,Datediff(dd, Dateadd(qq, Datediff(qq, 0, date), 0), date)
	   + 1                                                     AS DayNumberOfQuarter
FROM   cteDates
OPTION (MAXRECURSION 0); 
