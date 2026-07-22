use scheduleappointment

go
-- CHỈNH SỬA

-- Thêm cột parent_id ở bảng department

ALTER TABLE departments ADD parent_id BIGINT NULL;

go

ALTER TABLE departments
ADD CONSTRAINT FK_Department_Parent 
FOREIGN KEY (parent_id) REFERENCES departments(id);

go

ALTER TABLE departments ADD image_url VARCHAR(255) NULL;

go

INSERT INTO departments (name, parent_id) VALUES 
(N'Khoa Lâm Sàng', NULL),
(N'Khoa Cận Lâm Sàng', NULL),
(N'Khoa Hỗ Trợ Lâm Sàng', NULL);

go

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

go

-- 3. Đổ 6 khoa thuộc KHỐI CẬN LÂM SÀNG (parent_id = 2)
INSERT INTO departments (name, parent_id, image_url) VALUES 
(N'Khoa Chẩn đoán hình ảnh', 2, '/img/departments/khoa-chan-doan-hinh-anh.jpg'),
(N'Khoa Xét nghiệm', 2, '/img/departments/khoa-xet-nghiem.jpg'),
(N'Khoa Vi sinh', 2, '/img/departments/khoa-vi-sinh.jpg'),
(N'Khoa Giải phẫu bệnh', 2, '/img/departments/khoa-giai-phau-benh.jpg'),
(N'Khoa Nội soi', 2, '/img/departments/khoa-noi-soi.jpg'),
(N'Khoa Thăm dò chức năng', 2, '/img/departments/khoa-tham-do-chuc-nang.jpg');

go

-- 4. Đổ 4 khoa thuộc KHỐI DƯỢC & HỖ TRỢ (parent_id = 3)
INSERT INTO departments (name, parent_id, image_url) VALUES 
(N'Khoa Dược', 3, '/img/departments/khoa-duoc.jpg'),
(N'Khoa Dinh dưỡng - Tiết chế', 3, '/img/departments/khoa-dinh-duong.jpg'),
(N'Khoa Kiểm soát nhiễm khuẩn', 3, '/img/departments/khoa-kiem-soat-nhiem-khuan.jpg');

go