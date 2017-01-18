/*Kelly Truong Phase 1 --Part A*/
CREATE DATABASE TruongKellyProject
ON PRIMARY (
	NAME = 'TruongKellyProjectPrimary1',
	FILENAME = 'C:\CSCProjectsS16\TruongKellyProject.mdf',
	SIZE = 20MB,
	MAXSIZE = 30MB
),
(
	NAME = 'TruongKellyProjectPrimary2',
	FILENAME = 'C:\CSCProjectsS16\TruongKellyProject.ndf',
	SIZE = 20MB,
	MAXSIZE = 30MB
),

FILEGROUP TruongKellySecondary (
	NAME = 'TruongKellyProjectSecondary',
	FILENAME = 'C:\CSCProjectsS16\TruongKellyProjectSecondary.ndf',
	SIZE = 500KB,
	MAXSIZE = 10MB,
	FILEGROWTH = 1MB
)

LOG ON (
	NAME = 'TruongKellyProjectLog',
	FILENAME = 'C:\CSCProjectsS16\TruongKellyProjectLog.ldf',
	SIZE = 10MB,
	MAXSIZE = 20MB,
	FILEGROWTH =10%
)
GO
/*Phase 1 --Part B*/
ALTER DATABASE TruongKellyProject
ADD FILE (
	NAME = 'TruongKellyProjectSecondaryFeatures',
	FILENAME = 'C:\CSCProjectsS16\TruongKellyProjectSecondaryFeatures.ndf',
	SIZE = 500KB,
	MAXSIZE = 10MB,
	FILEGROWTH = 1MB
)
TO FILEGROUP [PRIMARY]

ALTER DATABASE TruongKellyProject
MODIFY FILEGROUP TruongKellySecondary DEFAULT

ALTER DATABASE TruongKellyProject
SET RECOVERY FULL

ALTER DATABASE TruongKellyProject
SET ANSI_NULL_DEFAULT ON

USE TruongKellyProject;
GO
/*Phase 1 --Part C*/
CREATE TABLE Manufacturer (
	ManuID INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
	ManuName VARCHAR(45) NOT NULL,
	ManuMainLocation VARCHAR(45) NOT NULL,
	ManuOtherLocations VARCHAR(MAX)
)

CREATE TABLE ProductType (
	ProdTypeID INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
	ProdTypeDescription VARCHAR(MAX),
	IsSeasonal BIT,
	IsMultiPart BIT
)

CREATE TABLE Manufacturer_makes_ProductType (
	MmPID INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
	Manufacturer_ManuID INT NOT NULL CHECK (Manufacturer_ManuID > 0),
	ProductType_ProdTypeID INT NOT NULL CHECK (ProductType_ProdTypeID > 0)
)
ALTER TABLE Manufacturer_makes_ProductType 
ADD FOREIGN KEY (Manufacturer_ManuID) REFERENCES Manufacturer(ManuID);
ALTER TABLE Manufacturer_makes_ProductType
ADD FOREIGN KEY (ProductType_ProdTypeID) REFERENCES ProductType(ProdTypeID);

CREATE TABLE Product (
	ProdID INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
	ProdSerial UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID(),
	ProdName VARCHAR(45) NOT NULL,
	ProdDescription VARCHAR(MAX),
	Price MONEY NOT NULL,
	ProductType_ProdTypeID INT NOT NULL 
	CHECK (ProductType_ProdTypeID > 0)
)
ON [PRIMARY]
ALTER TABLE Product
ADD FOREIGN KEY (ProductType_ProdTypeID) REFERENCES ProductType(ProdTypeID);

CREATE TABLE Customer (
	CustID INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
	CustName VARCHAR(45) NOT NULL,
	CustAddress VARCHAR(45),
	CustCity VARCHAR(45) NOT NULL,
	CustState CHAR(2) NOT NULL,
	CustMembershipStatus VARCHAR(45)
)

CREATE TABLE Review (
	ReviewID INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
	ReviewContent VARCHAR(MAX),
	Stars NUMERIC(1,0),
	Product_ProdID INT NOT NULL CHECK (Product_ProdID > 0),
	Customer_CustID INT NOT NULL CHECK (Customer_CustID > 0)
)
ALTER TABLE Review
ADD FOREIGN KEY (Product_ProdID) REFERENCES Product(ProdID);
ALTER TABLE Review
ADD FOREIGN KEY (Customer_CustID) REFERENCES Customer(CustID);

CREATE TABLE OrderInfo (
	OrderInfoID INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
	AlternateShippingAddress VARCHAR(45),
	FreeShipping BIT DEFAULT 0,
	OrderSubmitted DATETIME2,
	Customer_CustID INT NOT NULL CHECK (Customer_CustID > 0)
)
ALTER TABLE OrderInfo
ADD FOREIGN KEY (Customer_CustID) REFERENCES Customer(CustID);

CREATE TABLE Order_has_Products (
	OhpID INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
	OrderInfo_OrderID INT NOT NULL CHECK (OrderInfo_OrderID > 0),
	Product_ProdID INT NOT NULL CHECK (Product_ProdID > 0),
	TotalCost MONEY
)
ALTER TABLE Order_has_Products
ADD FOREIGN KEY (OrderInfo_OrderID) REFERENCES OrderInfo(OrderInfoID);
ALTER TABLE Order_has_Products
ADD FOREIGN KEY (Product_ProdID) REFERENCES Product(ProdID);
GO
/*Phase 2 --Part A*/
INSERT INTO Manufacturer (
	ManuName
,	ManuMainLocation
,	ManuOtherLocations)
VALUES
(	'Jenna Chain'
,	'4040 Quim Street Shreveport, LA 71115'
,	'700014 Ananda Palit Road Kolkata, IN 46001');
INSERT INTO Manufacturer (
	ManuName
,	ManuMainLocation
,	ManuOtherLocations)
VALUES
(	'Ivaylo Components & Spares'
,	'35 Domitille Parkway Phoenix, AZ 85003'
,	'1473 Tanglewood Drive West New York, NJ 07093');
INSERT INTO Manufacturer (
	ManuName
,	ManuMainLocation
,	ManuOtherLocations)
VALUES
(	'Yohna Fabrication'
,	'5109 East Avenue Palm City, FL 34990'
,	'4330 Monroe Drive Southfield, MI 48076');
INSERT INTO Manufacturer (
	ManuName
,	ManuMainLocation
,	ManuOtherLocations)
VALUES
(	'Dag Annushka Laboratories'
,	'988 Aspen Drive Allen Park, MI 48101'
,	'3715 4th Street West Fargo, ND 58102');
INSERT INTO Manufacturer (
	ManuName
,	ManuMainLocation)
VALUES
(	'Darell Glen Equipments'
,	'111 Zaro Lane Orange City, CA  90009');

INSERT INTO ProductType (
	ProdTypeDescription
,	IsSeasonal
,	IsMultiPart)
VALUES
(	'100 Sheets of Paper'
,	1
,	0);
INSERT INTO ProductType (
	ProdTypeDescription
,	IsSeasonal
,	IsMultiPart)
VALUES
(	'5 Pens'
,	1
,	1);
INSERT INTO ProductType (
	ProdTypeDescription
,	IsSeasonal
,	IsMultiPart)
VALUES
(	'20 Dual-Pocket Folders'
,	0
,	1);
INSERT INTO ProductType (
	ProdTypeDescription
,	IsSeasonal
,	IsMultiPart)
VALUES
(	'1 Giant Stapler'
,	0
,	0);
INSERT INTO ProductType (
	ProdTypeDescription)
VALUES
(	'5600 Paperclips');

INSERT INTO Manufacturer_makes_ProductType (
	Manufacturer_ManuID
,	ProductType_ProdTypeID)
VALUES
(	1
,	5);
INSERT INTO Manufacturer_makes_ProductType (
	Manufacturer_ManuID
,	ProductType_ProdTypeID)
VALUES
(	2
,	4);
INSERT INTO Manufacturer_makes_ProductType (
	Manufacturer_ManuID
,	ProductType_ProdTypeID)
VALUES
(	3
,	3);
INSERT INTO Manufacturer_makes_ProductType (
	Manufacturer_ManuID
,	ProductType_ProdTypeID)
VALUES
(	4
,	2);
INSERT INTO Manufacturer_makes_ProductType (
	Manufacturer_ManuID
,	ProductType_ProdTypeID)
VALUES
(	5
,	1);

INSERT INTO Product (
	ProdName
,	ProdDescription
,	Price
,	ProductType_ProdTypeID)
VALUES
(	'Computer'
,	'Comes with with advanced art program softwares'
,	32638.27
,	1);
INSERT INTO Product (
	ProdName
,	Price
,	ProductType_ProdTypeID)
VALUES
(	'Office Paper'
,	82.74
,	2);
INSERT INTO Product (
	ProdName
,	ProdDescription
,	Price
,	ProductType_ProdTypeID)
VALUES
(	'No.2 Pencils'
,	'Versitle use from standardized testing to general office use'
,	8.20
,	3);
INSERT INTO Product (
	ProdName
,	ProdDescription
,	Price
,	ProductType_ProdTypeID)
VALUES
(	'Software'
,	'Trial run supplements SPSS developed overseas'
,	97.24
,	4);
INSERT INTO Product (
	ProdName
,	ProdDescription
,	Price
,	ProductType_ProdTypeID)
VALUES
(	'Stationary'
,	'Imported for a test because the department was deemed "too ugly" and "lacking aesthetic"'
,	480.00
,	5);

INSERT INTO Customer (
	CustName
,	CustAddress
,	CustCity
,	CustState
,	CustMembershipStatus)
VALUES
(	'Lynsey Maddox'
,	'5734 Schnectady Drive'
,	'Kalamazoo'
,	'MI'
,	'Basic');
INSERT INTO Customer (
	CustName
,	CustAddress
,	CustCity
,	CustState
,	CustMembershipStatus)
VALUES
(	'Jen Bustamante'
,	'7770 Brown Street'
,	'Stockton'
,	'CA'
,	'Preferred');
INSERT INTO Customer (
	CustName
,	CustAddress
,	CustCity
,	CustState
,	CustMembershipStatus)
VALUES
(	'Amber Sommerville'
,	'3 Park Place'
,	'Salt Lake City'
,	'UT'
,	'Elite');
INSERT INTO Customer (
	CustName
,	CustAddress
,	CustCity
,	CustState)
VALUES
(	'Alana Uilleneuure'
,	'2702 Bloom Street'
,	'Portland'
,	'CT');
INSERT INTO Customer (
	CustName
,	CustAddress
,	CustCity
,	CustState
,	CustMembershipStatus)
VALUES
(	'Eyema Nurde'
,	'24 Kaugummi Street'
,	'Zzyzx'
,	'CA'
,	'Patrician');

INSERT INTO Review (
	ReviewContent
,	Stars
,	Product_ProdID
,	Customer_CustID)
VALUES
(	'Product was on time, handled well, was as expected! ...But they failed to deliver the optional cover... Minus one star but highly recommended'
,	1
,	1
,	5);
INSERT INTO Review (
	ReviewContent
,	Stars
,	Product_ProdID
,	Customer_CustID)
VALUES
(	'As expected, seller was fast, product as expected No complaints.'
,	2
,	2
,	4);
INSERT INTO Review (
	ReviewContent
,	Stars
,	Product_ProdID
,	Customer_CustID)
VALUES
(	'Very prompt, got the wrong item but cleared it up immediately and they let me keep the wrong item! ...But what will I do with a calendar?? Still cool'
,	3
,	3
,	3);
INSERT INTO Review (
	ReviewContent
,	Stars
,	Product_ProdID
,	Customer_CustID)
VALUES
(	'I WOULD GIVE THIS PRODUCT NO STARS AND IF I COULD!!!!!!!!!!!!!!!!!!!!!!!!!!! THEY WAS NOT NICE, SENT EMAILS TO SLOW, AINT GIVE MY MONEY BACK!! DO NOT BUY!!!!'
,	4
,	4
,	2);
INSERT INTO Review (
	Product_ProdID
,	Customer_CustID)
VALUES
(	5
,	1);

INSERT INTO OrderInfo (
	AlternateShippingAddress
,	FreeShipping
,	OrderSubmitted
,	Customer_CustID)
VALUES
(	'82 Spieleug Avenue'
,	1
,	'2013-07-17 00:00:00'
,	1);
INSERT INTO OrderInfo (
	AlternateShippingAddress
,	FreeShipping
,	OrderSubmitted
,	Customer_CustID)
VALUES
(	'320 Kowai Boulevard'
,	0
,	'2013-04-02 00:00:00'
,	2);
INSERT INTO OrderInfo (
	AlternateShippingAddress
,	FreeShipping
,	OrderSubmitted
,	Customer_CustID)
VALUES
(	'22 Espantose Road'
,	1
,	'2014-10-23'
,	3);
INSERT INTO OrderInfo (
	AlternateShippingAddress
,	FreeShipping
,	OrderSubmitted
,	Customer_CustID)
VALUES
(	'97 Taschenrechner Drive'
,	0
,	'2012-03-26'
,	4);
INSERT INTO OrderInfo (
	Customer_CustID)
VALUES
(	5);

INSERT INTO Order_has_Products (
	OrderInfo_OrderID
,	Product_ProdID
,	TotalCost)
VALUES
(	1
,	5
,	32638.27);
INSERT INTO Order_has_Products (
	OrderInfo_OrderID
,	Product_ProdID
,	TotalCost)
VALUES
(	2
,	4
,	82.74);
INSERT INTO Order_has_Products (
	OrderInfo_OrderID
,	Product_ProdID
,	TotalCost)
VALUES
(	3
,	3
,	8.20);
INSERT INTO Order_has_Products (
	OrderInfo_OrderID
,	Product_ProdID
,	TotalCost)
VALUES
(	4
,	2
,	97.24);
INSERT INTO Order_has_Products (
	OrderInfo_OrderID
,	Product_ProdID)
VALUES
(	5
,	1);
/*Phase 2 --Part B*/
SELECT DISTINCT Product_ProdID AS ProductID, Stars
FROM Review;

SELECT TOP 3 * FROM Manufacturer;

SELECT CustMembershipStatus AS MembershipStatus
FROM Customer;

SELECT *
INTO tblTest
FROM Manufacturer;

SELECT *
FROM tblTest;

TRUNCATE TABLE tblTest;

SELECT *
FROM tblTest;

DROP TABLE tblTest;

SELECT *
FROM Review;

SELECT SUM(Price) AS TotalPrice FROM Product;

SELECT *
FROM OrderInfo
WHERE FreeShipping = 1;

SELECT ProductType.ProdTypeID, ProdName
FROM Product
LEFT JOIN ProductType
ON Product.ProductType_ProdTypeID = ProductType.ProdTypeID
GROUP BY ProdName, ProductType.ProdTypeID;

SELECT ProductType.ProdTypeID, ProdName, Price
FROM Product
LEFT JOIN ProductType
ON Product.ProductType_ProdTypeID = ProductType.ProdTypeID
GROUP BY ProdName, ProductType.ProdTypeID, Price
HAVING Price > 100.00;

SELECT *
FROM Customer
ORDER BY CustCity;

SELECT Review.ReviewID, Customer.CustID
FROM Review
INNER JOIN Customer
ON Review.Customer_CustID = Customer.CustID;

SELECT *
FROM OrderInfo
LEFT JOIN Customer
ON OrderInfo.Customer_CustID = Customer.CustID;

SELECT Manufacturer.ManuName, Manufacturer_makes_ProductType.ProductType_ProdTypeID
FROM Manufacturer
RIGHT JOIN Manufacturer_makes_ProductType
ON Manufacturer_makes_ProductType.Manufacturer_ManuID = Manufacturer_makes_ProductType.ProductType_ProdTypeID;

SELECT Product.ProdName, ProductType.ProdTypeID
FROM Product
FULL OUTER JOIN ProductType
ON Product.ProductType_ProdTypeID=ProductType.ProdTypeID
ORDER BY ProdName, ProdTypeID;

WITH Review_CTE (ReviewID, ReviewContent, Stars)
AS
(
	SELECT ReviewID, ReviewContent, Stars
	FROM Review
	WHERE ReviewID IS NOT NULL
)
SELECT ReviewID, COUNT(ReviewContent) AS TotalReviews, Stars
FROM Review_CTE
GROUP BY Stars, ReviewID;

SELECT ProdDescription, ProdName,
    (SELECT MAX(Product.Price)
     FROM Product
     WHERE ProdID > 0)
FROM Product;

SELECT * 
FROM Customer
WHERE CustState IN ('CA','LA');

SELECT *
FROM OrderInfo
WHERE NOT EXISTS (SELECT *
                  FROM Customer
                  WHERE Customer.CustID = OrderInfo.Customer_CustID);

SELECT *
FROM Manufacturer
WHERE ManuID = ANY
    (SELECT Manufacturer_ManuID
     FROM Manufacturer_makes_ProductType
     WHERE Manufacturer_ManuID > ProductType_ProdTypeID) ;

SELECT *
  FROM ProductType
 WHERE ProdTypeID = ALL 
       (SELECT ProductType_ProdTypeID
          FROM Product
         WHERE Price < 50.00)
/*Phase 2 --Part C*/
UPDATE Customer
SET CustMembershipStatus = 'Silver'
WHERE CustMembershipStatus = 'Basic';

Update Order_has_Products
SET Order_has_Products.TotalCost = Product.Price
FROM Product
WHERE Order_has_Products.Product_ProdID = Product.ProdID;

UPDATE Review
SET ReviewContent = ProdDescription
FROM (	SELECT ProdDescription 
		FROM Product 
		WHERE ProdID = 1)i
WHERE ReviewID = 1;
		

DELETE FROM Review
WHERE ReviewID > 1;
/*Phase 2 --Part D*/
SELECT IsMultiPart, IsSeasonal, ProdTypeID
FROM ProductType
    INNER JOIN Manufacturer_makes_ProductType
        ON ProductType.ProdTypeID  = Manufacturer_makes_ProductType.ProductType_ProdTypeID
    INNER JOIN Product
        ON ProductType.ProdTypeID  = Product.ProductType_ProdTypeID
WHERE ProdTypeID > 0
GROUP BY CUBE(
    IsMultiPart, IsSeasonal, ProdTypeID)
ORDER BY IsMultiPart, IsSeasonal, ProdTypeID;

SELECT Price, ProdDescription, ProdID, ProdName
FROM Product
    INNER JOIN Review
        ON Product.ProdID  = Review.Product_ProdID
    INNER JOIN Order_has_Products
        ON Product.ProdID  = Order_has_Products.Product_ProdID
WHERE ProdID > 0
GROUP BY ROLLUP(
    Price, ProdDescription, ProdID, ProdName)
ORDER BY Price, ProdDescription, ProdID, ProdName;
GO
/*Phase 3 --Part A
Create SQL scrips to create stored procedures; include the codes to test and to create*/

/*add data to one table from data values passed in the parameters*/
CREATE PROCEDURE insertIntoManufactuer (	@ManuName			VARCHAR(45)
									,		@ManuMainLocation	VARCHAR (45))
AS
BEGIN
	INSERT INTO Manufacturer (
		ManuName
	,	ManuMainLocation)
	VALUES (
		@ManuName
	,	@ManuMainLocation);
END

EXEC insertIntoManufactuer		'Vandriver Nabuo Works'
							,	'987 Other Connection Lane';
SELECT *
FROM Manufacturer;
GO
/*add data to two tables using one stored procedure from data values passed in the parameters*/
CREATE PROCEDURE insertIntoProductTypeAndProduct (	@ProdTypeDescription	VARCHAR(MAX)
												,	@ProdName				VARCHAR(45)
												,	@ProdDescription		VARCHAR(MAX)
												,	@Price					MONEY
												,	@ProductType_ProdTypeID INT)
AS
BEGIN
	INSERT INTO ProductType (
		ProdTypeDescription)
	VALUES (
		@ProdTypeDescription)
	INSERT INTO Product (
		ProdName
	,	ProdDescription
	,	Price
	,	ProductType_ProdTypeID)
	VALUES (
		@ProdName
	,	@ProdDescription
	,	@Price
	,	@ProductType_ProdTypeID)
END

EXEC insertIntoProductTypeAndProduct	'Paper Shredder'
									,	'987 Other Connection Lane'
									,	'Harshly used and will not work all of the time'
									,	43.21
									,	6;
SELECT *
FROM ProductType
FULL OUTER JOIN Product
ON ProductType.ProdTypeID=Product.ProductType_ProdTypeID
ORDER BY ProdName, ProdTypeID;
GO
/*iterate through a table using a cursor and change a value on some rows based on a test*/
CREATE PROCEDURE updateReviewContent
AS	
BEGIN
	DECLARE updateReviewContentCursor CURSOR LOCAL FOR SELECT ReviewContent FROM Review;
	OPEN updateReviewContentCursor;
	DECLARE @currentReview VARCHAR(MAX);
	FETCH NEXT FROM updateReviewContentCursor INTO @currentReview;
	WHILE @@FETCH_STATUS = 0
	BEGIN
		IF @currentReview IS NULL
		BEGIN
			UPDATE Review
			SET ReviewContent = 'No review was provided'
			WHERE CURRENT OF updateReviewContentCursor
		END
		FETCH NEXT FROM updateReviewContentCursor INTO @currentReview;
	END
	CLOSE updateReviewContentCursor
END;

INSERT INTO Review (
	Product_ProdID
,	Customer_CustID)
VALUES
(	5
,	1);

EXEC updateReviewContent;
SELECT *
FROM Review;
GO
/*retreive data from all ONE table using XML AUTO*/
CREATE PROCEDURE selectCustomers
AS
BEGIN
	SELECT *
	FROM Customer
	FOR XML AUTO;
END

EXEC selectCustomers;
SELECT *
FROM Customer;
GO
/*retrieve data from all ONE table using XML EXPLICIT*/
CREATE PROCEDURE selectOrdersInfo
AS
BEGIN
	SELECT 1 AS Tag, NULL AS Parent	, OrderInfoID AS [OrderInfo!1!OrderInfoID]
									, AlternateShippingAddress AS [OrderInfo!1!AlternateShippingAddress]
									, FreeShipping AS [OrderInfo!1!FreeShipping]
									, OrderSubmitted AS [OrderInfo!1!Customer_CustID]
	FROM OrderInfo
	FOR XML EXPLICIT;
END

EXEC selectOrdersInfo;
SELECT *
FROM OrderInfo;
GO
/*stored procedure that uses dynamic SQL*/
CREATE PROCEDURE updateOtherLocations (@newManuLocation VARCHAR(45))
AS
BEGIN
	UPDATE Manufacturer
	SET ManuOtherLocations += @newManuLocation;
END

EXEC updateOtherLocations '; new location TBA';
SELECT ManuOtherLocations
FROM Manufacturer;
GO
/*stored procedure that returns records from one of the tables based on a filter parameter*/
CREATE PROCEDURE selectProductTypes (@filterProdTypeID INT)
AS
BEGIN
	SELECT *
	FROM ProductType
	WHERE ProdTypeID <= @filterProdTypeID;
END

EXEC selectProductTypes 3;
SELECT *
FROM ProductType;
GO
/*stored procedure that uses a return value/output parameter*/
CREATE PROCEDURE selectProdName (	@prodID INT
								,	@result VARCHAR(45) OUTPUT)
AS
BEGIN
	SELECT ProdName
	FROM Product
	WHERE ProdID = @prodID;
	RETURN;
END

DECLARE @printableResult VARCHAR(45);					
EXECUTE selectProdName 1, @result = @printableResult OUTPUT;
print @printableResult 
SELECT ProdID, ProdName
FROM Product;
GO
/*stored procedure that accepts an optional input*/
CREATE PROCEDURE updateCustomerAddress (@custID INT
									,	@newCustAddress VARCHAR(45) = NULL)
AS
BEGIN
	UPDATE Customer
	SET CustAddress = @newCustAddress
	WHERE CustID = @custID;
END
		
EXECUTE updateCustomerAddress 1;
SELECT CustID, CustAddress
FROM Customer;
GO
/*Phase 3 --Part B
Create a meaningful view of one table*/
CREATE VIEW ProtectedViewOfCustomers 
AS 
SELECT CustName, CustMembershipStatus 
FROM Customer;

SELECT *
FROM ProtectedViewOfCustomers;
GO
/*Phase 3 --Part C
Create a meaningful view of multiple tables*/
CREATE VIEW CustomersWithFreeShipping
AS
SELECT COUNT(*) AS NumberOfCustomers
FROM Customer
INNER JOIN OrderInfo
ON Customer.CustID=OrderInfo.Customer_CustID
WHERE FreeShipping = 1;

SELECT *
FROM CustomersWithFreeShipping;
GO
/*Phase 3 --Part D
Create a unique index on a meaningful column*/
CREATE INDEX indexByOrderDate
ON OrderInfo (OrderSubmitted)
GO
/*Phase 3 --Part E
Create a meaningful index on multiple columns*/
CREATE INDEX indexByReview
ON Review (Stars, ReviewID)
GO
/*Phase 3 --Part F
Create an updatable view and write SQL code to update the data in the table through the view*/
CREATE VIEW ViewOfCustomersByCustomer 
AS 
SELECT CustName, CustAddress, CustCity, CustState, CustMemberShipStatus
FROM Customer;

UPDATE ViewOfCustomersByCustomer
SET CustMemberShipStatus = 'Best'
WHERE CustState = 'CT';

SELECT *
FROM ViewOfCustomersByCustomer
GO
/*Removes Database
USE master;
DROP DATABASE TruongKellyProject;*/