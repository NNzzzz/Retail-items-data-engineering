SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[country_dim](
	[country_id] [char](2) NOT NULL,
	[c_name] [nvarchar](50) NULL,
	[c_population] [int] NULL,
 CONSTRAINT [PK_country__7E8CD055235F7B66] PRIMARY KEY CLUSTERED 
(
	[country_id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[country_dim](
	[country_id] [char](2) NOT NULL,
	[c_name] [nvarchar](50) NULL,
	[c_population] [int] NULL,
 CONSTRAINT [PK_country__7E8CD055235F7B66] PRIMARY KEY CLUSTERED 
(
	[country_id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[customer_dim](
	[customer_id] [int] IDENTITY(1,1) NOT NULL,
	[customer_number] [int] NULL,
	[name] [nvarchar](50) NULL,
	[city] [nvarchar](100) NULL,
PRIMARY KEY CLUSTERED 
(
	[customer_id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[date_dim](
	[date_id] [int] NOT NULL,
	[year] [int] NULL,
	[month] [int] NULL,
	[day] [int] NULL,
 CONSTRAINT [PK_date_dim_51FC48653D999A8B] PRIMARY KEY CLUSTERED 
(
	[date_id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[fact_sales](
	[countries_id] [char](2) NULL,
	[customers_id] [int] NULL,
	[products_id] [int] NULL,
	[date_id] [int] NULL,
	[order_id] [int] NULL,
	[sales_id] [int] NULL,
	[p_weight] [int] NULL,
	[s_quantity] [int] NULL
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[fact_sales]  WITH CHECK ADD  CONSTRAINT [FK_fact_salecount_76969D2E] FOREIGN KEY([countries_id])
REFERENCES [dbo].[country_dim] ([country_id])
GO

ALTER TABLE [dbo].[fact_sales] CHECK CONSTRAINT [FK_fact_salecount_76969D2E]
GO
ALTER TABLE [dbo].[fact_sales]  WITH CHECK ADD  CONSTRAINT [FK_fact_saledate__797309D9] FOREIGN KEY([date_id])
REFERENCES [dbo].[date_dim] ([date_id])
GO

ALTER TABLE [dbo].[fact_sales] CHECK CONSTRAINT [FK_fact_saledate__797309D9]
GO

ALTER TABLE [dbo].[fact_sales]  WITH CHECK ADD  CONSTRAINT [FK_fact_saleprodu_787EE5A0] FOREIGN KEY([products_id])
REFERENCES [dbo].[product_dim] ([product_id])
GO

ALTER TABLE [dbo].[fact_sales] CHECK CONSTRAINT [FK_fact_saleprodu_787EE5A0]
GO

ALTER TABLE [dbo].[fact_sales]  WITH CHECK ADD  CONSTRAINT [FK_fact_sales_customer_dim] FOREIGN KEY([customers_id])
REFERENCES [dbo].[customer_dim] ([customer_id])
GO

ALTER TABLE [dbo].[fact_sales] CHECK CONSTRAINT [FK_fact_sales_customer_dim]
GO