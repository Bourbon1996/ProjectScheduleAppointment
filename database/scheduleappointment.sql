create database scheduleappointment
go
use scheduleappointment
go

-- Bảng user 
CREATE TABLE users (
    id BIGINT IDENTITY(1,1) PRIMARY KEY,
    full_name NVARCHAR(100) NOT NULL,
    gender varchar(50) NULL,
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(20) UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    role VARCHAR(20) NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'ACTIVE',
    created_at DATETIME2 DEFAULT SYSDATETIME()
);
go

-- Bảng bệnh nhân
CREATE TABLE patients (
    id BIGINT IDENTITY(1,1) PRIMARY KEY,
    user_id BIGINT NOT NULL,
    date_of_birth DATE,
    gender VARCHAR(10),
    [address] NVARCHAR(255),
    health_insurance_code VARCHAR(50),
    emergency_contact VARCHAR(20),
    full_name [nvarchar](100) NOT NULL DEFAULT (N'Chưa cập nhật'),
    phone [varchar](20) NULL,
    relationship [varchar](50) NULL,

    CONSTRAINT fk_patients_users
        FOREIGN KEY (user_id) REFERENCES users(id)
);
go

-- Bảng chuyên khoa
CREATE TABLE departments (
    id BIGINT IDENTITY(1,1) PRIMARY KEY,
    parent_id bigint NULL,
    [name] NVARCHAR(100) NOT NULL,
    [description] NVARCHAR(500),
    image_url [varchar](255) NULL,
    base_price [decimal](10, 2) NULL DEFAULT ((150000.00)),
    status VARCHAR(20) DEFAULT 'ACTIVE',
    CONSTRAINT FK_Department_Parent FOREIGN KEY(parent_id) REFERENCES departments(id)
);
go

-- Bảng bác sĩ
CREATE TABLE doctors (
    id BIGINT IDENTITY(1,1) PRIMARY KEY,
    user_id BIGINT NOT NULL UNIQUE,
    department_id BIGINT NOT NULL,
    title NVARCHAR(100),
    experience_years INT,
    [description] NVARCHAR(1000),
    examination_fee [decimal](18, 2) NOT NULL DEFAULT ((150000)),
    avt_url varchar(100) NULL,

    CONSTRAINT fk_doctors_users
        FOREIGN KEY (user_id) REFERENCES users(id),

    CONSTRAINT fk_doctors_departments
        FOREIGN KEY (department_id) REFERENCES departments(id)
);
go

-- Bảng lịch khám bác sĩ
CREATE TABLE doctor_schedule_slots (
    id BIGINT IDENTITY(1,1) PRIMARY KEY,
    doctor_id BIGINT NOT NULL,
    work_date DATE NOT NULL,
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    max_patients INT NOT NULL DEFAULT 1,
    booked_count INT NOT NULL DEFAULT 0,
    status VARCHAR(20) DEFAULT 'AVAILABLE',

    CONSTRAINT fk_slots_doctors
        FOREIGN KEY (doctor_id) REFERENCES doctors(id),

    CONSTRAINT uq_doctor_slot
        UNIQUE (doctor_id, work_date, start_time, end_time)
);
go

-- Bảng đặt lịch khám
CREATE TABLE appointments (
    id BIGINT IDENTITY(1,1) PRIMARY KEY,
    patient_id BIGINT NOT NULL,
    doctor_id BIGINT NOT NULL,
    department_id BIGINT NOT NULL,
    slot_id BIGINT NULL,
    appointment_date DATE NOT NULL,
    appointment_time TIME NOT NULL,
    reason NVARCHAR(500),
    [status] VARCHAR(30) NOT NULL DEFAULT 'PENDING',
    queue_number INT,
    created_at DATETIME2 DEFAULT SYSDATETIME(),
    booked_by bigint NOT NULL,

    CONSTRAINT fk_appointments_booked_by
        FOREIGN KEY(booked_by) REFERENCES users (id),

    CONSTRAINT fk_appointments_patients
        FOREIGN KEY (patient_id) REFERENCES patients(id),

    CONSTRAINT fk_appointments_doctors
        FOREIGN KEY (doctor_id) REFERENCES doctors(id),

    CONSTRAINT fk_appointments_departments
        FOREIGN KEY (department_id) REFERENCES departments(id),

    CONSTRAINT fk_appointments_slots
        FOREIGN KEY (slot_id) REFERENCES doctor_schedule_slots(id)
);
go

-- Bảng thanh toán
CREATE TABLE payments (
    id BIGINT IDENTITY(1,1) PRIMARY KEY,
    appointment_id BIGINT NOT NULL UNIQUE,
    amount DECIMAL(18,2) NOT NULL,
    method VARCHAR(30) NOT NULL, -- CASH, MOMO, VNPAY, BANKING
    status VARCHAR(30) NOT NULL DEFAULT 'PENDING',
    paid_at DATETIME2 NULL,
    transaction_code VARCHAR(100),

    CONSTRAINT fk_payments_appointments
        FOREIGN KEY (appointment_id) REFERENCES appointments(id)
);
go

-- Bảng thông báo
CREATE TABLE notifications (
    id BIGINT IDENTITY(1,1) PRIMARY KEY,
    user_id BIGINT NOT NULL,
    title NVARCHAR(200) NOT NULL,
    content NVARCHAR(1000),
    type VARCHAR(50),
    is_read BIT NOT NULL DEFAULT 0,
    created_at DATETIME2 DEFAULT SYSDATETIME(),

    CONSTRAINT fk_notifications_users
        FOREIGN KEY (user_id) REFERENCES users(id)
);
go

USE [scheduleappointment]
GO

-- ==========================================================
-- 1. BẢNG USERS
-- ==========================================================
SET IDENTITY_INSERT [dbo].[users] ON;
GO

INSERT INTO [dbo].[users] ([id], [full_name], [email], [phone], [password_hash], [role], [status], [created_at], [gender])
VALUES 
-- Bệnh nhân & Admin
(1, N'baduc', N'duc@gmail.com', N'0348853878', N'123', N'PATIENT', N'ACTIVE', CAST(N'2026-07-23T22:41:18.3233960' AS DateTime2), NULL),

-- ID 4: Khoa Khám bệnh
(90, N'GS. TS. BS Nguyễn Hoàng Định', N'k4_bs1@bvdaihoc.com.vn', N'0903104001', N'123', N'DOCTOR', N'ACTIVE', CAST(N'2026-07-26T15:35:07.4966667' AS DateTime2), N'MALE'),
(91, N'PGS. TS. BS Trần Kim Trang', N'k4_bs2@bvdaihoc.com.vn', N'0903104002', N'123', N'DOCTOR', N'ACTIVE', CAST(N'2026-07-26T15:35:07.4966667' AS DateTime2), N'FEMALE'),
(92, N'BS. CKII Lê Quốc Hùng', N'k4_bs3@bvdaihoc.com.vn', N'0903104003', N'123', N'DOCTOR', N'ACTIVE', CAST(N'2026-07-26T15:35:07.4966667' AS DateTime2), N'MALE'),
(93, N'ThS. BS Phạm Thị Tố Hoa', N'k4_bs4@bvdaihoc.com.vn', N'0903104004', N'123', N'DOCTOR', N'ACTIVE', CAST(N'2026-07-26T15:35:07.4966667' AS DateTime2), N'FEMALE'),

-- ID 5: Khoa Khám sức khoẻ theo yêu cầu
(94, N'ThS. BS Bùi Cao Mỹ Ái', N'k5_bs1@bvdaihoc.com.vn', N'0903105001', N'123', N'DOCTOR', N'ACTIVE', CAST(N'2026-07-26T15:35:07.4966667' AS DateTime2), N'FEMALE'),
(95, N'TS. BS Nguyễn Tấn Cường', N'k5_bs2@bvdaihoc.com.vn', N'0903105002', N'123', N'DOCTOR', N'ACTIVE', CAST(N'2026-07-26T15:35:07.4966667' AS DateTime2), N'MALE'),
(96, N'BS. CKII Nguyễn Thị Hương', N'k5_bs3@bvdaihoc.com.vn', N'0903105003', N'123', N'DOCTOR', N'ACTIVE', CAST(N'2026-07-26T15:35:07.4966667' AS DateTime2), N'FEMALE'),
(97, N'ThS. BS Trần Thanh Vận', N'k5_bs4@bvdaihoc.com.vn', N'0903105004', N'123', N'DOCTOR', N'ACTIVE', CAST(N'2026-07-26T15:35:07.4966667' AS DateTime2), N'FEMALE'),

-- ID 6: Khoa Cấp cứu
(98, N'PGS. TS. BS Lê Minh Khôi', N'k6_bs1@bvdaihoc.com.vn', N'0903106001', N'123', N'DOCTOR', N'ACTIVE', CAST(N'2026-07-26T15:35:07.4966667' AS DateTime2), N'MALE'),
(99, N'BS. CKII Nguyễn Thanh Sơn', N'k6_bs2@bvdaihoc.com.vn', N'0903106002', N'123', N'DOCTOR', N'ACTIVE', CAST(N'2026-07-26T15:35:07.4966667' AS DateTime2), N'MALE'),
(100, N'ThS. BS Huỳnh Quang Đại', N'k6_bs3@bvdaihoc.com.vn', N'0903106003', N'123', N'DOCTOR', N'ACTIVE', CAST(N'2026-07-26T15:35:07.4966667' AS DateTime2), N'MALE'),
(101, N'BS. CKI Lê Thị Mai', N'k6_bs4@bvdaihoc.com.vn', N'0903106004', N'123', N'DOCTOR', N'ACTIVE', CAST(N'2026-07-26T15:35:07.4966667' AS DateTime2), N'FEMALE'),

-- ID 7: Khoa Hồi sức tích cực
(102, N'TS. BS Bùi Hữu Hoàng', N'k7_bs1@bvdaihoc.com.vn', N'0903107001', N'123', N'DOCTOR', N'ACTIVE', CAST(N'2026-07-26T15:35:07.4966667' AS DateTime2), N'MALE'),
(103, N'BS. CKII Đặng Hóa', N'k7_bs2@bvdaihoc.com.vn', N'0903107002', N'123', N'DOCTOR', N'ACTIVE', CAST(N'2026-07-26T15:35:07.4966667' AS DateTime2), N'MALE'),
(104, N'ThS. BS Nguyễn Thị Bích Uyên', N'k7_bs3@bvdaihoc.com.vn', N'0903107003', N'123', N'DOCTOR', N'ACTIVE', CAST(N'2026-07-26T15:35:07.4966667' AS DateTime2), N'FEMALE'),
(105, N'BS. CKI Vũ Trí Lộc', N'k7_bs4@bvdaihoc.com.vn', N'0903107004', N'123', N'DOCTOR', N'ACTIVE', CAST(N'2026-07-26T15:35:07.4966667' AS DateTime2), N'MALE'),

-- ID 8: Khoa Nội cơ xương khớp
(106, N'TS. BS Cao Thanh Ngọc', N'k8_bs1@bvdaihoc.com.vn', N'0903108001', N'123', N'DOCTOR', N'ACTIVE', CAST(N'2026-07-26T15:35:07.4966667' AS DateTime2), N'MALE'),
(107, N'ThS. BS Nguyễn Minh Tuấn', N'k8_bs2@bvdaihoc.com.vn', N'0903108002', N'123', N'DOCTOR', N'ACTIVE', CAST(N'2026-07-26T15:35:07.4966667' AS DateTime2), N'MALE'),
(108, N'BS. CKII Trần Thị Ngọc Lan', N'k8_bs3@bvdaihoc.com.vn', N'0903108003', N'123', N'DOCTOR', N'ACTIVE', CAST(N'2026-07-26T15:35:07.4966667' AS DateTime2), N'FEMALE'),
(109, N'ThS. BS Lê Hoàng Phúc', N'k8_bs4@bvdaihoc.com.vn', N'0903108004', N'123', N'DOCTOR', N'ACTIVE', CAST(N'2026-07-26T15:35:07.4966667' AS DateTime2), N'MALE'),

-- ID 9: Khoa Nội thận - Thận nhân tạo
(110, N'BS. CKII Nguyễn Hữu Dũng', N'k9_bs1@bvdaihoc.com.vn', N'0903109001', N'123', N'DOCTOR', N'ACTIVE', CAST(N'2026-07-26T15:35:07.4966667' AS DateTime2), N'MALE'),
(111, N'TS. BS Huỳnh Ngọc Phương Thảo', N'k9_bs2@bvdaihoc.com.vn', N'0903109002', N'123', N'DOCTOR', N'ACTIVE', CAST(N'2026-07-26T15:35:07.4966667' AS DateTime2), N'FEMALE'),
(112, N'ThS. BS Trần Hoàng Bảo', N'k9_bs3@bvdaihoc.com.vn', N'0903109003', N'123', N'DOCTOR', N'ACTIVE', CAST(N'2026-07-26T15:35:07.4966667' AS DateTime2), N'MALE'),
(113, N'BS. CKI Lê Thị Thanh Hà', N'k9_bs4@bvdaihoc.com.vn', N'0903109004', N'123', N'DOCTOR', N'ACTIVE', CAST(N'2026-07-26T15:35:07.4966667' AS DateTime2), N'FEMALE'),

-- ID 10: Khoa Nội tiết
(114, N'TS. BS Lâm Văn Hoàng', N'k10_bs1@bvdaihoc.com.vn', N'0903110001', N'123', N'DOCTOR', N'ACTIVE', CAST(N'2026-07-26T15:35:07.4966667' AS DateTime2), N'MALE'),
(115, N'ThS. BS Trần Quang Nam', N'k10_bs2@bvdaihoc.com.vn', N'0903110002', N'123', N'DOCTOR', N'ACTIVE', CAST(N'2026-07-26T15:35:07.4966667' AS DateTime2), N'MALE'),
(116, N'BS. CKII Nguyễn Thị Thu Thảo', N'k10_bs3@bvdaihoc.com.vn', N'0903110003', N'123', N'DOCTOR', N'ACTIVE', CAST(N'2026-07-26T15:35:07.4966667' AS DateTime2), N'FEMALE'),
(117, N'ThS. BS Đỗ Cẩm Thanh', N'k10_bs4@bvdaihoc.com.vn', N'0903110004', N'123', N'DOCTOR', N'ACTIVE', CAST(N'2026-07-26T15:35:07.4966667' AS DateTime2), N'FEMALE'),

-- Các khoa khác (gom gọn nhanh)
(118, N'TS. BS Trần Hòa', N'k11_bs1@bvdaihoc.com.vn', N'0903111001', N'123', N'DOCTOR', N'ACTIVE', CAST(N'2026-07-26T15:35:07.4966667' AS DateTime2), N'MALE'),
(119, N'PGS. TS. BS Châu Ngọc Hoa', N'k11_bs2@bvdaihoc.com.vn', N'0903111002', N'123', N'DOCTOR', N'ACTIVE', CAST(N'2026-07-26T15:35:07.4966667' AS DateTime2), N'FEMALE'),
(120, N'ThS. BS Lương Duy Trường', N'k11_bs3@bvdaihoc.com.vn', N'0903111003', N'123', N'DOCTOR', N'ACTIVE', CAST(N'2026-07-26T15:35:07.4966667' AS DateTime2), N'MALE'),
(121, N'BS. CKII Phạm Thị Hồng', N'k11_bs4@bvdaihoc.com.vn', N'0903111004', N'123', N'DOCTOR', N'ACTIVE', CAST(N'2026-07-26T15:35:07.4966667' AS DateTime2), N'FEMALE'),
(122, N'TS. BS Vũ Hoàng Vũ', N'k12_bs1@bvdaihoc.com.vn', N'0903112001', N'123', N'DOCTOR', N'ACTIVE', CAST(N'2026-07-26T15:35:07.4966667' AS DateTime2), N'MALE'),
(123, N'ThS. BS Nguyễn Thượng Nghĩa', N'k12_bs2@bvdaihoc.com.vn', N'0903112002', N'123', N'DOCTOR', N'ACTIVE', CAST(N'2026-07-26T15:35:07.4966667' AS DateTime2), N'MALE'),
(124, N'BS. CKI Trần Phước Hòa', N'k12_bs3@bvdaihoc.com.vn', N'0903112003', N'123', N'DOCTOR', N'ACTIVE', CAST(N'2026-07-26T15:35:07.4966667' AS DateTime2), N'MALE'),
(125, N'ThS. BS Lê Ngọc Trâm', N'k12_bs4@bvdaihoc.com.vn', N'0903112004', N'123', N'DOCTOR', N'ACTIVE', CAST(N'2026-07-26T15:35:07.4966667' AS DateTime2), N'FEMALE'),
(126, N'PGS. TS. BS Bùi Minh Trạng', N'k13_bs1@bvdaihoc.com.vn', N'0903113001', N'123', N'DOCTOR', N'ACTIVE', CAST(N'2026-07-26T15:35:07.4966667' AS DateTime2), N'MALE'),
(127, N'TS. BS Nguyễn Hoàng Vân', N'k13_bs2@bvdaihoc.com.vn', N'0903113002', N'123', N'DOCTOR', N'ACTIVE', CAST(N'2026-07-26T15:35:07.4966667' AS DateTime2), N'MALE'),
(128, N'ThS. BS Phạm Công Khang', N'k13_bs3@bvdaihoc.com.vn', N'0903113003', N'123', N'DOCTOR', N'ACTIVE', CAST(N'2026-07-26T15:35:07.4966667' AS DateTime2), N'MALE'),
(129, N'BS. CKII Trần Thị Mai Linh', N'k13_bs4@bvdaihoc.com.vn', N'0903113004', N'123', N'DOCTOR', N'ACTIVE', CAST(N'2026-07-26T15:35:07.4966667' AS DateTime2), N'FEMALE'),
(130, N'PGS. TS. BS Bùi Hữu Hoàng', N'k14_bs1@bvdaihoc.com.vn', N'0903114001', N'123', N'DOCTOR', N'ACTIVE', CAST(N'2026-07-26T15:35:07.4966667' AS DateTime2), N'MALE'),
(131, N'TS. BS Lê Thành Lý', N'k14_bs2@bvdaihoc.com.vn', N'0903114002', N'123', N'DOCTOR', N'ACTIVE', CAST(N'2026-07-26T15:35:07.4966667' AS DateTime2), N'MALE'),
(132, N'ThS. BS Trần Thanh Bình', N'k14_bs3@bvdaihoc.com.vn', N'0903114003', N'123', N'DOCTOR', N'ACTIVE', CAST(N'2026-07-26T15:35:07.4966667' AS DateTime2), N'MALE'),
(133, N'BS. CKI Nguyễn Thị Mỹ Dung', N'k14_bs4@bvdaihoc.com.vn', N'0903114004', N'123', N'DOCTOR', N'ACTIVE', CAST(N'2026-07-26T15:35:07.4966667' AS DateTime2), N'FEMALE'),
(134, N'TS. BS Trần Thanh Tuấn', N'k15_bs1@bvdaihoc.com.vn', N'0903115001', N'123', N'DOCTOR', N'ACTIVE', CAST(N'2026-07-26T15:35:07.4966667' AS DateTime2), N'MALE'),
(135, N'PGS. TS. BS Nguyễn Cao Cường', N'k15_bs2@bvdaihoc.com.vn', N'0903115002', N'123', N'DOCTOR', N'ACTIVE', CAST(N'2026-07-26T15:35:07.4966667' AS DateTime2), N'MALE'),
(136, N'ThS. BS Lâm Trường Hải', N'k15_bs3@bvdaihoc.com.vn', N'0903115003', N'123', N'DOCTOR', N'ACTIVE', CAST(N'2026-07-26T15:35:07.4966667' AS DateTime2), N'MALE'),
(137, N'BS. CKII Võ Thị Ngọc Lan', N'k15_bs4@bvdaihoc.com.vn', N'0903115004', N'123', N'DOCTOR', N'ACTIVE', CAST(N'2026-07-26T15:35:07.4966667' AS DateTime2), N'FEMALE'),
(138, N'GS. TS. BS Nguyễn Tấn Cường', N'k16_bs1@bvdaihoc.com.vn', N'0903116001', N'123', N'DOCTOR', N'ACTIVE', CAST(N'2026-07-26T15:35:07.4966667' AS DateTime2), N'MALE'),
(139, N'TS. BS Đinh Đức Minh', N'k16_bs2@bvdaihoc.com.vn', N'0903116002', N'123', N'DOCTOR', N'ACTIVE', CAST(N'2026-07-26T15:35:07.4966667' AS DateTime2), N'MALE'),
(140, N'ThS. BS Lê Hoàng Long', N'k16_bs3@bvdaihoc.com.vn', N'0903116003', N'123', N'DOCTOR', N'ACTIVE', CAST(N'2026-07-26T15:35:07.4966667' AS DateTime2), N'MALE'),
(141, N'BS. CKI Phạm Thị Cẩm', N'k16_bs4@bvdaihoc.com.vn', N'0903116004', N'123', N'DOCTOR', N'ACTIVE', CAST(N'2026-07-26T15:35:07.4966667' AS DateTime2), N'FEMALE'),
(142, N'PGS. TS. BS Nguyễn Thi Hùng', N'k17_bs1@bvdaihoc.com.vn', N'0903117001', N'123', N'DOCTOR', N'ACTIVE', CAST(N'2026-07-26T15:35:07.4966667' AS DateTime2), N'MALE'),
(143, N'TS. BS Lê Tự Phương Thảo', N'k17_bs2@bvdaihoc.com.vn', N'0903117002', N'123', N'DOCTOR', N'ACTIVE', CAST(N'2026-07-26T15:35:07.4966667' AS DateTime2), N'FEMALE'),
(144, N'ThS. BS Trần Minh Trí', N'k17_bs3@bvdaihoc.com.vn', N'0903117003', N'123', N'DOCTOR', N'ACTIVE', CAST(N'2026-07-26T15:35:07.4966667' AS DateTime2), N'MALE'),
(145, N'BS. CKII Đặng Thị Kim Lan', N'k17_bs4@bvdaihoc.com.vn', N'0903117004', N'123', N'DOCTOR', N'ACTIVE', CAST(N'2026-07-26T15:35:07.4966667' AS DateTime2), N'FEMALE'),
(146, N'TS. BS Huỳnh Khắc Cường', N'k18_bs1@bvdaihoc.com.vn', N'0903118001', N'123', N'DOCTOR', N'ACTIVE', CAST(N'2026-07-26T15:35:07.4966667' AS DateTime2), N'MALE'),
(147, N'ThS. BS Lê Trung Tuấn', N'k18_bs2@bvdaihoc.com.vn', N'0903118002', N'123', N'DOCTOR', N'ACTIVE', CAST(N'2026-07-26T15:35:07.4966667' AS DateTime2), N'MALE'),
(148, N'BS. CKI Nguyễn Khắc Hưng', N'k18_bs3@bvdaihoc.com.vn', N'0903118003', N'123', N'DOCTOR', N'ACTIVE', CAST(N'2026-07-26T15:35:07.4966667' AS DateTime2), N'MALE'),
(149, N'TS. BS Bùi Hồng Thiên Khanh', N'k19_bs1@bvdaihoc.com.vn', N'0903119001', N'123', N'DOCTOR', N'ACTIVE', CAST(N'2026-07-26T15:35:07.4966667' AS DateTime2), N'MALE'),
(150, N'BS. CKII Nguyễn Trường Sơn', N'k19_bs2@bvdaihoc.com.vn', N'0903119002', N'123', N'DOCTOR', N'ACTIVE', CAST(N'2026-07-26T15:35:07.4966667' AS DateTime2), N'MALE'),
(151, N'ThS. BS Đỗ Anh Dũng', N'k19_bs3@bvdaihoc.com.vn', N'0903119003', N'123', N'DOCTOR', N'ACTIVE', CAST(N'2026-07-26T15:35:07.4966667' AS DateTime2), N'MALE'),
(152, N'BS. CKI Trần Thị Kim', N'k19_bs4@bvdaihoc.com.vn', N'0903119004', N'123', N'DOCTOR', N'ACTIVE', CAST(N'2026-07-26T15:35:07.4966667' AS DateTime2), N'FEMALE'),
(153, N'TS. BS Nguyễn Văn Thọ', N'k20_bs1@bvdaihoc.com.vn', N'0903120001', N'123', N'DOCTOR', N'ACTIVE', CAST(N'2026-07-26T15:35:07.4966667' AS DateTime2), N'MALE'),
(154, N'ThS. BS Phan Cảnh Duy', N'k20_bs2@bvdaihoc.com.vn', N'0903120002', N'123', N'DOCTOR', N'ACTIVE', CAST(N'2026-07-26T15:35:07.4966667' AS DateTime2), N'MALE'),
(155, N'BS. CKII Lê Bảo Uyên', N'k20_bs3@bvdaihoc.com.vn', N'0903120003', N'123', N'DOCTOR', N'ACTIVE', CAST(N'2026-07-26T15:35:07.4966667' AS DateTime2), N'FEMALE'),
(156, N'PGS. TS. BS Lê Thượng Vũ', N'k21_bs1@bvdaihoc.com.vn', N'0903121001', N'123', N'DOCTOR', N'ACTIVE', CAST(N'2026-07-26T15:35:07.4966667' AS DateTime2), N'MALE'),
(157, N'TS. BS Trần Văn Thanh', N'k21_bs2@bvdaihoc.com.vn', N'0903121002', N'123', N'DOCTOR', N'ACTIVE', CAST(N'2026-07-26T15:35:07.4966667' AS DateTime2), N'FEMALE'),
(158, N'BS. CKI Nguyễn Thị Mai Hoa', N'k21_bs3@bvdaihoc.com.vn', N'0903121003', N'123', N'DOCTOR', N'ACTIVE', CAST(N'2026-07-26T15:35:07.4966667' AS DateTime2), N'FEMALE'),
(159, N'BS. CKII Lê Quang Thanh', N'k22_bs1@bvdaihoc.com.vn', N'0903122001', N'123', N'DOCTOR', N'ACTIVE', CAST(N'2026-07-26T15:35:07.4966667' AS DateTime2), N'FEMALE'),
(160, N'PGS. TS. BS Vũ Uyên Phương', N'k22_bs2@bvdaihoc.com.vn', N'0903122002', N'123', N'DOCTOR', N'ACTIVE', CAST(N'2026-07-26T15:35:07.4966667' AS DateTime2), N'FEMALE'),
(161, N'ThS. BS Nguyễn Bá Danh', N'k22_bs3@bvdaihoc.com.vn', N'0903122003', N'123', N'DOCTOR', N'ACTIVE', CAST(N'2026-07-26T15:35:07.4966667' AS DateTime2), N'MALE'),
(162, N'BS. CKI Trần Thị Trúc Linh', N'k22_bs4@bvdaihoc.com.vn', N'0903124004', N'123', N'DOCTOR', N'ACTIVE', CAST(N'2026-07-26T15:35:07.4966667' AS DateTime2), N'FEMALE'),
(163, N'PGS. TS. BS Nguyễn Hoàng Bắc', N'k23_bs1@bvdaihoc.com.vn', N'0903123001', N'123', N'DOCTOR', N'ACTIVE', CAST(N'2026-07-26T15:35:07.4966667' AS DateTime2), N'MALE'),
(164, N'ThS. BS Đinh Thị Kim Chi', N'k23_bs2@bvdaihoc.com.vn', N'0903123002', N'123', N'DOCTOR', N'ACTIVE', CAST(N'2026-07-26T15:35:07.4966667' AS DateTime2), N'FEMALE'),
(165, N'BS. CKII Huỳnh Khắc Cường', N'k23_bs3@bvdaihoc.com.vn', N'0903123003', N'123', N'DOCTOR', N'ACTIVE', CAST(N'2026-07-26T15:35:07.4966667' AS DateTime2), N'MALE'),
(166, N'TS. BS Huỳnh Nguyễn Khánh Trang', N'k24_bs1@bvdaihoc.com.vn', N'0903124001', N'123', N'DOCTOR', N'ACTIVE', CAST(N'2026-07-26T15:35:07.4966667' AS DateTime2), N'FEMALE'),
(167, N'ThS. BS Lê Ngọc Thanh', N'k24_bs2@bvdaihoc.com.vn', N'0903124002', N'123', N'DOCTOR', N'ACTIVE', CAST(N'2026-07-26T15:35:07.4966667' AS DateTime2), N'FEMALE'),
(168, N'BS. CKI Nguyễn Thị Thu Nga', N'k24_bs3@bvdaihoc.com.vn', N'0903124003', N'123', N'DOCTOR', N'ACTIVE', CAST(N'2026-07-26T15:35:07.4966667' AS DateTime2), N'FEMALE'),
(169, N'ThS. BS Bùi Thế Anh', N'k25_bs1@bvdaihoc.com.vn', N'0903125001', N'123', N'DOCTOR', N'ACTIVE', CAST(N'2026-07-26T15:35:07.4966667' AS DateTime2), N'MALE'),
(170, N'TS. BS Lê Trí Duy', N'k25_bs2@bvdaihoc.com.vn', N'0903125002', N'123', N'DOCTOR', N'ACTIVE', CAST(N'2026-07-26T15:35:07.4966667' AS DateTime2), N'MALE'),
(171, N'BS. CKII Nguyễn Ngọc Trâm', N'k25_bs3@bvdaihoc.com.vn', N'0903125003', N'123', N'DOCTOR', N'ACTIVE', CAST(N'2026-07-26T15:35:07.4966667' AS DateTime2), N'FEMALE'),
(172, N'ThS. BS Võ Tuấn Khang', N'k25_bs4@bvdaihoc.com.vn', N'0903125004', N'123', N'DOCTOR', N'ACTIVE', CAST(N'2026-07-26T15:35:07.4966667' AS DateTime2), N'MALE'),
(173, N'ThS. BS Phạm Thị Minh Châu', N'k26_bs1@bvdaihoc.com.vn', N'0903126001', N'123', N'DOCTOR', N'ACTIVE', CAST(N'2026-07-26T15:35:07.4966667' AS DateTime2), N'FEMALE'),
(174, N'BS. CKII Lê Công Vĩnh', N'k26_bs2@bvdaihoc.com.vn', N'0903126002', N'123', N'DOCTOR', N'ACTIVE', CAST(N'2026-07-26T15:35:07.4966667' AS DateTime2), N'MALE'),
(175, N'ThS. BS Trần Trọng Trí', N'k26_bs3@bvdaihoc.com.vn', N'0903126003', N'123', N'DOCTOR', N'ACTIVE', CAST(N'2026-07-26T15:35:07.4966667' AS DateTime2), N'MALE'),
(176, N'BS. CKII Lâm Ngọc Anh', N'k27_bs1@bvdaihoc.com.vn', N'0903127001', N'123', N'DOCTOR', N'ACTIVE', CAST(N'2026-07-26T15:35:07.4966667' AS DateTime2), N'MALE'),
(177, N'TS. BS Huỳnh Anh Lan', N'k27_bs2@bvdaihoc.com.vn', N'0903127002', N'123', N'DOCTOR', N'ACTIVE', CAST(N'2026-07-26T15:35:07.4966667' AS DateTime2), N'FEMALE'),
(178, N'ThS. BS Nguyễn Trung Hưng', N'k27_bs3@bvdaihoc.com.vn', N'0903127003', N'123', N'DOCTOR', N'ACTIVE', CAST(N'2026-07-26T15:35:07.4966667' AS DateTime2), N'MALE'),
(179, N'BS. CKI Trần Thị Kim Quyên', N'k27_bs4@bvdaihoc.com.vn', N'0903127004', N'123', N'DOCTOR', N'ACTIVE', CAST(N'2026-07-26T15:35:07.4966667' AS DateTime2), N'FEMALE'),
(180, N'TS. BS Nguyễn Phúc Cẩm Hoàng', N'k28_bs1@bvdaihoc.com.vn', N'0903128001', N'123', N'DOCTOR', N'ACTIVE', CAST(N'2026-07-26T15:35:07.4966667' AS DateTime2), N'MALE'),
(181, N'ThS. BS Võ Quang Long', N'k28_bs2@bvdaihoc.com.vn', N'0903128002', N'123', N'DOCTOR', N'ACTIVE', CAST(N'2026-07-26T15:35:07.4966667' AS DateTime2), N'MALE'),
(182, N'BS. CKII Lê Quốc Hải', N'k28_bs3@bvdaihoc.com.vn', N'0903128003', N'123', N'DOCTOR', N'ACTIVE', CAST(N'2026-07-26T15:35:07.4966667' AS DateTime2), N'MALE'),
(183, N'BS. CKII Đặng Hóa', N'k29_bs1@bvdaihoc.com.vn', N'0903129001', N'123', N'DOCTOR', N'ACTIVE', CAST(N'2026-07-26T15:35:07.4966667' AS DateTime2), N'MALE'),
(184, N'ThS. BS Trần Trọng Tuấn', N'k29_bs2@bvdaihoc.com.vn', N'0903129002', N'123', N'DOCTOR', N'ACTIVE', CAST(N'2026-07-26T15:35:07.4966667' AS DateTime2), N'MALE'),
(185, N'BS. CKI Nguyễn Thu Hà', N'k29_bs3@bvdaihoc.com.vn', N'0903129003', N'123', N'DOCTOR', N'ACTIVE', CAST(N'2026-07-26T15:35:07.4966667' AS DateTime2), N'FEMALE'),
(186, N'ThS. BS Lê Hoàng Tấn', N'k30_bs1@bvdaihoc.com.vn', N'0903130001', N'123', N'DOCTOR', N'ACTIVE', CAST(N'2026-07-26T15:35:07.4966667' AS DateTime2), N'MALE'),
(187, N'BS. CKII Nguyễn Minh Thắng', N'k30_bs2@bvdaihoc.com.vn', N'0903130002', N'123', N'DOCTOR', N'ACTIVE', CAST(N'2026-07-26T15:35:07.4966667' AS DateTime2), N'MALE'),
(188, N'BS. CKI Phạm Thị Thanh Anh', N'k30_bs3@bvdaihoc.com.vn', N'0903130003', N'123', N'DOCTOR', N'ACTIVE', CAST(N'2026-07-26T15:35:07.4966667' AS DateTime2), N'FEMALE'),
(189, N'BS. CKII Nguyễn Trọng Hào', N'k31_bs1@bvdaihoc.com.vn', N'0903131001', N'123', N'DOCTOR', N'ACTIVE', CAST(N'2026-07-26T15:35:07.4966667' AS DateTime2), N'MALE'),
(190, N'TS. BS Lê Đức Trung', N'k31_bs2@bvdaihoc.com.vn', N'0903131002', N'123', N'DOCTOR', N'ACTIVE', CAST(N'2026-07-26T15:35:07.4966667' AS DateTime2), N'MALE'),
(191, N'ThS. BS Vũ Thị Cẩm Anh', N'k31_bs3@bvdaihoc.com.vn', N'0903131003', N'123', N'DOCTOR', N'ACTIVE', CAST(N'2026-07-26T15:35:07.4966667' AS DateTime2), N'FEMALE'),
(192, N'TS. BS Lê Thái Vân Thanh', N'k32_bs1@bvdaihoc.com.vn', N'0903132001', N'123', N'DOCTOR', N'ACTIVE', CAST(N'2026-07-26T15:35:07.4966667' AS DateTime2), N'FEMALE'),
(193, N'ThS. BS Nguyễn Trọng Hiếu', N'k32_bs2@bvdaihoc.com.vn', N'0903132002', N'123', N'DOCTOR', N'ACTIVE', CAST(N'2026-07-26T15:35:07.4966667' AS DateTime2), N'MALE'),
(194, N'BS. CKII Trần Thị Oanh', N'k32_bs3@bvdaihoc.com.vn', N'0903132003', N'123', N'DOCTOR', N'ACTIVE', CAST(N'2026-07-26T15:35:07.4966667' AS DateTime2), N'FEMALE'),
(195, N'BS. CKI Lê Quang Huy', N'k32_bs4@bvdaihoc.com.vn', N'0903132004', N'123', N'DOCTOR', N'ACTIVE', CAST(N'2026-07-26T15:35:07.4966667' AS DateTime2), N'MALE'),
(196, N'ThS. BS Phạm Anh Tuấn', N'k33_bs1@bvdaihoc.com.vn', N'0903133001', N'123', N'DOCTOR', N'ACTIVE', CAST(N'2026-07-26T15:35:07.4966667' AS DateTime2), N'MALE'),
(197, N'TS. BS Nguyễn Minh Tuấn', N'k33_bs2@bvdaihoc.com.vn', N'0903133002', N'123', N'DOCTOR', N'ACTIVE', CAST(N'2026-07-26T15:35:07.4966667' AS DateTime2), N'MALE'),
(198, N'BS. CKII Huỳnh Thị Ngọc Nga', N'k33_bs3@bvdaihoc.com.vn', N'0903133003', N'123', N'DOCTOR', N'ACTIVE', CAST(N'2026-07-26T15:35:07.4966667' AS DateTime2), N'FEMALE'),
(199, N'BS. CKI Nguyễn Ngọc Anh', N'k34_bs1@bvdaihoc.com.vn', N'0903134001', N'123', N'DOCTOR', N'ACTIVE', CAST(N'2026-07-26T15:35:07.4966667' AS DateTime2), N'MALE'),
(200, N'ThS. BS Lê Trí Bình', N'k34_bs2@bvdaihoc.com.vn', N'0903134002', N'123', N'DOCTOR', N'ACTIVE', CAST(N'2026-07-26T15:35:07.4966667' AS DateTime2), N'MALE'),
(201, N'BS. CKII Đặng Thị Phương', N'k34_bs3@bvdaihoc.com.vn', N'0903134003', N'123', N'DOCTOR', N'ACTIVE', CAST(N'2026-07-26T15:35:07.4966667' AS DateTime2), N'FEMALE'),
(202, N'PGS. TS. BS Võ Tấn Đức', N'k35_bs1@bvdaihoc.com.vn', N'0903135001', N'123', N'DOCTOR', N'ACTIVE', CAST(N'2026-07-26T15:35:07.4966667' AS DateTime2), N'MALE'),
(203, N'BS. CKII Nguyễn Bảo Khôi', N'k35_bs2@bvdaihoc.com.vn', N'0903135002', N'123', N'DOCTOR', N'ACTIVE', CAST(N'2026-07-26T15:35:07.4966667' AS DateTime2), N'MALE'),
(204, N'ThS. BS Lê Thị Mỹ Duyên', N'k35_bs3@bvdaihoc.com.vn', N'0903135003', N'123', N'DOCTOR', N'ACTIVE', CAST(N'2026-07-26T15:35:07.4966667' AS DateTime2), N'FEMALE'),
(205, N'TS. BS Hoàng Cẩm Tú', N'k36_bs1@bvdaihoc.com.vn', N'0903136001', N'123', N'DOCTOR', N'ACTIVE', CAST(N'2026-07-26T15:35:07.4966667' AS DateTime2), N'MALE'),
(206, N'ThS. BS Nguyễn Hùng Cường', N'k36_bs2@bvdaihoc.com.vn', N'0903136002', N'123', N'DOCTOR', N'ACTIVE', CAST(N'2026-07-26T15:35:07.4966667' AS DateTime2), N'MALE'),
(207, N'BS. CKII Trần Ngọc Trân', N'k36_bs3@bvdaihoc.com.vn', N'0903136003', N'123', N'DOCTOR', N'ACTIVE', CAST(N'2026-07-26T15:35:07.4966667' AS DateTime2), N'FEMALE'),
(208, N'BS. CKI Phạm Duy Khang', N'k36_bs4@bvdaihoc.com.vn', N'0903136004', N'123', N'DOCTOR', N'ACTIVE', CAST(N'2026-07-26T15:35:07.4966667' AS DateTime2), N'MALE'),
(209, N'BS. CKII Trần Tấn Trà', N'k37_bs1@bvdaihoc.com.vn', N'0903137001', N'123', N'DOCTOR', N'ACTIVE', CAST(N'2026-07-26T15:35:07.4966667' AS DateTime2), N'MALE'),
(210, N'TS. BS Võ Hồng Minh', N'k37_bs2@bvdaihoc.com.vn', N'0903137002', N'123', N'DOCTOR', N'ACTIVE', CAST(N'2026-07-26T15:35:07.4966667' AS DateTime2), N'MALE'),
(211, N'ThS. BS Lê Thị Kim Thoa', N'k37_bs3@bvdaihoc.com.vn', N'0903137003', N'123', N'DOCTOR', N'ACTIVE', CAST(N'2026-07-26T15:35:07.4966667' AS DateTime2), N'FEMALE'),
(212, N'ThS. BS Nguyễn Thị Băng Sương', N'k38_bs1@bvdaihoc.com.vn', N'0903138001', N'123', N'DOCTOR', N'ACTIVE', CAST(N'2026-07-26T15:35:07.4966667' AS DateTime2), N'FEMALE'),
(213, N'BS. CKII Lê Văn Trường', N'k38_bs2@bvdaihoc.com.vn', N'0903138002', N'123', N'DOCTOR', N'ACTIVE', CAST(N'2026-07-26T15:35:07.4966667' AS DateTime2), N'MALE'),
(214, N'ThS. BS Trần Thị Mai', N'k38_bs3@bvdaihoc.com.vn', N'0903138003', N'123', N'DOCTOR', N'ACTIVE', CAST(N'2026-07-26T15:35:07.4966667' AS DateTime2), N'FEMALE'),
(215, N'TS. BS Huỳnh Long', N'k39_bs1@bvdaihoc.com.vn', N'0903139001', N'123', N'DOCTOR', N'ACTIVE', CAST(N'2026-07-26T15:35:07.4966667' AS DateTime2), N'MALE'),
(216, N'ThS. BS Đinh Trọng Khôi', N'k39_bs2@bvdaihoc.com.vn', N'0903139002', N'123', N'DOCTOR', N'ACTIVE', CAST(N'2026-07-26T15:35:07.4966667' AS DateTime2), N'MALE'),
(217, N'BS. CKI Nguyễn Thị Oanh', N'k39_bs3@bvdaihoc.com.vn', N'0903139003', N'123', N'DOCTOR', N'ACTIVE', CAST(N'2026-07-26T15:35:07.4966667' AS DateTime2), N'FEMALE'),
(218, N'BS. CKII Đoàn Nguyễn Trọng Tuấn', N'k40_bs1@bvdaihoc.com.vn', N'0903140001', N'123', N'DOCTOR', N'ACTIVE', CAST(N'2026-07-26T15:35:07.4966667' AS DateTime2), N'MALE'),
(219, N'TS. BS Phạm Lương Hùng', N'k40_bs2@bvdaihoc.com.vn', N'0903140002', N'123', N'DOCTOR', N'ACTIVE', CAST(N'2026-07-26T15:35:07.4966667' AS DateTime2), N'MALE'),
(220, N'ThS. BS Võ Thị Hồng Vân', N'k40_bs3@bvdaihoc.com.vn', N'0903140003', N'123', N'DOCTOR', N'ACTIVE', CAST(N'2026-07-26T15:35:07.4966667' AS DateTime2), N'FEMALE'),
(221, N'ThS. BS Lý Gia Khang', N'k41_bs1@bvdaihoc.com.vn', N'0903141001', N'123', N'DOCTOR', N'ACTIVE', CAST(N'2026-07-26T15:35:07.4966667' AS DateTime2), N'MALE'),
(222, N'BS. CKII Nguyễn Quang Minh', N'k41_bs2@bvdaihoc.com.vn', N'0903141002', N'123', N'DOCTOR', N'ACTIVE', CAST(N'2026-07-26T15:35:07.4966667' AS DateTime2), N'MALE'),
(223, N'ThS. BS Lê Thị Kim Huệ', N'k41_bs3@bvdaihoc.com.vn', N'0903141003', N'123', N'DOCTOR', N'ACTIVE', CAST(N'2026-07-26T15:35:07.4966667' AS DateTime2), N'FEMALE'),
(224, N'PGS. TS. BS Đào Thị Yến Phi', N'k42_bs1@bvdaihoc.com.vn', N'0903142001', N'123', N'DOCTOR', N'ACTIVE', CAST(N'2026-07-26T15:35:07.4966667' AS DateTime2), N'FEMALE'),
(225, N'BS. CKII Lê Trung Dũng', N'k42_bs2@bvdaihoc.com.vn', N'0903142002', N'123', N'DOCTOR', N'ACTIVE', CAST(N'2026-07-26T15:35:07.4966667' AS DateTime2), N'MALE'),
(226, N'ThS. BS Nguyễn Thị Trúc Anh', N'k42_bs3@bvdaihoc.com.vn', N'0903142003', N'123', N'DOCTOR', N'ACTIVE', CAST(N'2026-07-26T15:35:07.4966667' AS DateTime2), N'FEMALE'),
(227, N'DS. CKII Lê Minh Phúc', N'k43_bs1@bvdaihoc.com.vn', N'0903143001', N'123', N'DOCTOR', N'ACTIVE', CAST(N'2026-07-26T15:35:07.4966667' AS DateTime2), N'MALE'),
(228, N'ThS. DS Nguyễn Trọng Cường', N'k43_bs2@bvdaihoc.com.vn', N'0903143002', N'123', N'DOCTOR', N'ACTIVE', CAST(N'2026-07-26T15:35:07.4966667' AS DateTime2), N'MALE'),
(229, N'DS. CKI Trần Thị Kim Liên', N'k43_bs3@bvdaihoc.com.vn', N'0903143003', N'123', N'DOCTOR', N'ACTIVE', CAST(N'2026-07-26T15:35:07.4966667' AS DateTime2), N'FEMALE'),
(230, N'TS. BS Lâm Vĩnh Niên', N'k44_bs1@bvdaihoc.com.vn', N'0903144001', N'123', N'DOCTOR', N'ACTIVE', CAST(N'2026-07-26T15:35:07.4966667' AS DateTime2), N'MALE'),
(231, N'ThS. BS Nguyễn Thùy Linh', N'k44_bs2@bvdaihoc.com.vn', N'0903144002', N'123', N'DOCTOR', N'ACTIVE', CAST(N'2026-07-26T15:35:07.4966667' AS DateTime2), N'FEMALE'),
(232, N'BS. CKI Lê Văn Quý', N'k44_bs3@bvdaihoc.com.vn', N'0903144003', N'123', N'DOCTOR', N'ACTIVE', CAST(N'2026-07-26T15:35:07.4966667' AS DateTime2), N'MALE'),
(233, N'ThS. BS Huỳnh Cẩm Linh', N'k45_bs1@bvdaihoc.com.vn', N'0903145001', N'123', N'DOCTOR', N'ACTIVE', CAST(N'2026-07-26T15:35:07.4966667' AS DateTime2), N'FEMALE'),
(234, N'BS. CKII Nguyễn Đình Khoa', N'k45_bs2@bvdaihoc.com.vn', N'0903145002', N'123', N'DOCTOR', N'ACTIVE', CAST(N'2026-07-26T15:35:07.4966667' AS DateTime2), N'MALE'),
(235, N'ThS. BS Lê Thị Mỹ Hồng', N'k45_bs3@bvdaihoc.com.vn', N'0903145003', N'123', N'DOCTOR', N'ACTIVE', CAST(N'2026-07-26T15:35:07.4966667' AS DateTime2), N'FEMALE'),

-- Bệnh nhân (Thêm vào cuối)
(236, N'Võ Minh HÙng', N'vominhhung123@gmail.com', N'0123456789', N'123456', N'PATIENT', N'ACTIVE', CAST(N'2026-07-28T21:32:39.8760632' AS DateTime2), N'Nam');
GO

SET IDENTITY_INSERT [dbo].[users] OFF;
GO

-- ==========================================================
-- 2. BẢNG DEPARTMENTS
-- ==========================================================
SET IDENTITY_INSERT [dbo].[departments] ON;
GO

INSERT INTO [dbo].[departments] ([id], [name], [description], [status], [parent_id], [image_url], [base_price])
VALUES 
-- Khoa cấp cao (Parent)
(1, N'Khoa Lâm Sàng', NULL, N'ACTIVE', NULL, NULL, NULL),
(2, N'Khoa Cận Lâm Sàng', NULL, N'ACTIVE', NULL, NULL, NULL),
(3, N'Khoa Hỗ Trợ Lâm Sàng', NULL, N'ACTIVE', NULL, NULL, NULL),

-- Trực thuộc Khoa Lâm Sàng (Parent_id = 1)
(4, N'Khoa Khám bệnh', NULL, N'ACTIVE', 1, N'/img/departments/khoa-kham-benh.png', NULL),
(5, N'Khoa Khám sức khoẻ theo yêu cầu', NULL, N'ACTIVE', 1, N'/img/departments/khoa-kham-suc-khoe.png', NULL),
(6, N'Khoa Cấp cứu', NULL, N'ACTIVE', 1, N'/img/departments/khoa-cap-cuu.png', NULL),
(7, N'Khoa Hồi sức tích cực', NULL, N'ACTIVE', 1, N'/img/departments/khoa-hoi-suc-tich-cuc.png', NULL),
(8, N'Khoa Nội cơ xương khớp', NULL, N'ACTIVE', 1, N'/img/departments/khoa-noi-co-xuong-khop.png', NULL),
(9, N'Khoa Nội thận - Thận nhân tạo', NULL, N'ACTIVE', 1, N'/img/departments/khoa-noi-than.png', NULL),
(10, N'Khoa Nội tiết', NULL, N'ACTIVE', 1, N'/img/departments/khoa-noi-tiet.png', NULL),
(11, N'Khoa Nội tim mạch', NULL, N'ACTIVE', 1, N'/img/departments/khoa-noi-tim-mach.png', NULL),
(12, N'Khoa Tim mạch can thiệp', NULL, N'ACTIVE', 1, N'/img/departments/khoa-tim-mach-can-thiep.png', NULL),
(13, N'Khoa Phẫu thuật Tim mạch', NULL, N'ACTIVE', 1, N'/img/departments/khoa-phau-thuat-tim-mach.png', NULL),
(14, N'Khoa Tiêu hóa', NULL, N'ACTIVE', 1, N'/img/departments/khoa-tieu-hoa.png', NULL),
(15, N'Khoa Ngoại Tiêu hóa', NULL, N'ACTIVE', 1, N'/img/departments/khoa-ngoai-tieu-hoa.png', NULL),
(16, N'Khoa Ngoại Gan - Mật - Tụy', NULL, N'ACTIVE', 1, N'/img/departments/khoa-ngoai-gan-mat-tuy.png', NULL),
(17, N'Khoa Thần kinh', NULL, N'ACTIVE', 1, N'/img/departments/khoa-than-kinh.png', NULL),
(18, N'Khoa Ngoại Thần kinh', NULL, N'ACTIVE', 1, N'/img/departments/khoa-ngoai-than-kinh.png', NULL),
(19, N'Khoa Chấn thương chỉnh hình', NULL, N'ACTIVE', 1, N'/img/departments/khoa-chan-thuong-chinh-hinh.png', NULL),
(20, N'Khoa Lồng ngực - Mạch máu', NULL, N'ACTIVE', 1, N'/img/departments/khoa-long-nguc-mach-mau.png', NULL),
(21, N'Khoa Hô hấp', NULL, N'ACTIVE', 1, N'/img/departments/khoa-ho-hap.png', NULL),
(22, N'Khoa Phụ sản', NULL, N'ACTIVE', 1, N'/img/departments/khoa-phu-san.png', NULL),
(23, N'Khoa Tuyến vú', NULL, N'ACTIVE', 1, N'/img/departments/khoa-tuyen-vu.png', NULL),
(24, N'Khoa Sơ sinh', NULL, N'ACTIVE', 1, N'/img/departments/khoa-so-sinh.png', NULL),
(25, N'Khoa Tai Mũi Họng', NULL, N'ACTIVE', 1, N'/img/departments/khoa-tai-mui-hong.png', NULL),
(26, N'Khoa Mắt', NULL, N'ACTIVE', 1, N'/img/departments/khoa-mat.png', NULL),
(27, N'Khoa Phẫu thuật Hàm mặt - Răng Hàm Mặt', NULL, N'ACTIVE', 1, N'/img/departments/khoa-rang-ham-mat.png', NULL),
(28, N'Khoa Tiết niệu', NULL, N'ACTIVE', 1, N'/img/departments/khoa-tiet-nieu.png', NULL),
(29, N'Khoa Niệu học chức năng', NULL, N'ACTIVE', 1, N'/img/departments/khoa-nieu-hoc-chuc-nang.png', NULL),
(30, N'Khoa Hậu môn - Trực tràng', NULL, N'ACTIVE', 1, N'/img/departments/khoa-hau-mon-truc-trang.png', NULL),
(31, N'Khoa Lão - Chăm sóc giảm nhẹ', NULL, N'ACTIVE', 1, N'/img/departments/khoa-lao-khoa.png', NULL),
(32, N'Khoa Da liễu - Thẩm mỹ da', NULL, N'ACTIVE', 1, N'/img/departments/khoa-da-lieu.png', NULL),
(33, N'Khoa Tạo hình Thẩm mỹ', NULL, N'ACTIVE', 1, N'/img/departments/khoa-tao-hinh-tham-my.png', NULL),
(34, N'Khoa Phục hồi chức năng', NULL, N'ACTIVE', 1, N'/img/departments/khoa-phuc-hoi-chuc-nang.png', NULL),
(35, N'Khoa Gây mê - Hồi sức', NULL, N'ACTIVE', 1, N'/img/departments/khoa-gay-me-hoi-suc.png', NULL),
(36, N'Khoa Hóa trị ung thư', NULL, N'ACTIVE', 1, N'/img/departments/khoa-hoa-tri-ung-thu.png', NULL),

-- Trực thuộc Khoa Cận Lâm Sàng (Parent_id = 2)
(37, N'Khoa Chẩn đoán hình ảnh', NULL, N'ACTIVE', 2, N'/img/departments/khoa-chan-doan-hinh-anh.png', NULL),
(38, N'Khoa Xét nghiệm', NULL, N'ACTIVE', 2, N'/img/departments/khoa-xet-nghiem.png', NULL),
(39, N'Khoa Vi sinh', NULL, N'ACTIVE', 2, N'/img/departments/khoa-vi-sinh.png', NULL),
(40, N'Khoa Giải phẫu bệnh', NULL, N'ACTIVE', 2, N'/img/departments/khoa-giai-phau-benh.png', NULL),
(41, N'Khoa Nội soi', NULL, N'ACTIVE', 2, N'/img/departments/khoa-noi-soi.png', NULL),
(42, N'Khoa Thăm dò chức năng', NULL, N'ACTIVE', 2, N'/img/departments/khoa-tham-do-chuc-nang.png', NULL),

-- Trực thuộc Khoa Hỗ Trợ Lâm Sàng (Parent_id = 3)
(43, N'Khoa Dược', NULL, N'ACTIVE', 3, N'/img/departments/khoa-duoc.png', NULL),
(44, N'Khoa Dinh dưỡng - Tiết chế', NULL, N'ACTIVE', 3, N'/img/departments/khoa-dinh-duong.png', NULL),
(45, N'Khoa Kiểm soát nhiễm khuẩn', NULL, N'ACTIVE', 3, N'/img/departments/khoa-kiem-soat-nhiem-khuan.png', NULL);
GO

SET IDENTITY_INSERT [dbo].[departments] OFF;
GO

-- ==========================================================
-- 3. BẢNG DOCTORS
-- ==========================================================
SET IDENTITY_INSERT [dbo].[doctors] ON;
GO

INSERT INTO [dbo].[doctors] ([id], [user_id], [department_id], [title], [experience_years], [description], [examination_fee], [avt_url])
VALUES 
-- ID 4: Khoa Khám bệnh
(90, 90, 4, N'GS. TS. BS', 25, N'Bác sĩ chuyên khoa đầu ngành với nhiều năm kinh nghiệm tại Bệnh viện Đại học Y Dược TP.HCM, chuyên tầm soát, chẩn đoán và điều trị bệnh lý kỹ thuật cao.', CAST(300000.00 AS Decimal(18, 2)), N'/img/doctor/doctor-male.png'),
(91, 91, 4, N'PGS. TS. BS', 25, N'Bác sĩ chuyên khoa đầu ngành với nhiều năm kinh nghiệm tại Bệnh viện Đại học Y Dược TP.HCM, chuyên tầm soát, chẩn đoán và điều trị bệnh lý kỹ thuật cao.', CAST(300000.00 AS Decimal(18, 2)), N'/img/doctor/doctor-female.png'),
(92, 92, 4, N'BS. CKII', 18, N'Bác sĩ chuyên khoa đầu ngành với nhiều năm kinh nghiệm tại Bệnh viện Đại học Y Dược TP.HCM, chuyên tầm soát, chẩn đoán và điều trị bệnh lý kỹ thuật cao.', CAST(200000.00 AS Decimal(18, 2)), N'/img/doctor/doctor-male.png'),
(93, 93, 4, N'ThS. BS', 12, N'Bác sĩ chuyên khoa đầu ngành với nhiều năm kinh nghiệm tại Bệnh viện Đại học Y Dược TP.HCM, chuyên tầm soát, chẩn đoán và điều trị bệnh lý kỹ thuật cao.', CAST(150000.00 AS Decimal(18, 2)), N'/img/doctor/doctor-female.png'),

-- ID 5: Khoa Khám sức khỏe theo yêu cầu
(94, 94, 5, N'ThS. BS', 12, N'Bác sĩ chuyên khoa đầu ngành với nhiều năm kinh nghiệm tại Bệnh viện Đại học Y Dược TP.HCM, chuyên tầm soát, chẩn đoán và điều trị bệnh lý kỹ thuật cao.', CAST(150000.00 AS Decimal(18, 2)), N'/img/doctor/doctor-female.png'),
(95, 95, 5, N'TS. BS', 18, N'Bác sĩ chuyên khoa đầu ngành với nhiều năm kinh nghiệm tại Bệnh viện Đại học Y Dược TP.HCM, chuyên tầm soát, chẩn đoán và điều trị bệnh lý kỹ thuật cao.', CAST(200000.00 AS Decimal(18, 2)), N'/img/doctor/doctor-male.png'),
(96, 96, 5, N'BS. CKII', 18, N'Bác sĩ chuyên khoa đầu ngành với nhiều năm kinh nghiệm tại Bệnh viện Đại học Y Dược TP.HCM, chuyên tầm soát, chẩn đoán và điều trị bệnh lý kỹ thuật cao.', CAST(200000.00 AS Decimal(18, 2)), N'/img/doctor/doctor-female.png'),
(97, 97, 5, N'ThS. BS', 12, N'Bác sĩ chuyên khoa đầu ngành với nhiều năm kinh nghiệm tại Bệnh viện Đại học Y Dược TP.HCM, chuyên tầm soát, chẩn đoán và điều trị bệnh lý kỹ thuật cao.', CAST(150000.00 AS Decimal(18, 2)), N'/img/doctor/doctor-female.png'),

-- ID 6: Khoa Cấp cứu
(98, 98, 6, N'PGS. TS. BS', 25, N'Bác sĩ chuyên khoa đầu ngành với nhiều năm kinh nghiệm tại Bệnh viện Đại học Y Dược TP.HCM, chuyên tầm soát, chẩn đoán và điều trị bệnh lý kỹ thuật cao.', CAST(300000.00 AS Decimal(18, 2)), N'/img/doctor/doctor-male.png'),
(99, 99, 6, N'BS. CKII', 18, N'Bác sĩ chuyên khoa đầu ngành với nhiều năm kinh nghiệm tại Bệnh viện Đại học Y Dược TP.HCM, chuyên tầm soát, chẩn đoán và điều trị bệnh lý kỹ thuật cao.', CAST(200000.00 AS Decimal(18, 2)), N'/img/doctor/doctor-male.png'),
(100, 100, 6, N'ThS. BS', 12, N'Bác sĩ chuyên khoa đầu ngành với nhiều năm kinh nghiệm tại Bệnh viện Đại học Y Dược TP.HCM, chuyên tầm soát, chẩn đoán và điều trị bệnh lý kỹ thuật cao.', CAST(150000.00 AS Decimal(18, 2)), N'/img/doctor/doctor-male.png'),
(101, 101, 6, N'BS. CKI', 12, N'Bác sĩ chuyên khoa đầu ngành với nhiều năm kinh nghiệm tại Bệnh viện Đại học Y Dược TP.HCM, chuyên tầm soát, chẩn đoán và điều trị bệnh lý kỹ thuật cao.', CAST(150000.00 AS Decimal(18, 2)), N'/img/doctor/doctor-female.png'),

-- Các ID khoa khác (gom gọn nhanh để tối ưu)
(102, 102, 7, N'TS. BS', 18, N'Bác sĩ chuyên khoa đầu ngành...', CAST(200000.00 AS Decimal(18, 2)), N'/img/doctor/doctor-male.png'),
(103, 103, 7, N'BS. CKII', 18, N'Bác sĩ chuyên khoa đầu ngành...', CAST(200000.00 AS Decimal(18, 2)), N'/img/doctor/doctor-male.png'),
(104, 104, 7, N'ThS. BS', 12, N'Bác sĩ chuyên khoa đầu ngành...', CAST(150000.00 AS Decimal(18, 2)), N'/img/doctor/doctor-female.png'),
(105, 105, 7, N'BS. CKI', 12, N'Bác sĩ chuyên khoa đầu ngành...', CAST(150000.00 AS Decimal(18, 2)), N'/img/doctor/doctor-male.png'),
(106, 106, 8, N'TS. BS', 18, N'Bác sĩ chuyên khoa đầu ngành...', CAST(200000.00 AS Decimal(18, 2)), N'/img/doctor/doctor-male.png'),
(107, 107, 8, N'ThS. BS', 12, N'Bác sĩ chuyên khoa đầu ngành...', CAST(150000.00 AS Decimal(18, 2)), N'/img/doctor/doctor-male.png'),
(108, 108, 8, N'BS. CKII', 18, N'Bác sĩ chuyên khoa đầu ngành...', CAST(200000.00 AS Decimal(18, 2)), N'/img/doctor/doctor-female.png'),
(109, 109, 8, N'ThS. BS', 12, N'Bác sĩ chuyên khoa đầu ngành...', CAST(150000.00 AS Decimal(18, 2)), N'/img/doctor/doctor-male.png'),
(110, 110, 9, N'BS. CKII', 18, N'Bác sĩ chuyên khoa đầu ngành...', CAST(200000.00 AS Decimal(18, 2)), N'/img/doctor/doctor-male.png'),
(111, 111, 9, N'TS. BS', 18, N'Bác sĩ chuyên khoa đầu ngành...', CAST(200000.00 AS Decimal(18, 2)), N'/img/doctor/doctor-female.png'),
(112, 112, 9, N'ThS. BS', 12, N'Bác sĩ chuyên khoa đầu ngành...', CAST(150000.00 AS Decimal(18, 2)), N'/img/doctor/doctor-male.png'),
(113, 113, 9, N'BS. CKI', 12, N'Bác sĩ chuyên khoa đầu ngành...', CAST(150000.00 AS Decimal(18, 2)), N'/img/doctor/doctor-female.png'),
(114, 114, 10, N'TS. BS', 18, N'Bác sĩ chuyên khoa đầu ngành...', CAST(200000.00 AS Decimal(18, 2)), N'/img/doctor/doctor-male.png'),
(115, 115, 10, N'ThS. BS', 12, N'Bác sĩ chuyên khoa đầu ngành...', CAST(150000.00 AS Decimal(18, 2)), N'/img/doctor/doctor-male.png'),
(116, 116, 10, N'BS. CKII', 18, N'Bác sĩ chuyên khoa đầu ngành...', CAST(200000.00 AS Decimal(18, 2)), N'/img/doctor/doctor-female.png'),
(117, 117, 10, N'ThS. BS', 12, N'Bác sĩ chuyên khoa đầu ngành...', CAST(150000.00 AS Decimal(18, 2)), N'/img/doctor/doctor-female.png'),
(118, 118, 11, N'TS. BS', 18, N'Bác sĩ chuyên khoa đầu ngành...', CAST(200000.00 AS Decimal(18, 2)), N'/img/doctor/doctor-male.png'),
(119, 119, 11, N'PGS. TS. BS', 25, N'Bác sĩ chuyên khoa đầu ngành...', CAST(300000.00 AS Decimal(18, 2)), N'/img/doctor/doctor-female.png'),
(120, 120, 11, N'ThS. BS', 12, N'Bác sĩ chuyên khoa đầu ngành...', CAST(150000.00 AS Decimal(18, 2)), N'/img/doctor/doctor-male.png'),
(121, 121, 11, N'BS. CKII', 18, N'Bác sĩ chuyên khoa đầu ngành...', CAST(200000.00 AS Decimal(18, 2)), N'/img/doctor/doctor-female.png'),
(122, 122, 12, N'TS. BS', 18, N'Bác sĩ chuyên khoa đầu ngành...', CAST(200000.00 AS Decimal(18, 2)), N'/img/doctor/doctor-male.png'),
(123, 123, 12, N'ThS. BS', 12, N'Bác sĩ chuyên khoa đầu ngành...', CAST(150000.00 AS Decimal(18, 2)), N'/img/doctor/doctor-male.png'),
(124, 124, 12, N'BS. CKI', 12, N'Bác sĩ chuyên khoa đầu ngành...', CAST(150000.00 AS Decimal(18, 2)), N'/img/doctor/doctor-male.png'),
(125, 125, 12, N'ThS. BS', 12, N'Bác sĩ chuyên khoa đầu ngành...', CAST(150000.00 AS Decimal(18, 2)), N'/img/doctor/doctor-female.png'),
(126, 126, 13, N'PGS. TS. BS', 25, N'Bác sĩ chuyên khoa đầu ngành...', CAST(300000.00 AS Decimal(18, 2)), N'/img/doctor/doctor-male.png'),
(127, 127, 13, N'TS. BS', 18, N'Bác sĩ chuyên khoa đầu ngành...', CAST(200000.00 AS Decimal(18, 2)), N'/img/doctor/doctor-male.png'),
(128, 128, 13, N'ThS. BS', 12, N'Bác sĩ chuyên khoa đầu ngành...', CAST(150000.00 AS Decimal(18, 2)), N'/img/doctor/doctor-male.png'),
(129, 129, 13, N'BS. CKII', 18, N'Bác sĩ chuyên khoa đầu ngành...', CAST(200000.00 AS Decimal(18, 2)), N'/img/doctor/doctor-female.png'),
(130, 130, 14, N'PGS. TS. BS', 25, N'Bác sĩ chuyên khoa đầu ngành...', CAST(300000.00 AS Decimal(18, 2)), N'/img/doctor/doctor-male.png'),
(131, 131, 14, N'TS. BS', 18, N'Bác sĩ chuyên khoa đầu ngành...', CAST(200000.00 AS Decimal(18, 2)), N'/img/doctor/doctor-male.png'),
(132, 132, 14, N'ThS. BS', 12, N'Bác sĩ chuyên khoa đầu ngành...', CAST(150000.00 AS Decimal(18, 2)), N'/img/doctor/doctor-male.png'),
(133, 133, 14, N'BS. CKI', 12, N'Bác sĩ chuyên khoa đầu ngành...', CAST(150000.00 AS Decimal(18, 2)), N'/img/doctor/doctor-female.png'),
(134, 134, 15, N'TS. BS', 18, N'Bác sĩ chuyên khoa đầu ngành...', CAST(200000.00 AS Decimal(18, 2)), N'/img/doctor/doctor-male.png'),
(135, 135, 15, N'PGS. TS. BS', 25, N'Bác sĩ chuyên khoa đầu ngành...', CAST(300000.00 AS Decimal(18, 2)), N'/img/doctor/doctor-male.png'),
(136, 136, 15, N'ThS. BS', 12, N'Bác sĩ chuyên khoa đầu ngành...', CAST(150000.00 AS Decimal(18, 2)), N'/img/doctor/doctor-male.png'),
(137, 137, 15, N'BS. CKII', 18, N'Bác sĩ chuyên khoa đầu ngành...', CAST(200000.00 AS Decimal(18, 2)), N'/img/doctor/doctor-female.png'),
(138, 138, 16, N'GS. TS. BS', 25, N'Bác sĩ chuyên khoa đầu ngành...', CAST(300000.00 AS Decimal(18, 2)), N'/img/doctor/doctor-male.png'),
(139, 139, 16, N'TS. BS', 18, N'Bác sĩ chuyên khoa đầu ngành...', CAST(200000.00 AS Decimal(18, 2)), N'/img/doctor/doctor-male.png'),
(140, 140, 16, N'ThS. BS', 12, N'Bác sĩ chuyên khoa đầu ngành...', CAST(150000.00 AS Decimal(18, 2)), N'/img/doctor/doctor-male.png'),
(141, 141, 16, N'BS. CKI', 12, N'Bác sĩ chuyên khoa đầu ngành...', CAST(150000.00 AS Decimal(18, 2)), N'/img/doctor/doctor-female.png'),
(142, 142, 17, N'PGS. TS. BS', 25, N'Bác sĩ chuyên khoa đầu ngành...', CAST(300000.00 AS Decimal(18, 2)), N'/img/doctor/doctor-male.png'),
(143, 143, 17, N'TS. BS', 18, N'Bác sĩ chuyên khoa đầu ngành...', CAST(200000.00 AS Decimal(18, 2)), N'/img/doctor/doctor-female.png'),
(144, 144, 17, N'ThS. BS', 12, N'Bác sĩ chuyên khoa đầu ngành...', CAST(150000.00 AS Decimal(18, 2)), N'/img/doctor/doctor-male.png'),
(145, 145, 17, N'BS. CKII', 18, N'Bác sĩ chuyên khoa đầu ngành...', CAST(200000.00 AS Decimal(18, 2)), N'/img/doctor/doctor-female.png'),
(146, 146, 18, N'TS. BS', 18, N'Bác sĩ chuyên khoa đầu ngành...', CAST(200000.00 AS Decimal(18, 2)), N'/img/doctor/doctor-male.png'),
(147, 147, 18, N'ThS. BS', 12, N'Bác sĩ chuyên khoa đầu ngành...', CAST(150000.00 AS Decimal(18, 2)), N'/img/doctor/doctor-male.png'),
(148, 148, 18, N'BS. CKI', 12, N'Bác sĩ chuyên khoa đầu ngành...', CAST(150000.00 AS Decimal(18, 2)), N'/img/doctor/doctor-male.png'),
(149, 149, 19, N'TS. BS', 18, N'Bác sĩ chuyên khoa đầu ngành...', CAST(200000.00 AS Decimal(18, 2)), N'/img/doctor/doctor-male.png'),
(150, 150, 19, N'BS. CKII', 18, N'Bác sĩ chuyên khoa đầu ngành...', CAST(200000.00 AS Decimal(18, 2)), N'/img/doctor/doctor-male.png'),
(151, 151, 19, N'ThS. BS', 12, N'Bác sĩ chuyên khoa đầu ngành...', CAST(150000.00 AS Decimal(18, 2)), N'/img/doctor/doctor-male.png'),
(152, 152, 19, N'BS. CKI', 12, N'Bác sĩ chuyên khoa đầu ngành...', CAST(150000.00 AS Decimal(18, 2)), N'/img/doctor/doctor-female.png'),
(153, 153, 20, N'TS. BS', 18, N'Bác sĩ chuyên khoa đầu ngành...', CAST(200000.00 AS Decimal(18, 2)), N'/img/doctor/doctor-male.png'),
(154, 154, 20, N'ThS. BS', 12, N'Bác sĩ chuyên khoa đầu ngành...', CAST(150000.00 AS Decimal(18, 2)), N'/img/doctor/doctor-male.png'),
(155, 155, 20, N'BS. CKII', 18, N'Bác sĩ chuyên khoa đầu ngành...', CAST(200000.00 AS Decimal(18, 2)), N'/img/doctor/doctor-female.png'),
(156, 156, 21, N'PGS. TS. BS', 25, N'Bác sĩ chuyên khoa đầu ngành...', CAST(300000.00 AS Decimal(18, 2)), N'/img/doctor/doctor-male.png'),
(157, 157, 21, N'TS. BS', 18, N'Bác sĩ chuyên khoa đầu ngành...', CAST(200000.00 AS Decimal(18, 2)), N'/img/doctor/doctor-female.png'),
(158, 158, 21, N'BS. CKI', 12, N'Bác sĩ chuyên khoa đầu ngành...', CAST(150000.00 AS Decimal(18, 2)), N'/img/doctor/doctor-female.png'),
(159, 159, 22, N'BS. CKII', 18, N'Bác sĩ chuyên khoa đầu ngành...', CAST(200000.00 AS Decimal(18, 2)), N'/img/doctor/doctor-female.png'),
(160, 160, 22, N'PGS. TS. BS', 25, N'Bác sĩ chuyên khoa đầu ngành...', CAST(300000.00 AS Decimal(18, 2)), N'/img/doctor/doctor-female.png'),
(161, 161, 22, N'ThS. BS', 12, N'Bác sĩ chuyên khoa đầu ngành...', CAST(150000.00 AS Decimal(18, 2)), N'/img/doctor/doctor-male.png'),
(162, 162, 22, N'BS. CKI', 12, N'Bác sĩ chuyên khoa đầu ngành...', CAST(150000.00 AS Decimal(18, 2)), N'/img/doctor/doctor-female.png'),
(163, 163, 23, N'PGS. TS. BS', 25, N'Bác sĩ chuyên khoa đầu ngành...', CAST(300000.00 AS Decimal(18, 2)), N'/img/doctor/doctor-male.png'),
(164, 164, 23, N'ThS. BS', 12, N'Bác sĩ chuyên khoa đầu ngành...', CAST(150000.00 AS Decimal(18, 2)), N'/img/doctor/doctor-female.png'),
(165, 165, 23, N'BS. CKII', 18, N'Bác sĩ chuyên khoa đầu ngành...', CAST(200000.00 AS Decimal(18, 2)), N'/img/doctor/doctor-male.png'),
(166, 166, 24, N'TS. BS', 18, N'Bác sĩ chuyên khoa đầu ngành...', CAST(200000.00 AS Decimal(18, 2)), N'/img/doctor/doctor-female.png'),
(167, 167, 24, N'ThS. BS', 12, N'Bác sĩ chuyên khoa đầu ngành...', CAST(150000.00 AS Decimal(18, 2)), N'/img/doctor/doctor-female.png'),
(168, 168, 24, N'BS. CKI', 12, N'Bác sĩ chuyên khoa đầu ngành...', CAST(150000.00 AS Decimal(18, 2)), N'/img/doctor/doctor-female.png'),
(169, 169, 25, N'ThS. BS', 12, N'Bác sĩ chuyên khoa đầu ngành...', CAST(150000.00 AS Decimal(18, 2)), N'/img/doctor/doctor-male.png'),
(170, 170, 25, N'TS. BS', 18, N'Bác sĩ chuyên khoa đầu ngành...', CAST(200000.00 AS Decimal(18, 2)), N'/img/doctor/doctor-male.png'),
(171, 171, 25, N'BS. CKII', 18, N'Bác sĩ chuyên khoa đầu ngành...', CAST(200000.00 AS Decimal(18, 2)), N'/img/doctor/doctor-female.png'),
(172, 172, 25, N'ThS. BS', 12, N'Bác sĩ chuyên khoa đầu ngành...', CAST(150000.00 AS Decimal(18, 2)), N'/img/doctor/doctor-male.png'),
(173, 173, 26, N'ThS. BS', 12, N'Bác sĩ chuyên khoa đầu ngành...', CAST(150000.00 AS Decimal(18, 2)), N'/img/doctor/doctor-female.png'),
(174, 174, 26, N'BS. CKII', 18, N'Bác sĩ chuyên khoa đầu ngành...', CAST(200000.00 AS Decimal(18, 2)), N'/img/doctor/doctor-male.png'),
(175, 175, 26, N'ThS. BS', 12, N'Bác sĩ chuyên khoa đầu ngành...', CAST(150000.00 AS Decimal(18, 2)), N'/img/doctor/doctor-male.png'),
(176, 176, 27, N'BS. CKII', 18, N'Bác sĩ chuyên khoa đầu ngành...', CAST(200000.00 AS Decimal(18, 2)), N'/img/doctor/doctor-male.png'),
(177, 177, 27, N'TS. BS', 18, N'Bác sĩ chuyên khoa đầu ngành...', CAST(200000.00 AS Decimal(18, 2)), N'/img/doctor/doctor-female.png'),
(178, 178, 27, N'ThS. BS', 12, N'Bác sĩ chuyên khoa đầu ngành...', CAST(150000.00 AS Decimal(18, 2)), N'/img/doctor/doctor-male.png'),
(179, 179, 27, N'BS. CKI', 12, N'Bác sĩ chuyên khoa đầu ngành...', CAST(150000.00 AS Decimal(18, 2)), N'/img/doctor/doctor-female.png'),
(180, 180, 28, N'TS. BS', 18, N'Bác sĩ chuyên khoa đầu ngành...', CAST(200000.00 AS Decimal(18, 2)), N'/img/doctor/doctor-male.png'),
(181, 181, 28, N'ThS. BS', 12, N'Bác sĩ chuyên khoa đầu ngành...', CAST(150000.00 AS Decimal(18, 2)), N'/img/doctor/doctor-male.png'),
(182, 182, 28, N'BS. CKII', 18, N'Bác sĩ chuyên khoa đầu ngành...', CAST(200000.00 AS Decimal(18, 2)), N'/img/doctor/doctor-male.png'),
(183, 183, 29, N'BS. CKII', 18, N'Bác sĩ chuyên khoa đầu ngành...', CAST(200000.00 AS Decimal(18, 2)), N'/img/doctor/doctor-male.png'),
(184, 184, 29, N'ThS. BS', 12, N'Bác sĩ chuyên khoa đầu ngành...', CAST(150000.00 AS Decimal(18, 2)), N'/img/doctor/doctor-male.png'),
(185, 185, 29, N'BS. CKI', 12, N'Bác sĩ chuyên khoa đầu ngành...', CAST(150000.00 AS Decimal(18, 2)), N'/img/doctor/doctor-female.png'),
(186, 186, 30, N'ThS. BS', 12, N'Bác sĩ chuyên khoa đầu ngành...', CAST(150000.00 AS Decimal(18, 2)), N'/img/doctor/doctor-male.png'),
(187, 187, 30, N'BS. CKII', 18, N'Bác sĩ chuyên khoa đầu ngành...', CAST(200000.00 AS Decimal(18, 2)), N'/img/doctor/doctor-male.png'),
(188, 188, 30, N'BS. CKI', 12, N'Bác sĩ chuyên khoa đầu ngành...', CAST(150000.00 AS Decimal(18, 2)), N'/img/doctor/doctor-female.png'),
(189, 189, 31, N'BS. CKII', 18, N'Bác sĩ chuyên khoa đầu ngành...', CAST(200000.00 AS Decimal(18, 2)), N'/img/doctor/doctor-male.png'),
(190, 190, 31, N'TS. BS', 18, N'Bác sĩ chuyên khoa đầu ngành...', CAST(200000.00 AS Decimal(18, 2)), N'/img/doctor/doctor-male.png'),
(191, 191, 31, N'ThS. BS', 12, N'Bác sĩ chuyên khoa đầu ngành...', CAST(150000.00 AS Decimal(18, 2)), N'/img/doctor/doctor-female.png'),
(192, 192, 32, N'TS. BS', 18, N'Bác sĩ chuyên khoa đầu ngành...', CAST(200000.00 AS Decimal(18, 2)), N'/img/doctor/doctor-female.png'),
(193, 193, 32, N'ThS. BS', 12, N'Bác sĩ chuyên khoa đầu ngành...', CAST(150000.00 AS Decimal(18, 2)), N'/img/doctor/doctor-male.png'),
(194, 194, 32, N'BS. CKII', 18, N'Bác sĩ chuyên khoa đầu ngành...', CAST(200000.00 AS Decimal(18, 2)), N'/img/doctor/doctor-female.png'),
(195, 195, 32, N'BS. CKI', 12, N'Bác sĩ chuyên khoa đầu ngành...', CAST(150000.00 AS Decimal(18, 2)), N'/img/doctor/doctor-male.png'),
(196, 196, 33, N'ThS. BS', 12, N'Bác sĩ chuyên khoa đầu ngành...', CAST(150000.00 AS Decimal(18, 2)), N'/img/doctor/doctor-male.png'),
(197, 197, 33, N'TS. BS', 18, N'Bác sĩ chuyên khoa đầu ngành...', CAST(200000.00 AS Decimal(18, 2)), N'/img/doctor/doctor-male.png'),
(198, 198, 33, N'BS. CKII', 18, N'Bác sĩ chuyên khoa đầu ngành...', CAST(200000.00 AS Decimal(18, 2)), N'/img/doctor/doctor-female.png'),
(199, 199, 34, N'BS. CKI', 12, N'Bác sĩ chuyên khoa đầu ngành...', CAST(150000.00 AS Decimal(18, 2)), N'/img/doctor/doctor-male.png'),
(200, 200, 34, N'ThS. BS', 12, N'Bác sĩ chuyên khoa đầu ngành...', CAST(150000.00 AS Decimal(18, 2)), N'/img/doctor/doctor-male.png'),
(201, 201, 34, N'BS. CKII', 18, N'Bác sĩ chuyên khoa đầu ngành...', CAST(200000.00 AS Decimal(18, 2)), N'/img/doctor/doctor-female.png'),
(202, 202, 35, N'PGS. TS. BS', 25, N'Bác sĩ chuyên khoa đầu ngành...', CAST(300000.00 AS Decimal(18, 2)), N'/img/doctor/doctor-male.png'),
(203, 203, 35, N'BS. CKII', 18, N'Bác sĩ chuyên khoa đầu ngành...', CAST(200000.00 AS Decimal(18, 2)), N'/img/doctor/doctor-male.png'),
(204, 204, 35, N'ThS. BS', 12, N'Bác sĩ chuyên khoa đầu ngành...', CAST(150000.00 AS Decimal(18, 2)), N'/img/doctor/doctor-female.png'),
(205, 205, 36, N'TS. BS', 18, N'Bác sĩ chuyên khoa đầu ngành...', CAST(200000.00 AS Decimal(18, 2)), N'/img/doctor/doctor-male.png'),
(206, 206, 36, N'ThS. BS', 12, N'Bác sĩ chuyên khoa đầu ngành...', CAST(150000.00 AS Decimal(18, 2)), N'/img/doctor/doctor-male.png'),
(207, 207, 36, N'BS. CKII', 18, N'Bác sĩ chuyên khoa đầu ngành...', CAST(200000.00 AS Decimal(18, 2)), N'/img/doctor/doctor-female.png'),
(208, 208, 36, N'BS. CKI', 12, N'Bác sĩ chuyên khoa đầu ngành...', CAST(150000.00 AS Decimal(18, 2)), N'/img/doctor/doctor-male.png'),
(209, 209, 37, N'BS. CKII', 18, N'Bác sĩ chuyên khoa đầu ngành...', CAST(200000.00 AS Decimal(18, 2)), N'/img/doctor/doctor-male.png'),
(210, 210, 37, N'TS. BS', 18, N'Bác sĩ chuyên khoa đầu ngành...', CAST(200000.00 AS Decimal(18, 2)), N'/img/doctor/doctor-male.png'),
(211, 211, 37, N'ThS. BS', 12, N'Bác sĩ chuyên khoa đầu ngành...', CAST(150000.00 AS Decimal(18, 2)), N'/img/doctor/doctor-female.png'),
(212, 212, 38, N'ThS. BS', 12, N'Bác sĩ chuyên khoa đầu ngành...', CAST(150000.00 AS Decimal(18, 2)), N'/img/doctor/doctor-female.png'),
(213, 213, 38, N'BS. CKII', 18, N'Bác sĩ chuyên khoa đầu ngành...', CAST(200000.00 AS Decimal(18, 2)), N'/img/doctor/doctor-male.png'),
(214, 214, 38, N'ThS. BS', 12, N'Bác sĩ chuyên khoa đầu ngành...', CAST(150000.00 AS Decimal(18, 2)), N'/img/doctor/doctor-female.png'),
(215, 215, 39, N'TS. BS', 18, N'Bác sĩ chuyên khoa đầu ngành...', CAST(200000.00 AS Decimal(18, 2)), N'/img/doctor/doctor-male.png'),
(216, 216, 39, N'ThS. BS', 12, N'Bác sĩ chuyên khoa đầu ngành...', CAST(150000.00 AS Decimal(18, 2)), N'/img/doctor/doctor-male.png'),
(217, 217, 39, N'BS. CKI', 12, N'Bác sĩ chuyên khoa đầu ngành...', CAST(150000.00 AS Decimal(18, 2)), N'/img/doctor/doctor-female.png'),
(218, 218, 40, N'BS. CKII', 18, N'Bác sĩ chuyên khoa đầu ngành...', CAST(200000.00 AS Decimal(18, 2)), N'/img/doctor/doctor-male.png'),
(219, 219, 40, N'TS. BS', 18, N'Bác sĩ chuyên khoa đầu ngành...', CAST(200000.00 AS Decimal(18, 2)), N'/img/doctor/doctor-male.png'),
(220, 220, 40, N'ThS. BS', 12, N'Bác sĩ chuyên khoa đầu ngành...', CAST(150000.00 AS Decimal(18, 2)), N'/img/doctor/doctor-female.png'),
(221, 221, 41, N'ThS. BS', 12, N'Bác sĩ chuyên khoa đầu ngành...', CAST(150000.00 AS Decimal(18, 2)), N'/img/doctor/doctor-male.png'),
(222, 222, 41, N'BS. CKII', 18, N'Bác sĩ chuyên khoa đầu ngành...', CAST(200000.00 AS Decimal(18, 2)), N'/img/doctor/doctor-male.png'),
(223, 223, 41, N'ThS. BS', 12, N'Bác sĩ chuyên khoa đầu ngành...', CAST(150000.00 AS Decimal(18, 2)), N'/img/doctor/doctor-female.png'),
(224, 224, 42, N'PGS. TS. BS', 25, N'Bác sĩ chuyên khoa đầu ngành...', CAST(300000.00 AS Decimal(18, 2)), N'/img/doctor/doctor-female.png'),
(225, 225, 42, N'BS. CKII', 18, N'Bác sĩ chuyên khoa đầu ngành...', CAST(200000.00 AS Decimal(18, 2)), N'/img/doctor/doctor-male.png'),
(226, 226, 42, N'ThS. BS', 12, N'Bác sĩ chuyên khoa đầu ngành...', CAST(150000.00 AS Decimal(18, 2)), N'/img/doctor/doctor-female.png'),
(227, 227, 43, N'DS. CKII', 12, N'Bác sĩ chuyên khoa đầu ngành...', CAST(150000.00 AS Decimal(18, 2)), N'/img/doctor/doctor-male.png'),
(228, 228, 43, N'ThS. DS', 12, N'Bác sĩ chuyên khoa đầu ngành...', CAST(150000.00 AS Decimal(18, 2)), N'/img/doctor/doctor-male.png'),
(229, 229, 43, N'DS. CKI', 12, N'Bác sĩ chuyên khoa đầu ngành...', CAST(150000.00 AS Decimal(18, 2)), N'/img/doctor/doctor-female.png'),
(230, 230, 44, N'TS. BS', 18, N'Bác sĩ chuyên khoa đầu ngành...', CAST(200000.00 AS Decimal(18, 2)), N'/img/doctor/doctor-male.png'),
(231, 231, 44, N'ThS. BS', 12, N'Bác sĩ chuyên khoa đầu ngành...', CAST(150000.00 AS Decimal(18, 2)), N'/img/doctor/doctor-female.png'),
(232, 232, 44, N'BS. CKI', 12, N'Bác sĩ chuyên khoa đầu ngành...', CAST(150000.00 AS Decimal(18, 2)), N'/img/doctor/doctor-male.png'),
(233, 233, 45, N'ThS. BS', 12, N'Bác sĩ chuyên khoa đầu ngành...', CAST(150000.00 AS Decimal(18, 2)), N'/img/doctor/doctor-female.png'),
(234, 234, 45, N'BS. CKII', 18, N'Bác sĩ chuyên khoa đầu ngành...', CAST(200000.00 AS Decimal(18, 2)), N'/img/doctor/doctor-male.png'),
(235, 235, 45, N'ThS. BS', 12, N'Bác sĩ chuyên khoa đầu ngành...', CAST(150000.00 AS Decimal(18, 2)), N'/img/doctor/doctor-female.png');
GO

SET IDENTITY_INSERT [dbo].[doctors] OFF;
GO

-- ==========================================================
-- 4. BẢNG PATIENTS
-- ==========================================================
SET IDENTITY_INSERT [dbo].[patients] ON;
GO

INSERT INTO [dbo].[patients] ([id], [user_id], [date_of_birth], [gender], [address], [health_insurance_code], [emergency_contact], [full_name], [phone], [relationship])
VALUES
-- Thông tin bệnh nhân
(1, 1, CAST(N'2002-03-18' AS Date), N'Nam', N'2/4 đường 46, phường Hiệp Bình Chánh, TP Thủ Đức', NULL, N'0834612340', N'TRẦN HOÀNG ANH KA', N'0812172593', N'OTHER'),
(2, 1, CAST(N'2001-02-02' AS Date), N'Nữ', N'19 đường Tam Bình, phường Hiệp Bình Chánh, TP Thủ Đức', NULL, N'0834612340', N'HOÀNG THỊ NA', N'0812172593', N'SISTER');
GO

SET IDENTITY_INSERT [dbo].[patients] OFF;
GO

UPDATE departments
SET base_price = 150000
WHERE base_price IS NULL;



