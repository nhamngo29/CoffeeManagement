USE [master]
GO
/****** Object:  Database [CoffeeManagement]    Script Date: 12/17/2022 1:20:07 AM ******/
CREATE DATABASE [CoffeeManagement]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'CoffeeManagement', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER01\MSSQL\DATA\CoffeeManagement.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'CoffeeManagement_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER01\MSSQL\DATA\CoffeeManagement_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT
GO
ALTER DATABASE [CoffeeManagement] SET COMPATIBILITY_LEVEL = 150
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [CoffeeManagement].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [CoffeeManagement] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [CoffeeManagement] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [CoffeeManagement] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [CoffeeManagement] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [CoffeeManagement] SET ARITHABORT OFF 
GO
ALTER DATABASE [CoffeeManagement] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [CoffeeManagement] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [CoffeeManagement] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [CoffeeManagement] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [CoffeeManagement] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [CoffeeManagement] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [CoffeeManagement] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [CoffeeManagement] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [CoffeeManagement] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [CoffeeManagement] SET  ENABLE_BROKER 
GO
ALTER DATABASE [CoffeeManagement] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [CoffeeManagement] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [CoffeeManagement] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [CoffeeManagement] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [CoffeeManagement] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [CoffeeManagement] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [CoffeeManagement] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [CoffeeManagement] SET RECOVERY FULL 
GO
ALTER DATABASE [CoffeeManagement] SET  MULTI_USER 
GO
ALTER DATABASE [CoffeeManagement] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [CoffeeManagement] SET DB_CHAINING OFF 
GO
ALTER DATABASE [CoffeeManagement] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [CoffeeManagement] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [CoffeeManagement] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [CoffeeManagement] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
EXEC sys.sp_db_vardecimal_storage_format N'CoffeeManagement', N'ON'
GO
ALTER DATABASE [CoffeeManagement] SET QUERY_STORE = OFF
GO
USE [CoffeeManagement]
GO
/****** Object:  UserDefinedFunction [dbo].[FN_GetNumBillByDate]    Script Date: 12/17/2022 1:20:08 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[FN_GetNumBillByDate](@FromDate date,@ToDate date)
RETURNS INT
AS
BEGIN
	DECLARE @COUNT INT=0
	set @COUNT=( SELECT COUNT(*) FROM BILL AS B 
	WHERE CheckIn >=@FromDate AND CheckOut<=@ToDate and B.Status=1)
	RETURN @COUNT
END
GO
/****** Object:  UserDefinedFunction [dbo].[fuConvertToUnsign1]    Script Date: 12/17/2022 1:20:08 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[fuConvertToUnsign1] ( @strInput NVARCHAR(4000) ) RETURNS NVARCHAR(4000)
AS
BEGIN
	IF @strInput IS NULL RETURN @strInput
	IF @strInput = '' RETURN @strInput

	DECLARE @RT NVARCHAR(4000)
	DECLARE @SIGN_CHARS NCHAR(136)
	DECLARE @UNSIGN_CHARS NCHAR (136)

	SET @SIGN_CHARS = N'ăâđêôơưàảãạáằẳẵặắầẩẫậấèẻẽẹéềểễệế ìỉĩịíòỏõọóồổỗộốờởỡợớùủũụúừửữựứỳỷỹỵý ĂÂĐÊÔƠƯÀẢÃẠÁẰẲẴẶẮẦẨẪẬẤÈẺẼẸÉỀỂỄỆẾÌỈĨỊÍ ÒỎÕỌÓỒỔỖỘỐỜỞỠỢỚÙỦŨỤÚỪỬỮỰỨỲỶỸỴÝ' + NCHAR(272)+ NCHAR(208)
	SET @UNSIGN_CHARS = N'aadeoouaaaaaaaaaaaaaaaeeeeeeeeee iiiiiooooooooooooooouuuuuuuuuuyyyyy AADEOOUAAAAAAAAAAAAAAAEEEEEEEEEEIIIII OOOOOOOOOOOOOOOUUUUUUUUUUYYYYYDD'
	
	DECLARE @COUNTER int
	DECLARE @COUNTER1 int
	SET @COUNTER = 1

	WHILE (@COUNTER <= LEN(@strInput))
	BEGIN
		SET @COUNTER1 = 1
		WHILE (@COUNTER1 <= LEN(@SIGN_CHARS) + 1)
			BEGIN
				IF UNICODE(SUBSTRING(@SIGN_CHARS, @COUNTER1,1)) = UNICODE(SUBSTRING(@strInput,@COUNTER ,1) )
				BEGIN
					IF @COUNTER=1
						SET @strInput = SUBSTRING(@UNSIGN_CHARS, @COUNTER1,1) + SUBSTRING(@strInput, @COUNTER+1,LEN(@strInput)-1)
					ELSE
						SET @strInput = SUBSTRING(@strInput, 1, @COUNTER-1) +SUBSTRING(@UNSIGN_CHARS, @COUNTER1,1) + SUBSTRING(@strInput, @COUNTER+1,LEN(@strInput)- @COUNTER)
					BREAK
				END
					SET @COUNTER1 = @COUNTER1 +1
			END
			SET @COUNTER = @COUNTER +1
	END
	SET @strInput = replace(@strInput,' ','-')
	RETURN @strInput
END

GO
/****** Object:  Table [dbo].[Account]    Script Date: 12/17/2022 1:20:08 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Account](
	[UserName] [varchar](100) NOT NULL,
	[DisplayName] [nvarchar](100) NOT NULL,
	[Password] [varchar](500) NOT NULL,
	[TypeID] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[UserName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AccountType]    Script Date: 12/17/2022 1:20:08 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AccountType](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[TypeName] [nvarchar](50) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Bill]    Script Date: 12/17/2022 1:20:08 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Bill](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[CheckIn] [date] NOT NULL,
	[CheckOut] [date] NULL,
	[TableID] [int] NOT NULL,
	[Discount] [int] NOT NULL,
	[TotalPrice] [int] NULL,
	[Status] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[BillInfo]    Script Date: 12/17/2022 1:20:08 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BillInfo](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[BillID] [int] NOT NULL,
	[FoodID] [int] NOT NULL,
	[Amount] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CategoryFood]    Script Date: 12/17/2022 1:20:08 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CategoryFood](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](100) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[discount]    Script Date: 12/17/2022 1:20:08 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[discount](
	[ID] [varchar](10) NOT NULL,
	[NumPercent] [int] NULL,
	[Quantity] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Food]    Script Date: 12/17/2022 1:20:08 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Food](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](100) NOT NULL,
	[Type] [int] NOT NULL,
	[Price] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TableCoffee]    Script Date: 12/17/2022 1:20:08 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TableCoffee](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](100) NOT NULL,
	[Status] [nvarchar](100) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TypeFood]    Script Date: 12/17/2022 1:20:08 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TypeFood](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](100) NOT NULL,
	[IdCategory] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
INSERT [dbo].[Account] ([UserName], [DisplayName], [Password], [TypeID]) VALUES (N'admin', N'Người quản lý', N'21232F297A57A5A743894A0E4A801FC3', 1)
INSERT [dbo].[Account] ([UserName], [DisplayName], [Password], [TypeID]) VALUES (N'nhamngoo29', N'Nguyễn Nhâm Ngọ', N'CAF1A3DFB505FFED0D024130F58C5CFA', 2)
INSERT [dbo].[Account] ([UserName], [DisplayName], [Password], [TypeID]) VALUES (N'Phuong', N'phuong', N'0', 2)
GO
SET IDENTITY_INSERT [dbo].[AccountType] ON 

INSERT [dbo].[AccountType] ([ID], [TypeName]) VALUES (1, N'Quản lý')
INSERT [dbo].[AccountType] ([ID], [TypeName]) VALUES (2, N'Nhân viên')
SET IDENTITY_INSERT [dbo].[AccountType] OFF
GO
SET IDENTITY_INSERT [dbo].[Bill] ON 

INSERT [dbo].[Bill] ([ID], [CheckIn], [CheckOut], [TableID], [Discount], [TotalPrice], [Status]) VALUES (1, CAST(N'2022-12-07' AS Date), CAST(N'2022-12-07' AS Date), 21, 0, 50000, 1)
INSERT [dbo].[Bill] ([ID], [CheckIn], [CheckOut], [TableID], [Discount], [TotalPrice], [Status]) VALUES (2, CAST(N'2022-12-07' AS Date), CAST(N'2022-12-07' AS Date), 28, 0, 50000, 1)
INSERT [dbo].[Bill] ([ID], [CheckIn], [CheckOut], [TableID], [Discount], [TotalPrice], [Status]) VALUES (3, CAST(N'2022-12-08' AS Date), CAST(N'2022-12-08' AS Date), 23, 0, 35000, 1)
INSERT [dbo].[Bill] ([ID], [CheckIn], [CheckOut], [TableID], [Discount], [TotalPrice], [Status]) VALUES (4, CAST(N'2022-12-08' AS Date), CAST(N'2022-12-08' AS Date), 23, 0, 25000, 1)
INSERT [dbo].[Bill] ([ID], [CheckIn], [CheckOut], [TableID], [Discount], [TotalPrice], [Status]) VALUES (6, CAST(N'2022-12-08' AS Date), CAST(N'2022-12-08' AS Date), 22, 0, 25000, 1)
INSERT [dbo].[Bill] ([ID], [CheckIn], [CheckOut], [TableID], [Discount], [TotalPrice], [Status]) VALUES (7, CAST(N'2022-12-08' AS Date), CAST(N'2022-12-08' AS Date), 21, 0, 94000, 1)
INSERT [dbo].[Bill] ([ID], [CheckIn], [CheckOut], [TableID], [Discount], [TotalPrice], [Status]) VALUES (8, CAST(N'2022-12-08' AS Date), CAST(N'2022-12-08' AS Date), 22, 0, 318000, 1)
INSERT [dbo].[Bill] ([ID], [CheckIn], [CheckOut], [TableID], [Discount], [TotalPrice], [Status]) VALUES (9, CAST(N'2022-12-08' AS Date), CAST(N'2022-12-08' AS Date), 23, 0, 0, 0)
INSERT [dbo].[Bill] ([ID], [CheckIn], [CheckOut], [TableID], [Discount], [TotalPrice], [Status]) VALUES (11, CAST(N'2022-12-08' AS Date), CAST(N'2022-12-08' AS Date), 6, 0, 0, 0)
INSERT [dbo].[Bill] ([ID], [CheckIn], [CheckOut], [TableID], [Discount], [TotalPrice], [Status]) VALUES (12, CAST(N'2022-12-08' AS Date), CAST(N'2022-12-10' AS Date), 1, 0, 275000, 1)
INSERT [dbo].[Bill] ([ID], [CheckIn], [CheckOut], [TableID], [Discount], [TotalPrice], [Status]) VALUES (13, CAST(N'2022-12-08' AS Date), CAST(N'2022-12-08' AS Date), 20, 0, 0, 0)
INSERT [dbo].[Bill] ([ID], [CheckIn], [CheckOut], [TableID], [Discount], [TotalPrice], [Status]) VALUES (14, CAST(N'2022-12-09' AS Date), CAST(N'2022-12-10' AS Date), 2, 0, 25000, 1)
INSERT [dbo].[Bill] ([ID], [CheckIn], [CheckOut], [TableID], [Discount], [TotalPrice], [Status]) VALUES (15, CAST(N'2022-12-10' AS Date), CAST(N'2022-12-10' AS Date), 3, 0, 25000, 1)
INSERT [dbo].[Bill] ([ID], [CheckIn], [CheckOut], [TableID], [Discount], [TotalPrice], [Status]) VALUES (16, CAST(N'2022-12-10' AS Date), CAST(N'2022-12-10' AS Date), 25, 0, 35000, 1)
INSERT [dbo].[Bill] ([ID], [CheckIn], [CheckOut], [TableID], [Discount], [TotalPrice], [Status]) VALUES (17, CAST(N'2022-12-10' AS Date), CAST(N'2022-12-10' AS Date), 26, 0, 35000, 1)
INSERT [dbo].[Bill] ([ID], [CheckIn], [CheckOut], [TableID], [Discount], [TotalPrice], [Status]) VALUES (18, CAST(N'2022-12-10' AS Date), CAST(N'2022-12-10' AS Date), 22, 0, 25000, 1)
INSERT [dbo].[Bill] ([ID], [CheckIn], [CheckOut], [TableID], [Discount], [TotalPrice], [Status]) VALUES (19, CAST(N'2022-12-10' AS Date), CAST(N'2022-12-10' AS Date), 4, 0, 25000, 1)
INSERT [dbo].[Bill] ([ID], [CheckIn], [CheckOut], [TableID], [Discount], [TotalPrice], [Status]) VALUES (20, CAST(N'2022-12-12' AS Date), CAST(N'2022-12-12' AS Date), 1, 0, 25000, 1)
INSERT [dbo].[Bill] ([ID], [CheckIn], [CheckOut], [TableID], [Discount], [TotalPrice], [Status]) VALUES (21, CAST(N'2022-12-14' AS Date), CAST(N'2022-12-14' AS Date), 5, 0, 25000, 1)
INSERT [dbo].[Bill] ([ID], [CheckIn], [CheckOut], [TableID], [Discount], [TotalPrice], [Status]) VALUES (22, CAST(N'2022-12-14' AS Date), CAST(N'2022-12-14' AS Date), 30, 1, 34650, 1)
INSERT [dbo].[Bill] ([ID], [CheckIn], [CheckOut], [TableID], [Discount], [TotalPrice], [Status]) VALUES (23, CAST(N'2022-12-14' AS Date), CAST(N'2022-12-14' AS Date), 25, 0, 60000, 1)
INSERT [dbo].[Bill] ([ID], [CheckIn], [CheckOut], [TableID], [Discount], [TotalPrice], [Status]) VALUES (24, CAST(N'2022-12-14' AS Date), CAST(N'2022-12-14' AS Date), 1, 30, 17500, 1)
INSERT [dbo].[Bill] ([ID], [CheckIn], [CheckOut], [TableID], [Discount], [TotalPrice], [Status]) VALUES (25, CAST(N'2022-12-17' AS Date), CAST(N'2022-12-17' AS Date), 24, 0, 35000, 1)
SET IDENTITY_INSERT [dbo].[Bill] OFF
GO
SET IDENTITY_INSERT [dbo].[BillInfo] ON 

INSERT [dbo].[BillInfo] ([ID], [BillID], [FoodID], [Amount]) VALUES (1, 3, 19, 1)
INSERT [dbo].[BillInfo] ([ID], [BillID], [FoodID], [Amount]) VALUES (2, 2, 27, 2)
INSERT [dbo].[BillInfo] ([ID], [BillID], [FoodID], [Amount]) VALUES (7, 8, 27, 1)
INSERT [dbo].[BillInfo] ([ID], [BillID], [FoodID], [Amount]) VALUES (8, 8, 28, 1)
INSERT [dbo].[BillInfo] ([ID], [BillID], [FoodID], [Amount]) VALUES (9, 8, 27, 1)
INSERT [dbo].[BillInfo] ([ID], [BillID], [FoodID], [Amount]) VALUES (10, 1, 27, 1)
INSERT [dbo].[BillInfo] ([ID], [BillID], [FoodID], [Amount]) VALUES (11, 1, 28, 1)
INSERT [dbo].[BillInfo] ([ID], [BillID], [FoodID], [Amount]) VALUES (13, 7, 16, 1)
INSERT [dbo].[BillInfo] ([ID], [BillID], [FoodID], [Amount]) VALUES (14, 8, 18, 1)
INSERT [dbo].[BillInfo] ([ID], [BillID], [FoodID], [Amount]) VALUES (15, 7, 20, 1)
INSERT [dbo].[BillInfo] ([ID], [BillID], [FoodID], [Amount]) VALUES (16, 8, 30, 2)
INSERT [dbo].[BillInfo] ([ID], [BillID], [FoodID], [Amount]) VALUES (17, 8, 23, 1)
INSERT [dbo].[BillInfo] ([ID], [BillID], [FoodID], [Amount]) VALUES (18, 8, 20, 1)
INSERT [dbo].[BillInfo] ([ID], [BillID], [FoodID], [Amount]) VALUES (21, 12, 27, 1)
INSERT [dbo].[BillInfo] ([ID], [BillID], [FoodID], [Amount]) VALUES (22, 12, 28, 1)
INSERT [dbo].[BillInfo] ([ID], [BillID], [FoodID], [Amount]) VALUES (25, 12, 30, 1)
INSERT [dbo].[BillInfo] ([ID], [BillID], [FoodID], [Amount]) VALUES (26, 12, 30, 1)
INSERT [dbo].[BillInfo] ([ID], [BillID], [FoodID], [Amount]) VALUES (27, 12, 27, 1)
INSERT [dbo].[BillInfo] ([ID], [BillID], [FoodID], [Amount]) VALUES (28, 14, 27, 1)
INSERT [dbo].[BillInfo] ([ID], [BillID], [FoodID], [Amount]) VALUES (29, 15, 27, 1)
INSERT [dbo].[BillInfo] ([ID], [BillID], [FoodID], [Amount]) VALUES (30, 16, 29, 1)
INSERT [dbo].[BillInfo] ([ID], [BillID], [FoodID], [Amount]) VALUES (31, 17, 29, 1)
INSERT [dbo].[BillInfo] ([ID], [BillID], [FoodID], [Amount]) VALUES (32, 18, 28, 1)
INSERT [dbo].[BillInfo] ([ID], [BillID], [FoodID], [Amount]) VALUES (33, 19, 27, 1)
INSERT [dbo].[BillInfo] ([ID], [BillID], [FoodID], [Amount]) VALUES (34, 20, 27, 1)
INSERT [dbo].[BillInfo] ([ID], [BillID], [FoodID], [Amount]) VALUES (35, 21, 27, 1)
INSERT [dbo].[BillInfo] ([ID], [BillID], [FoodID], [Amount]) VALUES (36, 22, 16, 1)
INSERT [dbo].[BillInfo] ([ID], [BillID], [FoodID], [Amount]) VALUES (38, 23, 28, 1)
INSERT [dbo].[BillInfo] ([ID], [BillID], [FoodID], [Amount]) VALUES (39, 23, 16, 1)
INSERT [dbo].[BillInfo] ([ID], [BillID], [FoodID], [Amount]) VALUES (40, 24, 27, 1)
INSERT [dbo].[BillInfo] ([ID], [BillID], [FoodID], [Amount]) VALUES (41, 25, 16, 1)
SET IDENTITY_INSERT [dbo].[BillInfo] OFF
GO
SET IDENTITY_INSERT [dbo].[CategoryFood] ON 

INSERT [dbo].[CategoryFood] ([ID], [Name]) VALUES (1, N'Đồ ăn')
INSERT [dbo].[CategoryFood] ([ID], [Name]) VALUES (2, N'Đồ uống')
INSERT [dbo].[CategoryFood] ([ID], [Name]) VALUES (3, N'Khác')
SET IDENTITY_INSERT [dbo].[CategoryFood] OFF
GO
INSERT [dbo].[discount] ([ID], [NumPercent], [Quantity]) VALUES (N'08A5E8', 30, -10)
INSERT [dbo].[discount] ([ID], [NumPercent], [Quantity]) VALUES (N'0FCD56', 30, 1)
INSERT [dbo].[discount] ([ID], [NumPercent], [Quantity]) VALUES (N'25D504', 30, 5)
INSERT [dbo].[discount] ([ID], [NumPercent], [Quantity]) VALUES (N'2B1E5B', 30, 5)
INSERT [dbo].[discount] ([ID], [NumPercent], [Quantity]) VALUES (N'43F469', 30, 5)
INSERT [dbo].[discount] ([ID], [NumPercent], [Quantity]) VALUES (N'44BA50', 30, 5)
INSERT [dbo].[discount] ([ID], [NumPercent], [Quantity]) VALUES (N'6C71DE', 30, 5)
INSERT [dbo].[discount] ([ID], [NumPercent], [Quantity]) VALUES (N'909A66', 30, 5)
INSERT [dbo].[discount] ([ID], [NumPercent], [Quantity]) VALUES (N'A44736', 30, 5)
INSERT [dbo].[discount] ([ID], [NumPercent], [Quantity]) VALUES (N'AC55C2', 30, 5)
INSERT [dbo].[discount] ([ID], [NumPercent], [Quantity]) VALUES (N'CC250A', 30, 5)
INSERT [dbo].[discount] ([ID], [NumPercent], [Quantity]) VALUES (N'D37A97', 50, 5)
GO
SET IDENTITY_INSERT [dbo].[Food] ON 

INSERT [dbo].[Food] ([ID], [Name], [Type], [Price]) VALUES (16, N'PHIN Sữa Đá', 1, 35000)
INSERT [dbo].[Food] ([ID], [Name], [Type], [Price]) VALUES (17, N'Phin Đen Đá', 1, 35000)
INSERT [dbo].[Food] ([ID], [Name], [Type], [Price]) VALUES (18, N'Bạc Xỉu Đá', 1, 35000)
INSERT [dbo].[Food] ([ID], [Name], [Type], [Price]) VALUES (19, N'Cà Phê Espresso', 1, 35000)
INSERT [dbo].[Food] ([ID], [Name], [Type], [Price]) VALUES (20, N'Freeze Trà Xanh', 2, 59000)
INSERT [dbo].[Food] ([ID], [Name], [Type], [Price]) VALUES (21, N'Freeze Sô-cô-la', 2, 59000)
INSERT [dbo].[Food] ([ID], [Name], [Type], [Price]) VALUES (22, N'Trà Sen Vàng', 3, 49000)
INSERT [dbo].[Food] ([ID], [Name], [Type], [Price]) VALUES (23, N'Trà Thạch Đào', 3, 49000)
INSERT [dbo].[Food] ([ID], [Name], [Type], [Price]) VALUES (24, N'Trà Thanh Đào', 3, 49000)
INSERT [dbo].[Food] ([ID], [Name], [Type], [Price]) VALUES (25, N'Trà Thạch Vải', 3, 49000)
INSERT [dbo].[Food] ([ID], [Name], [Type], [Price]) VALUES (26, N'Trà Đào Cam Sả', 3, 49000)
INSERT [dbo].[Food] ([ID], [Name], [Type], [Price]) VALUES (27, N'Bánh Ngọt', 4, 25000)
INSERT [dbo].[Food] ([ID], [Name], [Type], [Price]) VALUES (28, N'Bánh Mì Pate', 4, 25000)
INSERT [dbo].[Food] ([ID], [Name], [Type], [Price]) VALUES (29, N'Bánh Mì Ốp La', 4, 35000)
INSERT [dbo].[Food] ([ID], [Name], [Type], [Price]) VALUES (30, N'Cà Phê Đóng Gói', 5, 100000)
INSERT [dbo].[Food] ([ID], [Name], [Type], [Price]) VALUES (31, N'Merchandise', 5, 100000)
INSERT [dbo].[Food] ([ID], [Name], [Type], [Price]) VALUES (32, N'Cà phê trồn', 1, 230000)
INSERT [dbo].[Food] ([ID], [Name], [Type], [Price]) VALUES (34, N'32', 2, 32)
INSERT [dbo].[Food] ([ID], [Name], [Type], [Price]) VALUES (35, N'3', 1, 3232)
INSERT [dbo].[Food] ([ID], [Name], [Type], [Price]) VALUES (36, N'321', 1, 32)
SET IDENTITY_INSERT [dbo].[Food] OFF
GO
SET IDENTITY_INSERT [dbo].[TableCoffee] ON 

INSERT [dbo].[TableCoffee] ([ID], [Name], [Status]) VALUES (1, N'Bàn 1', N'Trống')
INSERT [dbo].[TableCoffee] ([ID], [Name], [Status]) VALUES (2, N'Bàn 2', N'Trống')
INSERT [dbo].[TableCoffee] ([ID], [Name], [Status]) VALUES (3, N'Bàn 3', N'Trống')
INSERT [dbo].[TableCoffee] ([ID], [Name], [Status]) VALUES (4, N'Bàn 4', N'Trống')
INSERT [dbo].[TableCoffee] ([ID], [Name], [Status]) VALUES (5, N'Bàn 5', N'Trống')
INSERT [dbo].[TableCoffee] ([ID], [Name], [Status]) VALUES (6, N'Bàn 6', N'Trống')
INSERT [dbo].[TableCoffee] ([ID], [Name], [Status]) VALUES (7, N'Bàn 7', N'Trống')
INSERT [dbo].[TableCoffee] ([ID], [Name], [Status]) VALUES (8, N'Bàn 8', N'Trống')
INSERT [dbo].[TableCoffee] ([ID], [Name], [Status]) VALUES (9, N'Bàn 9', N'Trống')
INSERT [dbo].[TableCoffee] ([ID], [Name], [Status]) VALUES (10, N'Bàn 10', N'Trống')
INSERT [dbo].[TableCoffee] ([ID], [Name], [Status]) VALUES (11, N'Bàn 11', N'Trống')
INSERT [dbo].[TableCoffee] ([ID], [Name], [Status]) VALUES (12, N'Bàn 12', N'Trống')
INSERT [dbo].[TableCoffee] ([ID], [Name], [Status]) VALUES (13, N'Bàn 13', N'Trống')
INSERT [dbo].[TableCoffee] ([ID], [Name], [Status]) VALUES (14, N'Bàn 14', N'Trống')
INSERT [dbo].[TableCoffee] ([ID], [Name], [Status]) VALUES (15, N'Bàn 15', N'Trống')
INSERT [dbo].[TableCoffee] ([ID], [Name], [Status]) VALUES (16, N'Bàn 16', N'Trống')
INSERT [dbo].[TableCoffee] ([ID], [Name], [Status]) VALUES (17, N'Bàn 17', N'Trống')
INSERT [dbo].[TableCoffee] ([ID], [Name], [Status]) VALUES (18, N'Bàn 18', N'Trống')
INSERT [dbo].[TableCoffee] ([ID], [Name], [Status]) VALUES (19, N'Bàn 19', N'Trống')
INSERT [dbo].[TableCoffee] ([ID], [Name], [Status]) VALUES (20, N'Bàn 20', N'Trống')
INSERT [dbo].[TableCoffee] ([ID], [Name], [Status]) VALUES (21, N'Bàn 21', N'Trống')
INSERT [dbo].[TableCoffee] ([ID], [Name], [Status]) VALUES (22, N'Bàn 22', N'Trống')
INSERT [dbo].[TableCoffee] ([ID], [Name], [Status]) VALUES (23, N'Bàn 23', N'Trống')
INSERT [dbo].[TableCoffee] ([ID], [Name], [Status]) VALUES (24, N'Bàn 24', N'Trống')
INSERT [dbo].[TableCoffee] ([ID], [Name], [Status]) VALUES (25, N'Bàn 25', N'Trống')
INSERT [dbo].[TableCoffee] ([ID], [Name], [Status]) VALUES (26, N'Bàn 26', N'Trống')
INSERT [dbo].[TableCoffee] ([ID], [Name], [Status]) VALUES (27, N'Bàn 27', N'Trống')
INSERT [dbo].[TableCoffee] ([ID], [Name], [Status]) VALUES (28, N'Bàn 28', N'Trống')
INSERT [dbo].[TableCoffee] ([ID], [Name], [Status]) VALUES (29, N'Bàn 29', N'Trống')
INSERT [dbo].[TableCoffee] ([ID], [Name], [Status]) VALUES (30, N'Bàn 30', N'Trống')
SET IDENTITY_INSERT [dbo].[TableCoffee] OFF
GO
SET IDENTITY_INSERT [dbo].[TypeFood] ON 

INSERT [dbo].[TypeFood] ([Id], [Name], [IdCategory]) VALUES (1, N'Cà phê', 2)
INSERT [dbo].[TypeFood] ([Id], [Name], [IdCategory]) VALUES (2, N'Freeze', 2)
INSERT [dbo].[TypeFood] ([Id], [Name], [IdCategory]) VALUES (3, N'Trà', 2)
INSERT [dbo].[TypeFood] ([Id], [Name], [IdCategory]) VALUES (4, N'Bánh', 1)
INSERT [dbo].[TypeFood] ([Id], [Name], [IdCategory]) VALUES (5, N'Khác', 3)
SET IDENTITY_INSERT [dbo].[TypeFood] OFF
GO
ALTER TABLE [dbo].[Account] ADD  DEFAULT (N'Name') FOR [DisplayName]
GO
ALTER TABLE [dbo].[Account] ADD  DEFAULT ((0)) FOR [Password]
GO
ALTER TABLE [dbo].[Bill] ADD  DEFAULT (getdate()) FOR [CheckIn]
GO
ALTER TABLE [dbo].[Bill] ADD  DEFAULT ((0)) FOR [Discount]
GO
ALTER TABLE [dbo].[Bill] ADD  DEFAULT ((0)) FOR [TotalPrice]
GO
ALTER TABLE [dbo].[Bill] ADD  DEFAULT ((0)) FOR [Status]
GO
ALTER TABLE [dbo].[BillInfo] ADD  DEFAULT ((0)) FOR [Amount]
GO
ALTER TABLE [dbo].[CategoryFood] ADD  DEFAULT (N'Chưa đặt tên') FOR [Name]
GO
ALTER TABLE [dbo].[Food] ADD  DEFAULT (N'Chưa đặt tên') FOR [Name]
GO
ALTER TABLE [dbo].[Food] ADD  DEFAULT ((0)) FOR [Price]
GO
ALTER TABLE [dbo].[TableCoffee] ADD  DEFAULT (N'Chưa đặt tên') FOR [Name]
GO
ALTER TABLE [dbo].[TableCoffee] ADD  DEFAULT (N'Trống') FOR [Status]
GO
ALTER TABLE [dbo].[TypeFood] ADD  DEFAULT (N'Chưa đặt tên') FOR [Name]
GO
ALTER TABLE [dbo].[Account]  WITH CHECK ADD FOREIGN KEY([TypeID])
REFERENCES [dbo].[AccountType] ([ID])
GO
ALTER TABLE [dbo].[Bill]  WITH CHECK ADD FOREIGN KEY([TableID])
REFERENCES [dbo].[TableCoffee] ([ID])
GO
ALTER TABLE [dbo].[BillInfo]  WITH CHECK ADD FOREIGN KEY([BillID])
REFERENCES [dbo].[Bill] ([ID])
GO
ALTER TABLE [dbo].[BillInfo]  WITH CHECK ADD FOREIGN KEY([FoodID])
REFERENCES [dbo].[Food] ([ID])
GO
ALTER TABLE [dbo].[Food]  WITH CHECK ADD  CONSTRAINT [FK_Food_Type] FOREIGN KEY([Type])
REFERENCES [dbo].[TypeFood] ([Id])
GO
ALTER TABLE [dbo].[Food] CHECK CONSTRAINT [FK_Food_Type]
GO
ALTER TABLE [dbo].[TypeFood]  WITH CHECK ADD FOREIGN KEY([IdCategory])
REFERENCES [dbo].[CategoryFood] ([ID])
GO
/****** Object:  StoredProcedure [dbo].[GetNumBillByDate]    Script Date: 12/17/2022 1:20:08 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[GetNumBillByDate] @FromDate date,@ToDate date
AS
BEGIN
SELECT COUNT(*) FROM BILL AS B 
	WHERE CheckIn >=@FromDate AND CheckOut<=@ToDate and B.Status=1
END
GO
/****** Object:  StoredProcedure [dbo].[GetUnCheckBillIDByTableID]    Script Date: 12/17/2022 1:20:08 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[GetUnCheckBillIDByTableID]
@TableID INT
AS
	SELECT * FROM dbo.Bill WHERE TableID = @TableID AND Status = 0

GO
/****** Object:  StoredProcedure [dbo].[SP_BillardTable]    Script Date: 12/17/2022 1:20:08 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_BillardTable] @TableID1 INT, @TableID2 INT
AS
BEGIN
	DECLARE @isTable1Null INT = 0
	DECLARE @isTable2Null INT = 0
	SELECT @isTable1Null = ID FROM dbo.Bill WHERE TableID = @TableID1 AND Status = 0
	SELECT @isTable2Null = ID FROM dbo.Bill WHERE TableID = @TableID2 AND Status = 0
	print(@isTable1Null)
	print(@isTable2Null)
	IF (@isTable1Null = 0 AND @isTable2Null > 0)
		BEGIN
			UPDATE dbo.Bill SET TableID = @TableID1 WHERE ID = @isTable2Null
			UPDATE dbo.TableCoffee SET Status = N'Có người' WHERE ID = @TableID1
			UPDATE dbo.TableCoffee SET Status = N'Trống' WHERE ID = @TableID2
        END
	ELSE IF (@isTable1Null > 0 AND @isTable2Null = 0)
		BEGIN
			print(N'Vô trong bản có trống từ bàn có người')
			UPDATE dbo.Bill SET TableID = @TableID2 WHERE Status = 0 AND ID = @isTable1Null
			UPDATE dbo.TableCoffee SET Status = N'Có người' WHERE ID = @TableID2
			UPDATE dbo.TableCoffee SET Status = N'Trống' WHERE ID = @TableID1
        END
    ELSE IF (@isTable1Null > 0 AND @isTable2Null > 0)
		BEGIN
			SELECT ID INTO IDBillInfoTable FROM BillInfo WHERE BillID=@isTable1Null
			--select * from IDBillInfoTable
			UPDATE BillInfo SET BillID=@isTable2Null WHERE ID IN(SELECT * FROM IDBillInfoTable)
			UPDATE dbo.TableCoffee SET Status = N'Có người' WHERE ID = @TableID2
			UPDATE dbo.TableCoffee SET Status = N'Trống' WHERE ID = @TableID1
			DROP table IDBillInfoTable
        END
END
GO
/****** Object:  StoredProcedure [dbo].[SP_CheckOut]    Script Date: 12/17/2022 1:20:08 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_CheckOut]
@ID INT, @Discount INT, @TotalPrice INT
AS
	UPDATE dbo.Bill SET Status = 1, Discount = @Discount, TotalPrice = @TotalPrice,CheckOut=GETDATE() WHERE ID = @ID
GO
/****** Object:  StoredProcedure [dbo].[SP_DeleteAccount]    Script Date: 12/17/2022 1:20:08 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_DeleteAccount]
@UserName VARCHAR(100)
AS
	DELETE dbo.Account WHERE UserName = @UserName

GO
/****** Object:  StoredProcedure [dbo].[SP_DeleteBill]    Script Date: 12/17/2022 1:20:08 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_DeleteBill]
@ID INT
AS
	DELETE dbo.Bill WHERE ID = @ID

GO
/****** Object:  StoredProcedure [dbo].[SP_DeleteBillInfoByBillID]    Script Date: 12/17/2022 1:20:08 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_DeleteBillInfoByBillID]
@BillID INT
AS
	DELETE dbo.BillInfo WHERE BillID = @BillID

GO
/****** Object:  StoredProcedure [dbo].[SP_DeleteCategory]    Script Date: 12/17/2022 1:20:08 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[SP_DeleteCategory]
@ID int
as
begin
	declare @FoodCount int = 0
	select @FoodCount = COUNT(*) from Food where Type = @ID

	if (@FoodCount = 0)
		delete CategoryFood where ID = @ID
end

GO
/****** Object:  StoredProcedure [dbo].[SP_DeleteFood]    Script Date: 12/17/2022 1:20:08 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_DeleteFood]
@FoodID INT
AS
BEGIN
	DECLARE @BillIDCount INT = 0
	SELECT @BillIDCount = COUNT(*) FROM Bill AS b, BillInfo AS bi WHERE FoodID = @FoodID AND b.ID = bi.BillID AND b.Status = 0

	IF (@BillIDCount = 0)
	BEGIN
		DELETE BillInfo WHERE FoodID = @FoodID
		DELETE Food WHERE ID = @FoodID
	END
END

GO
/****** Object:  StoredProcedure [dbo].[SP_DeleteFoodByIdBill]    Script Date: 12/17/2022 1:20:08 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_DeleteFoodByIdBill] @BillID INT,@FoodName nvarchar(100),@Count INT 
AS
BEGIN
	declare @isExistBillInfo int,@foodAmount int = 1,@FoodId int
	select @isExistBillInfo = BillInfo.ID, @foodAmount = Amount,@FoodId=BillInfo.FoodID
	from BillInfo,Food
	where BillID = @BillID and FoodID = Food.ID and Food.Name=@FoodName 
	if (@isExistBillInfo > 0)
	begin
		declare @newAmount int = @foodAmount - @Count
		if (@newAmount > 0)
				update BillInfo set Amount = @newAmount where FoodID = @FoodID and BillID=@BillID
		ELSE IF (@newAmount <= 0)
			delete BillInfo where BillID = @BillID and FoodID = @FoodID
	end
END
GO
/****** Object:  StoredProcedure [dbo].[SP_DeleteTableFood]    Script Date: 12/17/2022 1:20:08 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[SP_DeleteTableFood]
@ID int
as begin
	declare @count int = 0
	select @count = COUNT(*) from TableCoffee where ID = @ID and Status = N'Trống'

	if (@count <> 0)
	begin
		declare @BillID int
		select @BillID = b.ID from Bill as b, TableCoffee as t where b.TableID = t.ID

		delete BillInfo where BillID = @BillID
		delete Bill where ID = @BillID
		delete TableCoffee where ID = @ID
	end
end

GO
/****** Object:  StoredProcedure [dbo].[SP_DeleteTypeFood]    Script Date: 12/17/2022 1:20:08 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_DeleteTypeFood]
@TypeFoodId INT
AS
BEGIN
	DECLARE @BillIDCount INT = 0,@FoodID int
	SELECT @BillIDCount = COUNT(*),@FoodID=F.ID FROM Bill, Food AS F, TypeFood AS TF ,BillInfo as BI where F.Type=TF.Id and BI.FoodID =F.ID and TF.Id=@TypeFoodId and Bill.ID=BI.BillID and Status=0 group by F.ID
	IF (@BillIDCount = 0)
	BEGIN
		DELETE BillInfo WHERE FoodID = @FoodID
		DELETE Food WHERE ID = @FoodID
		Delete TypeFood where Id=@TypeFoodId
	END
END
GO
/****** Object:  StoredProcedure [dbo].[SP_GetAccountByUserName]    Script Date: 12/17/2022 1:20:08 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_GetAccountByUserName]
@UserName VARCHAR(100)
AS
	SELECT *
	FROM dbo.Account
	WHERE UserName = @UserName

GO
/****** Object:  StoredProcedure [dbo].[SP_GetAllAccount]    Script Date: 12/17/2022 1:20:08 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_GetAllAccount]
AS
	SELECT UserName, DisplayName, TypeID FROM dbo.Account

GO
/****** Object:  StoredProcedure [dbo].[SP_GetAllFood]    Script Date: 12/17/2022 1:20:08 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_GetAllFood]
AS
	SELECT * FROM dbo.Food

GO
/****** Object:  StoredProcedure [dbo].[SP_GetAllTable]    Script Date: 12/17/2022 1:20:08 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_GetAllTable]
AS
	SELECT ID, Name FROM dbo.TableCoffee

GO
/****** Object:  StoredProcedure [dbo].[SP_GetListBillByDateAndPage]    Script Date: 12/17/2022 1:20:08 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_GetListBillByDateAndPage] @FromDate date,@ToDate date,@Page int
AS
BEGIN
	DECLARE @pageRow INT = 10
	DECLARE @selectRows INT = @pageRow*@Page
	DECLARE @exceptRows INT =(@page -1) * @pageRow
	select TOP(@selectRows) b.ID, t.Name, CheckIn, Discount, TotalPrice
	from Bill as b, TableCoffee as t
	where CheckIn >= @FromDate and CheckIn <= @ToDate and b.status = 1 and t.ID = b.TableID
	EXCEPT
	select TOP(@exceptRows)b.ID, t.Name, CheckIn, Discount, TotalPrice
	from Bill as b, TableCoffee as t
	where CheckIn >= @FromDate and CheckIn <= @ToDate and b.status = 1 and t.ID = b.TableID

END
GO
/****** Object:  StoredProcedure [dbo].[SP_GetListBillByDay]    Script Date: 12/17/2022 1:20:08 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_GetListBillByDay]
@FromDate DATE, @ToDate DATE
AS
BEGIN
	SELECT b.ID, t.Name, CheckIn, discount, TotalPrice
	FROM Bill AS b, TableCoffee AS t
	WHERE CheckIn >= @FromDate AND CheckIn <= @ToDate AND b.status = 1 AND t.ID = b.TableID
END

GO
/****** Object:  StoredProcedure [dbo].[SP_GetListFoodByTypeFoodID]    Script Date: 12/17/2022 1:20:08 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_GetListFoodByTypeFoodID]
@TypeFoodID INT
AS
	SELECT ID, Name, Price FROM dbo.Food WHERE Type = @TypeFoodID

GO
/****** Object:  StoredProcedure [dbo].[SP_GetListTable]    Script Date: 12/17/2022 1:20:08 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_GetListTable]
AS
	SELECT * FROM dbo.TableCoffee

GO
/****** Object:  StoredProcedure [dbo].[SP_GetListTempBillByTableID]    Script Date: 12/17/2022 1:20:08 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_GetListTempBillByTableID]
@TableID INT
AS
	SELECT f.Name, bi.Amount, f.Price, f.Price * bi.Amount AS totalPrice
	FROM dbo.BillInfo bi, dbo.Bill b, dbo.Food f
	WHERE b.ID = bi.BillID AND bi.FoodID = f.ID AND b.Status = 0 AND b.TableID = @TableID

GO
/****** Object:  StoredProcedure [dbo].[SP_GetMaxBillID]    Script Date: 12/17/2022 1:20:08 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[SP_GetMaxBillID]
AS
	SELECT MAX(ID) FROM dbo.Bill

GO
/****** Object:  StoredProcedure [dbo].[SP_GetNumPercent]    Script Date: 12/17/2022 1:20:08 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_GetNumPercent] @ID varchar(10)
AS
BEGIN
	DECLARE @NumPercent INT = 0
	SET @NumPercent=(SELECT TOP 1 NumPercent from discount where ID=@ID and Quantity>0)
	IF(@NumPercent>0)
	BEGIN
		UPDATE Discount SET Quantity =Quantity-1
		where ID=@ID
	END
	SELECT @NumPercent
END
GO
/****** Object:  StoredProcedure [dbo].[SP_GetTypeFoodByIdCategory]    Script Date: 12/17/2022 1:20:08 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_GetTypeFoodByIdCategory] @ID INT
AS
BEGIN
	SELECT * FROM TypeFood WHERE IdCategory=@ID
END  
GO
/****** Object:  StoredProcedure [dbo].[SP_GetTypeListIdNameNameCategory]    Script Date: 12/17/2022 1:20:08 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_GetTypeListIdNameNameCategory]
AS
BEGIN
	select TypeFood.Id as [Mã loại],IdCategory,TypeFood.Name as [Tên loại],CategoryFood.Name as[Tên thể loại] from TypeFood,CategoryFood where TypeFood.IdCategory=CategoryFood.ID
END
GO
/****** Object:  StoredProcedure [dbo].[SP_InsertAccount]    Script Date: 12/17/2022 1:20:08 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_InsertAccount]
@UserName VARCHAR(100), @DisplayName NVARCHAR(100), @TypeID INT
AS
	INSERT dbo.Account ( UserName, DisplayName, TypeID )
	VALUES  ( @UserName, @DisplayName, @TypeID )

GO
/****** Object:  StoredProcedure [dbo].[SP_InsertBill]    Script Date: 12/17/2022 1:20:08 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_InsertBill]
@TableID INT
AS
	INSERT dbo.Bill (CheckIn, TableID, status, discount) VALUES (GETDATE(), @TableID, 0, 0)

GO
/****** Object:  StoredProcedure [dbo].[SP_InsertBillInfo]    Script Date: 12/17/2022 1:20:08 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_InsertBillInfo]
@BillID int, @FoodID int, @Amount int
as
begin
	declare @isExistBillInfo int
	declare @foodAmount int = 1

	select @isExistBillInfo = ID, @foodAmount = Amount
	from BillInfo
	where BillID = @BillID and FoodID = @FoodID

	if (@isExistBillInfo > 0)
	begin
		declare @newAmount int = @foodAmount + @Amount
		if (@newAmount > 0)
			update BillInfo set Amount = @newAmount where FoodID = @FoodID
		ELSE IF (@newAmount <= 0)
			delete BillInfo where BillID = @BillID and FoodID = @FoodID
	end
	else
		IF (@Amount > 0)
			INSERT into BillInfo (BillID, FoodID, Amount) values (@BillID, @FoodID, @Amount)
end

GO
/****** Object:  StoredProcedure [dbo].[SP_InsertFood]    Script Date: 12/17/2022 1:20:08 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROC [dbo].[SP_InsertFood] @Name NVARCHAR(100), @TypeID INT, @Price INT
AS
	INSERT dbo.Food( Name, Type, Price )
	VALUES  ( @Name, @TypeID, @Price )
GO
/****** Object:  StoredProcedure [dbo].[SP_InsertTable]    Script Date: 12/17/2022 1:20:08 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_InsertTable]
@Name NVARCHAR(100)
AS
	INSERT dbo.TableCoffee ( Name )
	VALUES  ( @Name )

GO
/****** Object:  StoredProcedure [dbo].[SP_InsertTypeFood]    Script Date: 12/17/2022 1:20:08 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_InsertTypeFood] @Name NVARCHAR(100),@IdCategory INT
AS
BEGIN
	INSERT INTO TypeFood VALUES (@NAME,@IdCategory)
END
GO
/****** Object:  StoredProcedure [dbo].[SP_Login]    Script Date: 12/17/2022 1:20:08 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_Login]
@UserName NVARCHAR(100), @Password NVARCHAR(100)
AS
	SELECT *
	FROM dbo.Account
	WHERE UserName = @UserName AND Password = @Password

GO
/****** Object:  StoredProcedure [dbo].[SP_MergeTable]    Script Date: 12/17/2022 1:20:08 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[SP_MergeTable]
@TableID1 INT, @TableID2 INT
AS
	BEGIN
		DECLARE @UnCheckBillID1 INT = -1
		DECLARE @UnCheckBillID2 INT = -1
		SELECT @UnCheckBillID1 = ID FROM dbo.Bill WHERE TableID = @TableID1 AND Status = 0
		SELECT @UnCheckBillID2 = ID FROM dbo.Bill WHERE TableID = @TableID2 AND Status = 0

		IF (@UnCheckBillID1 != -1 AND @UnCheckBillID2 != -1)
			BEGIN
				DECLARE @BillInfoID INT
				SELECT @BillInfoID = ID FROM dbo.BillInfo WHERE BillID = @UnCheckBillID1

				UPDATE dbo.BillInfo SET BillID = @UnCheckBillID2 WHERE ID = @BillInfoID
				DELETE dbo.Bill WHERE ID = @UnCheckBillID1

				UPDATE dbo.TableCoffee SET STATUS = N'Trống' WHERE ID = @TableID1
			END
    END

GO
/****** Object:  StoredProcedure [dbo].[SP_ResetPassword]    Script Date: 12/17/2022 1:20:08 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_ResetPassword]
@UserName VARCHAR(100)
AS
	UPDATE dbo.Account SET Password = 'C4CA4238A0B923820DCC509A6F75849B' WHERE UserName = @UserName--Mật khẩu mặt định là 1
GO
/****** Object:  StoredProcedure [dbo].[SP_SearchFoodByName]    Script Date: 12/17/2022 1:20:08 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_SearchFoodByName]
@Name NVARCHAR(100)
AS
	SELECT * FROM dbo.Food WHERE dbo.fuConvertToUnsign1(Name) LIKE N'%' + dbo.fuConvertToUnsign1(@Name) + '%'

GO
/****** Object:  StoredProcedure [dbo].[SP_SwitchTable]    Script Date: 12/17/2022 1:20:08 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[SP_SwitchTable]
@TableID1 INT, @TableID2 INT
AS
BEGIN
	DECLARE @isTable1Null INT = 0
	DECLARE @isTable2Null INT = 0
	SELECT @isTable1Null = ID FROM dbo.Bill WHERE TableID = @TableID1 AND Status = 0
	SELECT @isTable2Null = ID FROM dbo.Bill WHERE TableID = @TableID2 AND Status = 0

	IF (@isTable1Null = 0 AND @isTable2Null > 0)
		BEGIN
			UPDATE dbo.Bill SET TableID = @TableID1 WHERE ID = @isTable2Null
			UPDATE dbo.TableCoffee SET Status = N'Có người' WHERE ID = @TableID1
			UPDATE dbo.TableCoffee SET Status = N'Trống' WHERE ID = @TableID2
        END
	ELSE IF (@isTable1Null > 0 AND @isTable2Null = 0)
		BEGIN
			UPDATE dbo.Bill SET TableID = @TableID2 WHERE Status = 0 AND ID = @isTable1Null
			UPDATE dbo.TableCoffee SET Status = N'Có người' WHERE ID = @TableID2
			UPDATE dbo.TableCoffee SET Status = N'Trống' WHERE ID = @TableID1
        END
    ELSE IF (@isTable1Null > 0 AND @isTable2Null > 0)
		BEGIN
			UPDATE dbo.Bill SET TableID = @TableID2 WHERE ID = @isTable1Null
			UPDATE dbo.Bill SET TableID = @TableID1 WHERE ID = @isTable2Null
        END
END

GO
/****** Object:  StoredProcedure [dbo].[SP_UpdateAccount]    Script Date: 12/17/2022 1:20:08 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_UpdateAccount]
@UserName VARCHAR(100), @DisplayName NVARCHAR(100), @Password VARCHAR(100), @NewPassword VARCHAR(100)
AS
BEGIN
	DECLARE @isRightPass INT = 0
	SELECT @isRightPass = COUNT(*) FROM Account WHERE UserName = @UserName and Password = @Password
	IF (@isRightPass = 1)
	BEGIN
		IF (@NewPassword = null or @NewPassword = '')
			UPDATE Account SET DisplayName = @DisplayName WHERE UserName = @UserName
		ELSE
			UPDATE Account SET DisplayName = @DisplayName, Password = @NewPassword WHERE UserName = @UserName
	END
END

GO
/****** Object:  StoredProcedure [dbo].[SP_UpdateAccountFromAdmin]    Script Date: 12/17/2022 1:20:08 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_UpdateAccountFromAdmin] @UserName VARCHAR(100), @DisplayName NVARCHAR(100),@TypeAccount int
AS
BEGIN
	DECLARE @isRight INT =0
	SELECT @isRight =COUNT(*) from Account where UserName=@UserName
		IF(@isRight=1)
			BEGIN
				UPDATE Account SET DisplayName=@DisplayName,TypeID=@TypeAccount WHERE UserName=@UserName
			END
END
GO
/****** Object:  StoredProcedure [dbo].[SP_UpdateFood]    Script Date: 12/17/2022 1:20:08 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_UpdateFood]
@ID INT, @Name NVARCHAR(100), @TypeID INT, @Price INT
AS
	DECLARE @BillIDCount INT = 0
	SELECT @BillIDCount = COUNT(*) FROM Bill AS b, BillInfo AS bi WHERE FoodID = @ID AND b.ID = bi.BillID AND b.Status = 0

	IF (@BillIDCount = 0)
		UPDATE dbo.Food SET Name = @Name, Type = @TypeID, Price = @Price WHERE ID = @ID
GO
/****** Object:  StoredProcedure [dbo].[SP_UpdateTable]    Script Date: 12/17/2022 1:20:08 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_UpdateTable]
@ID INT, @Name NVARCHAR(100)
AS
	UPDATE dbo.TableCoffee SET Name = @Name WHERE ID = @ID

GO
/****** Object:  StoredProcedure [dbo].[SP_UpdateTypeFood]    Script Date: 12/17/2022 1:20:08 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_UpdateTypeFood] @Id int, @Name NVARCHAR(100),@IdCategory INT
AS
BEGIN
	UPDATE TypeFood
	SET Name=@Name,IdCategory=@IdCategory
	WHERE Id=@Id
END
GO
/****** Object:  StoredProcedure [dbo].[USP_SearchAccountByUserName]    Script Date: 12/17/2022 1:20:08 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[USP_SearchAccountByUserName]
@UserName VARCHAR(100)
AS
	SELECT * FROM dbo.Account WHERE dbo.fuConvertToUnsign1(UserName) LIKE N'%' + dbo.fuConvertToUnsign1(@UserName) + '%'

GO
/****** Object:  Trigger [dbo].[TG_UpdateBill]    Script Date: 12/17/2022 1:20:08 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[TG_UpdateBill]
on [dbo].[Bill] for update
as
begin
	declare @billID int
	select @billID = ID from inserted
	declare @tableID int
	select @tableID = TableID from Bill where ID = @billID
	declare @amount int = 0
	select @amount = COUNT(*) from Bill where TableID = @tableID and Status = 0
	if (@amount = 0)
		update TableCoffee set Status = N'Trống' where ID = @tableID
end

GO
ALTER TABLE [dbo].[Bill] ENABLE TRIGGER [TG_UpdateBill]
GO
/****** Object:  Trigger [dbo].[TG_DeleteBillInfo]    Script Date: 12/17/2022 1:20:09 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create trigger [dbo].[TG_DeleteBillInfo]
on [dbo].[BillInfo] for delete
as
begin
	declare @IDBillInfo int
	declare @BillID int
	select @IDBillInfo = id, @BillID = BillID from deleted

	declare @TableID int
	select @TableID = TableID from Bill where ID = @BillID

	declare @count int = 0
	select @count = COUNT(*) from BillInfo as bi, Bill as b where b.ID = bi.BillID and b.ID = @BillID and b.status = 0

	if (@count = 0)
		update TableCoffee set Status = N'Trống' where ID = @TableID
end

GO
ALTER TABLE [dbo].[BillInfo] ENABLE TRIGGER [TG_DeleteBillInfo]
GO
/****** Object:  Trigger [dbo].[UTG_UpdateBillInfo]    Script Date: 12/17/2022 1:20:09 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- end Bill's procedure
create trigger [dbo].[UTG_UpdateBillInfo]
on [dbo].[BillInfo] for insert
as
begin
	declare @billID int
	select @billID = BillID from inserted

	declare @tableID int
	select @tableID = TableID from Bill where ID = @billID and status = 0

	declare @count int
	select @count = COUNT(*) from BillInfo where BillID = @billID

	if (@count > 0)
		update TableCoffee set Status = N'Có người' where ID = @tableID
	else
		update TableCoffee set Status = N'Trống' where ID = @tableID
end

GO
ALTER TABLE [dbo].[BillInfo] ENABLE TRIGGER [UTG_UpdateBillInfo]
GO
USE [master]
GO
ALTER DATABASE [CoffeeManagement] SET  READ_WRITE 
GO
