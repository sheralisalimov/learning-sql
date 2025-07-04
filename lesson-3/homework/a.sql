1 BULK INSERT nima Ko‘p sonli yozuvlarni matn (CSV, txt) fayldan jadvalga tez yuklash.
2 --Import formatlari (kamida 4): 
CSV, TXT, XML, JSON, Excel (.xlsx/.xls).
3 --Products jadvali yaratish:
CREATE TABLE Products (
  ProductID INT PRIMARY KEY,
  ProductName VARCHAR(50),
  Price DECIMAL(10,2)
);
4 --Mahsulot qo‘shish:
INSERT INTO Products (ProductID, ProductName, Price)
VALUES (1,'Book',9.99),(2,'Pen',1.50),(3,'Laptop',1200.00
5 NULL vs NOT NULL: NULL – qiymat yo‘q; NOT NULL – qiymat bo‘lishi shart.
6 UNIQUE cheklov qo‘yish: ALTER TABLE Products ADD CONSTRAINT UQ_ProductName UNIQUE(ProductName);
7 --
8 --Categories jadvali (PRIMARY + UNIQUE):
CREATE TABLE Categories (
  CategoryID INT PRIMARY KEY,
  CategoryName VARCHAR(50) UNIQUE
);
9 IDENTITY ustuni nima: Avtomatik ketma‑ket son bilan to‘ladi, masalan INT IDENTITY(1,1).
10 --BULK INSERT Products
FROM 'C:\data\products.csv'
WITH (
  FIELDTERMINATOR = ',',
  ROWTERMINATOR = '\n',
  FIRSTROW = 2
);
11 --FOREIGN KEY qo‘shish:
ALTER TABLE Products
ADD CONSTRAINT FK_Prod_Cat 
  FOREIGN KEY (CategoryID) 
  REFERENCES Categories(CategoryID);
12 --PRIMARY vs UNIQUE:
PRIMARY: bitta, NOT NULL, birlamchi kalit.
UNIQUE: ko‘p bo‘lishi mumkin, NULL ruxsat etadi.
13 --CHECK cheklov qo‘yish:
ALTER TABLE Products
ADD CONSTRAINT CK_Price_Positive CHECK (Price > 0);
14 --Stock ustuni qo‘shish:
ALTER TABLE Products
ADD Stock INT NOT NULL DEFAULT 0;
15 --ISNULL bilan NULL to‘ldirish:
SELECT ProductID, ISNULL(Stock,0) AS StockValue
FROM Products;
1. BULK INSERT nima va nima uchun ishlatiladi?
BULK INSERT – bu SQL Serverda kattaroq hajmdagi ma’lumotlarni (masalan, CSV, TXT, XML) bir vaqtning o‘zida jadvalga kiritish imkonini beruvchi T‑SQL operatori
Nega kerak?
Tezkor yuklash: minglab, milyonlab qatorlarni individual INSERT operatorlari bilan emas, bir marotaba yuklaydi .
Log yozuvlari kamayadi, bu esa umumiy samaradorlikni oshiradi
2. Qaysi 4 ta fayl formatini SQL Serverga import qilish mumkin?
SQL Serverda import qilsa bo‘ladigan keng tarqalgan formatlar:

.csv (Comma‑Separated Values)

.txt (Plain Text, comma yoki tab bilan ajratilgan)

.xml (XML formatdagi fayllar)

.xlsx yoki .xls (Excel), faqat ular oldin CSV yoki TXT ga konvertatsiya qilinadi
3. --Products jadvalini yaratish
CREATE TABLE Products (
  ProductID INT PRIMARY KEY,
  ProductName VARCHAR(50),
  Price DECIMAL(10,2)
);
4. --Products jadvaliga INSERT INTO yordamida uchta yozuv (record) kiriting.
INSERT INTO Products (ProductID, ProductName, Price) VALUES
(1, 'Laptop', 1200.00),
(2, 'Mouse', 25.50),
(3, 'Keyboard', 75.00);
5. --NULL va NOT NULL orasidagi farqni misollar bilan tushuntiring.
ALTER TABLE Products ADD Description VARCHAR(255) NULL;
INSERT INTO Products (ProductID, ProductName, Price, Description) VALUES (4, 'Monitor', 300.00, NULL);
6. --Products jadvalidagi ProductName ustuniga UNIQUE cheklovini qo'shing.
ALTER TABLE Products
ADD CONSTRAINT UQ_ProductName UNIQUE (ProductName);
7. --SQL so'rovda uning maqsadini tushuntiruvchi izoh yozing.
SELECT ProductID, ProductName, Price
FROM Products;
8. --Categories nomli jadval yarating. Unda CategoryID PRIMARY KEY va CategoryName UNIQUE bo'lsin.
CREATE TABLE Categories (
    CategoryID INT PRIMARY KEY,
    CategoryName VARCHAR(50) UNIQUE NOT NULL
);
9. --SQL Serverdagi IDENTITY ustunining maqsadini tushuntiring.
IDENTITY ustuni SQL Serverda jadvalga yangi qator qo'shilganda, ushbu ustun uchun avtomatik ravishda noyob (unique) va o'sib boruvchi (incremental) sonli qiymat yaratish uchun ishlatiladi. U, odatda, PRIMARY KEY bilan birga ishlatiladi, chunki u har bir qator uchun noyob identifikatorni kafolatlaydi. Siz IDENTITY(boshlash_qiymati, o'sish_qadami) formatida belgilashingiz mumkin. Masalan, IDENTITY(1,1) 1 dan boshlab har safar 1 ga oshirib boradi. Bu qo'lda ID kiritish zaruratini yo'q qiladi va xatolarni kamaytiradi.
10 --BULK INSERT yordamida matn faylidan Products jadvaliga ma'lumot import qiling.
BULK INSERT Products
FROM 'C:\Data\products.txt'  -- serverdagi to‘liq yo‘l
WITH (
  FIELDTERMINATOR = ',',      -- maydonlarni vergul bilan ajratadi
  ROWTERMINATOR = '\n',       -- satr oxirini belgilaydi
  FIRSTROW = 1                -- agar faylda sarlavha bo‘lsa: 2; bu misolda yo‘q
);
11. --Kategoriyalar jadvaliga murojaat qilib, FOREIGN KEYni Mahsulotlar jadvalida yarating.
ALTER TABLE Products
ADD CONSTRAINT FK_Products_Categories
    FOREIGN KEY (CategoryID)
    REFERENCES Categories(CategoryID)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
12. --PRIMARY KEY va UNIQUE KEY o'rtasidagi farqlarni misollar bilan tushuntiring.
Farqlar 
Xususiyat	PRIMARY KEY	UNIQUE KEY
NULL qiymat	Not NULL, NULL qabul qilmaydi 
NULL qabul qilishi mumkin (SQL Server’da faqat bitta NULL oʻziga xos)
Takrorlanish	Takrorlanmagan, unikal	Takrorlanmagan, unikal
Jadvaldagi sondagi farq	Bitta bo‘lishi mumkin (faqat 1 ta PK)	Bir nechta bo‘lishi mumkin (bir nechta UK)
Index turi	Default bo‘lib clustered index hosil qiladi	Defaultda non‑clustered unique index hosil qiladi
13. --Products jadvaliga CHECK cheklovini qo'shing, bunda Price > 0 bo'lishini ta'minlang.
ALTER TABLE Products
ADD CONSTRAINT CK_Products_PricePositive CHECK (Price > 0);
GO
14. --Products jadvalini o'zgartirib, Stock (INT, NOT NULL) ustunini qo'shing.
ALTER TABLE Products
ADD Stock INT NOT NULL DEFAULT 0; -- Yangi qo'shilgan ustunga sukut bo'yicha 0 qiymatini beradi
GO
UPDATE Products SET Stock = 100 WHERE ProductID = 4;
UPDATE Products SET Stock = 50 WHERE ProductID = 5;
UPDATE Products SET Stock = 200 WHERE ProductID = 6;
SELECT * FROM Products;
15. --ISNULL funksiyasidan foydalanib, ustundagi NULL qiymatlarni sukut bo'yicha (default) qiymat bilan almashtiring.
-- Description ustunini qo'shish (agar u hali yo'q bo'lsa)
IF NOT EXISTS (SELECT * FROM sys.columns WHERE Name = N'Description' AND Object_ID = Object_ID(N'Products'))
BEGIN
    ALTER TABLE Products ADD Description VARCHAR(255) NULL;
END;
GO

-- Ba'zi mahsulotlar uchun Description ustunini NULL qilib qo'yamiz, ba'zilariga qiymat beramiz
UPDATE Products SET Description = NULL WHERE ProductID = 4;
UPDATE Products SET Description = 'Yuqori sifatli ofis printeri' WHERE ProductID = 5;
UPDATE Products SET Description = NULL WHERE ProductID = 6;
GO
16 --SQL Serverda FOREIGN KEY cheklovlarining maqsadini va qo'llanilishini tushuntiring.
FOREIGN KEY (chetki kalit) – bu bir jadvaldagi (odatda "bolalar jadvali" deb ataladi) ustun yoki ustunlar to'plami bo'lib, u boshqa jadvaldagi (odatda "asosiy jadval" yoki "ota-ona jadvali" deb ataladi) PRIMARY KEY yoki UNIQUE KEY ustuniga murojaat qiladi. U jadvallar orasida bog'liqlikni o'rnatadi.
Ma'lumotlar yaxlitligini ta'minlash (Referential Integrity): Bu eng muhim maqsadi. FOREIGN KEYlar jadvallar o'rtasidagi munosabatlarning to'g'ri va izchil bo'lishini ta'minlaydi. Ya'ni, siz bolalar jadvaliga asosiy jadvalda mavjud bo'lmagan qiymatni kirita olmaysiz.
FOREIGN KEYlar jadvalni CREATE TABLE buyrug'i bilan yaratishda yoki ALTER TABLE buyrug'i bilan mavjud jadvalga qo'shiladi.
REFERENCES kalit so'zi qaysi jadval va qaysi ustunga murojaat qilinishini ko'rsatadi.
Ular bilan birga ON DELETE va ON UPDATE qoidalari ishlatilishi mumkin. Bu qoidalar asosiy jadvalda qator o'chirilganda yoki yangilanganda bolalar jadvaliga qanday ta'sir qilishini belgilaydi.
17. --Customers jadvalini yaratish uchun skript yozing, unda Age >= 18 ni ta'minlaydigan CHECK cheklovi bo'lsin.
IF OBJECT_ID('Customers', 'U') IS NOT NULL
    DROP TABLE Customers;
GO
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY IDENTITY(1,1),
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Age INT,
    Email VARCHAR(100) UNIQUE,
    CONSTRAINT CK_Customers_Age CHECK (Age >= 18) -- CHECK cheklovi
);
GO
INSERT INTO Customers (FirstName, LastName, Age, Email) VALUES
('Ali', 'Valiyev', 25, 'ali@example.com');

SELECT * FROM Customers;
18. --IDENTITY ustunini 100 dan boshlab 10 ga oshiruvchi jadval yarating.
IF OBJECT_ID('Orders', 'U') IS NOT NULL
    DROP TABLE Orders;
GO
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY IDENTITY(100,10), -- IDENTITY(boshlash_qiymati, o'sish_qadami)
    CustomerID INT NOT NULL,
    OrderDate DATETIME DEFAULT GETDATE(),
    TotalAmount DECIMAL(10,2)
);
GO
-- Yangi yozuvlar kiritish
INSERT INTO Orders (CustomerID, TotalAmount) VALUES (1, 150.00); -- OrderID = 100
INSERT INTO Orders (CustomerID, TotalAmount) VALUES (2, 230.50); -- OrderID = 110
INSERT INTO Orders (CustomerID, TotalAmount) VALUES (1, 75.20);  -- OrderID = 120
SELECT * FROM Orders;
19. --Yangi OrderDetails jadvalida kompozit PRIMARY KEY yaratish uchun so'rov yozing.
IF OBJECT_ID('OrderDetails', 'U') IS NOT NULL
    DROP TABLE OrderDetails;
GO
CREATE TABLE OrderDetails (
    OrderID INT NOT NULL,
    ProductID INT NOT NULL,
    Quantity INT NOT NULL,
    UnitPrice DECIMAL(10,2) NOT NULL,
    CONSTRAINT PK_OrderDetails PRIMARY KEY (OrderID, ProductID) 
);
GO
INSERT INTO OrderDetails (OrderID, ProductID, Quantity, UnitPrice) VALUES
(100, 4, 2, 350.00), -- Buyurtma 100, Mahsulot 4
(100, 5, 1, 200.00), -- Buyurtma 100, Mahsulot 5
(110, 4, 1, 350.00); -- Buyurtma 110, Mahsulot 4
SELECT * FROM OrderDetails;
20. --COALESCE va ISNULL funksiyalarining NULL qiymatlarni qayta ishlashdagi farqlarini misollar bilan tushuntiring.
SELECT ISNULL(NULL, 'Mavjud emas') AS Result1,
       ISNULL('Qiymat bor', 'Mavjud emas') AS Result2,
       ISNULL(NULL, 0) AS Result3; -- Natija 0, INT turida
SELECT COALESCE(NULL, NULL, 'Mavjud', 'Boshqa') AS Result1,
       COALESCE(NULL, 10, NULL, 20) AS Result2;
21.-- Employees nomli jadval yarating, unda EmpID ustunida PRIMARY KEY va Email ustunida UNIQUE KEY bo'lsin.
IF OBJECT_ID('Employees', 'U') IS NOT NULL
    DROP TABLE Employees;
GO
CREATE TABLE Employees (
    EmpID INT PRIMARY KEY IDENTITY(1,1), -- PRIMARY KEY
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Email VARCHAR(100) UNIQUE,           -- UNIQUE KEY
    PhoneNumber VARCHAR(20)
);
GO
INSERT INTO Employees (FirstName, LastName, Email, PhoneNumber) VALUES
('Jasur', 'Karimov', 'jasur@company.com', '998901234567'),
('Dilnoza', 'Axmedova', 'dilnoza@company.com', '998912345678');
INSERT INTO Employees (FirstName, LastName, Email, PhoneNumber) VALUES
('Nodira', 'Tojieva', NULL, '998945678901');
SELECT * FROM Employees;
22. --ON DELETE CASCADE va ON UPDATE CASCADE opsiyalariga ega FOREIGN KEY yaratish uchun so'rov yozing.
1. Ota-ona jadvali (Departments) yaratamiz:
IF OBJECT_ID('Departments', 'U') IS NOT NULL
    DROP TABLE Departments;
GO
CREATE TABLE Departments (
    DeptID INT PRIMARY KEY IDENTITY(1,1),
    DeptName VARCHAR(50) NOT NULL UNIQUE
);
GO
INSERT INTO Departments (DeptName) VALUES
('HR'),
('IT'),
('Finance');
GO
2. Bolalar jadvali (Staff) yaratamiz va FOREIGN KEYni qo'shamiz:
IF OBJECT_ID('Staff', 'U') IS NOT NULL
    DROP TABLE Staff;
GO
CREATE TABLE Staff (
    StaffID INT PRIMARY KEY IDENTITY(1,1),
    StaffName VARCHAR(100) NOT NULL,
    DeptID INT NOT NULL,
    CONSTRAINT FK_Staff_Departments FOREIGN KEY (DeptID)
        REFERENCES Departments (DeptID)
        ON DELETE CASCADE    -- Agar Department o'chirilsa, unga tegishli Staff ham o'chadi
        ON UPDATE CASCADE    -- Agar Department ID yangilansa, Staffdagi DeptID ham yangilanadi
);
GO
-- Namuna ma'lumotlar
INSERT INTO Staff (StaffName, DeptID) VALUES
('Jalol', 1), -- HR
('Muxlisa', 2), -- IT
('Shahzod', 1), -- HR
('Farida', 3); -- Finance
SELECT * FROM Departments;
SELECT * FROM Staff;
4. ON UPDATE CASCADE ni sinab ko'rish (avval jadvalni qayta yaratib olish kerak bo'ladi, chunki ma'lumotlar o'chib ketgan bo'lishi mumkin):
PRINT '--- Department ID 2 ni yangilashdan OLDIN ---';
SELECT * FROM Departments;
SELECT * FROM Staff;
UPDATE Departments SET DeptID = 20 WHERE DeptID = 2; 
PRINT '--- Department ID 2 ni yangilashdan KEYIN ---';
SELECT * FROM Departments;
SELECT * FROM Staff;
