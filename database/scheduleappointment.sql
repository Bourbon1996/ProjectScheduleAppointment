create database scheduleappointment
use scheduleappointment

-- Bảng user 
CREATE TABLE users (
    id BIGINT IDENTITY(1,1) PRIMARY KEY,
    full_name NVARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(20) UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    role VARCHAR(20) NOT NULL, -- PATIENT, DOCTOR, STAFF, ADMIN
    status VARCHAR(20) NOT NULL DEFAULT 'ACTIVE',
    created_at DATETIME2 DEFAULT SYSDATETIME()
);

-- Bảng bệnh nhân
CREATE TABLE patients (
    id BIGINT IDENTITY(1,1) PRIMARY KEY,
    user_id BIGINT NOT NULL UNIQUE,
    date_of_birth DATE,
    gender VARCHAR(10),
    address NVARCHAR(255),
    health_insurance_code VARCHAR(50),
    emergency_contact VARCHAR(20),

    CONSTRAINT fk_patients_users
        FOREIGN KEY (user_id) REFERENCES users(id)
);

-- Bảng chuyên khoa
CREATE TABLE departments (
    id BIGINT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(100) NOT NULL,
    description NVARCHAR(500),
    status VARCHAR(20) DEFAULT 'ACTIVE'
);

-- Bảng bác sĩ
CREATE TABLE doctors (
    id BIGINT IDENTITY(1,1) PRIMARY KEY,
    user_id BIGINT NOT NULL UNIQUE,
    department_id BIGINT NOT NULL,
    title NVARCHAR(100),
    experience_years INT,
    description NVARCHAR(1000),

    CONSTRAINT fk_doctors_users
        FOREIGN KEY (user_id) REFERENCES users(id),

    CONSTRAINT fk_doctors_departments
        FOREIGN KEY (department_id) REFERENCES departments(id)
);

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
    status VARCHAR(30) NOT NULL DEFAULT 'PENDING',
    queue_number INT,
    created_at DATETIME2 DEFAULT SYSDATETIME(),

    CONSTRAINT fk_appointments_patients
        FOREIGN KEY (patient_id) REFERENCES patients(id),

    CONSTRAINT fk_appointments_doctors
        FOREIGN KEY (doctor_id) REFERENCES doctors(id),

    CONSTRAINT fk_appointments_departments
        FOREIGN KEY (department_id) REFERENCES departments(id),

    CONSTRAINT fk_appointments_slots
        FOREIGN KEY (slot_id) REFERENCES doctor_schedule_slots(id)
);

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



-- CHỈNH SỬA

-- Thêm cột parent_id ở bảng department

ALTER TABLE departments ALTER COLUMN parent_id BIGINT NULL;

ALTER TABLE departments
ADD CONSTRAINT FK_Department_Parent 
FOREIGN KEY (parent_id) REFERENCES departments(id);

ALTER TABLE departments ADD image_url VARCHAR(255) NULL;

INSERT INTO departments (name, parent_id) VALUES 
(N'Khoa Lâm Sàng', NULL),
(N'Khoa Cận Lâm Sàng', NULL),
(N'Khoa Hỗ Trợ Lâm Sàng', NULL);

INSERT INTO departments (name, parent_id, image_url) VALUES 
(N'Khoa Khám bệnh', 1, '/img/departments/khoa-kham-benh.jpg'),
(N'Khoa Khám sức khoẻ theo yêu cầu', 1, '/img/departments/khoa-kham-suc-khoe.jpg'),
(N'Khoa Cấp cứu', 1, '/img/departments/khoa-cap-cuu.jpg'),
(N'Khoa Hồi sức tích cực', 1, '/img/departments/khoa-hoi-suc-tich-cuc.jpg'),
(N'Khoa Nội cơ xương khớp', 1, '/img/departments/khoa-noi-co-xuong-khop.jpg'),
(N'Khoa Nội thận - Thận nhân tạo', 1, '/img/departments/khoa-noi-than.jpg'),
(N'Khoa Nội tiết', 1, '/img/departments/khoa-noi-tiet.jpg'),
(N'Khoa Nội tim mạch', 1, '/img/departments/khoa-noi-tim-mach.jpg'),
(N'Khoa Tim mạch can thiệp', 1, '/img/departments/khoa-tim-mach-can-thiep.jpg'),
(N'Khoa Phẫu thuật Tim mạch', 1, '/img/departments/khoa-phau-thuat-tim-mach.jpg'),
(N'Khoa Tiêu hóa', 1, '/img/departments/khoa-tieu-hoa.jpg'),
(N'Khoa Ngoại Tiêu hóa', 1, '/img/departments/khoa-ngoai-tieu-hoa.jpg'),
(N'Khoa Ngoại Gan - Mật - Tụy', 1, '/img/departments/khoa-ngoai-gan-mat-tuy.jpg'),
(N'Khoa Thần kinh', 1, '/img/departments/khoa-than-kinh.jpg'),
(N'Khoa Ngoại Thần kinh', 1, '/img/departments/khoa-ngoai-than-kinh.jpg'),
(N'Khoa Chấn thương chỉnh hình', 1, '/img/departments/khoa-chan-thuong-chinh-hinh.jpg'),
(N'Khoa Lồng ngực - Mạch máu', 1, '/img/departments/khoa-long-nguc-mach-mau.jpg'),
(N'Khoa Hô hấp', 1, '/img/departments/khoa-ho-hap.jpg'),
(N'Khoa Phụ sản', 1, '/img/departments/khoa-phu-san.jpg'),
(N'Khoa Tuyến vú', 1, '/img/departments/khoa-tuyen-vu.jpg'),
(N'Khoa Sơ sinh', 1, '/img/departments/khoa-so-sinh.jpg'),
(N'Khoa Tai Mũi Họng', 1, '/img/departments/khoa-tai-mui-hong.jpg'),
(N'Khoa Mắt', 1, '/img/departments/khoa-mat.jpg'),
(N'Khoa Phẫu thuật Hàm mặt - Răng Hàm Mặt', 1, '/img/departments/khoa-rang-ham-mat.jpg'),
(N'Khoa Tiết niệu', 1, '/img/departments/khoa-tiet-nieu.jpg'),
(N'Khoa Niệu học chức năng', 1, '/img/departments/khoa-nieu-hoc-chuc-nang.jpg'),
(N'Khoa Hậu môn - Trực tràng', 1, '/img/departments/khoa-hau-mon-truc-trang.jpg'),
(N'Khoa Lão - Chăm sóc giảm nhẹ', 1, '/img/departments/khoa-lao-khoa.jpg'),
(N'Khoa Da liễu - Thẩm mỹ da', 1, '/img/departments/khoa-da-lieu.jpg'),
(N'Khoa Tạo hình Thẩm mỹ', 1, '/img/departments/khoa-tao-hinh-tham-my.jpg'),
(N'Khoa Phục hồi chức năng', 1, '/img/departments/khoa-phuc-hoi-chuc-nang.jpg'),
(N'Khoa Gây mê - Hồi sức', 1, '/img/departments/khoa-gay-me-hoi-suc.jpg'),
(N'Khoa Hóa trị ung thư', 1, '/img/departments/khoa-hoa-tri-ung-thu.jpg');

-- 3. Đổ 6 khoa thuộc KHỐI CẬN LÂM SÀNG (parent_id = 2)
INSERT INTO departments (name, parent_id, image_url) VALUES 
(N'Khoa Chẩn đoán hình ảnh', 2, '/img/departments/khoa-chan-doan-hinh-anh.jpg'),
(N'Khoa Xét nghiệm', 2, '/img/departments/khoa-xet-nghiem.jpg'),
(N'Khoa Vi sinh', 2, '/img/departments/khoa-vi-sinh.jpg'),
(N'Khoa Giải phẫu bệnh', 2, '/img/departments/khoa-giai-phau-benh.jpg'),
(N'Khoa Nội soi', 2, '/img/departments/khoa-noi-soi.jpg'),
(N'Khoa Thăm dò chức năng', 2, '/img/departments/khoa-tham-do-chuc-nang.jpg');

-- 4. Đổ 4 khoa thuộc KHỐI DƯỢC & HỖ TRỢ (parent_id = 3)
INSERT INTO departments (name, parent_id, image_url) VALUES 
(N'Khoa Dược', 3, '/img/departments/khoa-duoc.jpg'),
(N'Khoa Dinh dưỡng - Tiết chế', 3, '/img/departments/khoa-dinh-duong.jpg'),
(N'Khoa Kiểm soát nhiễm khuẩn', 3, '/img/departments/khoa-kiem-soat-nhiem-khuan.jpg');