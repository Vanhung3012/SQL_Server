CREATE DATABASE Lab02_QuanLySanxuat;
GO
USE Lab02_QuanLySanxuat;
GO

CREATE TABLE ToSanXuat (
    MaTSX CHAR(4) PRIMARY KEY,
    TenTSX NVARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE CongNhan (
    MACN CHAR(5) PRIMARY KEY,
    Ho NVARCHAR(50) NOT NULL,
    Ten NVARCHAR(50) NOT NULL,
    Phai NVARCHAR(3),
    NgaySinh DATE,
    MaTSX CHAR(4),
    FOREIGN KEY (MaTSX) REFERENCES ToSanXuat(MaTSX)
);


CREATE TABLE SanPham (
    MaSP CHAR(5) PRIMARY KEY,
    TenSP NVARCHAR(100) NOT NULL UNIQUE, 
    DVT NVARCHAR(10) NOT NULL,
    TienCong DECIMAL(10, 2) NOT NULL CHECK (TienCong > 0) 
);
CREATE TABLE ThanhPham (
    MACN CHAR(5) NOT NULL,
    MaSP CHAR(5) NOT NULL,
    Ngay DATE NOT NULL,
    SoLuong INT NOT NULL CHECK (SoLuong > 0), 
    PRIMARY KEY (MACN, MaSP, Ngay),
    FOREIGN KEY (MACN) REFERENCES CongNhan(MACN),
    FOREIGN KEY (MaSP) REFERENCES SanPham(MaSP)
);

INSERT INTO ToSanXuat (MaTSX, TenTSX)
VALUES
    ('TS01', N'Tổ 1'),
    ('TS02', N'Tổ 2');


INSERT INTO CongNhan (MACN, Ho, Ten, Phai, NgaySinh, MaTSX)
VALUES
    ('CN001', N'Nguyễn Trường', N'An', N'Nam', '1981-05-12', 'TS01'),
    ('CN002', N'Lê Thị Hồng', N'Gẩm', N'Nữ', '1980-06-04', 'TS01'),
    ('CN003', N'Nguyễn Công', N'Thành', N'Nam', '1981-05-04', 'TS02'),
    ('CN004', N'Võ Hữu', N'Hạnh', N'Nam', '1980-02-15', 'TS02'),
    ('CN005', N'Lý Thanh', N'Hân', N'Nữ', '1981-12-03', 'TS01');

INSERT INTO SanPham (MaSP, TenSP, DVT, TienCong)
VALUES
    ('SP001', N'Nồi đất', N'cái', 10000),
    ('SP002', N'Chén', N'cái', 2000),
    ('SP003', N'Bình gốm nhỏ', N'cái', 20000),
    ('SP004', N'Bình gốm lớn', N'cái', 25000);

INSERT INTO ThanhPham (MACN, MaSP, Ngay, SoLuong)
VALUES
    ('CN001', 'SP001', '2007-02-01', 10),
    ('CN002', 'SP001', '2007-02-01', 5),
    ('CN003', 'SP002', '2007-01-10', 50),
    ('CN004', 'SP003', '2007-01-12', 10),
    ('CN005', 'SP002', '2007-01-12', 100),
    ('CN002', 'SP004', '2007-02-13', 10),
    ('CN001', 'SP003', '2007-02-14', 15),
    ('CN003', 'SP001', '2007-01-15', 20),
    ('CN003', 'SP004', '2007-02-14', 15),
    ('CN004', 'SP002', '2007-01-30', 100),
    ('CN005', 'SP003', '2007-02-01', 50),
    ('CN001', 'SP001', '2007-02-20', 30);

-- 1) Liệt kê công nhân theo tổ sản xuất:
SELECT 
    TSX.TenTSX,
    CONCAT(CN.Ho, ' ', CN.Ten) AS HoTen,
    CN.NgaySinh,
    CN.Phai
FROM CongNhan CN
JOIN ToSanXuat TSX ON CN.MaTSX = TSX.MaTSX
ORDER BY TSX.TenTSX, CN.Ten;

--2) Liệt kê các thành phẩm mà 'Nguyễn Trường An' đã làm:
SELECT 
    SP.TenSP,
    TP.Ngay,
    TP.SoLuong,
    (TP.SoLuong * SP.TienCong) AS ThanhTien
FROM ThanhPham TP
JOIN SanPham SP ON TP.MaSP = SP.MaSP
JOIN CongNhan CN ON TP.MACN = CN.MACN
WHERE CONCAT(CN.Ho, ' ', CN.Ten) = N'Nguyễn Trường An'
ORDER BY TP.Ngay;
--3) Liệt kê nhân viên không sản xuất sản phẩm 'Bình gốm lớn':
SELECT 
    CONCAT(CN.Ho, ' ', CN.Ten) AS HoTen
FROM CongNhan CN
WHERE CN.MACN NOT IN (
    SELECT TP.MACN
    FROM ThanhPham TP
    JOIN SanPham SP ON TP.MaSP = SP.MaSP
    WHERE SP.TenSP = N'Bình gốm lớn'
);
--4) Liệt kê công nhân sản xuất cả 'Nồi đất' và 'Bình gốm nhỏ':
SELECT 
    CONCAT(CN.Ho, ' ', CN.Ten) AS HoTen
FROM CongNhan CN
WHERE CN.MACN IN (
    SELECT TP.MACN
    FROM ThanhPham TP
    JOIN SanPham SP ON TP.MaSP = SP.MaSP
    WHERE SP.TenSP = N'Nồi đất'
)
AND CN.MACN IN (
    SELECT TP.MACN
    FROM ThanhPham TP
    JOIN SanPham SP ON TP.MaSP = SP.MaSP
    WHERE SP.TenSP = N'Bình gốm nhỏ'
);

--5) Thống kê số lượng công nhân theo từng tổ sản xuất:
SELECT 
    TSX.TenTSX,
    COUNT(CN.MACN) AS SoLuongCongNhan
FROM ToSanXuat TSX
JOIN CongNhan CN ON TSX.MaTSX = CN.MaTSX
GROUP BY TSX.TenTSX;
--6) Tổng số lượng và tiền công mỗi nhân viên:
SELECT 
    CN.Ho,
    CN.Ten,
    SP.TenSP,
    SUM(TP.SoLuong) AS TongSLThanhPham,
    SUM(TP.SoLuong * SP.TienCong) AS TongThanhTien
FROM CongNhan CN
JOIN ThanhPham TP ON CN.MACN = TP.MACN
JOIN SanPham SP ON TP.MaSP = SP.MaSP
GROUP BY CN.Ho, CN.Ten, SP.TenSP;
--7) Tổng tiền công trả trong tháng 1/2007:
SELECT 
    SUM(TP.SoLuong * SP.TienCong) AS TongTienCong
FROM ThanhPham TP
JOIN SanPham SP ON TP.MaSP = SP.MaSP
WHERE YEAR(TP.Ngay) = 2007 AND MONTH(TP.Ngay) = 1;
--8) Sản phẩm được sản xuất nhiều nhất trong tháng 2/2007:
SELECT TOP 1
    SP.TenSP,
    SUM(TP.SoLuong) AS TongSanLuong
FROM ThanhPham TP
JOIN SanPham SP ON TP.MaSP = SP.MaSP
WHERE YEAR(TP.Ngay) = 2007 AND MONTH(TP.Ngay) = 2
GROUP BY SP.TenSP
ORDER BY TongSanLuong DESC;

--9) Công nhân sản xuất 'Chén' nhiều nhất:
SELECT TOP 1 
    CONCAT(CN.Ho, ' ', CN.Ten) AS HoTen,
    SUM(TP.SoLuong) AS TongSoLuong
FROM CongNhan CN
JOIN ThanhPham TP ON CN.MACN = TP.MACN
JOIN SanPham SP ON TP.MaSP = SP.MaSP
WHERE SP.TenSP = N'Chén'
GROUP BY CN.Ho, CN.Ten
ORDER BY TongSoLuong DESC;

--10) Tiền công tháng 2/2007 của 'CN002':
SELECT 
    SUM(TP.SoLuong * SP.TienCong) AS TongTienCong
FROM ThanhPham TP
JOIN SanPham SP ON TP.MaSP = SP.MaSP
WHERE TP.MACN = 'CN002' AND YEAR(TP.Ngay) = 2007 AND MONTH(TP.Ngay) = 2;

--11) Công nhân sản xuất từ 3 loại sản phẩm trở lên:
SELECT 
    CONCAT(CN.Ho, ' ', CN.Ten) AS HoTen
FROM CongNhan CN
JOIN ThanhPham TP ON CN.MACN = TP.MACN
GROUP BY CN.MACN, CN.Ho, CN.Ten
HAVING COUNT(DISTINCT TP.MaSP) >= 3;

--12) Cập nhật giá tiền công của các loại bình gốm:
UPDATE SanPham
SET TienCong = TienCong + 1000
WHERE TenSP LIKE N'Bình gốm%';

--13) Thêm công nhân mới:
INSERT INTO CongNhan (MACN, Ho, Ten, Phai, MaTSX)
VALUES ('CN006', N'Lê Thị', N'Lan', N'Nữ', 'TS02');

--A. Viết các hàm
--a) Tính tổng số công nhân của một tổ sản xuất cho trước
CREATE FUNCTION TongSoCongNhan (@MaTSX CHAR(4))
RETURNS INT
AS
BEGIN
    DECLARE @SoCongNhan INT;
    SELECT @SoCongNhan = COUNT(*)
    FROM CongNhan
    WHERE MaTSX = @MaTSX;
    RETURN @SoCongNhan;
END;
-- dùng
SELECT dbo.TongSoCongNhan('TS01') AS TongCongNhan;

--b) Tính tổng sản lượng sản xuất trong một tháng của một loại sản phẩm cho trước
CREATE FUNCTION TongSanLuongThang (@MaSP CHAR(5), @Nam INT, @Thang INT)
RETURNS INT
AS
BEGIN
    DECLARE @TongSanLuong INT;
    SELECT @TongSanLuong = SUM(SoLuong)
    FROM ThanhPham
    WHERE MaSP = @MaSP AND YEAR(Ngay) = @Nam AND MONTH(Ngay) = @Thang;
    RETURN @TongSanLuong;
END;

-- dùng
SELECT dbo.TongSanLuongThang('SP001', 2007, 2) AS TongSanLuong;

--c) Tính tổng tiền công tháng của một công nhân cho trước
CREATE FUNCTION TongTienCongThang (@MACN CHAR(5), @Nam INT, @Thang INT)
RETURNS DECIMAL(10, 2)
AS
BEGIN
    DECLARE @TongTienCong DECIMAL(10, 2);
    SELECT @TongTienCong = SUM(TP.SoLuong * SP.TienCong)
    FROM ThanhPham TP
    JOIN SanPham SP ON TP.MaSP = SP.MaSP
    WHERE TP.MACN = @MACN AND YEAR(TP.Ngay) = @Nam AND MONTH(TP.Ngay) = @Thang;
    RETURN @TongTienCong;
END;

-- dùng
SELECT dbo.TongTienCongThang('CN002', 2007, 2) AS TongTienCong;

--d) Tính tổng thu nhập trong năm của một tổ sản xuất cho trước
CREATE FUNCTION TongThuNhapNam (@MaTSX CHAR(4), @Nam INT)
RETURNS DECIMAL(10, 2)
AS
BEGIN
    DECLARE @TongThuNhap DECIMAL(10, 2);
    SELECT @TongThuNhap = SUM(TP.SoLuong * SP.TienCong)
    FROM ThanhPham TP
    JOIN SanPham SP ON TP.MaSP = SP.MaSP
    JOIN CongNhan CN ON TP.MACN = CN.MACN
    WHERE CN.MaTSX = @MaTSX AND YEAR(TP.Ngay) = @Nam;
    RETURN @TongThuNhap;
END;

-- dùng
SELECT dbo.TongThuNhapNam('TS01', 2007) AS TongThuNhap;

--e) Tính tổng sản lượng sản xuất của một loại sản phẩm trong một khoảng thời gian cho trước
CREATE FUNCTION TongSanLuongKhoangThoiGian (@MaSP CHAR(5), @NgayBD DATE, @NgayKT DATE)
RETURNS INT
AS
BEGIN
    DECLARE @TongSanLuong INT;
    SELECT @TongSanLuong = SUM(SoLuong)
    FROM ThanhPham
    WHERE MaSP = @MaSP AND Ngay BETWEEN @NgayBD AND @NgayKT;
    RETURN @TongSanLuong;
END;

-- dùng
SELECT dbo.TongSanLuongKhoangThoiGian('SP003', '2007-01-01', '2007-02-01') AS TongSanLuong;

-- B. Viết các thủ tục
--a) In danh sách các công nhân của một tổ sản xuất cho trước
CREATE PROCEDURE InDanhSachCongNhan (@MaTSX CHAR(4))
AS
BEGIN
    SELECT 
        CONCAT(Ho, ' ', Ten) AS HoTen,
        NgaySinh,
        Phai
    FROM CongNhan
    WHERE MaTSX = @MaTSX
    ORDER BY Ten;
END;

-- dùng
EXEC InDanhSachCongNhan 'TS01';

--b) In bảng chấm công sản xuất trong tháng của một công nhân cho trước
CREATE PROCEDURE BangChamCongThang (@MACN CHAR(5), @Nam INT, @Thang INT)
AS
BEGIN
    SELECT 
        SP.TenSP,
        SP.DVT,
        TP.SoLuong,
        SP.TienCong AS DonGia,
        (TP.SoLuong * SP.TienCong) AS ThanhTien
    FROM ThanhPham TP
    JOIN SanPham SP ON TP.MaSP = SP.MaSP
    WHERE TP.MACN = @MACN AND YEAR(TP.Ngay) = @Nam AND MONTH(TP.Ngay) = @Thang
    ORDER BY TP.Ngay;
END;

-- dùng
EXEC BangChamCongThang 'CN002', 2007, 1;


