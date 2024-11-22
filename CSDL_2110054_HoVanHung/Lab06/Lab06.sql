CREATE DATABASE Lab06_QLHocVien;
GO

USE Lab06_QLHocVien;
GO

-- Bảng CaHoc
CREATE TABLE CaHoc (
    Ca INT PRIMARY KEY,
    GioBatDau TIME NOT NULL,
    GioKetThuc TIME NOT NULL,
    CHECK (GioKetThuc > GioBatDau)
);

-- Bảng GiaoVien
CREATE TABLE GiaoVien (
    MSGV CHAR(4) PRIMARY KEY,
    HoGV NVARCHAR(50) NOT NULL,
    TenGV NVARCHAR(50) NOT NULL,
    DienThoai CHAR(6) NOT NULL
);

-- Bảng Lop
CREATE TABLE Lop (
    MaLop CHAR(4) PRIMARY KEY,
    TenLop NVARCHAR(100) NOT NULL,
    NgayKG DATE NOT NULL,
    HocPhi INT NOT NULL CHECK (HocPhi > 0),
    Ca INT NOT NULL,
    SoTiet INT NOT NULL CHECK (SoTiet > 0),
    SoHV INT NOT NULL CHECK (SoHV <= 30),
    MSGV CHAR(4) NOT NULL,
    FOREIGN KEY (Ca) REFERENCES CaHoc(Ca),
    FOREIGN KEY (MSGV) REFERENCES GiaoVien(MSGV)
);

-- Bảng HocVien
CREATE TABLE HocVien (
    MSHV CHAR(6) PRIMARY KEY,
    Ho NVARCHAR(50) NOT NULL,
    Ten NVARCHAR(50) NOT NULL,
    NgaySinh DATE NOT NULL,
    Phai NVARCHAR(3) NOT NULL,
    MaLop CHAR(4) NOT NULL,
    FOREIGN KEY (MaLop) REFERENCES Lop(MaLop)
);

-- Bảng HocPhi
CREATE TABLE HocPhi (
    SoBL CHAR(4) PRIMARY KEY,
    MSHV CHAR(6) NOT NULL,
    NgayThu DATE NOT NULL,
    SoTien INT NOT NULL CHECK (SoTien > 0),
    NoiDung NVARCHAR(100) NOT NULL,
    NguoiThu NVARCHAR(50) NOT NULL,
    FOREIGN KEY (MSHV) REFERENCES HocVien(MSHV)
);
GO

--4. Ràng buộc toàn vẹn
--a) “Giờ kết thúc của một ca học không được trước giờ bắt đầu ca học đó.”
--b) “Sĩ số của một lớp học không quá 30 học viên và đúng bằng số học viên thuộc lớp đó.”
CREATE TRIGGER trg_UpdateSoHV
ON HocVien
AFTER INSERT, DELETE
AS
BEGIN
    DECLARE @MaLop CHAR(4), @SoHV INT;

    SELECT @MaLop = MaLop
    FROM inserted;

    SELECT @SoHV = COUNT(*)
    FROM HocVien
    WHERE MaLop = @MaLop;

    UPDATE Lop
    SET SoHV = @SoHV
    WHERE MaLop = @MaLop;
    
    IF @SoHV > 30
    BEGIN
        THROW 50001, N'Sĩ số lớp vượt quá 30 học viên.', 1;
    END;
END;
GO

--c) Tổng số tiền thu của một học viên không vượt quá học phí của lớp mà học viên đó đăng ký.
CREATE TRIGGER trg_CheckHocPhi
ON HocPhi
AFTER INSERT
AS
BEGIN
    DECLARE @MSHV CHAR(6), @SoTienDaThu INT, @HocPhi INT, @MaLop CHAR(4);

    SELECT @MSHV = MSHV
    FROM inserted;

    SELECT @MaLop = MaLop
    FROM HocVien
    WHERE MSHV = @MSHV;

    SELECT @HocPhi = HocPhi
    FROM Lop
    WHERE MaLop = @MaLop;

    SELECT @SoTienDaThu = SUM(SoTien)
    FROM HocPhi
    WHERE MSHV = @MSHV;

    IF @SoTienDaThu > @HocPhi
    BEGIN
        THROW 50002, N'Số tiền đã thu vượt quá học phí.', 1;
    END;
END;
GO

--5. Thủ tục 
--a) Thêm dữ liệu vào các bảng

-- Thêm ca học
CREATE PROCEDURE AddCaHoc
    @Ca INT,
    @GioBatDau TIME,
    @GioKetThuc TIME
AS
BEGIN
    INSERT INTO CaHoc (Ca, GioBatDau, GioKetThuc)
    VALUES (@Ca, @GioBatDau, @GioKetThuc);
END;
GO


EXEC AddCaHoc @Ca = 1, @GioBatDau = '07:30', @GioKetThuc = '10:45';
EXEC AddCaHoc @Ca = 2, @GioBatDau = '13:30', @GioKetThuc = '16:45';
EXEC AddCaHoc @Ca = 3, @GioBatDau = '17:30', @GioKetThuc = '20:45';

-- Thêm giáo viên
CREATE PROCEDURE AddGiaoVien
    @MSGV CHAR(4),
    @HoGV NVARCHAR(50),
    @TenGV NVARCHAR(50),
    @DienThoai CHAR(10)
AS
BEGIN
    INSERT INTO GiaoVien (MSGV, HoGV, TenGV, DienThoai)
    VALUES (@MSGV, @HoGV, @TenGV, @DienThoai);
END;
GO

EXEC AddGiaoVien @MSGV = 'G001', @HoGV = N'Lê Hoàng', @TenGV = N'Anh', @DienThoai = '858936';
EXEC AddGiaoVien @MSGV = 'G002', @HoGV = N'Nguyễn Ngọc', @TenGV = N'Lan', @DienThoai = '845623';
EXEC AddGiaoVien @MSGV = 'G003', @HoGV = N'Trần Minh', @TenGV = N'Hùng', @DienThoai = '823456';
EXEC AddGiaoVien @MSGV = 'G004', @HoGV = N'Võ Thanh', @TenGV = N'Trung', @DienThoai = '841256';


-- Thêm lớp học
CREATE PROCEDURE AddLop
    @MaLop CHAR(4),
    @TenLop NVARCHAR(100),
    @NgayKG DATE,
    @HocPhi INT,
    @Ca INT,
    @SoTiet INT,
    @MSGV CHAR(4)
AS
BEGIN
    INSERT INTO Lop (MaLop, TenLop, NgayKG, HocPhi, Ca, SoTiet, SoHV, MSGV)
    VALUES (@MaLop, @TenLop, @NgayKG, @HocPhi, @Ca, @SoTiet, 0, @MSGV);
END;
GO


EXEC AddLop @MaLop = 'E114', @TenLop = N'Excel 3-5-7', @NgayKG = '2008-01-02', @HocPhi = 120000, @Ca = 1, @SoTiet = 45, @MSGV = 'G003';
EXEC AddLop @MaLop = 'E115', @TenLop = N'Excel 2-4-6', @NgayKG = '2008-01-22', @HocPhi = 120000, @Ca = 3, @SoTiet = 45, @MSGV = 'G001';
EXEC AddLop @MaLop = 'W123', @TenLop = N'Word 2-4-6', @NgayKG = '2008-02-18', @HocPhi = 100000, @Ca = 3, @SoTiet = 30, @MSGV = 'G001';
EXEC AddLop @MaLop = 'W124', @TenLop = N'Word 3-5-7', @NgayKG = '2008-03-01', @HocPhi = 100000, @Ca = 1, @SoTiet = 30, @MSGV = 'G002';
EXEC AddLop @MaLop = 'A075', @TenLop = N'Access 2-4-6', @NgayKG = '2008-12-18', @HocPhi = 150000, @Ca = 3, @SoTiet = 60, @MSGV = 'G003';

-- Thêm học viên
CREATE PROCEDURE AddHocVien
    @MSHV CHAR(6),
    @Ho NVARCHAR(50),
    @Ten NVARCHAR(50),
    @NgaySinh DATE,
    @Phai NVARCHAR(3),
    @MaLop CHAR(4)
AS
BEGIN
    INSERT INTO HocVien (MSHV, Ho, Ten, NgaySinh, Phai, MaLop)
    VALUES (@MSHV, @Ho, @Ten, @NgaySinh, @Phai, @MaLop);
END;
GO

EXEC AddHocVien @MSHV = 'A07501', @Ho = N'Lê Văn', @Ten = N'Minh', @NgaySinh = '1998-06-10', @Phai = N'Nam', @MaLop = 'A075';
EXEC AddHocVien @MSHV = 'A07502', @Ho = N'Nguyễn Thị', @Ten = N'Mai', @NgaySinh = '1998-04-20', @Phai = N'Nữ', @MaLop = 'A075';
EXEC AddHocVien @MSHV = 'A07503', @Ho = N'Lê Ngọc', @Ten = N'Tuấn', @NgaySinh = '1994-06-10', @Phai = N'Nam', @MaLop = 'A075';
EXEC AddHocVien @MSHV = 'E11401', @Ho = N'Vương Tuấn', @Ten = N'Vũ', @NgaySinh = '1999-03-25', @Phai = N'Nam', @MaLop = 'E114';
EXEC AddHocVien @MSHV = 'E11402', @Ho = N'Lý Ngọc', @Ten = N'Hân', @NgaySinh = '1995-12-01', @Phai = N'Nữ', @MaLop = 'E114';
EXEC AddHocVien @MSHV = 'E11403', @Ho = N'Trần Mai', @Ten = N'Linh', @NgaySinh = '1990-06-04', @Phai = N'Nữ', @MaLop = 'E114';
EXEC AddHocVien @MSHV = 'W12301', @Ho = N'Nguyễn Ngọc', @Ten = N'Tuyết', @NgaySinh = '1996-05-12', @Phai = N'Nữ', @MaLop = 'W123';


-- Thêm biên lai học phí
CREATE PROCEDURE AddHocPhi
    @SoBL CHAR(4),
    @MSHV CHAR(6),
    @NgayThu DATE,
    @SoTien INT,
    @NoiDung NVARCHAR(100),
    @NguoiThu NVARCHAR(50)
AS
BEGIN
    INSERT INTO HocPhi (SoBL, MSHV, NgayThu, SoTien, NoiDung, NguoiThu)
    VALUES (@SoBL, @MSHV, @NgayThu, @SoTien, @NoiDung, @NguoiThu);
END;
GO

EXEC AddHocPhi @SoBL = '0001', @MSHV = 'E11401', @NgayThu = '2008-01-02', @SoTien = 120000, @NoiDung = N'HP Excel 3-5-7', @NguoiThu = N'Vân';
EXEC AddHocPhi @SoBL = '0002', @MSHV = 'E11402', @NgayThu = '2008-01-02', @SoTien = 120000, @NoiDung = N'HP Excel 3-5-7', @NguoiThu = N'Vân';
EXEC AddHocPhi @SoBL = '0003', @MSHV = 'E11403', @NgayThu = '2008-01-02', @SoTien = 80000, @NoiDung = N'HP Excel 3-5-7', @NguoiThu = N'Vân';
EXEC AddHocPhi @SoBL = '0004', @MSHV = 'W12301', @NgayThu = '2008-02-18', @SoTien = 100000, @NoiDung = N'HP Word 2-4-6', @NguoiThu = N'Lan';
EXEC AddHocPhi @SoBL = '0005', @MSHV = 'A07501', @NgayThu = '2008-12-16', @SoTien = 150000, @NoiDung = N'HP Access 2-4-6', @NguoiThu = N'Lan';
EXEC AddHocPhi @SoBL = '0006', @MSHV = 'A07502', @NgayThu = '2008-12-16', @SoTien = 100000, @NoiDung = N'HP Access 2-4-6', @NguoiThu = N'Lan';
EXEC AddHocPhi @SoBL = '0007', @MSHV = 'A07503', @NgayThu = '2008-12-18', @SoTien = 150000, @NoiDung = N'HP Access 2-4-6', @NguoiThu = N'Vân';
EXEC AddHocPhi @SoBL = '0008', @MSHV = 'A07502', @NgayThu = '2009-01-15', @SoTien = 50000, @NoiDung = N'HP Access 2-4-6', @NguoiThu = N'Vân';


--b) Cập nhật thông tin học viên
CREATE PROCEDURE UpdateHocVien
    @MSHV CHAR(6),
    @Ho NVARCHAR(50),
    @Ten NVARCHAR(50),
    @NgaySinh DATE,
    @Phai NVARCHAR(3)
AS
BEGIN
    UPDATE HocVien
    SET Ho = @Ho, Ten = @Ten, NgaySinh = @NgaySinh, Phai = @Phai
    WHERE MSHV = @MSHV;
END;
GO


EXEC UpdateHocVien 
    @MSHV = 'E11401', 
    @Ho = N'Nguyễn Văn', 
    @Ten = N'Tú', 
    @NgaySinh = '1998-03-25', 
    @Phai = N'Nam';

--c) Xóa một học viên
CREATE PROCEDURE DeleteHocVien
    @MSHV CHAR(6)
AS
BEGIN
    DELETE FROM HocPhi WHERE MSHV = @MSHV;
    DELETE FROM HocVien WHERE MSHV = @MSHV;
END;
GO

EXEC DeleteHocVien @MSHV = 'A07503';


--d) Cập nhật thông tin của một lớp học
CREATE PROCEDURE UpdateLop
    @MaLop CHAR(4),
    @TenLop NVARCHAR(100),
    @NgayKG DATE,
    @HocPhi INT,
    @Ca INT,
    @SoTiet INT,
    @MSGV CHAR(4)
AS
BEGIN
    UPDATE Lop
    SET TenLop = @TenLop, NgayKG = @NgayKG, HocPhi = @HocPhi, Ca = @Ca, SoTiet = @SoTiet, MSGV = @MSGV
    WHERE MaLop = @MaLop;
END;
GO

EXEC UpdateLop 
    @MaLop = 'E114', 
    @TenLop = N'Excel Advanced', 
    @NgayKG = '2008-01-15', 
    @HocPhi = 150000, 
    @Ca = 1, 
    @SoTiet = 50, 
    @MSGV = 'G004';

--e) Xóa một lớp học nếu không có học viên
CREATE PROCEDURE DeleteLop
    @MaLop CHAR(4)
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM HocVien WHERE MaLop = @MaLop)
    BEGIN
        DELETE FROM Lop WHERE MaLop = @MaLop;
    END
    ELSE
    BEGIN
        THROW 50003, 'Không thể xóa lớp học vì vẫn còn học viên.', 1;
    END;
END;
GO

EXEC DeleteLop @MaLop = 'W124';


--f) Lập danh sách học viên của một lớp
CREATE PROCEDURE ListHocVienByLop
    @MaLop CHAR(4)
AS
BEGIN
    SELECT MSHV, Ho, Ten, NgaySinh, Phai
    FROM HocVien
    WHERE MaLop = @MaLop;
END;
GO

EXEC ListHocVienByLop @MaLop = 'A075';

--g) Lập danh sách học viên chưa đóng đủ học phí
CREATE PROCEDURE ListHocVienChuaDongDuHocPhi
    @MaLop CHAR(4)
AS
BEGIN
    SELECT HV.MSHV, HV.Ho, HV.Ten, HV.MaLop, SUM(HP.SoTien) AS TongDaNop, L.HocPhi
    FROM HocVien HV
    LEFT JOIN HocPhi HP ON HV.MSHV = HP.MSHV
    JOIN Lop L ON HV.MaLop = L.MaLop
    WHERE HV.MaLop = @MaLop
    GROUP BY HV.MSHV, HV.Ho, HV.Ten, HV.MaLop, L.HocPhi
    HAVING SUM(HP.SoTien) < L.HocPhi OR SUM(HP.SoTien) IS NULL;
END;
GO

EXEC ListHocVienChuaDongDuHocPhi @MaLop = 'E114';

--6. Hàm
--a) Tính tổng học phí của một lớp
CREATE FUNCTION TotalHocPhiLop (@MaLop CHAR(4))
RETURNS INT
AS
BEGIN
    DECLARE @Total INT;
    SELECT @Total = SUM(HP.SoTien)
    FROM HocPhi HP
    JOIN HocVien HV ON HP.MSHV = HV.MSHV
    WHERE HV.MaLop = @MaLop;

    RETURN ISNULL(@Total, 0);
END;
GO

SELECT dbo.TotalHocPhiLop('A075') AS TongHocPhi;

--b) Tính tổng học phí thu được trong một khoảng thời gian
CREATE FUNCTION TotalHocPhiByTime (@StartDate DATE, @EndDate DATE)
RETURNS INT
AS
BEGIN
    DECLARE @Total INT;
    SELECT @Total = SUM(SoTien)
    FROM HocPhi
    WHERE NgayThu BETWEEN @StartDate AND @EndDate;

    RETURN ISNULL(@Total, 0);
END;
GO

SELECT dbo.TotalHocPhiByTime('2008-01-01', '2008-12-31') AS TongHocPhiTheoThoiGian;


--c) Kiểm tra học viên đã nộp đủ học phí hay chưa
CREATE FUNCTION IsHocPhiPaid (@MSHV CHAR(6))
RETURNS BIT
AS
BEGIN
    -- Biến chứa kết quả trả về
    DECLARE @Result BIT = 0;
    DECLARE @TotalPaid INT = 0;
    DECLARE @HocPhi INT = 0;

    -- Tính tổng tiền đã nộp của học viên
    SELECT @TotalPaid = SUM(SoTien)
    FROM HocPhi
    WHERE MSHV = @MSHV;

    -- Lấy học phí của lớp mà học viên thuộc về
    SELECT @HocPhi = L.HocPhi
    FROM HocVien HV
    JOIN Lop L ON HV.MaLop = L.MaLop
    WHERE HV.MSHV = @MSHV;

    -- Kiểm tra điều kiện
    IF @TotalPaid >= @HocPhi
        SET @Result = 1; -- Đã nộp đủ
    ELSE
        SET @Result = 0; -- Chưa nộp đủ

    -- Trả về kết quả
    RETURN @Result;
END;
GO

SELECT dbo.IsHocPhiPaid('E11403') AS DaNopDu;


--d) Hàm sinh mã số học viên
CREATE FUNCTION GenerateMSHV (@MaLop CHAR(4), @SoThuTu INT)
RETURNS CHAR(6)
AS
BEGIN
    RETURN CONCAT(@MaLop, RIGHT(CONCAT('0', @SoThuTu), 2));
END;
GO


SELECT dbo.GenerateMSHV('E115', 5) AS MaSoHocVienMoi;