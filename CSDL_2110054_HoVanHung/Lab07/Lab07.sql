CREATE DATABASE Lab07_QuanLySinhVien
GO
USE Lab07_QuanLySinhVien
GO

-- Tạo Bảng Khoa

CREATE TABLE KHOA 
(
	MSkhoa VARCHAR(2) PRIMARY KEY,
	TenKhoa NVARCHAR(20) NOT NULL,
	TenTat VARCHAR (4) NOT NULL,
);

-- Tạo Bảng Lớp
CREATE TABLE LOP 
(
	MSLop VARCHAR(4) PRIMARY KEY,
	TenLop NVARCHAR (30) NOT NULL,
	MSKhoa VARCHAR(2) FOREIGN KEY REFERENCES KHOA(MSKhoa),
	NienKhoa INT NOT NULL
);

--Tạo bảng Tỉnh

CREATE TABLE TINH 
(
	MSTinh VARCHAR(2) PRIMARY KEY,
	TenTinh NVARCHAR(20) NOT NULL,
);

CREATE TABLE MONHOC
(
	MSMH VARCHAR(4) PRIMARY KEY,
	TenMH NVARCHAR (30) NOT NULL,
	HeSo INT NOT NULL
);
CREATE TABLE SINHVIEN
(
	MSSV VARCHAR(8) PRIMARY KEY,
	Ho NVARCHAR (30) NOT NULL,
	Ten NVARCHAR (20) NOT NULL,
	NgaySinh DATE NOT NULL,
	MSTinh VARCHAR(2) FOREIGN KEY REFERENCES TINH(MSTinh),
	NgayNhapHoc DATE NOT NULL,
	MSLop VARCHAR(4) FOREIGN KEY REFERENCES LOP(MSLop),
	Phai BIT NOT NULL, -- 1 Nam, 0 Nu
	DiaChi NVARCHAR(100) NOT NULL,
	DienThoai VARCHAR(10)
);
CREATE TABLE BANGDIEM
(
	MSSV VARCHAR(8) FOREIGN KEY REFERENCES SINHVIEN(MSSV),
	MSMH VARCHAR(4) FOREIGN KEY REFERENCES MONHOC(MSMH),
	LanThi TINYINT NOT NULL,
	DIEM Float NOT NULL CHECK (Diem>=0 AND Diem <= 10),
	PRIMARY KEY (MSSV, MSMH, LanThi)
);


INSERT INTO KHOA (MSkhoa, TenKhoa, TenTat) VALUES
('01', N'Công Nghệ Thông Tin', 'CNTT'),
('02', N'Điện tử viễn thông', 'DTVT'),
('03', N'Quản Trị Kinh Doanh', 'QTKD'),
('04', N'Công Nghệ Sinh Học', 'CNSH');

INSERT INTO LOP (MSLop, TenLop, MSKhoa, NienKhoa)  VALUES 
('98TH', N'Tin hoc khoa 1998', '01', 1998),
('98VT', N'Vien thon khoa 1998', '02', 1998),
('99TH', N'Tin hoc khoa 1999', '01', 1999),
('99VT', N'Vien thon khoa 1999', '02', 1999),
('99QT', N'Quan tri khoa 1999', '03', 1999);

INSERT INTO TINH (MSTinh, TenTinh) VALUES
('01',N'An Giang'),
('02',N'THHCM'),
('03',N'Dong Nai'),
('04',N'Long An'),
('05',N'Hue'),
('06',N'Ca Mau');

INSERT INTO SINHVIEN (MSSV, Ho, Ten, NgaySinh, MSTinh, NgayNhapHoc, MSLop, Phai, DiaChi, DienThoai) VALUES 
('98TH001', N'Nguyen Van', N'An', '1980-08-06', '01', '1998-09-03', '98TH', 1, N'12 Tran Hung Dao, Q.1', '8234512'),
('98TH002', N'Le Thi', N'An', '1979-10-17', '01', '1998-09-03', '98TH', 0, N'23 CMT8, Q. Tan Binh', '0303234342'),
('98VT001', N'Nguyen Duc', N'Binh', '1981-11-25', '02', '1998-09-03', '98VT', 1, N'245 Lac Long Quan, Q.11', '8654323'),
('98VT002', N'Tran Ngoc', N'Anh', '1980-08-19', '02', '1998-09-03', '98VT', 0, N'242 Tran Hung Dao, Q.1', NULL),
('99TH001', N'Ly Van', N'Hung', '1981-09-27', '03', '1999-10-05', '99TH', 1, N'178 CMT8, Q. Tan Binh', '7563213'),
('99TH002', N'Van Minh', N'Hoang', '1981-01-01', '04', '1999-10-05', '99TH', 1, N'272 Ly Thuong Kiet, Q.10', '8341234'),
('99TH003', N'Nguyen', N'Tuan', '1980-01-12', '03', '1999-10-05', '99TH', 1, N'162 Tran Hung Dao, Q.5', NULL),
('99TH004', N'Tran Van', N'Minh', '1981-06-25', '04', '1999-10-05', '99TH', 1, N'147 Dien Bien Phu, Q.3', '72367754'),
('99TH005', N'Nguyen Thai', N'Minh', '1980-01-01', '04', '1999-10-05', '99TH', 1, N'345 Le Dai Hanh, Q.11', NULL),
('99VT001', N'Le Ngoc', N'Mai', '1982-06-21', '01', '1999-10-05', '99VT', 0, N'129 Tran Hung Dao, Q.1', '0903124534'),
('99QT001', N'Nguyen Thi', N'Oanh', '1973-08-19', '04', '1999-10-05', '99QT', 0, N'76 Hung Vuong, Q.5', '0901656324'),
('99QT002', N'Le My', N'Hanh', '1976-05-20', '04', '1999-10-05', '99QT', 0, N'12 Pham Ngoc Thach, Q.3', NULL);


DELETE FROM SINHVIEN

INSERT INTO MONHOC (MSMH, TenMH, HeSo) VALUES
('TA01', N'Nhap mon tin hoc', 2),
('TA02', N'Lap trinh co ban', 3 ),
('TB01', N'Cau truc du lieu', 2),
('TB02', N'Co so du lieu', 2),
('QA01', N'Kinh te vi mo', 2),
('QA02', N'Quan tri chat luong', 3),
('VA01', N'Dien tu co ban', 2),
('VA02', N'Mach so', 3),
('VB01', N'Truyen so lieu', 3),
('XA01', N'Vat ly dai cuong', 2);




INSERT INTO BANGDIEM (MSSV, MSMH, LanThi, DIEM) VALUES
('98TH001', 'TA01', 1, 8.5),
('98TH001', 'TA02', 1, 8),
('98TH002', 'TA01', 1, 4),
('98TH002', 'TA01', 2, 5.5),
('98TH001', 'TB01', 1, 7.5),
('98TH002', 'TB01', 1, 8),
('98VT001', 'VA01', 1, 4),
('98VT001', 'VA01', 2, 5),
('98VT002', 'VA02', 1, 7.5),
('99TH001', 'TA01', 1, 4),
('99TH001', 'TA01', 2, 6),
('99TH001', 'TB01', 1, 6.5),
('99TH002', 'TB01', 1, 10),
('99TH002', 'TB02', 1, 9),
('99TH003', 'TA02', 1, 7.5),
('99TH003', 'TB01', 1, 3),
('99TH003', 'TB01', 2, 6),
('99TH003', 'TB02', 1, 8),
('99TH004', 'TB02', 1, 2),
('99TH004', 'TB02', 2, 4),
('99TH004', 'TB02', 3, 3),
('99QT001', 'QA01', 1, 7),
('99QT001', 'QA02', 1, 6.5),
('99QT002', 'QA01', 1, 8.5),
('99QT002', 'QA02', 1, 9);

-- Truy vấn đơn giản
-- 1) Liệt kê MSSV, Họ, Tên, Địa chỉ của tất cả sinh viên
SELECT MSSV, Ho, Ten, DiaChi
FROM SINHVIEN;

-- 2) Liệt kê MSSV, Họ, Tên, MS Tỉnh của tất cả sinh viên. Sắp xếp kết quả theo MS tỉnh, trong cùng tỉnh sắp xếp theo họ tên
SELECT MSSV, Ho, Ten, MSTinh
FROM SINHVIEN
ORDER BY MSTinh, Ho, Ten;

-- 3) Liệt kê sinh viên nữ của tỉnh Long An
SELECT *
FROM SINHVIEN
WHERE MSTinh = '04' AND Phai = '0';

-- 4) Liệt kê sinh viên có sinh nhật trong tháng giêng
SELECT *
FROM SINHVIEN
WHERE MONTH(NgaySinh) = 1;

-- 5) Liệt kê sinh viên có sinh nhật nhằm ngày 1/1
SELECT *
FROM SINHVIEN
WHERE DAY(NgaySinh) = 1 AND MONTH(NgaySinh) = 1;

-- 6) Liệt kê sinh viên có số điện thoại
SELECT *
FROM SINHVIEN
WHERE DienThoai IS NOT NULL;

-- 7) Liệt kê sinh viên có số điện thoại di động
SELECT *
FROM SINHVIEN
WHERE DienThoai LIKE '09%';

-- 8) Liệt kê sinh viên tên 'Minh' học lớp '99TH'
SELECT *
FROM SINHVIEN
WHERE Ten = 'Minh' AND MSLop LIKE '99TH%';

-- 9) Liệt kê sinh viên có địa chỉ ở đường 'Tran Hung Dao'
SELECT *
FROM SINHVIEN
WHERE DiaChi LIKE '%Tran Hung Dao%';

-- 10) Liệt kê sinh viên có tên lót chữ 'Van' (không liệt kê người họ 'Van')
SELECT *
FROM SINHVIEN
WHERE Ho LIKE '% Van%' AND Ho NOT LIKE 'Van%';

-- 11) Liệt kê MSSV, Ho Ten (ghép họ và tên thành một cột), Tuổi của sinh viên ở tỉnh Long An
SELECT 
    MSSV,
    CONCAT(Ho, ' ', Ten) AS HoTen,
    YEAR(GETDATE()) - YEAR(NgaySinh) AS Tuoi
FROM SINHVIEN
WHERE MSTinh = '04';


-- 12) Liệt kê sinh viên nam từ 23 đến 28 tuổi
SELECT *
FROM SINHVIEN
WHERE Phai = '1' 
AND (YEAR(GETDATE()) - YEAR(NgaySinh)) BETWEEN 23 AND 28;

-- 13) Liệt kê sinh viên nam từ 32 tuổi trở lên và sinh viên nữ từ 27 tuổi trở lên
SELECT *
FROM SINHVIEN
WHERE (Phai = '1' AND (YEAR(GETDATE()) - YEAR(NgaySinh)) >= 32)
   OR (Phai = '0' AND (YEAR(GETDATE()) - YEAR(NgaySinh)) >= 27);


-- 14) Liệt kê sinh viên khi nhập học còn dưới 18 tuổi, hoặc đã trên 25 tuổi
SELECT *
FROM SINHVIEN
WHERE (YEAR(NgayNhapHoc) - YEAR(NgaySinh)) < 18
OR (YEAR(NgayNhapHoc) - YEAR(NgaySinh)) > 25;

-- 15) Liệt kê danh sách sinh viên của khóa 99 (MSSV có 2 ký tự đầu là '99')
SELECT *
FROM SINHVIEN
WHERE MSSV LIKE '99%';

-- 16) Liệt kê MSSV, Điểm thi lần 1 môn 'Co so du lieu' của lớp '99TH'
SELECT s.MSSV, b.Diem
FROM SINHVIEN s
JOIN BANGDIEM b ON s.MSSV = b.MSSV
WHERE s.MSLop LIKE '99TH%'
AND b.MSMH = 'TB02'
AND b.LanThi = 1;

-- 17) Liệt kê MSSV, Họ tên của sinh viên lớp '99TH' thi không đạt lần 1 môn 'Co so du lieu'
SELECT s.MSSV, s.Ho, s.Ten
FROM SINHVIEN s
JOIN BANGDIEM b ON s.MSSV = b.MSSV
WHERE s.MSLop LIKE '99TH%'
AND b.MSMH = 'TB02'
AND b.LanThi = 1
AND b.Diem < 5;

-- 18) Liệt kê tất cả các điểm thi của sinh viên có mã số '99TH001'
SELECT m.MSMH, m.TenMH, b.LanThi, b.Diem
FROM BANGDIEM b
JOIN MONHOC m ON b.MSMH = m.MSMH
WHERE b.MSSV = '99TH001';


-- 19) Liệt kê MSSV, họ tên, MSLop của sinh viên có điểm thi lần 1 môn 'Co so du lieu' từ 8 điểm trở lên
SELECT s.MSSV, s.Ho, s.Ten, s.MSLop
FROM SINHVIEN s
JOIN BANGDIEM b ON s.MSSV = b.MSSV
WHERE b.MSMH = 'TB02'
AND b.LanThi = 1
AND b.Diem >= 8;

-- 20) Liệt kê các tỉnh không có sinh viên theo học
SELECT t.*
FROM TINH t
LEFT JOIN SINHVIEN s ON t.MSTinh = s.MSTinh
WHERE s.MSSV IS NULL;

-- 21) Liệt kê sinh viên hiện chưa có điểm môn thi nào
SELECT s.*
FROM SINHVIEN s
LEFT JOIN BANGDIEM b ON s.MSSV = b.MSSV
WHERE b.MSSV IS NULL;

-- Truy vấn gộp nhóm
-- 22) Thống kê số lượng sinh viên ở mỗi lớp
SELECT s.MSLop, l.TenLop, COUNT(*) AS SoLuongSV
FROM SINHVIEN s
JOIN LOP l ON s.MSLop = l.MSLop
GROUP BY s.MSLop, l.TenLop;


-- 23) Thống kê số lượng sinh viên ở mỗi tỉnh
SELECT t.MSTinh, t.TenTinh,
    SUM(CASE WHEN s.Phai = 1 THEN 1 ELSE 0 END) AS SoSVNam,
    SUM(CASE WHEN s.Phai = 0 THEN 1 ELSE 0 END) AS SoSVNu,
    COUNT(*) AS TongCong
FROM TINH t
LEFT JOIN SINHVIEN s ON t.MSTinh = s.MSTinh
GROUP BY t.MSTinh, t.TenTinh;


-- 24) Thống kê kết quả thi lần 1 môn 'Co so du lieu' ở các lớp
SELECT 
    l.MSLop,
    l.TenLop,
    COUNT(*) AS TongSV,
    SUM(CASE WHEN b.Diem >= 5 THEN 1 ELSE 0 END) AS SoSVDat,
    ROUND(AVG(b.Diem), 2) AS DiemTrungBinh
FROM LOP l
JOIN SINHVIEN s ON l.MSLop = s.MSLop
LEFT JOIN BANGDIEM b ON s.MSSV = b.MSSV AND b.MSMH = 'TB02' AND b.LanThi = 1
GROUP BY l.MSLop, l.TenLop;

-- Hàm & Thủ tục
-- 25) Lọc ra điểm cao nhất trong các lần thi
CREATE PROCEDURE GetHighestScores
AS
BEGIN
    SELECT 
        sv.MSSV,
        mh.MSMH,
        mh.TenMH,
        mh.HeSo,
        MAX(bd.Diem) AS Diem,
        MAX(bd.Diem) * mh.HeSo AS DiemHeSo
    FROM SINHVIEN sv
    JOIN BANGDIEM bd ON sv.MSSV = bd.MSSV
    JOIN MONHOC mh ON bd.MSMH = mh.MSMH
    GROUP BY sv.MSSV, mh.MSMH, mh.TenMH, mh.HeSo;
END;



-- 26) Lập bảng tổng kết điểm
CREATE PROCEDURE CreateFinalGrades
AS
BEGIN
    SELECT 
        sv.MSSV,
        sv.Ho,
        sv.Ten,
        ROUND(SUM(bd.Diem * mh.HeSo) / SUM(mh.HeSo), 2) AS DTB
    FROM SINHVIEN sv
    JOIN BANGDIEM bd ON sv.MSSV = bd.MSSV
    JOIN MONHOC mh ON bd.MSMH = mh.MSMH
    GROUP BY sv.MSSV, sv.Ho, sv.Ten;
END;


-- 27) Thống kê số lượng sinh viên Long An theo khoa
CREATE PROCEDURE CountLongAnStudentsByFaculty()
BEGIN
    SELECT 
        k.MSKhoa,
        k.TenKhoa,
        COUNT(sv.MSSV) as SoLuongSV
    FROM KHOA k
    LEFT JOIN LOP l ON k.MSKhoa = l.MSKhoa
    LEFT JOIN SINHVIEN sv ON l.MSLop = sv.MSLop
    WHERE sv.MSTinh = '04'
    GROUP BY k.MSKhoa, k.TenKhoa;
END;

-- 28) Nhập vào MSSV, in ra bảng điểm
CREATE PROCEDURE CountLongAnStudentsByFaculty
AS
BEGIN
    SELECT 
        k.MSKhoa,
        k.TenKhoa,
        COUNT(sv.MSSV) AS SoLuongSV
    FROM KHOA k
    LEFT JOIN LOP l ON k.MSKhoa = l.MSKhoa
    LEFT JOIN SINHVIEN sv ON l.MSLop = sv.MSLop
    WHERE sv.MSTinh = '04'
    GROUP BY k.MSKhoa, k.TenKhoa;
END;

-- 29) Nhập vào MS lớp, in ra bảng tổng kết
CREATE PROCEDURE GetClassSummary (@p_MSLop VARCHAR(10))
AS
BEGIN
    SELECT 
        sv.MSSV,
        sv.Ho,
        sv.Ten,
        ROUND(SUM(bd.Diem * mh.HeSo) / SUM(mh.HeSo), 2) AS DTB,
        CASE 
            WHEN ROUND(SUM(bd.Diem * mh.HeSo) / SUM(mh.HeSo), 2) >= 8 THEN 'Giỏi'
            WHEN ROUND(SUM(bd.Diem * mh.HeSo) / SUM(mh.HeSo), 2) >= 7 THEN 'Khá'
            WHEN ROUND(SUM(bd.Diem * mh.HeSo) / SUM(mh.HeSo), 2) >= 5 THEN 'Trung bình'
            ELSE 'Yếu'
        END AS XepLoai
    FROM SINHVIEN sv
    JOIN BANGDIEM bd ON sv.MSSV = bd.MSSV
    JOIN MONHOC mh ON bd.MSMH = mh.MSMH
    WHERE sv.MSLop = @p_MSLop
    GROUP BY sv.MSSV, sv.Ho, sv.Ten;
END;


-- Cập nhật dữ liệu
-- 30) Tạo bảng SinhVienTinh và thêm thuộc tính HBONG
CREATE TABLE SinhVienTinh (
    MSSV VARCHAR(15),
    Ho VARCHAR(50),
    Ten VARCHAR(50),
    NgaySinh DATE,
    Phai CHAR(1),
    MSTinh VARCHAR(10),
    MSLop VARCHAR(10),
    HBONG INT DEFAULT 0
);

-- 31) Chèn dữ liệu vào bảng SinhVienTinh
INSERT INTO SinhVienTinh (MSSV, Ho, Ten, NgaySinh, Phai, MSTinh, MSLop)
SELECT MSSV, Ho, Ten, NgaySinh, Phai, MSTinh, MSLop
FROM SINHVIEN
WHERE MSTinh != '02';

-- 32) Cập nhật HBONG = 10000 cho tất cả sinh viên
UPDATE SinhVienTinh
SET HBONG = 10000;

-- 33) Tăng HBONG thêm 10% cho sinh viên nữ
UPDATE SinhVienTinh
SET HBONG = HBONG * 1.1
WHERE Phai = '0';

-- 34) Xóa sinh viên có quê quán ở Long An
DELETE FROM SinhVienTinh
WHERE MSTinh = '04';
