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
    user_id BIGINT NOT NULL UNIQUE,
    date_of_birth DATE,
    gender VARCHAR(10),
    [address] NVARCHAR(255),
    health_insurance_code VARCHAR(50),
    emergency_contact VARCHAR(20),
    full_name [nvarchar](100) NOT NULL DEFAULT (N'Chưa cập nhật'),
    phone [varchar](20) NULL,
    relationship [varchar](50) NULL

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



