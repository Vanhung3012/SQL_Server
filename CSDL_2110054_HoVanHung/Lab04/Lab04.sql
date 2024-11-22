-- I. TẠO CƠ SỞ DỮ LIỆU
CREATE DATABASE Lab04_QLDatBao;
GO

USE Lab04_QLDatBao;
GO

-- II. TẠO CÁC BẢNG VÀ RÀNG BUỘC
-- 1. Bảng BAO_TCHI
CREATE TABLE BAO_TCHI (
    MaBaoTC CHAR(5) PRIMARY KEY,
    Ten NVARCHAR(100) NOT NULL,
    DinhKy NVARCHAR(50) NOT NULL,
    SoLuong INT NOT NULL,
    GiaBan DECIMAL(15, 2) NOT NULL,
    CONSTRAINT CHK_GiaBan CHECK (GiaBan > 0),
    CONSTRAINT CHK_SoLuong CHECK (SoLuong > 0)
);

-- 2. Bảng PHATHANH
CREATE TABLE PHATHANH (
    MaBaoTC CHAR(5),
    SoBaoTC INT,
    NgayPH DATE NOT NULL,
    PRIMARY KEY (MaBaoTC, SoBaoTC),
    FOREIGN KEY (MaBaoTC) REFERENCES BAO_TCHI(MaBaoTC)
);

-- 3. Bảng KHACHHANG
CREATE TABLE KHACHHANG (
    MaKH CHAR(5) PRIMARY KEY,
    TenKH NVARCHAR(100) NOT NULL,
    DiaChi NVARCHAR(200) NOT NULL
);

-- 4. Bảng DATBAO
CREATE TABLE DATBAO (
    MaKH CHAR(5),
    MaBaoTC CHAR(5),
    SLMua INT NOT NULL,
    NgayDM DATE NOT NULL,
    PRIMARY KEY (MaKH, MaBaoTC),
    FOREIGN KEY (MaKH) REFERENCES KHACHHANG(MaKH),
    FOREIGN KEY (MaBaoTC) REFERENCES BAO_TCHI(MaBaoTC),
    CONSTRAINT CHK_SLMua CHECK (SLMua > 0)
);

-- III. TẠO CÁC CHỈ MỤC
CREATE INDEX IX_BaoTchi_Ten ON BAO_TCHI(Ten);
CREATE INDEX IX_KhachHang_Ten ON KHACHHANG(TenKH);
CREATE INDEX IX_DatBao_NgayDM ON DATBAO(NgayDM);
CREATE INDEX IX_PhatHanh_NgayPH ON PHATHANH(NgayPH);

-- IV. TẠO CÁC STORED PROCEDURES
-- 1. Thêm báo/tạp chí
CREATE PROCEDURE sp_ThemBaoTchi
    @MaBaoTC CHAR(5),
    @Ten NVARCHAR(100),
    @DinhKy NVARCHAR(50),
    @SoLuong INT,
    @GiaBan DECIMAL(15,2)
AS
BEGIN
    BEGIN TRY
        IF @SoLuong <= 0
            THROW 50001, N'Số lượng phải lớn hơn 0', 1;
        IF @GiaBan <= 0
            THROW 50002, N'Giá bán phải lớn hơn 0', 1;

        INSERT INTO BAO_TCHI (MaBaoTC, Ten, DinhKy, SoLuong, GiaBan)
        VALUES (@MaBaoTC, @Ten, @DinhKy, @SoLuong, @GiaBan);
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMsg NVARCHAR(2000) = ERROR_MESSAGE();
        THROW 50000, @ErrorMsg, 1;
    END CATCH;
END;
GO

-- 2. Thêm phát hành
CREATE PROCEDURE sp_ThemPhatHanh
    @MaBaoTC CHAR(5),
    @SoBaoTC INT,
    @NgayPH DATE
AS
BEGIN
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM BAO_TCHI WHERE MaBaoTC = @MaBaoTC)
            THROW 50003, N'Mã báo/tạp chí không tồn tại', 1;
        
        INSERT INTO PHATHANH (MaBaoTC, SoBaoTC, NgayPH)
        VALUES (@MaBaoTC, @SoBaoTC, @NgayPH);
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMsg NVARCHAR(2000) = ERROR_MESSAGE();
        THROW 50000, @ErrorMsg, 1;
    END CATCH;
END;
GO

-- 3. Thêm khách hàng
CREATE PROCEDURE sp_ThemKhachHang
    @MaKH CHAR(5),
    @TenKH NVARCHAR(100),
    @DiaChi NVARCHAR(200)
AS
BEGIN
    BEGIN TRY
        IF EXISTS (SELECT 1 FROM KHACHHANG WHERE MaKH = @MaKH)
            THROW 50004, N'Mã khách hàng đã tồn tại', 1;
        
        INSERT INTO KHACHHANG (MaKH, TenKH, DiaChi)
        VALUES (@MaKH, @TenKH, @DiaChi);
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMsg NVARCHAR(2000) = ERROR_MESSAGE();
        THROW 50000, @ErrorMsg, 1;
    END CATCH;
END;
GO

-- 4. Thêm đặt báo
CREATE PROCEDURE sp_ThemDatBao
    @MaKH CHAR(5),
    @MaBaoTC CHAR(5),
    @SLMua INT,
    @NgayDM DATE
AS
BEGIN
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM KHACHHANG WHERE MaKH = @MaKH)
            THROW 50005, N'Mã khách hàng không tồn tại', 1;
        
        IF NOT EXISTS (SELECT 1 FROM BAO_TCHI WHERE MaBaoTC = @MaBaoTC)
            THROW 50006, N'Mã báo/tạp chí không tồn tại', 1;
            
        IF @SLMua <= 0
            THROW 50007, N'Số lượng mua phải lớn hơn 0', 1;

        INSERT INTO DATBAO (MaKH, MaBaoTC, SLMua, NgayDM)
        VALUES (@MaKH, @MaBaoTC, @SLMua, @NgayDM);
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMsg NVARCHAR(2000) = ERROR_MESSAGE();
        THROW 50000, @ErrorMsg, 1;
    END CATCH;
END;
GO

-- V. TẠO CÁC VIEWS
-- 1. View thống kê doanh thu theo tháng
CREATE VIEW vw_DoanhThuTheoThang AS
SELECT 
    MONTH(DB.NgayDM) as Thang,
    YEAR(DB.NgayDM) as Nam,
    COUNT(DISTINCT DB.MaKH) as SoKhachHang,
    SUM(DB.SLMua) as TongSoLuong,
    SUM(DB.SLMua * BT.GiaBan) as DoanhThu
FROM DATBAO DB
JOIN BAO_TCHI BT ON DB.MaBaoTC = BT.MaBaoTC
GROUP BY MONTH(DB.NgayDM), YEAR(DB.NgayDM);
GO

-- 2. View thống kê đặt báo theo khách hàng
CREATE VIEW vw_ThongKeDatBaoTheoKH AS
SELECT 
    KH.MaKH,
    KH.TenKH,
    COUNT(DISTINCT DB.MaBaoTC) as SoLoaiBao,
    SUM(DB.SLMua) as TongSoLuong,
    SUM(DB.SLMua * BT.GiaBan) as TongTienDat
FROM KHACHHANG KH
LEFT JOIN DATBAO DB ON KH.MaKH = DB.MaKH
LEFT JOIN BAO_TCHI BT ON DB.MaBaoTC = BT.MaBaoTC
GROUP BY KH.MaKH, KH.TenKH;
GO

-- VI. TẠO CÁC FUNCTIONS
-- 1. Function tính tổng tiền mua báo của khách hàng
CREATE FUNCTION fn_TongTienMuaBao (@MaKH CHAR(5))
RETURNS TABLE
AS
RETURN
    SELECT 
        KH.TenKH,
        SUM(DB.SLMua * BT.GiaBan) as TongTien,
        COUNT(DISTINCT DB.MaBaoTC) as SoLoaiBao,
        MAX(DB.NgayDM) as NgayDatGanNhat
    FROM KHACHHANG KH
    LEFT JOIN DATBAO DB ON KH.MaKH = DB.MaKH
    LEFT JOIN BAO_TCHI BT ON DB.MaBaoTC = BT.MaBaoTC
    WHERE KH.MaKH = @MaKH
    GROUP BY KH.TenKH;
GO

-- 2. Function tính tổng tiền thu được của báo/tạp chí
CREATE FUNCTION fn_TongTienThu (@MaBaoTC CHAR(5))
RETURNS TABLE
AS
RETURN
    SELECT 
        BT.Ten,
        BT.DinhKy,
        SUM(DB.SLMua) as TongSoLuongDat,
        COUNT(DISTINCT DB.MaKH) as SoKhachHang,
        SUM(DB.SLMua * BT.GiaBan) as TongDoanhThu
    FROM BAO_TCHI BT
    LEFT JOIN DATBAO DB ON BT.MaBaoTC = DB.MaBaoTC
    WHERE BT.MaBaoTC = @MaBaoTC
    GROUP BY BT.Ten, BT.DinhKy;
GO

-- VII. THÊM DỮ LIỆU MẪU
-- 1. Thêm báo/tạp chí
EXEC sp_ThemBaoTchi 'TT01', N'Tuổi trẻ', N'Nhật báo', 1000, 1500;
EXEC sp_ThemBaoTchi 'KT01', N'Kiến thức ngày nay', N'Bán nguyệt san', 3000, 6000;
EXEC sp_ThemBaoTchi 'TN01', N'Thanh niên', N'Nhật báo', 1000, 2000;
EXEC sp_ThemBaoTchi 'PN01', N'Phụ nữ', N'Tuần báo', 2000, 4000;
EXEC sp_ThemBaoTchi 'PN02', N'Phụ nữ', N'Nhật báo', 1000, 2000;

-- 2. Thêm phát hành
EXEC sp_ThemPhatHanh 'TT01', 123, '2005-12-15';
EXEC sp_ThemPhatHanh 'KT01', 70, '2005-12-15';
EXEC sp_ThemPhatHanh 'TT01', 124, '2005-12-16';
EXEC sp_ThemPhatHanh 'TN01', 256, '2005-12-17';
EXEC sp_ThemPhatHanh 'PN01', 45, '2005-12-23';
EXEC sp_ThemPhatHanh 'PN02', 111, '2005-12-18';
EXEC sp_ThemPhatHanh 'PN02', 112, '2005-12-19';
EXEC sp_ThemPhatHanh 'TT01', 125, '2005-12-17';
EXEC sp_ThemPhatHanh 'PN01', 46, '2005-12-30';

-- 3. Thêm khách hàng
EXEC sp_ThemKhachHang 'KH01', N'LAN', N'2 NCT';
EXEC sp_ThemKhachHang 'KH02', N'NAM', N'32 THĐ';
EXEC sp_ThemKhachHang 'KH03', N'NGỌC', N'16 LHP';

-- 4. Thêm đặt báo
EXEC sp_ThemDatBao 'KH01', 'TT01', 100, '2000-01-12';
EXEC sp_ThemDatBao 'KH02', 'TN01', 150, '2001-05-01';
EXEC sp_ThemDatBao 'KH01', 'PN01', 200, '2001-06-25';
EXEC sp_ThemDatBao 'KH03', 'KT01', 50, '2002-03-17';
EXEC sp_ThemDatBao 'KH03', 'PN02', 200, '2003-08-26';
EXEC sp_ThemDatBao 'KH02', 'TT01', 250, '2004-01-15';
EXEC sp_ThemDatBao 'KH01', 'KT01', 300, '2004-10-14';

--II. Truy vấn dữ liệu
--1. Cho biết các tờ báo, tạp chí có định kỳ phát hành hàng tuần (Tuần báo).
SELECT MaBaoTC, Ten, GiaBan
FROM BAO_TCHI
WHERE DinhKy = 'Tuần báo';

--2. Cho biết thông tin về các tờ báo thuộc loại báo phụ nữ (mã báo tạp chí bắt đầu bằng PN).
SELECT MaBaoTC, Ten, GiaBan
FROM BAO_TCHI
WHERE MaBaoTC LIKE 'PN%';

--3. Cho biết tên các khách hàng có đặt mua báo phụ nữ (mã báo tạp chí bắt đầu bằng PN), không liệt kê khách hàng trùng.
SELECT DISTINCT KH.TenKH
FROM KHACHHANG KH
JOIN DATBAO DB ON KH.MaKH = DB.MaKH
JOIN BAO_TCHI BT ON DB.MaBaoTC = BT.MaBaoTC
WHERE BT.MaBaoTC LIKE 'PN%';

--4. Cho biết tên các khách hàng có đặt mua tất cả các báo phụ nữ (mã báo tạp chí bắt đầu bằng PN).
SELECT KH.TenKH
FROM KHACHHANG KH
JOIN DATBAO DB ON KH.MaKH = DB.MaKH
JOIN BAO_TCHI BT ON DB.MaBaoTC = BT.MaBaoTC
WHERE BT.MaBaoTC LIKE 'PN%'
GROUP BY KH.MaKH, KH.TenKH
HAVING COUNT(DISTINCT BT.MaBaoTC) = (SELECT COUNT(*) FROM BAO_TCHI WHERE MaBaoTC LIKE 'PN%');

--5. Cho biết các khách hàng không đặt mua báo thanh niên.
SELECT KH.TenKH
FROM KHACHHANG KH
WHERE NOT EXISTS (
    SELECT 1
    FROM DATBAO DB
    JOIN BAO_TCHI BT ON DB.MaBaoTC = BT.MaBaoTC
    WHERE KH.MaKH = DB.MaKH AND BT.MaBaoTC = 'TN01'
);

--6. Cho biết số tờ báo mà mỗi khách hàng đã đặt mua.
SELECT KH.TenKH, SUM(DB.SLMua) AS TongSL
FROM KHACHHANG KH
JOIN DATBAO DB ON KH.MaKH = DB.MaKH
GROUP BY KH.MaKH, KH.TenKH;

--7. Cho biết số khách hàng đặt mua báo trong năm 2004.
SELECT COUNT(DISTINCT DB.MaKH) AS SoKhachHang
FROM DATBAO DB
JOIN BAO_TCHI BT ON DB.MaBaoTC = BT.MaBaoTC
WHERE YEAR(DB.NgayDM) = 2004;

--8. Cho biết thông tin đặt mua báo của các khách hàng (TenKH, Ten, DinhKy, SLMua, SoTien), trong đó SoTien = SLMua x DonGia.
SELECT KH.TenKH, BT.Ten, BT.DinhKy, DB.SLMua, (DB.SLMua * BT.GiaBan) AS SoTien
FROM DATBAO DB
JOIN KHACHHANG KH ON DB.MaKH = KH.MaKH
JOIN BAO_TCHI BT ON DB.MaBaoTC = BT.MaBaoTC;

--9. Cho biết các tờ báo, tạp chí (Ten, DinhKy) và tổng số lượng đặt mua của các khách hàng đối với tờ báo, tạp chí đó.
SELECT BT.Ten, BT.DinhKy, SUM(DB.SLMua) AS TongSL
FROM DATBAO DB
JOIN BAO_TCHI BT ON DB.MaBaoTC = BT.MaBaoTC
GROUP BY BT.MaBaoTC, BT.Ten, BT.DinhKy;

--10. Cho biết tên các tờ báo dành cho học sinh, sinh viên (mã báo tạp chí bắt đầu bằng HS).
SELECT Ten
FROM BAO_TCHI
WHERE MaBaoTC LIKE 'HS%';

--11. Cho biết những tờ báo không có người đặt mua.
SELECT BT.Ten
FROM BAO_TCHI BT
WHERE NOT EXISTS (
    SELECT 1
    FROM DATBAO DB
    WHERE DB.MaBaoTC = BT.MaBaoTC
);
--12. Cho biết tên, định kỳ của những tờ báo có nhiều người đặt mua nhất.
SELECT BT.Ten, BT.DinhKy
FROM BAO_TCHI BT
JOIN DATBAO DB ON BT.MaBaoTC = DB.MaBaoTC
GROUP BY BT.MaBaoTC, BT.Ten, BT.DinhKy
HAVING COUNT(DISTINCT DB.MaKH) = (
    SELECT MAX(TongKhach)
    FROM (
        SELECT COUNT(DISTINCT DB.MaKH) AS TongKhach
        FROM DATBAO DB
        GROUP BY DB.MaBaoTC
    ) AS Temp
);

--13. Cho biết khách hàng đặt mua nhiều báo, tạp chí nhất.
SELECT TOP 1 KH.TenKH
FROM KHACHHANG KH
JOIN DATBAO DB ON KH.MaKH = DB.MaKH
GROUP BY KH.MaKH, KH.TenKH
ORDER BY COUNT(DISTINCT DB.MaBaoTC) DESC;


--14. Cho biết các tờ báo phát hành định kỳ một tháng 2 lần.
SELECT *
FROM BAO_TCHI
WHERE DinhKy LIKE '%2 lần%';

--15. Cho biết các tờ báo, tạp chí chỉ có từ 3 khách hàng đặt mua trở lên.
SELECT BT.MaBaoTC, BT.Ten, BT.GiaBan, BT.SoLuong, BT.DinhKy
FROM BAO_TCHI BT
JOIN DATBAO DB ON BT.MaBaoTC = DB.MaBaoTC
GROUP BY BT.MaBaoTC, BT.Ten, BT.GiaBan, BT.SoLuong, BT.DinhKy
HAVING COUNT(DISTINCT DB.MaKH) >= 3;


-- Phân chia các khối lệnh SQL bằng GO
GO

-- a. Tính tổng số tiền mua báo/tạp chí của một khách hàng cho trước
CREATE FUNCTION fn_TongTienMuaBao (@MaKH CHAR(5))
RETURNS DECIMAL(15, 2)
AS
BEGIN
    DECLARE @TongTien DECIMAL(15, 2);
    SELECT @TongTien = SUM(DB.SLMua * BT.GiaBan)
    FROM DATBAO DB
    JOIN BAO_TCHI BT ON DB.MaBaoTC = BT.MaBaoTC
    WHERE DB.MaKH = @MaKH;
    RETURN @TongTien;
END;
GO

-- b. Tính tổng số tiền thu được của một tờ báo/tạp chí cho trước
CREATE FUNCTION fn_TongTienThu (@MaBaoTC CHAR(5))
RETURNS DECIMAL(15, 2)
AS
BEGIN
    DECLARE @TongTien DECIMAL(15, 2);
    SELECT @TongTien = SUM(DB.SLMua * BT.GiaBan)
    FROM DATBAO DB
    JOIN BAO_TCHI BT ON DB.MaBaoTC = BT.MaBaoTC
    WHERE DB.MaBaoTC = @MaBaoTC;
    RETURN @TongTien;
END;
GO


--B. Viết các thủ tục sau:
--a. In danh mục báo, tạp chí phải giao cho một khách hàng cho trước.
CREATE PROCEDURE sp_InDanhMucBaoTchiGiao (@MaKH CHAR(5))
AS
BEGIN
    SELECT BT.Ten, DB.SLMua
    FROM DATBAO DB
    JOIN BAO_TCHI BT ON DB.MaBaoTC = BT.MaBaoTC
    WHERE DB.MaKH = @MaKH;
END;

--b. In danh sách khách hàng đặt mua báo/tạp chí cho trước.
CREATE PROCEDURE sp_InDanhSachKhachHangDatBao (@MaBaoTC CHAR(5))
AS
BEGIN
    SELECT KH.TenKH, DB.SLMua
    FROM DATBAO DB
    JOIN KHACHHANG KH ON DB.MaKH = KH.MaKH
    WHERE DB.MaBaoTC = @MaBaoTC;
END;



