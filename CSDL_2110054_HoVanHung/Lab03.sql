CREATE DATABASE Lab03_QLNhapXuatHangHoa;
GO
USE Lab03_QLNhapXuatHangHoa;
GO

CREATE TABLE HANGHOA (
    MAHH CHAR(6) PRIMARY KEY,
    TENHH NVARCHAR(100) NOT NULL,
    DVT NVARCHAR(10) NOT NULL,
    SOLUONGTON INT NOT NULL CHECK (SOLUONGTON >= 0) -- Ràng buộc: Số lượng tồn không âm
);

CREATE TABLE DOITAC (
    MADT CHAR(5) PRIMARY KEY,
    TENDT NVARCHAR(100) NOT NULL,
    DIACHI NVARCHAR(200),
    DIENTHOAI CHAR(15),
    CHECK (MADT LIKE 'CC%' OR MADT LIKE 'K%') -- Mã đối tác phải theo định dạng
);
CREATE TABLE KHANANGCC (
    MADT CHAR(5) NOT NULL,
    MAHH CHAR(6) NOT NULL,
    PRIMARY KEY (MADT, MAHH),
    FOREIGN KEY (MADT) REFERENCES DOITAC(MADT),
    FOREIGN KEY (MAHH) REFERENCES HANGHOA(MAHH)
);

CREATE TABLE HOADON (
    SOHD CHAR(5) PRIMARY KEY,
    NGAYLAPHD DATE NOT NULL,
    MADT CHAR(5) NOT NULL,
    TONGTG DECIMAL(15, 2) NOT NULL CHECK (TONGTG >= 0), -- Tổng tiền không âm
    FOREIGN KEY (MADT) REFERENCES DOITAC(MADT),
    CHECK (SOHD LIKE 'N%' OR SOHD LIKE 'X%') -- Mã hóa đơn phải theo định dạng
);

CREATE TABLE CT_HOADON (
    SOHD CHAR(5) NOT NULL,
    MAHH CHAR(6) NOT NULL,
    DONGIA DECIMAL(15, 2) NOT NULL CHECK (DONGIA > 0), -- Đơn giá dương
    SOLUONG INT NOT NULL CHECK (SOLUONG > 0), -- Số lượng dương
    PRIMARY KEY (SOHD, MAHH),
    FOREIGN KEY (SOHD) REFERENCES HOADON(SOHD),
    FOREIGN KEY (MAHH) REFERENCES HANGHOA(MAHH)
);

INSERT INTO HANGHOA (MAHH, TENHH, DVT, SOLUONGTON)
VALUES
    ('CPU01', N'CPU INTEL,CELERON 600 BOX', 'CÁI', 5),
    ('CPU02', N'CPU INTEL,PIII 700', 'CÁI', 10),
    ('CPU03', N'CPU AMD K7 ATHLON 600', 'CÁI', 8),
    ('HDD01', N'HDD 10.2 GB QUANTUM', 'CÁI', 10),
    ('HDD02', N'HDD 13.6 GB SEAGATE', 'CÁI', 15),
    ('HDD03', N'HDD 20 GB QUANTUM', 'CÁI', 6),
    ('KB01', N'KB GENIUS', 'CÁI', 12),
    ('KB02', N'KB MITSUMIMI', 'CÁI', 5),
    ('MB01', N'GIGABYTE CHIPSET INTEL', 'CÁI', 10),
    ('MB02', N'ACOPR BX CHIPSET VIA', 'CÁI', 10),
    ('MB03', N'INTEL PHI CHIPSET INTEL', 'CÁI', 10),
    ('MB04', N'ECS CHIPSET SIS', 'CÁI', 10),
    ('MB05', N'ECS CHIPSET VIA', 'CÁI', 10),
    ('MNT01', N'SAMSUNG 14" SYNCMASTER', 'CÁI', 5),
    ('MNT02', N'LG 14"', 'CÁI', 5),
    ('MNT03', N'ACER 14"', 'CÁI', 8),
    ('MNT04', N'PHILIPS 14"', 'CÁI', 6),
    ('MNT05', N'VIEWSONIC 14"', 'CÁI', 7);

INSERT INTO DOITAC (MADT, TENDT, DIACHI, DIENTHOAI)
VALUES
    ('CC001', N'Cty TNC', N'176 BTX Q1 - TPHCM', '08.8250259'),
    ('CC002', N'Cty Hoàng Long', N'15A TTT Q1 -TP. HCM', '08.8250898'),
    ('CC003', N'Cty Hợp Nhất', N'152 BTX Q1-TP.HCM', '08.8252376'),
    ('K0001', N'Nguyễn Minh Hải', N'91 Nguyễn Văn Trỗi Tp. Đà Lạt', '063.831129'),
    ('K0002', N'Như Quỳnh', N'21 Điện Biên Phủ. N.Trang', '058590270'),
    ('K0003', N'Trần Nhật Duật', N'Lê Lợi TP. Huế', '054.848376'),
    ('K0004', N'Phan Nguyễn Hùng Anh', N'11 Nam Kỳ Khởi nghĩa- TP. Đà lạt', '063.823409');


INSERT INTO HOADON (SOHD, NGAYLAPHD, MADT, TONGTG)
VALUES
    ('N0001', '2006-01-25', 'CC001', 1000000),
    ('N0002', '2006-05-01', 'CC002', 1500000),
    ('X0001', '2006-05-12', 'K0001', 500000),
    ('X0002', '2006-06-16', 'K0002', 700000),
    ('X0003', '2006-04-20', 'K0001', 800000);


INSERT INTO KHANANGCC (MADT, MAHH)
VALUES
    ('CC001', 'CPU01'),
    ('CC001', 'HDD03'),
    ('CC001', 'KB01'),
    ('CC001', 'MB02'),
    ('CC001', 'MB04'),
    ('CC001', 'MNT01'),
    ('CC002', 'CPU01'),
    ('CC002', 'CPU02'),
    ('CC002', 'CPU03'),
    ('CC002', 'KB02'),
    ('CC002', 'MB01'),
    ('CC002', 'MB05'),
    ('CC002', 'MNT03'),
    ('CC003', 'HDD01'),
    ('CC003', 'HDD02'),
    ('CC003', 'HDD03'),
    ('CC003', 'MB03');


INSERT INTO CT_HOADON (SOHD, MAHH, DONGIA, SOLUONG)
VALUES
    ('N0001', 'CPU01', 63, 10),
    ('N0001', 'HDD03', 97, 7),
    ('N0001', 'KB01', 3, 5),
    ('N0001', 'MB02', 57, 5),
    ('N0001', 'MNT01', 112, 3),
    ('N0002', 'CPU02', 115, 3),
    ('N0002', 'KB02', 5, 7),
    ('N0002', 'MNT03', 111, 5),
    ('X0001', 'CPU01', 67, 2),
    ('X0001', 'HDD03', 100, 2),
    ('X0001', 'KB01', 5, 2),
    ('X0001', 'MB02', 62, 1),
    ('X0002', 'CPU01', 67, 1),
    ('X0002', 'KB02', 7, 3),
    ('X0002', 'MNT01', 115, 2),
    ('X0003', 'CPU01', 67, 1),
    ('X0003', 'MNT03', 115, 2);

--1) Liệt kê các mặt hàng thuộc loại đĩa cứng
SELECT MAHH, TENHH, DVT, SOLUONGTON
FROM HANGHOA
WHERE TENHH LIKE N'%HDD%';


--2) Liệt kê các mặt hàng có số lượng tồn trên 10
SELECT MAHH, TENHH, DVT, SOLUONGTON
FROM HANGHOA
WHERE SOLUONGTON > 10;

--3) Thông tin các nhà cung cấp ở Thành phố Hồ Chí Minh
SELECT MADT, TENDT, DIACHI, DIENTHOAI
FROM DOITAC
WHERE DIACHI LIKE N'%TP.HCM%';

--4) Liệt kê các hóa đơn nhập hàng trong tháng 5/2006
SELECT 
    HD.SOHD, 
    HD.NGAYLAPHD, 
    DT.TENDT, 
    DT.DIACHI, 
    DT.DIENTHOAI, 
    COUNT(CT.MAHH) AS SoMatHang
FROM HOADON HD
JOIN DOITAC DT ON HD.MADT = DT.MADT
JOIN CT_HOADON CT ON HD.SOHD = CT.SOHD
WHERE HD.SOHD LIKE 'N%' AND MONTH(HD.NGAYLAPHD) = 5 AND YEAR(HD.NGAYLAPHD) = 2006
GROUP BY HD.SOHD, HD.NGAYLAPHD, DT.TENDT, DT.DIACHI, DT.DIENTHOAI;

--5) Tên các nhà cung cấp có cung cấp đĩa cứng
SELECT DISTINCT DT.TENDT
FROM KHANANGCC K
JOIN HANGHOA H ON K.MAHH = H.MAHH
JOIN DOITAC DT ON K.MADT = DT.MADT
WHERE H.TENHH LIKE N'%HDD%';

--6) Nhà cung cấp có thể cung cấp tất cả các loại đĩa cứng
SELECT TENDT
FROM DOITAC DT
WHERE NOT EXISTS (
    SELECT *
    FROM HANGHOA H
    WHERE H.TENHH LIKE N'%HDD%'
    AND NOT EXISTS (
        SELECT *
        FROM KHANANGCC K
        WHERE K.MADT = DT.MADT AND K.MAHH = H.MAHH
    )
);

--7) Nhà cung cấp không cung cấp đĩa cứng
SELECT TENDT
FROM DOITAC DT
WHERE NOT EXISTS (
    SELECT *
    FROM KHANANGCC K
    JOIN HANGHOA H ON K.MAHH = H.MAHH
    WHERE DT.MADT = K.MADT AND H.TENHH LIKE N'%HDD%'
);

--8) Mặt hàng chưa bán được
SELECT H.MAHH, H.TENHH, H.DVT
FROM HANGHOA H
WHERE NOT EXISTS (
    SELECT *
    FROM CT_HOADON CT
    WHERE H.MAHH = CT.MAHH
);

--9) Mặt hàng bán chạy nhất (tính theo số lượng)
SELECT TOP 1 H.TENHH, SUM(CT.SOLUONG) AS TongSoLuong
FROM HANGHOA H
JOIN CT_HOADON CT ON H.MAHH = CT.MAHH
GROUP BY H.TENHH
ORDER BY SUM(CT.SOLUONG) DESC;

--10) Mặt hàng nhập về ít nhất
SELECT TOP 1 H.TENHH, SUM(CT.SOLUONG) AS TongNhap
FROM HANGHOA H
JOIN CT_HOADON CT ON H.MAHH = CT.MAHH
JOIN HOADON HD ON CT.SOHD = HD.SOHD
WHERE HD.SOHD LIKE 'N%'
GROUP BY H.TENHH
ORDER BY SUM(CT.SOLUONG) ASC;

--11) Hóa đơn nhập nhiều mặt hàng nhất
SELECT TOP 1 HD.SOHD, COUNT(CT.MAHH) AS SoMatHang
FROM HOADON HD
JOIN CT_HOADON CT ON HD.SOHD = CT.SOHD
WHERE HD.SOHD LIKE 'N%'
GROUP BY HD.SOHD
ORDER BY COUNT(CT.MAHH) DESC;

--12) Mặt hàng không được nhập hàng trong tháng 1/2006
SELECT MAHH, TENHH
FROM HANGHOA
WHERE MAHH NOT IN (
    SELECT DISTINCT CT.MAHH
    FROM CT_HOADON CT
    JOIN HOADON HD ON CT.SOHD = HD.SOHD
    WHERE HD.SOHD LIKE 'N%' AND MONTH(HD.NGAYLAPHD) = 1 AND YEAR(HD.NGAYLAPHD) = 2006
);

--13) Mặt hàng không bán trong tháng 6/2006
SELECT MAHH, TENHH
FROM HANGHOA
WHERE MAHH NOT IN (
    SELECT DISTINCT CT.MAHH
    FROM CT_HOADON CT
    JOIN HOADON HD ON CT.SOHD = HD.SOHD
    WHERE HD.SOHD LIKE 'X%' AND MONTH(HD.NGAYLAPHD) = 6 AND YEAR(HD.NGAYLAPHD) = 2006
);

--14) Cửa hàng bán bao nhiêu mặt hàng
SELECT COUNT(DISTINCT CT.MAHH) AS SoMatHangBanDuoc
FROM CT_HOADON CT
JOIN HOADON HD ON CT.SOHD = HD.SOHD
WHERE HD.SOHD LIKE 'X%';

--15) Số mặt hàng mà từng nhà cung cấp có thể cung cấp
SELECT DT.TENDT, COUNT(DISTINCT K.MAHH) AS SoMatHang
FROM DOITAC DT
JOIN KHANANGCC K ON DT.MADT = K.MADT
GROUP BY DT.TENDT;

--16) Khách hàng giao dịch nhiều nhất
SELECT TOP 1 DT.TENDT, COUNT(HD.SOHD) AS SoLanGiaoDich
FROM DOITAC DT
JOIN HOADON HD ON DT.MADT = HD.MADT
WHERE DT.MADT LIKE 'K%'
GROUP BY DT.TENDT
ORDER BY COUNT(HD.SOHD) DESC;

--17) Tổng doanh thu năm 2006
SELECT SUM(CT.SOLUONG * CT.DONGIA) AS TongDoanhThu
FROM CT_HOADON CT
JOIN HOADON HD ON CT.SOHD = HD.SOHD
WHERE HD.SOHD LIKE 'X%' AND YEAR(HD.NGAYLAPHD) = 2006;

--18) Loại mặt hàng bán chạy nhất
SELECT TOP 1 LEFT(TENHH, CHARINDEX(' ', TENHH)) AS LoaiHang, SUM(SOLUONG) AS TongSoLuong
FROM HANGHOA H
JOIN CT_HOADON CT ON H.MAHH = CT.MAHH
GROUP BY LEFT(TENHH, CHARINDEX(' ', TENHH))
ORDER BY SUM(SOLUONG) DESC;

--19) Thông tin bán hàng tháng 5/2006
SELECT H.MAHH, H.TENHH, H.DVT, SUM(CT.SOLUONG) AS TongSoLuong, SUM(CT.SOLUONG * CT.DONGIA) AS TongThanhTien
FROM HANGHOA H
JOIN CT_HOADON CT ON H.MAHH = CT.MAHH
JOIN HOADON HD ON CT.SOHD = HD.SOHD
WHERE HD.SOHD LIKE 'X%' AND MONTH(HD.NGAYLAPHD) = 5 AND YEAR(HD.NGAYLAPHD) = 2006
GROUP BY H.MAHH, H.TENHH, H.DVT;

--20) Mặt hàng có nhiều người mua nhất
SELECT TOP 1 H.TENHH, COUNT(DISTINCT HD.MADT) AS SoNguoiMua
FROM HANGHOA H
JOIN CT_HOADON CT ON H.MAHH = CT.MAHH
JOIN HOADON HD ON CT.SOHD = HD.SOHD
WHERE HD.SOHD LIKE 'X%'
GROUP BY H.TENHH
ORDER BY COUNT(DISTINCT HD.MADT) DESC;

--21) Cập nhật tổng trị giá các hóa đơn
UPDATE HOADON
SET TONGTG = (
    SELECT SUM(CT.SOLUONG * CT.DONGIA)
    FROM CT_HOADON CT
    WHERE CT.SOHD = HOADON.SOHD
);

--A. Viết các hàm
--a. Tính tổng số lượng nhập trong một khoảng thời gian của một mặt hàng cho trước.
CREATE FUNCTION fn_TongSoLuongNhap(
    @maHH CHAR(6),
    @startDate DATE,
    @endDate DATE
) RETURNS INT
AS
BEGIN
    DECLARE @totalQuantity INT;

    SELECT @totalQuantity = SUM(CT.SOLUONG)
    FROM HOADON H
    JOIN CT_HOADON CT ON H.SOHD = CT.SOHD
    WHERE CT.MAHH = @maHH
    AND H.NGAYLAPHD BETWEEN @startDate AND @endDate
    AND H.SOHD LIKE 'N%'  -- 'N%' chỉ các hóa đơn nhập

    RETURN @totalQuantity;
END;


--b. Tính tổng số lượng xuất trong một khoảng thời gian của một mặt hàng cho trước.
CREATE FUNCTION fn_TongSoLuongXuat(
    @maHH CHAR(6),
    @startDate DATE,
    @endDate DATE
) RETURNS INT
AS
BEGIN
    DECLARE @totalQuantity INT;

    SELECT @totalQuantity = SUM(CT.SOLUONG)
    FROM HOADON H
    JOIN CT_HOADON CT ON H.SOHD = CT.SOHD
    WHERE CT.MAHH = @maHH
    AND H.NGAYLAPHD BETWEEN @startDate AND @endDate
    AND H.SOHD LIKE 'X%'  -- 'X%' chỉ các hóa đơn xuất

    RETURN @totalQuantity;
END;


--c. Tính tổng doanh thu trong một tháng cho trước.
CREATE FUNCTION fn_TongDoanhThu(
    @month INT,
    @year INT
) RETURNS DECIMAL(15,2)
AS
BEGIN
    DECLARE @totalRevenue DECIMAL(15,2);

    SELECT @totalRevenue = SUM(TONGTG)
    FROM HOADON
    WHERE MONTH(NGAYLAPHD) = @month
    AND YEAR(NGAYLAPHD) = @year
    AND SOHD LIKE 'X%'  -- 'X%' chỉ các hóa đơn xuất

    RETURN @totalRevenue;
END;

--d. Tính tổng doanh thu của một mặt hàng trong một khoảng thời gian cho trước.
CREATE FUNCTION fn_TongDoanhThuMatHang(
    @maHH CHAR(6),
    @startDate DATE,
    @endDate DATE
) RETURNS DECIMAL(15,2)
AS
BEGIN
    DECLARE @totalRevenue DECIMAL(15,2);

    SELECT @totalRevenue = SUM(CT.SOLUONG * CT.DONGIA)
    FROM HOADON H
    JOIN CT_HOADON CT ON H.SOHD = CT.SOHD
    WHERE CT.MAHH = @maHH
    AND H.NGAYLAPHD BETWEEN @startDate AND @endDate
    AND H.SOHD LIKE 'X%'  -- 'X%' chỉ các hóa đơn xuất

    RETURN @totalRevenue;
END;

--e. Tính tổng số tiền nhập hàng trong một khoảng thời gian cho trước.
CREATE FUNCTION fn_TongTienNhap(
    @startDate DATE,
    @endDate DATE
) RETURNS DECIMAL(15,2)
AS
BEGIN
    DECLARE @totalCost DECIMAL(15,2);

    SELECT @totalCost = SUM(CT.SOLUONG * CT.DONGIA)
    FROM HOADON H
    JOIN CT_HOADON CT ON H.SOHD = CT.SOHD
    WHERE H.NGAYLAPHD BETWEEN @startDate AND @endDate
    AND H.SOHD LIKE 'N%'  -- 'N%' chỉ các hóa đơn nhập

    RETURN @totalCost;
END;

--f. Tính tổng số tiền của một hóa đơn cho trước.
CREATE FUNCTION fn_TongTienHoaDon(
    @soHD CHAR(5)
) RETURNS DECIMAL(15,2)
AS
BEGIN
    DECLARE @totalAmount DECIMAL(15,2);

    SELECT @totalAmount = SUM(CT.SOLUONG * CT.DONGIA)
    FROM CT_HOADON CT
    WHERE CT.SOHD = @soHD

    RETURN @totalAmount;
END;

--B. Viết các thủ tục
--a. Cập nhật số lượng tồn của một mặt hàng khi nhập hàng hoặc xuất hàng.
CREATE PROCEDURE sp_CapNhatSoLuongTon(
    @maHH CHAR(6),
    @soLuong INT,
    @operation CHAR(1)  -- 'I' cho nhập hàng, 'E' cho xuất hàng
)
AS
BEGIN
    IF @operation = 'I'  -- Nếu là nhập hàng
    BEGIN
        UPDATE HANGHOA
        SET SOLUONGTON = SOLUONGTON + @soLuong
        WHERE MAHH = @maHH;
    END
    ELSE IF @operation = 'E'  -- Nếu là xuất hàng
    BEGIN
        UPDATE HANGHOA
        SET SOLUONGTON = SOLUONGTON - @soLuong
        WHERE MAHH = @maHH;
    END
END;

--b. Cập nhật tổng trị giá của một hóa đơn.
CREATE PROCEDURE sp_CapNhatTongTienHoaDon(
    @soHD CHAR(5)
)
AS
BEGIN
    DECLARE @totalAmount DECIMAL(15,2);

    SELECT @totalAmount = SUM(CT.SOLUONG * CT.DONGIA)
    FROM CT_HOADON CT
    WHERE CT.SOHD = @soHD;

    UPDATE HOADON
    SET TONGTG = @totalAmount
    WHERE SOHD = @soHD;
END;

--c. In đầy đủ thông tin của một hóa đơn.
CREATE PROCEDURE sp_InHoaDon(
    @soHD CHAR(5)
)
AS
BEGIN
    SELECT H.SOHD, H.NGAYLAPHD, D.TENDT, H.TONGTG
    FROM HOADON H
    JOIN DOITAC D ON H.MADT = D.MADT
    WHERE H.SOHD = @soHD;

    SELECT CT.MAHH, HH.TENHH, CT.SOLUONG, CT.DONGIA, (CT.SOLUONG * CT.DONGIA) AS TONGTIEN
    FROM CT_HOADON CT
    JOIN HANGHOA HH ON CT.MAHH = HH.MAHH
    WHERE CT.SOHD = @soHD;
END;






