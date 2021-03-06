USE [TentamenDatabasAntonAsplund]
GO
/****** Object:  UserDefinedFunction [dbo].[CalculateParkingCost]    Script Date: 2020-02-09 17:56:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[CalculateParkingCost] (@ArrivalParkTime DATETIME, @CheckOutTime DATETIME, @VehicleTypeID int)
RETURNS money
AS
BEGIN
DECLARE @TotalBill money
SET @TotalBill = 0
DECLARE @HourlyRate money
SET @HourlyRate = (SELECT VT.Price FROM VehicleType VT WHERE VT.VehicleTypeID = @VehicleTypeID)
DECLARE @TotalTimeDiff decimal
SET @TotalTimeDiff = DATEDIFF(minute, @ArrivalParkTime, @CheckOutTime) - 5

IF @TotalTimeDiff < 120 AND @TotalTimeDiff > 0
BEGIN
SET @TotalBill = @HourlyRate * 2
END

ELSE IF @TotalTimeDiff >= 120
BEGIN
SET @TotalBill = @HourlyRate * CEILING(@TotalTimeDiff/60) 
END

RETURN @TotalBill

END
GO
/****** Object:  UserDefinedFunction [dbo].[FindFreeParking]    Script Date: 2020-02-09 17:56:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[FindFreeParking] (@Size int)
RETURNS int 
AS
BEGIN 
DECLARE @Result int

SET @Result = (SELECT TOP 1 ParkingSpaceID FROM ParkingSpace P WHERE P.ParkingSpaceSize + @size <= P.ParksingSpaceMaxSize)

IF @Result < 1
BEGIN
SET @Result = 0
END

RETURN @Result
END
GO
/****** Object:  UserDefinedFunction [dbo].[FindSpecificFreeParking]    Script Date: 2020-02-09 17:56:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[FindSpecificFreeParking] (@Size int, @SpecificParkingSpot int)
RETURNS int 
AS
BEGIN 
DECLARE @ParkingSpotCap int

SET @ParkingSpotCap = (SELECT PS.ParkingSpaceSize FROM ParkingSpace PS WHERE PS.ParkingSpaceID = @SpecificParkingSpot)

IF @ParkingSpotCap + @Size > 2
BEGIN
SET @SpecificParkingSpot = -1
END

RETURN @SpecificParkingSpot
END
GO
/****** Object:  Table [dbo].[ParkedVehicle]    Script Date: 2020-02-09 17:56:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ParkedVehicle](
	[ParkedVehicleID] [int] IDENTITY(1,1) NOT NULL,
	[RegistrationNumber] [nvarchar](10) NOT NULL,
	[ArrivalParkTime] [datetime] NOT NULL,
	[ParkingspaceID] [int] NOT NULL,
	[VehicleTypeID] [int] NOT NULL,
 CONSTRAINT [PK_ParkedVehicle] PRIMARY KEY CLUSTERED 
(
	[ParkedVehicleID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ParkingSpace]    Script Date: 2020-02-09 17:56:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ParkingSpace](
	[ParkingSpaceID] [int] IDENTITY(1,1) NOT NULL,
	[ParkingSpaceSize] [int] NOT NULL,
	[ParksingSpaceMaxSize] [int] NOT NULL,
	[ParkingSpaceNumber] [int] NOT NULL,
 CONSTRAINT [PK_ParkingSpace] PRIMARY KEY CLUSTERED 
(
	[ParkingSpaceID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[VehicleArchive]    Script Date: 2020-02-09 17:56:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[VehicleArchive](
	[VehicleArchiveID] [int] NOT NULL,
	[RegistrationNumber] [nvarchar](10) NOT NULL,
	[ArrivalTime] [datetime] NOT NULL,
	[CheckOutTime] [datetime] NOT NULL,
	[TotalCost] [money] NOT NULL,
	[ParkingSpaceID] [int] NOT NULL,
	[VehicleTypeID] [int] NOT NULL,
 CONSTRAINT [PK_VehicleArchive] PRIMARY KEY CLUSTERED 
(
	[VehicleArchiveID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[VehicleType]    Script Date: 2020-02-09 17:56:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[VehicleType](
	[VehicleTypeID] [int] IDENTITY(1,1) NOT NULL,
	[VehicleType] [nvarchar](10) NOT NULL,
	[Size] [int] NOT NULL,
	[Price] [money] NOT NULL,
 CONSTRAINT [PK_VehicleType] PRIMARY KEY CLUSTERED 
(
	[VehicleTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[WorkOrderRecipt]    Script Date: 2020-02-09 17:56:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WorkOrderRecipt](
	[WorkOrderRecipt] [int] IDENTITY(1,1) NOT NULL,
	[VehicleRegistrationNumber] [nvarchar](10) NOT NULL,
	[VehicleType] [nvarchar](10) NOT NULL,
	[MoveFromParkingSpace] [int] NOT NULL,
	[MoveToParkingSpace] [int] NOT NULL,
 CONSTRAINT [PK_WorkOrderRecipt] PRIMARY KEY CLUSTERED 
(
	[WorkOrderRecipt] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[ParkedVehicle] ON 

INSERT [dbo].[ParkedVehicle] ([ParkedVehicleID], [RegistrationNumber], [ArrivalParkTime], [ParkingspaceID], [VehicleTypeID]) VALUES (97, N'MC001', CAST(N'2020-02-08T01:34:15.213' AS DateTime), 1, 2)
INSERT [dbo].[ParkedVehicle] ([ParkedVehicleID], [RegistrationNumber], [ArrivalParkTime], [ParkingspaceID], [VehicleTypeID]) VALUES (100, N'ORU270', CAST(N'2020-02-08T02:25:20.203' AS DateTime), 12, 1)
INSERT [dbo].[ParkedVehicle] ([ParkedVehicleID], [RegistrationNumber], [ArrivalParkTime], [ParkingspaceID], [VehicleTypeID]) VALUES (102, N'драсти', CAST(N'2020-02-08T02:26:02.097' AS DateTime), 1, 2)
INSERT [dbo].[ParkedVehicle] ([ParkedVehicleID], [RegistrationNumber], [ArrivalParkTime], [ParkingspaceID], [VehicleTypeID]) VALUES (106, N'プログラマー', CAST(N'2020-02-08T02:27:42.863' AS DateTime), 33, 2)
INSERT [dbo].[ParkedVehicle] ([ParkedVehicleID], [RegistrationNumber], [ArrivalParkTime], [ParkingspaceID], [VehicleTypeID]) VALUES (108, N'1f3f2f2', CAST(N'2020-02-08T10:44:28.413' AS DateTime), 55, 1)
INSERT [dbo].[ParkedVehicle] ([ParkedVehicleID], [RegistrationNumber], [ArrivalParkTime], [ParkingspaceID], [VehicleTypeID]) VALUES (110, N'rgnr333', CAST(N'2020-02-08T10:53:57.880' AS DateTime), 8, 1)
INSERT [dbo].[ParkedVehicle] ([ParkedVehicleID], [RegistrationNumber], [ArrivalParkTime], [ParkingspaceID], [VehicleTypeID]) VALUES (111, N'ABG777', CAST(N'2020-02-08T10:54:08.300' AS DateTime), 13, 1)
INSERT [dbo].[ParkedVehicle] ([ParkedVehicleID], [RegistrationNumber], [ArrivalParkTime], [ParkingspaceID], [VehicleTypeID]) VALUES (115, N'CAR401', CAST(N'2020-02-08T23:53:01.713' AS DateTime), 2, 2)
INSERT [dbo].[ParkedVehicle] ([ParkedVehicleID], [RegistrationNumber], [ArrivalParkTime], [ParkingspaceID], [VehicleTypeID]) VALUES (117, N'MC402', CAST(N'2020-02-08T23:54:20.847' AS DateTime), 3, 2)
INSERT [dbo].[ParkedVehicle] ([ParkedVehicleID], [RegistrationNumber], [ArrivalParkTime], [ParkingspaceID], [VehicleTypeID]) VALUES (118, N'MC403', CAST(N'2020-02-08T23:54:20.857' AS DateTime), 3, 2)
INSERT [dbo].[ParkedVehicle] ([ParkedVehicleID], [RegistrationNumber], [ArrivalParkTime], [ParkingspaceID], [VehicleTypeID]) VALUES (119, N'MC404', CAST(N'2020-02-08T23:54:20.860' AS DateTime), 66, 2)
INSERT [dbo].[ParkedVehicle] ([ParkedVehicleID], [RegistrationNumber], [ArrivalParkTime], [ParkingspaceID], [VehicleTypeID]) VALUES (120, N'MC405', CAST(N'2020-02-08T23:54:20.860' AS DateTime), 74, 2)
INSERT [dbo].[ParkedVehicle] ([ParkedVehicleID], [RegistrationNumber], [ArrivalParkTime], [ParkingspaceID], [VehicleTypeID]) VALUES (121, N'MC406', CAST(N'2020-02-08T23:54:20.860' AS DateTime), 56, 2)
INSERT [dbo].[ParkedVehicle] ([ParkedVehicleID], [RegistrationNumber], [ArrivalParkTime], [ParkingspaceID], [VehicleTypeID]) VALUES (122, N'MC407', CAST(N'2020-02-08T23:54:20.860' AS DateTime), 7, 2)
INSERT [dbo].[ParkedVehicle] ([ParkedVehicleID], [RegistrationNumber], [ArrivalParkTime], [ParkingspaceID], [VehicleTypeID]) VALUES (123, N'MC408', CAST(N'2020-02-08T23:54:20.863' AS DateTime), 87, 2)
INSERT [dbo].[ParkedVehicle] ([ParkedVehicleID], [RegistrationNumber], [ArrivalParkTime], [ParkingspaceID], [VehicleTypeID]) VALUES (124, N'MC409', CAST(N'2020-02-08T23:54:20.863' AS DateTime), 9, 2)
INSERT [dbo].[ParkedVehicle] ([ParkedVehicleID], [RegistrationNumber], [ArrivalParkTime], [ParkingspaceID], [VehicleTypeID]) VALUES (125, N'MC410', CAST(N'2020-02-08T23:54:20.863' AS DateTime), 9, 2)
INSERT [dbo].[ParkedVehicle] ([ParkedVehicleID], [RegistrationNumber], [ArrivalParkTime], [ParkingspaceID], [VehicleTypeID]) VALUES (126, N'MC411', CAST(N'2020-02-08T23:54:20.863' AS DateTime), 10, 2)
INSERT [dbo].[ParkedVehicle] ([ParkedVehicleID], [RegistrationNumber], [ArrivalParkTime], [ParkingspaceID], [VehicleTypeID]) VALUES (127, N'MC412', CAST(N'2020-02-08T23:54:20.863' AS DateTime), 87, 2)
INSERT [dbo].[ParkedVehicle] ([ParkedVehicleID], [RegistrationNumber], [ArrivalParkTime], [ParkingspaceID], [VehicleTypeID]) VALUES (128, N'MC413', CAST(N'2020-02-08T23:54:20.863' AS DateTime), 11, 2)
INSERT [dbo].[ParkedVehicle] ([ParkedVehicleID], [RegistrationNumber], [ArrivalParkTime], [ParkingspaceID], [VehicleTypeID]) VALUES (129, N'ADO876', CAST(N'2020-02-08T23:58:50.233' AS DateTime), 14, 1)
INSERT [dbo].[ParkedVehicle] ([ParkedVehicleID], [RegistrationNumber], [ArrivalParkTime], [ParkingspaceID], [VehicleTypeID]) VALUES (131, N'BGD123', CAST(N'2020-02-09T09:48:11.387' AS DateTime), 11, 2)
INSERT [dbo].[ParkedVehicle] ([ParkedVehicleID], [RegistrationNumber], [ArrivalParkTime], [ParkingspaceID], [VehicleTypeID]) VALUES (132, N'GFH123', CAST(N'2020-02-09T11:28:54.340' AS DateTime), 71, 1)
INSERT [dbo].[ParkedVehicle] ([ParkedVehicleID], [RegistrationNumber], [ArrivalParkTime], [ParkingspaceID], [VehicleTypeID]) VALUES (144, N'GFD123', CAST(N'2015-03-15T00:00:00.000' AS DateTime), 16, 1)
INSERT [dbo].[ParkedVehicle] ([ParkedVehicleID], [RegistrationNumber], [ArrivalParkTime], [ParkingspaceID], [VehicleTypeID]) VALUES (145, N'GFF213', CAST(N'2015-04-15T00:00:00.000' AS DateTime), 17, 1)
INSERT [dbo].[ParkedVehicle] ([ParkedVehicleID], [RegistrationNumber], [ArrivalParkTime], [ParkingspaceID], [VehicleTypeID]) VALUES (146, N'G234DD', CAST(N'2016-02-15T00:00:00.000' AS DateTime), 18, 1)
INSERT [dbo].[ParkedVehicle] ([ParkedVehicleID], [RegistrationNumber], [ArrivalParkTime], [ParkingspaceID], [VehicleTypeID]) VALUES (147, N'AAA584', CAST(N'2011-02-15T00:00:00.000' AS DateTime), 19, 1)
INSERT [dbo].[ParkedVehicle] ([ParkedVehicleID], [RegistrationNumber], [ArrivalParkTime], [ParkingspaceID], [VehicleTypeID]) VALUES (148, N'DF32422', CAST(N'2014-02-15T00:00:00.000' AS DateTime), 20, 1)
INSERT [dbo].[ParkedVehicle] ([ParkedVehicleID], [RegistrationNumber], [ArrivalParkTime], [ParkingspaceID], [VehicleTypeID]) VALUES (149, N'DE2143', CAST(N'2020-01-15T00:00:00.000' AS DateTime), 21, 1)
INSERT [dbo].[ParkedVehicle] ([ParkedVehicleID], [RegistrationNumber], [ArrivalParkTime], [ParkingspaceID], [VehicleTypeID]) VALUES (150, N'FF321', CAST(N'2015-03-15T00:00:00.000' AS DateTime), 22, 1)
INSERT [dbo].[ParkedVehicle] ([ParkedVehicleID], [RegistrationNumber], [ArrivalParkTime], [ParkingspaceID], [VehicleTypeID]) VALUES (151, N'FD2124', CAST(N'2015-03-15T00:00:00.000' AS DateTime), 23, 1)
INSERT [dbo].[ParkedVehicle] ([ParkedVehicleID], [RegistrationNumber], [ArrivalParkTime], [ParkingspaceID], [VehicleTypeID]) VALUES (152, N'GF3123', CAST(N'2015-03-15T00:00:00.000' AS DateTime), 24, 1)
INSERT [dbo].[ParkedVehicle] ([ParkedVehicleID], [RegistrationNumber], [ArrivalParkTime], [ParkingspaceID], [VehicleTypeID]) VALUES (153, N'GFD533', CAST(N'2015-03-15T00:00:00.000' AS DateTime), 25, 1)
INSERT [dbo].[ParkedVehicle] ([ParkedVehicleID], [RegistrationNumber], [ArrivalParkTime], [ParkingspaceID], [VehicleTypeID]) VALUES (154, N'GAA621', CAST(N'2015-03-15T00:00:00.000' AS DateTime), 26, 1)
INSERT [dbo].[ParkedVehicle] ([ParkedVehicleID], [RegistrationNumber], [ArrivalParkTime], [ParkingspaceID], [VehicleTypeID]) VALUES (158, N'FGD556', CAST(N'2020-02-09T12:26:46.253' AS DateTime), 27, 1)
INSERT [dbo].[ParkedVehicle] ([ParkedVehicleID], [RegistrationNumber], [ArrivalParkTime], [ParkingspaceID], [VehicleTypeID]) VALUES (159, N'ABV654', CAST(N'2020-02-09T17:40:50.807' AS DateTime), 81, 2)
INSERT [dbo].[ParkedVehicle] ([ParkedVehicleID], [RegistrationNumber], [ArrivalParkTime], [ParkingspaceID], [VehicleTypeID]) VALUES (160, N'4A23000', CAST(N'2020-02-09T17:42:54.810' AS DateTime), 83, 1)
INSERT [dbo].[ParkedVehicle] ([ParkedVehicleID], [RegistrationNumber], [ArrivalParkTime], [ParkingspaceID], [VehicleTypeID]) VALUES (161, N'2H27149', CAST(N'2020-02-09T17:43:30.093' AS DateTime), 2, 2)
INSERT [dbo].[ParkedVehicle] ([ParkedVehicleID], [RegistrationNumber], [ArrivalParkTime], [ParkingspaceID], [VehicleTypeID]) VALUES (162, N'KJH887', CAST(N'2020-02-09T17:44:52.803' AS DateTime), 28, 1)
INSERT [dbo].[ParkedVehicle] ([ParkedVehicleID], [RegistrationNumber], [ArrivalParkTime], [ParkingspaceID], [VehicleTypeID]) VALUES (163, N'UJH778', CAST(N'2020-02-09T17:45:01.527' AS DateTime), 29, 1)
INSERT [dbo].[ParkedVehicle] ([ParkedVehicleID], [RegistrationNumber], [ArrivalParkTime], [ParkingspaceID], [VehicleTypeID]) VALUES (164, N'ÆÆÆ333', CAST(N'2020-02-09T17:47:47.443' AS DateTime), 4, 1)
INSERT [dbo].[ParkedVehicle] ([ParkedVehicleID], [RegistrationNumber], [ArrivalParkTime], [ParkingspaceID], [VehicleTypeID]) VALUES (165, N'часы', CAST(N'2020-02-09T17:48:39.410' AS DateTime), 5, 2)
INSERT [dbo].[ParkedVehicle] ([ParkedVehicleID], [RegistrationNumber], [ArrivalParkTime], [ParkingspaceID], [VehicleTypeID]) VALUES (166, N'良いです', CAST(N'2020-02-09T17:52:34.567' AS DateTime), 6, 1)
INSERT [dbo].[ParkedVehicle] ([ParkedVehicleID], [RegistrationNumber], [ArrivalParkTime], [ParkingspaceID], [VehicleTypeID]) VALUES (167, N'鸡蛋面条', CAST(N'2020-02-09T17:54:00.247' AS DateTime), 15, 1)
INSERT [dbo].[ParkedVehicle] ([ParkedVehicleID], [RegistrationNumber], [ArrivalParkTime], [ParkingspaceID], [VehicleTypeID]) VALUES (168, N'冠状病毒', CAST(N'2020-02-09T17:54:15.983' AS DateTime), 5, 2)
SET IDENTITY_INSERT [dbo].[ParkedVehicle] OFF
SET IDENTITY_INSERT [dbo].[ParkingSpace] ON 

INSERT [dbo].[ParkingSpace] ([ParkingSpaceID], [ParkingSpaceSize], [ParksingSpaceMaxSize], [ParkingSpaceNumber]) VALUES (1, 2, 2, 1)
INSERT [dbo].[ParkingSpace] ([ParkingSpaceID], [ParkingSpaceSize], [ParksingSpaceMaxSize], [ParkingSpaceNumber]) VALUES (2, 2, 2, 2)
INSERT [dbo].[ParkingSpace] ([ParkingSpaceID], [ParkingSpaceSize], [ParksingSpaceMaxSize], [ParkingSpaceNumber]) VALUES (3, 2, 2, 3)
INSERT [dbo].[ParkingSpace] ([ParkingSpaceID], [ParkingSpaceSize], [ParksingSpaceMaxSize], [ParkingSpaceNumber]) VALUES (4, 2, 2, 4)
INSERT [dbo].[ParkingSpace] ([ParkingSpaceID], [ParkingSpaceSize], [ParksingSpaceMaxSize], [ParkingSpaceNumber]) VALUES (5, 2, 2, 5)
INSERT [dbo].[ParkingSpace] ([ParkingSpaceID], [ParkingSpaceSize], [ParksingSpaceMaxSize], [ParkingSpaceNumber]) VALUES (6, 2, 2, 6)
INSERT [dbo].[ParkingSpace] ([ParkingSpaceID], [ParkingSpaceSize], [ParksingSpaceMaxSize], [ParkingSpaceNumber]) VALUES (7, 1, 2, 7)
INSERT [dbo].[ParkingSpace] ([ParkingSpaceID], [ParkingSpaceSize], [ParksingSpaceMaxSize], [ParkingSpaceNumber]) VALUES (8, 2, 2, 8)
INSERT [dbo].[ParkingSpace] ([ParkingSpaceID], [ParkingSpaceSize], [ParksingSpaceMaxSize], [ParkingSpaceNumber]) VALUES (9, 2, 2, 9)
INSERT [dbo].[ParkingSpace] ([ParkingSpaceID], [ParkingSpaceSize], [ParksingSpaceMaxSize], [ParkingSpaceNumber]) VALUES (10, 1, 2, 10)
INSERT [dbo].[ParkingSpace] ([ParkingSpaceID], [ParkingSpaceSize], [ParksingSpaceMaxSize], [ParkingSpaceNumber]) VALUES (11, 2, 2, 11)
INSERT [dbo].[ParkingSpace] ([ParkingSpaceID], [ParkingSpaceSize], [ParksingSpaceMaxSize], [ParkingSpaceNumber]) VALUES (12, 2, 2, 12)
INSERT [dbo].[ParkingSpace] ([ParkingSpaceID], [ParkingSpaceSize], [ParksingSpaceMaxSize], [ParkingSpaceNumber]) VALUES (13, 2, 2, 13)
INSERT [dbo].[ParkingSpace] ([ParkingSpaceID], [ParkingSpaceSize], [ParksingSpaceMaxSize], [ParkingSpaceNumber]) VALUES (14, 2, 2, 14)
INSERT [dbo].[ParkingSpace] ([ParkingSpaceID], [ParkingSpaceSize], [ParksingSpaceMaxSize], [ParkingSpaceNumber]) VALUES (15, 2, 2, 15)
INSERT [dbo].[ParkingSpace] ([ParkingSpaceID], [ParkingSpaceSize], [ParksingSpaceMaxSize], [ParkingSpaceNumber]) VALUES (16, 2, 2, 16)
INSERT [dbo].[ParkingSpace] ([ParkingSpaceID], [ParkingSpaceSize], [ParksingSpaceMaxSize], [ParkingSpaceNumber]) VALUES (17, 2, 2, 17)
INSERT [dbo].[ParkingSpace] ([ParkingSpaceID], [ParkingSpaceSize], [ParksingSpaceMaxSize], [ParkingSpaceNumber]) VALUES (18, 2, 2, 18)
INSERT [dbo].[ParkingSpace] ([ParkingSpaceID], [ParkingSpaceSize], [ParksingSpaceMaxSize], [ParkingSpaceNumber]) VALUES (19, 2, 2, 19)
INSERT [dbo].[ParkingSpace] ([ParkingSpaceID], [ParkingSpaceSize], [ParksingSpaceMaxSize], [ParkingSpaceNumber]) VALUES (20, 2, 2, 20)
INSERT [dbo].[ParkingSpace] ([ParkingSpaceID], [ParkingSpaceSize], [ParksingSpaceMaxSize], [ParkingSpaceNumber]) VALUES (21, 2, 2, 21)
INSERT [dbo].[ParkingSpace] ([ParkingSpaceID], [ParkingSpaceSize], [ParksingSpaceMaxSize], [ParkingSpaceNumber]) VALUES (22, 2, 2, 22)
INSERT [dbo].[ParkingSpace] ([ParkingSpaceID], [ParkingSpaceSize], [ParksingSpaceMaxSize], [ParkingSpaceNumber]) VALUES (23, 2, 2, 23)
INSERT [dbo].[ParkingSpace] ([ParkingSpaceID], [ParkingSpaceSize], [ParksingSpaceMaxSize], [ParkingSpaceNumber]) VALUES (24, 2, 2, 24)
INSERT [dbo].[ParkingSpace] ([ParkingSpaceID], [ParkingSpaceSize], [ParksingSpaceMaxSize], [ParkingSpaceNumber]) VALUES (25, 2, 2, 25)
INSERT [dbo].[ParkingSpace] ([ParkingSpaceID], [ParkingSpaceSize], [ParksingSpaceMaxSize], [ParkingSpaceNumber]) VALUES (26, 2, 2, 26)
INSERT [dbo].[ParkingSpace] ([ParkingSpaceID], [ParkingSpaceSize], [ParksingSpaceMaxSize], [ParkingSpaceNumber]) VALUES (27, 2, 2, 27)
INSERT [dbo].[ParkingSpace] ([ParkingSpaceID], [ParkingSpaceSize], [ParksingSpaceMaxSize], [ParkingSpaceNumber]) VALUES (28, 2, 2, 28)
INSERT [dbo].[ParkingSpace] ([ParkingSpaceID], [ParkingSpaceSize], [ParksingSpaceMaxSize], [ParkingSpaceNumber]) VALUES (29, 2, 2, 29)
INSERT [dbo].[ParkingSpace] ([ParkingSpaceID], [ParkingSpaceSize], [ParksingSpaceMaxSize], [ParkingSpaceNumber]) VALUES (30, 0, 2, 30)
INSERT [dbo].[ParkingSpace] ([ParkingSpaceID], [ParkingSpaceSize], [ParksingSpaceMaxSize], [ParkingSpaceNumber]) VALUES (31, 0, 2, 31)
INSERT [dbo].[ParkingSpace] ([ParkingSpaceID], [ParkingSpaceSize], [ParksingSpaceMaxSize], [ParkingSpaceNumber]) VALUES (32, 0, 2, 32)
INSERT [dbo].[ParkingSpace] ([ParkingSpaceID], [ParkingSpaceSize], [ParksingSpaceMaxSize], [ParkingSpaceNumber]) VALUES (33, 1, 2, 33)
INSERT [dbo].[ParkingSpace] ([ParkingSpaceID], [ParkingSpaceSize], [ParksingSpaceMaxSize], [ParkingSpaceNumber]) VALUES (34, 0, 2, 34)
INSERT [dbo].[ParkingSpace] ([ParkingSpaceID], [ParkingSpaceSize], [ParksingSpaceMaxSize], [ParkingSpaceNumber]) VALUES (35, 0, 2, 35)
INSERT [dbo].[ParkingSpace] ([ParkingSpaceID], [ParkingSpaceSize], [ParksingSpaceMaxSize], [ParkingSpaceNumber]) VALUES (36, 0, 2, 36)
INSERT [dbo].[ParkingSpace] ([ParkingSpaceID], [ParkingSpaceSize], [ParksingSpaceMaxSize], [ParkingSpaceNumber]) VALUES (37, 0, 2, 37)
INSERT [dbo].[ParkingSpace] ([ParkingSpaceID], [ParkingSpaceSize], [ParksingSpaceMaxSize], [ParkingSpaceNumber]) VALUES (38, 0, 2, 38)
INSERT [dbo].[ParkingSpace] ([ParkingSpaceID], [ParkingSpaceSize], [ParksingSpaceMaxSize], [ParkingSpaceNumber]) VALUES (39, 0, 2, 39)
INSERT [dbo].[ParkingSpace] ([ParkingSpaceID], [ParkingSpaceSize], [ParksingSpaceMaxSize], [ParkingSpaceNumber]) VALUES (40, 0, 2, 40)
INSERT [dbo].[ParkingSpace] ([ParkingSpaceID], [ParkingSpaceSize], [ParksingSpaceMaxSize], [ParkingSpaceNumber]) VALUES (41, 0, 2, 41)
INSERT [dbo].[ParkingSpace] ([ParkingSpaceID], [ParkingSpaceSize], [ParksingSpaceMaxSize], [ParkingSpaceNumber]) VALUES (42, 0, 2, 42)
INSERT [dbo].[ParkingSpace] ([ParkingSpaceID], [ParkingSpaceSize], [ParksingSpaceMaxSize], [ParkingSpaceNumber]) VALUES (43, -4, 2, 43)
INSERT [dbo].[ParkingSpace] ([ParkingSpaceID], [ParkingSpaceSize], [ParksingSpaceMaxSize], [ParkingSpaceNumber]) VALUES (44, -2, 2, 44)
INSERT [dbo].[ParkingSpace] ([ParkingSpaceID], [ParkingSpaceSize], [ParksingSpaceMaxSize], [ParkingSpaceNumber]) VALUES (45, -2, 2, 45)
INSERT [dbo].[ParkingSpace] ([ParkingSpaceID], [ParkingSpaceSize], [ParksingSpaceMaxSize], [ParkingSpaceNumber]) VALUES (46, -2, 2, 46)
INSERT [dbo].[ParkingSpace] ([ParkingSpaceID], [ParkingSpaceSize], [ParksingSpaceMaxSize], [ParkingSpaceNumber]) VALUES (47, -2, 2, 47)
INSERT [dbo].[ParkingSpace] ([ParkingSpaceID], [ParkingSpaceSize], [ParksingSpaceMaxSize], [ParkingSpaceNumber]) VALUES (48, -2, 2, 48)
INSERT [dbo].[ParkingSpace] ([ParkingSpaceID], [ParkingSpaceSize], [ParksingSpaceMaxSize], [ParkingSpaceNumber]) VALUES (49, -4, 2, 49)
INSERT [dbo].[ParkingSpace] ([ParkingSpaceID], [ParkingSpaceSize], [ParksingSpaceMaxSize], [ParkingSpaceNumber]) VALUES (50, -4, 2, 50)
INSERT [dbo].[ParkingSpace] ([ParkingSpaceID], [ParkingSpaceSize], [ParksingSpaceMaxSize], [ParkingSpaceNumber]) VALUES (51, 0, 2, 51)
INSERT [dbo].[ParkingSpace] ([ParkingSpaceID], [ParkingSpaceSize], [ParksingSpaceMaxSize], [ParkingSpaceNumber]) VALUES (52, 0, 2, 52)
INSERT [dbo].[ParkingSpace] ([ParkingSpaceID], [ParkingSpaceSize], [ParksingSpaceMaxSize], [ParkingSpaceNumber]) VALUES (53, -4, 2, 53)
INSERT [dbo].[ParkingSpace] ([ParkingSpaceID], [ParkingSpaceSize], [ParksingSpaceMaxSize], [ParkingSpaceNumber]) VALUES (54, 0, 2, 54)
INSERT [dbo].[ParkingSpace] ([ParkingSpaceID], [ParkingSpaceSize], [ParksingSpaceMaxSize], [ParkingSpaceNumber]) VALUES (55, 2, 2, 55)
INSERT [dbo].[ParkingSpace] ([ParkingSpaceID], [ParkingSpaceSize], [ParksingSpaceMaxSize], [ParkingSpaceNumber]) VALUES (56, 1, 2, 56)
INSERT [dbo].[ParkingSpace] ([ParkingSpaceID], [ParkingSpaceSize], [ParksingSpaceMaxSize], [ParkingSpaceNumber]) VALUES (57, 0, 2, 57)
INSERT [dbo].[ParkingSpace] ([ParkingSpaceID], [ParkingSpaceSize], [ParksingSpaceMaxSize], [ParkingSpaceNumber]) VALUES (58, 0, 2, 58)
INSERT [dbo].[ParkingSpace] ([ParkingSpaceID], [ParkingSpaceSize], [ParksingSpaceMaxSize], [ParkingSpaceNumber]) VALUES (59, 0, 2, 59)
INSERT [dbo].[ParkingSpace] ([ParkingSpaceID], [ParkingSpaceSize], [ParksingSpaceMaxSize], [ParkingSpaceNumber]) VALUES (60, 0, 2, 60)
INSERT [dbo].[ParkingSpace] ([ParkingSpaceID], [ParkingSpaceSize], [ParksingSpaceMaxSize], [ParkingSpaceNumber]) VALUES (61, 0, 2, 61)
INSERT [dbo].[ParkingSpace] ([ParkingSpaceID], [ParkingSpaceSize], [ParksingSpaceMaxSize], [ParkingSpaceNumber]) VALUES (62, 0, 2, 62)
INSERT [dbo].[ParkingSpace] ([ParkingSpaceID], [ParkingSpaceSize], [ParksingSpaceMaxSize], [ParkingSpaceNumber]) VALUES (63, 0, 2, 63)
INSERT [dbo].[ParkingSpace] ([ParkingSpaceID], [ParkingSpaceSize], [ParksingSpaceMaxSize], [ParkingSpaceNumber]) VALUES (64, 0, 2, 64)
INSERT [dbo].[ParkingSpace] ([ParkingSpaceID], [ParkingSpaceSize], [ParksingSpaceMaxSize], [ParkingSpaceNumber]) VALUES (65, 0, 2, 65)
INSERT [dbo].[ParkingSpace] ([ParkingSpaceID], [ParkingSpaceSize], [ParksingSpaceMaxSize], [ParkingSpaceNumber]) VALUES (66, 1, 2, 66)
INSERT [dbo].[ParkingSpace] ([ParkingSpaceID], [ParkingSpaceSize], [ParksingSpaceMaxSize], [ParkingSpaceNumber]) VALUES (67, -4, 2, 67)
INSERT [dbo].[ParkingSpace] ([ParkingSpaceID], [ParkingSpaceSize], [ParksingSpaceMaxSize], [ParkingSpaceNumber]) VALUES (68, 0, 2, 68)
INSERT [dbo].[ParkingSpace] ([ParkingSpaceID], [ParkingSpaceSize], [ParksingSpaceMaxSize], [ParkingSpaceNumber]) VALUES (69, 0, 2, 69)
INSERT [dbo].[ParkingSpace] ([ParkingSpaceID], [ParkingSpaceSize], [ParksingSpaceMaxSize], [ParkingSpaceNumber]) VALUES (70, 0, 2, 70)
INSERT [dbo].[ParkingSpace] ([ParkingSpaceID], [ParkingSpaceSize], [ParksingSpaceMaxSize], [ParkingSpaceNumber]) VALUES (71, 2, 2, 71)
INSERT [dbo].[ParkingSpace] ([ParkingSpaceID], [ParkingSpaceSize], [ParksingSpaceMaxSize], [ParkingSpaceNumber]) VALUES (72, 0, 2, 72)
INSERT [dbo].[ParkingSpace] ([ParkingSpaceID], [ParkingSpaceSize], [ParksingSpaceMaxSize], [ParkingSpaceNumber]) VALUES (73, 0, 2, 73)
INSERT [dbo].[ParkingSpace] ([ParkingSpaceID], [ParkingSpaceSize], [ParksingSpaceMaxSize], [ParkingSpaceNumber]) VALUES (74, 1, 2, 74)
INSERT [dbo].[ParkingSpace] ([ParkingSpaceID], [ParkingSpaceSize], [ParksingSpaceMaxSize], [ParkingSpaceNumber]) VALUES (75, 0, 2, 75)
INSERT [dbo].[ParkingSpace] ([ParkingSpaceID], [ParkingSpaceSize], [ParksingSpaceMaxSize], [ParkingSpaceNumber]) VALUES (76, -4, 2, 76)
INSERT [dbo].[ParkingSpace] ([ParkingSpaceID], [ParkingSpaceSize], [ParksingSpaceMaxSize], [ParkingSpaceNumber]) VALUES (77, 0, 2, 77)
INSERT [dbo].[ParkingSpace] ([ParkingSpaceID], [ParkingSpaceSize], [ParksingSpaceMaxSize], [ParkingSpaceNumber]) VALUES (78, 0, 2, 78)
INSERT [dbo].[ParkingSpace] ([ParkingSpaceID], [ParkingSpaceSize], [ParksingSpaceMaxSize], [ParkingSpaceNumber]) VALUES (79, 0, 2, 79)
INSERT [dbo].[ParkingSpace] ([ParkingSpaceID], [ParkingSpaceSize], [ParksingSpaceMaxSize], [ParkingSpaceNumber]) VALUES (80, 0, 2, 80)
INSERT [dbo].[ParkingSpace] ([ParkingSpaceID], [ParkingSpaceSize], [ParksingSpaceMaxSize], [ParkingSpaceNumber]) VALUES (81, 1, 2, 81)
INSERT [dbo].[ParkingSpace] ([ParkingSpaceID], [ParkingSpaceSize], [ParksingSpaceMaxSize], [ParkingSpaceNumber]) VALUES (82, 0, 2, 82)
INSERT [dbo].[ParkingSpace] ([ParkingSpaceID], [ParkingSpaceSize], [ParksingSpaceMaxSize], [ParkingSpaceNumber]) VALUES (83, 2, 2, 83)
INSERT [dbo].[ParkingSpace] ([ParkingSpaceID], [ParkingSpaceSize], [ParksingSpaceMaxSize], [ParkingSpaceNumber]) VALUES (84, 0, 2, 84)
INSERT [dbo].[ParkingSpace] ([ParkingSpaceID], [ParkingSpaceSize], [ParksingSpaceMaxSize], [ParkingSpaceNumber]) VALUES (85, 0, 2, 85)
INSERT [dbo].[ParkingSpace] ([ParkingSpaceID], [ParkingSpaceSize], [ParksingSpaceMaxSize], [ParkingSpaceNumber]) VALUES (86, 0, 2, 86)
INSERT [dbo].[ParkingSpace] ([ParkingSpaceID], [ParkingSpaceSize], [ParksingSpaceMaxSize], [ParkingSpaceNumber]) VALUES (87, 2, 2, 87)
INSERT [dbo].[ParkingSpace] ([ParkingSpaceID], [ParkingSpaceSize], [ParksingSpaceMaxSize], [ParkingSpaceNumber]) VALUES (88, 0, 2, 88)
INSERT [dbo].[ParkingSpace] ([ParkingSpaceID], [ParkingSpaceSize], [ParksingSpaceMaxSize], [ParkingSpaceNumber]) VALUES (89, 0, 2, 89)
INSERT [dbo].[ParkingSpace] ([ParkingSpaceID], [ParkingSpaceSize], [ParksingSpaceMaxSize], [ParkingSpaceNumber]) VALUES (90, 0, 2, 90)
INSERT [dbo].[ParkingSpace] ([ParkingSpaceID], [ParkingSpaceSize], [ParksingSpaceMaxSize], [ParkingSpaceNumber]) VALUES (91, 0, 2, 91)
INSERT [dbo].[ParkingSpace] ([ParkingSpaceID], [ParkingSpaceSize], [ParksingSpaceMaxSize], [ParkingSpaceNumber]) VALUES (92, 0, 2, 92)
INSERT [dbo].[ParkingSpace] ([ParkingSpaceID], [ParkingSpaceSize], [ParksingSpaceMaxSize], [ParkingSpaceNumber]) VALUES (93, 0, 2, 93)
INSERT [dbo].[ParkingSpace] ([ParkingSpaceID], [ParkingSpaceSize], [ParksingSpaceMaxSize], [ParkingSpaceNumber]) VALUES (94, 0, 2, 94)
INSERT [dbo].[ParkingSpace] ([ParkingSpaceID], [ParkingSpaceSize], [ParksingSpaceMaxSize], [ParkingSpaceNumber]) VALUES (95, 0, 2, 95)
INSERT [dbo].[ParkingSpace] ([ParkingSpaceID], [ParkingSpaceSize], [ParksingSpaceMaxSize], [ParkingSpaceNumber]) VALUES (96, 0, 2, 96)
INSERT [dbo].[ParkingSpace] ([ParkingSpaceID], [ParkingSpaceSize], [ParksingSpaceMaxSize], [ParkingSpaceNumber]) VALUES (97, 0, 2, 97)
INSERT [dbo].[ParkingSpace] ([ParkingSpaceID], [ParkingSpaceSize], [ParksingSpaceMaxSize], [ParkingSpaceNumber]) VALUES (98, 0, 2, 98)
INSERT [dbo].[ParkingSpace] ([ParkingSpaceID], [ParkingSpaceSize], [ParksingSpaceMaxSize], [ParkingSpaceNumber]) VALUES (99, 0, 2, 99)
GO
INSERT [dbo].[ParkingSpace] ([ParkingSpaceID], [ParkingSpaceSize], [ParksingSpaceMaxSize], [ParkingSpaceNumber]) VALUES (100, 0, 2, 100)
SET IDENTITY_INSERT [dbo].[ParkingSpace] OFF
INSERT [dbo].[VehicleArchive] ([VehicleArchiveID], [RegistrationNumber], [ArrivalTime], [CheckOutTime], [TotalCost], [ParkingSpaceID], [VehicleTypeID]) VALUES (16, N'ABC123', CAST(N'2020-02-05T18:51:06.167' AS DateTime), CAST(N'2020-02-05T23:39:27.243' AS DateTime), 50.0000, 1, 2)
INSERT [dbo].[VehicleArchive] ([VehicleArchiveID], [RegistrationNumber], [ArrivalTime], [CheckOutTime], [TotalCost], [ParkingSpaceID], [VehicleTypeID]) VALUES (17, N'AwC123', CAST(N'2020-02-05T18:51:22.547' AS DateTime), CAST(N'2020-02-06T18:53:54.370' AS DateTime), 240.0000, 69, 2)
INSERT [dbo].[VehicleArchive] ([VehicleArchiveID], [RegistrationNumber], [ArrivalTime], [CheckOutTime], [TotalCost], [ParkingSpaceID], [VehicleTypeID]) VALUES (18, N'AwCÅ23', CAST(N'2020-02-05T18:51:38.730' AS DateTime), CAST(N'2020-02-06T19:35:55.433' AS DateTime), 0.0000, 2, 2)
INSERT [dbo].[VehicleArchive] ([VehicleArchiveID], [RegistrationNumber], [ArrivalTime], [CheckOutTime], [TotalCost], [ParkingSpaceID], [VehicleTypeID]) VALUES (19, N'AööÅ23', CAST(N'2020-02-05T18:51:52.727' AS DateTime), CAST(N'2020-02-06T19:46:11.900' AS DateTime), 500.0000, 3, 1)
INSERT [dbo].[VehicleArchive] ([VehicleArchiveID], [RegistrationNumber], [ArrivalTime], [CheckOutTime], [TotalCost], [ParkingSpaceID], [VehicleTypeID]) VALUES (21, N'Aö7723', CAST(N'2020-02-05T18:55:56.400' AS DateTime), CAST(N'2020-02-06T19:55:17.030' AS DateTime), 250.0000, 1, 2)
INSERT [dbo].[VehicleArchive] ([VehicleArchiveID], [RegistrationNumber], [ArrivalTime], [CheckOutTime], [TotalCost], [ParkingSpaceID], [VehicleTypeID]) VALUES (24, N'777723', CAST(N'2020-02-05T19:33:11.047' AS DateTime), CAST(N'2020-02-06T00:00:09.680' AS DateTime), 50.0000, 4, 2)
INSERT [dbo].[VehicleArchive] ([VehicleArchiveID], [RegistrationNumber], [ArrivalTime], [CheckOutTime], [TotalCost], [ParkingSpaceID], [VehicleTypeID]) VALUES (27, N'753723', CAST(N'2020-02-05T19:33:33.460' AS DateTime), CAST(N'2020-02-05T23:19:32.500' AS DateTime), 30.0000, 4, 2)
INSERT [dbo].[VehicleArchive] ([VehicleArchiveID], [RegistrationNumber], [ArrivalTime], [CheckOutTime], [TotalCost], [ParkingSpaceID], [VehicleTypeID]) VALUES (30, N'7512683', CAST(N'2020-02-05T19:33:55.020' AS DateTime), CAST(N'2020-02-06T19:13:57.623' AS DateTime), 480.0000, 4, 1)
INSERT [dbo].[VehicleArchive] ([VehicleArchiveID], [RegistrationNumber], [ArrivalTime], [CheckOutTime], [TotalCost], [ParkingSpaceID], [VehicleTypeID]) VALUES (48, N'758883', CAST(N'2020-02-05T20:12:16.560' AS DateTime), CAST(N'2020-02-05T23:05:55.673' AS DateTime), 40.0000, 7, 1)
INSERT [dbo].[VehicleArchive] ([VehicleArchiveID], [RegistrationNumber], [ArrivalTime], [CheckOutTime], [TotalCost], [ParkingSpaceID], [VehicleTypeID]) VALUES (55, N'0123456789', CAST(N'2020-02-06T11:17:13.477' AS DateTime), CAST(N'2020-02-06T19:15:26.570' AS DateTime), 0.0000, 5, 1)
INSERT [dbo].[VehicleArchive] ([VehicleArchiveID], [RegistrationNumber], [ArrivalTime], [CheckOutTime], [TotalCost], [ParkingSpaceID], [VehicleTypeID]) VALUES (57, N'BIL123', CAST(N'2020-02-06T19:57:55.947' AS DateTime), CAST(N'2020-02-06T20:05:44.713' AS DateTime), 40.0000, 1, 1)
INSERT [dbo].[VehicleArchive] ([VehicleArchiveID], [RegistrationNumber], [ArrivalTime], [CheckOutTime], [TotalCost], [ParkingSpaceID], [VehicleTypeID]) VALUES (58, N'BIL124', CAST(N'2020-02-06T19:57:55.963' AS DateTime), CAST(N'2020-02-06T21:55:55.910' AS DateTime), 40.0000, 2, 1)
INSERT [dbo].[VehicleArchive] ([VehicleArchiveID], [RegistrationNumber], [ArrivalTime], [CheckOutTime], [TotalCost], [ParkingSpaceID], [VehicleTypeID]) VALUES (59, N'BIL125', CAST(N'2020-02-06T19:57:55.963' AS DateTime), CAST(N'2020-02-06T21:57:24.973' AS DateTime), 40.0000, 3, 1)
INSERT [dbo].[VehicleArchive] ([VehicleArchiveID], [RegistrationNumber], [ArrivalTime], [CheckOutTime], [TotalCost], [ParkingSpaceID], [VehicleTypeID]) VALUES (60, N'BIL126', CAST(N'2020-02-06T19:57:55.963' AS DateTime), CAST(N'2020-02-06T22:06:46.550' AS DateTime), 60.0000, 4, 1)
INSERT [dbo].[VehicleArchive] ([VehicleArchiveID], [RegistrationNumber], [ArrivalTime], [CheckOutTime], [TotalCost], [ParkingSpaceID], [VehicleTypeID]) VALUES (70, N'BIL1288', CAST(N'2020-02-06T20:23:26.027' AS DateTime), CAST(N'2020-02-06T20:23:30.550' AS DateTime), 0.0000, 1, 1)
INSERT [dbo].[VehicleArchive] ([VehicleArchiveID], [RegistrationNumber], [ArrivalTime], [CheckOutTime], [TotalCost], [ParkingSpaceID], [VehicleTypeID]) VALUES (71, N'MC23334', CAST(N'2020-02-06T20:28:49.413' AS DateTime), CAST(N'2020-02-06T22:13:58.433' AS DateTime), 20.0000, 1, 2)
INSERT [dbo].[VehicleArchive] ([VehicleArchiveID], [RegistrationNumber], [ArrivalTime], [CheckOutTime], [TotalCost], [ParkingSpaceID], [VehicleTypeID]) VALUES (72, N'MC23335', CAST(N'2020-02-06T20:28:49.430' AS DateTime), CAST(N'2020-02-06T22:15:42.740' AS DateTime), 20.0000, 1, 2)
INSERT [dbo].[VehicleArchive] ([VehicleArchiveID], [RegistrationNumber], [ArrivalTime], [CheckOutTime], [TotalCost], [ParkingSpaceID], [VehicleTypeID]) VALUES (73, N'MC23338', CAST(N'2020-02-06T20:28:49.430' AS DateTime), CAST(N'2020-02-07T08:54:31.083' AS DateTime), 0.0000, 5, 2)
INSERT [dbo].[VehicleArchive] ([VehicleArchiveID], [RegistrationNumber], [ArrivalTime], [CheckOutTime], [TotalCost], [ParkingSpaceID], [VehicleTypeID]) VALUES (74, N'MC23337', CAST(N'2020-02-06T20:28:49.430' AS DateTime), CAST(N'2020-02-08T01:37:09.320' AS DateTime), 300.0000, 5, 2)
INSERT [dbo].[VehicleArchive] ([VehicleArchiveID], [RegistrationNumber], [ArrivalTime], [CheckOutTime], [TotalCost], [ParkingSpaceID], [VehicleTypeID]) VALUES (75, N'MC23336', CAST(N'2020-02-06T20:28:49.430' AS DateTime), CAST(N'2020-02-08T01:38:35.973' AS DateTime), 300.0000, 6, 2)
INSERT [dbo].[VehicleArchive] ([VehicleArchiveID], [RegistrationNumber], [ArrivalTime], [CheckOutTime], [TotalCost], [ParkingSpaceID], [VehicleTypeID]) VALUES (76, N'MC233311', CAST(N'2020-02-06T20:28:49.430' AS DateTime), CAST(N'2020-02-08T01:46:16.057' AS DateTime), 300.0000, 6, 2)
INSERT [dbo].[VehicleArchive] ([VehicleArchiveID], [RegistrationNumber], [ArrivalTime], [CheckOutTime], [TotalCost], [ParkingSpaceID], [VehicleTypeID]) VALUES (77, N'MC23224', CAST(N'2020-02-06T20:28:49.430' AS DateTime), CAST(N'2020-02-07T08:49:29.970' AS DateTime), 130.0000, 7, 2)
INSERT [dbo].[VehicleArchive] ([VehicleArchiveID], [RegistrationNumber], [ArrivalTime], [CheckOutTime], [TotalCost], [ParkingSpaceID], [VehicleTypeID]) VALUES (78, N'MC24434', CAST(N'2020-02-06T20:28:49.430' AS DateTime), CAST(N'2020-02-06T22:12:46.720' AS DateTime), 20.0000, 7, 2)
INSERT [dbo].[VehicleArchive] ([VehicleArchiveID], [RegistrationNumber], [ArrivalTime], [CheckOutTime], [TotalCost], [ParkingSpaceID], [VehicleTypeID]) VALUES (79, N'MC27774', CAST(N'2020-02-06T20:28:49.433' AS DateTime), CAST(N'2020-02-07T08:58:55.400' AS DateTime), 0.0000, 8, 2)
INSERT [dbo].[VehicleArchive] ([VehicleArchiveID], [RegistrationNumber], [ArrivalTime], [CheckOutTime], [TotalCost], [ParkingSpaceID], [VehicleTypeID]) VALUES (80, N'MC334', CAST(N'2020-02-06T20:28:49.433' AS DateTime), CAST(N'2020-02-06T22:08:12.130' AS DateTime), 20.0000, 8, 2)
INSERT [dbo].[VehicleArchive] ([VehicleArchiveID], [RegistrationNumber], [ArrivalTime], [CheckOutTime], [TotalCost], [ParkingSpaceID], [VehicleTypeID]) VALUES (81, N'CAR12344', CAST(N'2020-02-07T11:50:14.247' AS DateTime), CAST(N'2020-02-08T01:32:03.007' AS DateTime), 280.0000, 1, 1)
INSERT [dbo].[VehicleArchive] ([VehicleArchiveID], [RegistrationNumber], [ArrivalTime], [CheckOutTime], [TotalCost], [ParkingSpaceID], [VehicleTypeID]) VALUES (82, N'ABC123', CAST(N'2020-02-07T23:12:53.463' AS DateTime), CAST(N'2020-02-08T01:21:55.067' AS DateTime), 60.0000, 2, 1)
INSERT [dbo].[VehicleArchive] ([VehicleArchiveID], [RegistrationNumber], [ArrivalTime], [CheckOutTime], [TotalCost], [ParkingSpaceID], [VehicleTypeID]) VALUES (83, N'123BBBC', CAST(N'2020-02-07T23:13:03.650' AS DateTime), CAST(N'2020-02-08T01:34:44.973' AS DateTime), 60.0000, 3, 1)
INSERT [dbo].[VehicleArchive] ([VehicleArchiveID], [RegistrationNumber], [ArrivalTime], [CheckOutTime], [TotalCost], [ParkingSpaceID], [VehicleTypeID]) VALUES (91, N'123FFF', CAST(N'2020-02-07T23:50:41.383' AS DateTime), CAST(N'2020-02-08T01:30:03.503' AS DateTime), 20.0000, 5, 2)
INSERT [dbo].[VehicleArchive] ([VehicleArchiveID], [RegistrationNumber], [ArrivalTime], [CheckOutTime], [TotalCost], [ParkingSpaceID], [VehicleTypeID]) VALUES (92, N'ACB123', CAST(N'2020-02-08T00:02:26.677' AS DateTime), CAST(N'2020-02-08T01:26:27.293' AS DateTime), 20.0000, 4, 2)
INSERT [dbo].[VehicleArchive] ([VehicleArchiveID], [RegistrationNumber], [ArrivalTime], [CheckOutTime], [TotalCost], [ParkingSpaceID], [VehicleTypeID]) VALUES (93, N'ABC123222', CAST(N'2020-02-08T00:03:40.013' AS DateTime), CAST(N'2020-02-08T01:57:54.707' AS DateTime), 0.0000, 7, 1)
INSERT [dbo].[VehicleArchive] ([VehicleArchiveID], [RegistrationNumber], [ArrivalTime], [CheckOutTime], [TotalCost], [ParkingSpaceID], [VehicleTypeID]) VALUES (94, N'123123123', CAST(N'2020-02-08T00:04:16.380' AS DateTime), CAST(N'2020-02-09T11:54:43.520' AS DateTime), 0.0000, 1, 2)
INSERT [dbo].[VehicleArchive] ([VehicleArchiveID], [RegistrationNumber], [ArrivalTime], [CheckOutTime], [TotalCost], [ParkingSpaceID], [VehicleTypeID]) VALUES (95, N'UZU840', CAST(N'2020-02-08T00:04:47.877' AS DateTime), CAST(N'2020-02-08T01:24:21.460' AS DateTime), 40.0000, 8, 1)
INSERT [dbo].[VehicleArchive] ([VehicleArchiveID], [RegistrationNumber], [ArrivalTime], [CheckOutTime], [TotalCost], [ParkingSpaceID], [VehicleTypeID]) VALUES (96, N'ABC123', CAST(N'2020-02-08T01:34:02.303' AS DateTime), CAST(N'2020-02-08T12:04:05.513' AS DateTime), 0.0000, 1, 1)
INSERT [dbo].[VehicleArchive] ([VehicleArchiveID], [RegistrationNumber], [ArrivalTime], [CheckOutTime], [TotalCost], [ParkingSpaceID], [VehicleTypeID]) VALUES (98, N'FCJ355', CAST(N'2020-02-08T02:24:48.040' AS DateTime), CAST(N'2020-02-08T13:18:06.647' AS DateTime), 0.0000, 3, 1)
INSERT [dbo].[VehicleArchive] ([VehicleArchiveID], [RegistrationNumber], [ArrivalTime], [CheckOutTime], [TotalCost], [ParkingSpaceID], [VehicleTypeID]) VALUES (101, N'プログラマー', CAST(N'2020-02-08T02:25:46.853' AS DateTime), CAST(N'2020-02-08T02:27:25.273' AS DateTime), 0.0000, 6, 1)
INSERT [dbo].[VehicleArchive] ([VehicleArchiveID], [RegistrationNumber], [ArrivalTime], [CheckOutTime], [TotalCost], [ParkingSpaceID], [VehicleTypeID]) VALUES (109, N'ifnweqif', CAST(N'2020-02-08T10:47:11.763' AS DateTime), CAST(N'2020-02-09T01:46:05.410' AS DateTime), 0.0000, 7, 1)
INSERT [dbo].[VehicleArchive] ([VehicleArchiveID], [RegistrationNumber], [ArrivalTime], [CheckOutTime], [TotalCost], [ParkingSpaceID], [VehicleTypeID]) VALUES (112, N'ggff22', CAST(N'2020-02-08T10:58:00.400' AS DateTime), CAST(N'2020-02-09T01:45:53.377' AS DateTime), 150.0000, 10, 2)
INSERT [dbo].[VehicleArchive] ([VehicleArchiveID], [RegistrationNumber], [ArrivalTime], [CheckOutTime], [TotalCost], [ParkingSpaceID], [VehicleTypeID]) VALUES (113, N'gewkng', CAST(N'2020-02-08T10:58:05.527' AS DateTime), CAST(N'2020-02-09T11:55:20.387' AS DateTime), 250.0000, 32, 2)
INSERT [dbo].[VehicleArchive] ([VehicleArchiveID], [RegistrationNumber], [ArrivalTime], [CheckOutTime], [TotalCost], [ParkingSpaceID], [VehicleTypeID]) VALUES (114, N'awfa', CAST(N'2020-02-08T23:52:15.633' AS DateTime), CAST(N'2020-02-09T11:54:28.990' AS DateTime), 120.0000, 1, 2)
INSERT [dbo].[VehicleArchive] ([VehicleArchiveID], [RegistrationNumber], [ArrivalTime], [CheckOutTime], [TotalCost], [ParkingSpaceID], [VehicleTypeID]) VALUES (116, N'MC401', CAST(N'2020-02-08T23:53:30.590' AS DateTime), CAST(N'2020-02-09T12:24:35.063' AS DateTime), 130.0000, 4, 2)
INSERT [dbo].[VehicleArchive] ([VehicleArchiveID], [RegistrationNumber], [ArrivalTime], [CheckOutTime], [TotalCost], [ParkingSpaceID], [VehicleTypeID]) VALUES (130, N'CAR789', CAST(N'2020-02-09T01:41:20.467' AS DateTime), CAST(N'2020-02-09T01:41:28.837' AS DateTime), 0.0000, 17, 1)
INSERT [dbo].[VehicleArchive] ([VehicleArchiveID], [RegistrationNumber], [ArrivalTime], [CheckOutTime], [TotalCost], [ParkingSpaceID], [VehicleTypeID]) VALUES (133, N'GFD123', CAST(N'2020-11-15T00:00:00.000' AS DateTime), CAST(N'2020-02-09T12:14:09.813' AS DateTime), 0.0000, 43, 1)
INSERT [dbo].[VehicleArchive] ([VehicleArchiveID], [RegistrationNumber], [ArrivalTime], [CheckOutTime], [TotalCost], [ParkingSpaceID], [VehicleTypeID]) VALUES (139, N'FF321', CAST(N'2020-11-15T00:00:00.000' AS DateTime), CAST(N'2020-02-09T12:14:21.177' AS DateTime), 0.0000, 49, 1)
INSERT [dbo].[VehicleArchive] ([VehicleArchiveID], [RegistrationNumber], [ArrivalTime], [CheckOutTime], [TotalCost], [ParkingSpaceID], [VehicleTypeID]) VALUES (140, N'FD2124', CAST(N'2020-11-15T00:00:00.000' AS DateTime), CAST(N'2020-02-09T12:14:32.547' AS DateTime), 0.0000, 50, 1)
INSERT [dbo].[VehicleArchive] ([VehicleArchiveID], [RegistrationNumber], [ArrivalTime], [CheckOutTime], [TotalCost], [ParkingSpaceID], [VehicleTypeID]) VALUES (141, N'GF3123', CAST(N'2020-11-15T00:00:00.000' AS DateTime), CAST(N'2020-02-09T12:14:39.330' AS DateTime), 0.0000, 53, 1)
INSERT [dbo].[VehicleArchive] ([VehicleArchiveID], [RegistrationNumber], [ArrivalTime], [CheckOutTime], [TotalCost], [ParkingSpaceID], [VehicleTypeID]) VALUES (142, N'GFD533', CAST(N'2020-11-15T00:00:00.000' AS DateTime), CAST(N'2020-02-09T12:14:59.517' AS DateTime), 0.0000, 76, 1)
INSERT [dbo].[VehicleArchive] ([VehicleArchiveID], [RegistrationNumber], [ArrivalTime], [CheckOutTime], [TotalCost], [ParkingSpaceID], [VehicleTypeID]) VALUES (143, N'GAA621', CAST(N'2020-11-15T00:00:00.000' AS DateTime), CAST(N'2020-02-09T12:14:49.230' AS DateTime), 0.0000, 67, 1)
INSERT [dbo].[VehicleArchive] ([VehicleArchiveID], [RegistrationNumber], [ArrivalTime], [CheckOutTime], [TotalCost], [ParkingSpaceID], [VehicleTypeID]) VALUES (155, N'afafaw', CAST(N'2020-02-09T12:23:35.787' AS DateTime), CAST(N'2020-02-09T12:24:12.630' AS DateTime), 0.0000, 27, 1)
INSERT [dbo].[VehicleArchive] ([VehicleArchiveID], [RegistrationNumber], [ArrivalTime], [CheckOutTime], [TotalCost], [ParkingSpaceID], [VehicleTypeID]) VALUES (157, N'wgewgwege', CAST(N'2020-02-09T12:26:04.390' AS DateTime), CAST(N'2020-02-09T12:26:18.507' AS DateTime), 0.0000, 4, 2)
SET IDENTITY_INSERT [dbo].[VehicleType] ON 

INSERT [dbo].[VehicleType] ([VehicleTypeID], [VehicleType], [Size], [Price]) VALUES (1, N'Car', 2, 20.0000)
INSERT [dbo].[VehicleType] ([VehicleTypeID], [VehicleType], [Size], [Price]) VALUES (2, N'MotorCycle', 1, 10.0000)
INSERT [dbo].[VehicleType] ([VehicleTypeID], [VehicleType], [Size], [Price]) VALUES (3, N'Truck', 3, 30.0000)
SET IDENTITY_INSERT [dbo].[VehicleType] OFF
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__ParkedVe__E88646020F05D53B]    Script Date: 2020-02-09 17:56:08 ******/
ALTER TABLE [dbo].[ParkedVehicle] ADD UNIQUE NONCLUSTERED 
(
	[RegistrationNumber] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__ParkedVe__E8864602C14C1668]    Script Date: 2020-02-09 17:56:08 ******/
ALTER TABLE [dbo].[ParkedVehicle] ADD UNIQUE NONCLUSTERED 
(
	[RegistrationNumber] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ParkedVehicle]  WITH CHECK ADD  CONSTRAINT [FK_ParkingSpace] FOREIGN KEY([ParkingspaceID])
REFERENCES [dbo].[ParkingSpace] ([ParkingSpaceID])
GO
ALTER TABLE [dbo].[ParkedVehicle] CHECK CONSTRAINT [FK_ParkingSpace]
GO
ALTER TABLE [dbo].[ParkedVehicle]  WITH CHECK ADD  CONSTRAINT [FK_VehicleType] FOREIGN KEY([VehicleTypeID])
REFERENCES [dbo].[VehicleType] ([VehicleTypeID])
GO
ALTER TABLE [dbo].[ParkedVehicle] CHECK CONSTRAINT [FK_VehicleType]
GO
ALTER TABLE [dbo].[ParkedVehicle]  WITH CHECK ADD  CONSTRAINT [CHECK_RegistrationNumber] CHECK  ((len([RegistrationNumber])>=(3)))
GO
ALTER TABLE [dbo].[ParkedVehicle] CHECK CONSTRAINT [CHECK_RegistrationNumber]
GO
ALTER TABLE [dbo].[ParkingSpace]  WITH CHECK ADD  CONSTRAINT [CHECK_Location] CHECK  (([ParkingSpaceNumber]<=(100)))
GO
ALTER TABLE [dbo].[ParkingSpace] CHECK CONSTRAINT [CHECK_Location]
GO
/****** Object:  StoredProcedure [dbo].[USP_AddVehicle]    Script Date: 2020-02-09 17:56:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[USP_AddVehicle] (@RegistrationNumber nvarchar (20), @VehicleType int)
AS

BEGIN TRANSACTION

DECLARE @Size int
SET @Size = (SELECT size FROM VehicleType WHERE @VehicleType = VehicleTypeID)

DECLARE @FirstParkingSpace int 
SET @FirstParkingSpace = dbo.FindFreeParking(@Size)


IF (@FirstParkingSpace > 0)
BEGIN
INSERT INTO ParkedVehicle (RegistrationNumber, ArrivalParkTime, ParkingspaceID, VehicleTypeID) VALUES (@RegistrationNumber, GETDATE(), dbo.FindFreeParking(@Size), @VehicleType)
IF @@ERROR = 0
BEGIN
UPDATE ParkingSpace 
SET ParkingSpaceSize = ParkingSpaceSize + @Size 
WHERE ParkingSpaceID = @FirstParkingSpace;

COMMIT TRANSACTION

END
ELSE
BEGIN
ROLLBACK TRANSACTION
END

return @FirstParkingSpace

END

GO
/****** Object:  StoredProcedure [dbo].[USP_CalculateIncomeFromPastDateToPastDate]    Script Date: 2020-02-09 17:56:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_CalculateIncomeFromPastDateToPastDate] (@StartSearchDate Datetime, @EndDate DATETIME)
AS
BEGIN

SELECT CAST(VA.CheckOutTime AS date) AS [DAY], SUM(VA.TotalCost) AS [Daily Income] FROM VehicleArchive VA
WHERE CAST(VA.CheckOutTime AS date) >= @StartSearchDate AND CAST(VA.CheckOutTime AS date) <= @EndDate
GROUP BY CAST(VA.CheckOutTime AS date)

END
GO
/****** Object:  StoredProcedure [dbo].[USP_CalculateIncomeFromTodayToPastDate]    Script Date: 2020-02-09 17:56:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_CalculateIncomeFromTodayToPastDate] (@StartSearchDate Datetime)
AS
BEGIN

SELECT CAST(VA.CheckOutTime AS date) AS [DAY], SUM(VA.TotalCost) AS [Daily Income] FROM VehicleArchive VA
WHERE CAST(VA.CheckOutTime AS date) >= @StartSearchDate 
GROUP BY CAST(VA.CheckOutTime AS date)

END
GO
/****** Object:  StoredProcedure [dbo].[USP_GetAllEmptyParkingSpaces]    Script Date: 2020-02-09 17:56:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_GetAllEmptyParkingSpaces]
AS
BEGIN

SELECT PS.ParkingspaceID FROM ParkingSpace PS
LEFT OUTER JOIN ParkedVehicle PV
ON PS.ParkingSpaceID = PV.ParkingspaceID
WHERE PV.ParkingspaceID IS NULL
ORDER BY PS.ParkingSpaceID

END
GO
/****** Object:  StoredProcedure [dbo].[USP_GetFullParkingSpaceHistory]    Script Date: 2020-02-09 17:56:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_GetFullParkingSpaceHistory]
AS
BEGIN

SELECT VA.RegistrationNumber, 

FORMAT(VA.ArrivalTime, 'yyyy-MM-dd HH:mm:ss'),

FORMAT(VA.CheckOutTime, 'yyyy-MM-dd HH:mm:ss'),
CONCAT(CONVERT(nvarchar(255), 
FLOOR(DATEDIFF(Minute, VA.ArrivalTime, GETDATE())/60)), ' Hours ',CONVERT(nvarchar(255),
FLOOR(DATEDIFF(Minute, VA.ArrivalTime, GETDATE())%60)), ' Minutes ') AS [Time parked] 
FROM VehicleArchive VA

END
GO
/****** Object:  StoredProcedure [dbo].[USP_MoveVehicle]    Script Date: 2020-02-09 17:56:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[USP_MoveVehicle](@RegistrationNumber nvarchar(10), @SpecificParkingSpot int)
AS
BEGIN
DECLARE @Size int
SET @Size = (SELECT VT.Size FROM ParkedVehicle PV JOIN VehicleType VT ON VT.VehicleTypeID = PV.VehicleTypeID WHERE PV.RegistrationNumber = @RegistrationNumber)

SET @SpecificParkingSpot = dbo.FindSpecificFreeParking(@Size,@SpecificParkingSpot)

If @SpecificParkingSpot > 0
BEGIN
UPDATE ParkedVehicle
SET ParkingspaceID = @SpecificParkingSpot
WHERE RegistrationNumber = @RegistrationNumber
END

DECLARE @OldParkingSpot int
SET @OldParkingSpot = (SELECT TOP 1 WOR.MoveFromParkingSpace FROM WorkOrderRecipt WOR WHERE WOR.VehicleRegistrationNumber = @RegistrationNumber)

return @OldParkingSpot

END
GO
/****** Object:  StoredProcedure [dbo].[USP_OptimizeParking]    Script Date: 2020-02-09 17:56:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_OptimizeParking]
AS
BEGIN

DECLARE @LastParkedVehicleIDChecked int
SET @LastParkedVehicleIDChecked = 0

DECLARE @NewSpot int 
DECLARE @OldSpot int
DECLARE @VehicleID int
DECLARE @VehicleSize int


WHILE (@LastParkedVehicleIDChecked < (SELECT TOP 1 ParkedVehicleID FROM ParkedVehicle ORDER BY ParkedVehicleID DESC))
BEGIN

SET @VehicleID = (SELECT top 1 PV.ParkedVehicleID FROM ParkedVehicle PV WHERE PV.ParkedVehicleID > @LastParkedVehicleIDChecked)

SET @OldSpot = (SELECT PS.ParkingSpaceID FROM ParkedVehicle PV JOIN ParkingSpace PS ON PV.ParkingspaceID = PS.ParkingSpaceID WHERE @VehicleID = PV.ParkedVehicleID)

SET  @VehicleSize = (SELECT VT.Size FROM ParkedVehicle PV JOIN VehicleType VT ON VT.VehicleTypeID = PV.VehicleTypeID WHERE @VehicleID = PV.ParkedVehicleID)

SET @NewSpot = dbo.FindFreeParking(@VehicleSize)
 
IF @NewSpot > 0 AND @OldSpot > @NewSpot
	BEGIN
	UPDATE ParkedVehicle
	SET ParkingspaceID = @NewSpot
	WHERE @VehicleID = ParkedVehicleID
	END


SET @LastParkedVehicleIDChecked = @VehicleID
END

END
GO
/****** Object:  StoredProcedure [dbo].[USP_OptimizeParkingMC]    Script Date: 2020-02-09 17:56:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_OptimizeParkingMC]
AS
BEGIN

DECLARE @LastParkedVehicleIDChecked int
SET @LastParkedVehicleIDChecked = 0

DECLARE @NewSpot int 
DECLARE @OldSpot int
DECLARE @VehicleID int
DECLARE @VehicleSize int


WHILE (@LastParkedVehicleIDChecked < (SELECT TOP 1 PV.ParkedVehicleID FROM ParkedVehicle PV WHERE PV.VehicleTypeID  = '2' ORDER BY ParkedVehicleID DESC))
BEGIN

SET @VehicleID = (SELECT top 1 PV.ParkedVehicleID FROM ParkedVehicle PV WHERE PV.ParkedVehicleID > @LastParkedVehicleIDChecked AND PV.VehicleTypeID  = '2')

SET @OldSpot = (SELECT PS.ParkingSpaceID FROM ParkedVehicle PV JOIN ParkingSpace PS ON PV.ParkingspaceID = PS.ParkingSpaceID WHERE @VehicleID = PV.ParkedVehicleID)

SET  @VehicleSize = (SELECT VT.Size FROM ParkedVehicle PV JOIN VehicleType VT ON VT.VehicleTypeID = PV.VehicleTypeID WHERE @VehicleID = PV.ParkedVehicleID)

SET @NewSpot = dbo.FindFreeParking(@VehicleSize)
 
IF @NewSpot > 0 AND @OldSpot > @NewSpot
	BEGIN
	UPDATE ParkedVehicle
	SET ParkingspaceID = @NewSpot
	WHERE @VehicleID = ParkedVehicleID
	END


SET @LastParkedVehicleIDChecked = @VehicleID
END

END
GO
/****** Object:  StoredProcedure [dbo].[USP_RemoveVehicle]    Script Date: 2020-02-09 17:56:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_RemoveVehicle] (@RegistrationNumber nvarchar(10))
AS
SET NOCOUNT OFF
BEGIN TRANSACTION
DELETE FROM ParkedVehicle WHERE RegistrationNumber = @RegistrationNumber
if @@ROWCOUNT = 0
BEGIN
ROLLBACK TRANSACTION
END
ELSE
BEGIN
COMMIT TRANSACTION
END

GO
/****** Object:  StoredProcedure [dbo].[USP_RemoveVehicleForFree]    Script Date: 2020-02-09 17:56:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[USP_RemoveVehicleForFree] (@RegistrationNumber nvarchar(10))
AS
BEGIN

BEGIN TRANSACTION
DELETE FROM ParkedVehicle WHERE RegistrationNumber = @RegistrationNumber

if @@ROWCOUNT != 0 AND @@ERROR = 0
BEGIN
COMMIT TRANSACTION
UPDATE VehicleArchive
SET TotalCost = 0
WHERE VehicleArchiveID = (SELECT TOP 1 VehicleArchiveID FROM VehicleArchive WHERE RegistrationNumber = @RegistrationNumber ORDER BY VehicleArchiveID DESC)
END

ELSE
BEGIN
ROLLBACK TRANSACTION
END




END
GO
/****** Object:  StoredProcedure [dbo].[USP_SearchForSpecificVehicle]    Script Date: 2020-02-09 17:56:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_SearchForSpecificVehicle] (@RegistrationNumber nvarchar(10))
AS
BEGIN

DECLARE @ParkedTotalTime decimal(38,2) 
SET @ParkedTotalTime = DATEDIFF(minute, (SELECT PV.ArrivalParkTime FROM ParkedVehicle PV WHERE RegistrationNumber = @RegistrationNumber), GETDATE())

SELECT PV.RegistrationNumber, PV.ArrivalParkTime, 
FLOOR(@ParkedTotalTime/60) AS [Parked Hours], 
FLOOR(@ParkedTotalTime%60) AS [Parked Minutes], 
dbo.CalculateParkingCost(PV.ArrivalParkTime, GETDATE(), PV.VehicleTypeID) AS [Total Cost], 
VT.VehicleType, PS.ParkingSpaceNumber 

FROM ParkedVehicle PV JOIN ParkingSpace PS ON PV.ParkingspaceID = PS.ParkingSpaceID JOIN VehicleType VT ON VT.VehicleTypeID = PV.VehicleTypeID WHERE RegistrationNumber = @RegistrationNumber

END
GO
/****** Object:  StoredProcedure [dbo].[USP_SeeEntireParkingLot]    Script Date: 2020-02-09 17:56:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_SeeEntireParkingLot]
AS
BEGIN

SELECT COALESCE(PS.ParkingspaceID, '') AS [Parking Spot Number], COALESCE(STRING_AGG(PV.RegistrationNumber, ' - '), '') AS [Registration Numbers], COALESCE(STRING_AGG(VT.VehicleType, ' - '), '') AS [VehicleType]
FROM ParkedVehicle PV 
FULL JOIN ParkingSpace PS ON PS.ParkingSpaceID = PV.ParkingspaceID 
LEFT OUTER JOIN VehicleType VT ON VT.VehicleTypeID = PV.VehicleTypeID GROUP BY PS.ParkingspaceID 

END
GO
/****** Object:  StoredProcedure [dbo].[USP_SeeVehiclesParkedMoreThanTwoDays]    Script Date: 2020-02-09 17:56:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[USP_SeeVehiclesParkedMoreThanTwoDays]
AS
BEGIN
SELECT 
PV.RegistrationNumber AS [Registration Number], 
PV.ParkingspaceID AS [Parking Lot], CONCAT(
CONVERT(nvarchar(255), FLOOR(DATEDIFF(Minute, PV.ArrivalParkTime, GETDATE())/60)), ' Hours ',
CONVERT(nvarchar(255),FLOOR(DATEDIFF(Minute, PV.ArrivalParkTime, GETDATE())%60)), ' Minutes '
) AS [Time parked so far] FROM ParkedVehicle PV WHERE DATEDIFF(minute, PV.ArrivalParkTime, GETDATE()) > 2880

END
GO
