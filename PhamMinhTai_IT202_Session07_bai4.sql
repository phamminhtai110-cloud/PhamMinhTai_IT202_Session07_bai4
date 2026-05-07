-- =========================================
-- THẢM HỌA "BLACK FRIDAY"
-- NULL + NOT IN = SẬP TOÀN BỘ TRUY VẤN
-- =========================================


/*
================================================
1. KHÁM NGHIỆM TỬ THI (BOOLEAN LOGIC)
================================================

Query gốc:

SELECT *
FROM Courses
WHERE id NOT IN (
    SELECT course_id
    FROM Enrollments
);

------------------------------------------------
GIẢ SỬ SUBQUERY TRẢ VỀ:
------------------------------------------------

(1, 2, NULL)

Khi đó SQL sẽ hiểu thành:

id NOT IN (1, 2, NULL)

Tương đương logic:

id != 1
AND id != 2
AND id != NULL

------------------------------------------------
VẤN ĐỀ CHÍNH:
------------------------------------------------

Trong SQL:

x != NULL

KHÔNG BAO GIỜ trả về TRUE/FALSE.

Nó trả về:

UNKNOWN

------------------------------------------------
BOOLEAN LOGIC SQL
------------------------------------------------

TRUE AND TRUE AND UNKNOWN

=> KẾT QUẢ = UNKNOWN

Trong WHERE:
- Chỉ TRUE mới được giữ lại
- FALSE hoặc UNKNOWN đều bị loại

=> Toàn bộ dữ liệu biến mất.
=> Query trả về 0 dòng.
=> Marketing tưởng hệ thống không còn khóa học nào.
*/


-- =========================================
-- 2. GIẢI PHÁP KIẾN TRÚC
-- =========================================

/*
Phải loại NULL ngay trong Subquery.

Thêm:

WHERE course_id IS NOT NULL

để ngăn NULL phá hủy logic NOT IN.
*/


-- =========================================
-- 3. CÂU LỆNH SQL ĐÃ VÁ LỖI
-- =========================================

SELECT *
FROM Courses
WHERE id NOT IN (
    SELECT course_id
    FROM Enrollments
    WHERE course_id IS NOT NULL
);


-- =========================================
-- 4. GIẢI PHÁP AN TOÀN TUYỆT ĐỐI (KHUYẾN NGHỊ)
-- =========================================

/*
NOT EXISTS an toàn hơn NOT IN
vì:
- Không bị NULL phá logic
- Performance tốt hơn trên dữ liệu lớn
- Hỗ trợ short-circuit
*/

SELECT c.*
FROM Courses c
WHERE NOT EXISTS (
    SELECT 1
    FROM Enrollments e
    WHERE e.course_id = c.id
);


-- =========================================
-- 5. KẾT LUẬN TECH LEAD
-- =========================================

/*
Production thực tế:
- NOT IN + NULL = quả bom hẹn giờ
- Dữ liệu bẩn là chuyện chắc chắn xảy ra

Best Practice:
✅ Ưu tiên NOT EXISTS
✅ Hoặc lọc NULL trong subquery
✅ Không tin dữ liệu production luôn sạch
*/