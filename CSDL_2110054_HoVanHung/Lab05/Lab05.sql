CREATE DATABASE Lab05_QLTour;
GO

USE Lab05_QLTour;
GO

-- Bảng Tour
CREATE TABLE Tour (
    MaTour CHAR(4) PRIMARY KEY,
    TongSoNgay INT CHECK (TongSoNgay > 0)
);

-- Bảng ThanhPho
CREATE TABLE ThanhPho (
    MaTP CHAR(2) PRIMARY KEY,
    TenTP NVARCHAR(50) NOT NULL
);

-- Bảng Tour_TP
CREATE TABLE Tour_TP (
    MaTour CHAR(4),
    MaTP CHAR(2),
    SoNgay INT CHECK (SoNgay > 0),
    PRIMARY KEY (MaTour, MaTP),
    FOREIGN KEY (MaTour) REFERENCES Tour(MaTour),
    FOREIGN KEY (MaTP) REFERENCES ThanhPho(MaTP)
);

-- Bảng Lich_TourDL
CREATE TABLE Lich_TourDL (
    MaTour CHAR(4),
    NgayKH DATE,
    TenHDV NVARCHAR(50) NOT NULL,
    SoNguoi INT CHECK (SoNguoi > 0),
    TenKH NVARCHAR(50) NOT NULL,
    PRIMARY KEY (MaTour, NgayKH),
    FOREIGN KEY (MaTour) REFERENCES Tour(MaTour)
);
GO

-- Xây dựng các thủ tục
-- Thêm dữ liệu vào bảng Tour
CREATE PROCEDURE AddTour
    @MaTour CHAR(4),
    @TongSoNgay INT
AS
BEGIN
    INSERT INTO Tour (MaTour, TongSoNgay)
    VALUES (@MaTour, @TongSoNgay);
END;
GO

-- Thêm dữ liệu vào bảng ThanhPho
CREATE PROCEDURE AddThanhPho
    @MaTP CHAR(2),
    @TenTP NVARCHAR(50)
AS
BEGIN
    INSERT INTO ThanhPho (MaTP, TenTP)
    VALUES (@MaTP, @TenTP);
END;
GO

-- Thêm dữ liệu vào bảng Tour_TP
CREATE PROCEDURE AddTourTP
    @MaTour CHAR(4),
    @MaTP CHAR(2),
    @SoNgay INT
AS
BEGIN
    INSERT INTO Tour_TP (MaTour, MaTP, SoNgay)
    VALUES (@MaTour, @MaTP, @SoNgay);
END;
GO

-- Thêm dữ liệu vào bảng Lich_TourDL
CREATE PROCEDURE AddLichTourDL
    @MaTour CHAR(4),
    @NgayKH DATE,
    @TenHDV NVARCHAR(50),
    @SoNguoi INT,
    @TenKH NVARCHAR(50)
AS
BEGIN
    INSERT INTO Lich_TourDL (MaTour, NgayKH, TenHDV, SoNguoi, TenKH)
    VALUES (@MaTour, @NgayKH, @TenHDV, @SoNguoi, @TenKH);
END;
GO

-- thêm dữ liệu
EXEC AddTour 'T001', 3;
EXEC AddTour 'T002', 4;
EXEC AddTour 'T003', 5;
EXEC AddTour 'T004', 7;

EXEC AddThanhPho '01', N'Đà Lạt';
EXEC AddThanhPho '02', N'Nha Trang';
EXEC AddThanhPho '03', N'Phan Thiết';
EXEC AddThanhPho '04', N'Huế';
EXEC AddThanhPho '05', N'Đà Nẵng';

EXEC AddTourTP 'T001', '01', 2;
EXEC AddTourTP 'T001', '03', 2;
EXEC AddTourTP 'T002', '01', 2;
EXEC AddTourTP 'T002', '02', 2;
EXEC AddTourTP 'T003', '02', 1;
EXEC AddTourTP 'T003', '01', 2;
EXEC AddTourTP 'T003', '04', 2;
EXEC AddTourTP 'T004', '02', 2;
EXEC AddTourTP 'T004', '05', 3;
EXEC AddTourTP 'T004', '04', 2;

EXEC AddLichTourDL 'T001', '2017-02-14', N'Vân', 20, N'Nguyễn Hoàng';
EXEC AddLichTourDL 'T002', '2017-02-14', N'Nam', 30, N'Lê Ngọc';
EXEC AddLichTourDL 'T002', '2017-03-06', N'Hùng', 20, N'Lý Dũng';
EXEC AddLichTourDL 'T003', '2017-02-18', N'Dũng', 20, N'Lý Dũng';
EXEC AddLichTourDL 'T004', '2017-02-18', N'Hùng', 30, N'Dũng Nam';
EXEC AddLichTourDL 'T003', '2017-03-10', N'Nam', 45, N'Nguyễn An';
EXEC AddLichTourDL 'T002', '2017-04-28', N'Vân', 25, N'Ngọc Dung';
EXEC AddLichTourDL 'T004', '2017-04-29', N'Dũng', 35, N'Lê Ngọc';
EXEC AddLichTourDL 'T001', '2017-04-30', N'Nam', 25, N'Trần Nam';
EXEC AddLichTourDL 'T003', '2017-06-15', N'Vân', 20, N'Trịnh Bá';


--4. Câu truy vấn SQL
--(a) Các tour có tổng số ngày từ 3 đến 5:
SELECT * 
FROM Tour
WHERE TongSoNgay BETWEEN 3 AND 5;

--(b) Các tour tổ chức trong tháng 2 năm 2017:
SELECT * 
FROM Lich_TourDL
WHERE MONTH(NgayKH) = 2 AND YEAR(NgayKH) = 2017;

--(c) Các tour không đi qua thành phố 'Nha Trang':
SELECT DISTINCT T.MaTour
FROM Tour T
WHERE NOT EXISTS (
    SELECT 1 
    FROM Tour_TP TP
    JOIN ThanhPho P ON TP.MaTP = P.MaTP
    WHERE P.TenTP = 'Nha Trang' AND T.MaTour = TP.MaTour
);

--(d) Số lượng thành phố mỗi tour đi qua:
SELECT MaTour, COUNT(MaTP) AS SoLuongThanhPho
FROM Tour_TP
GROUP BY MaTour;

--(e) Số lượng tour mỗi hướng dẫn viên hướng dẫn:
SELECT TenHDV, COUNT(DISTINCT MaTour) AS SoLuongTour
FROM Lich_TourDL
GROUP BY TenHDV;

--(f) Thành phố có nhiều tour đi qua nhất:
SELECT TOP 1 P.TenTP, COUNT(DISTINCT TP.MaTour) AS SoLuongTour
FROM Tour_TP TP
JOIN ThanhPho P ON TP.MaTP = P.MaTP
GROUP BY P.TenTP
ORDER BY SoLuongTour DESC;

--(g) Thông tin tour đi qua tất cả các thành phố:
SELECT T.MaTour
FROM Tour T
WHERE NOT EXISTS (
    SELECT P.MaTP 
    FROM ThanhPho P
    WHERE NOT EXISTS (
        SELECT 1
        FROM Tour_TP TP
        WHERE TP.MaTour = T.MaTour AND TP.MaTP = P.MaTP
    )
);

--(h) Danh sách các tour đi qua thành phố 'Đà Lạt':
SELECT Tp.MaTour, TP.SoNgay
FROM Tour_TP TP
JOIN ThanhPho P ON TP.MaTP = P.MaTP
WHERE P.TenTP = N'Đà Lạt';

--(i) Tour có tổng số khách tham gia nhiều nhất:
SELECT TOP 1 T.MaTour, SUM(LT.SoNguoi) AS TongSoNguoi
FROM Lich_TourDL LT
JOIN Tour T ON LT.MaTour = T.MaTour
GROUP BY T.MaTour
ORDER BY TongSoNguoi DESC;

--(j) Thành phố mà tất cả các tour đều đi qua:
SELECT P.TenTP
FROM ThanhPho P
WHERE NOT EXISTS (
    SELECT T.MaTour
    FROM Tour T
    WHERE NOT EXISTS (
        SELECT 1
        FROM Tour_TP TP
        WHERE TP.MaTP = P.MaTP AND TP.MaTour = T.MaTour
    )
);

