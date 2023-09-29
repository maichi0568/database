--1. (2 đ) Tạo các bảng trong cơ sở dữ liệu.
--Cần đảm bảo các ràng buộc trong cơ sở dữ liệu được thỏa mãn. satisfied.
CREATE TABLE book (
	book_id CHAR(10) NOT NULL,
	title CHAR(50) NOT NULL,
	publisher CHAR(20) NOT NULL,
	published_year integer,
	total_number_of_copies integer,
	current_number_of_copies integer,
	CONSTRAINT book_pk PRIMARY KEY (book_id),
	CONSTRAINT book_chk_publisher_year CHECK (published_year>1900),
	CONSTRAINT book_chk_totalcopy CHECK (total_number_of_copies>=0),
	CONSTRAINT book_chk_total CHECK (total_number_of_copies>=current_number_of_copies)
);

CREATE TABLE borrower (
  borrower_id CHAR(10) PRIMARY KEY,
  name CHAR(50) NOT NULL,
  address TEXT,
  telephone_number CHAR(12)
);

CREATE TABLE borrowcard (
  card_id SERIAL PRIMARY KEY,
  borrower_id CHAR(10) REFERENCES Borrower(borrower_id),
  borrow_date DATE NOT NULL,
  expected_return_date DATE NOT NULL,
  actual_return_date DATE
);

CREATE TABLE borrowcarditem (
  card_id INTEGER REFERENCES BorrowCard(card_id),
  book_id CHAR(10) REFERENCES Book(book_id),
  number_of_copies INTEGER,
  PRIMARY KEY (card_id, book_id)
);

--2. (1 đ) Liệt kê các cuốn sách xuất bản trong năm 2020
--bởi nhà xuất bản Wiley.
select book_id, title 
from book 
where publisher='Wiley'
	and published_year='2020';

--3. (1 đ) Liệt kê tổng số đầu sách trong thư viện cho
--từng nhà xuất bản (publisher, total)
select publisher, count(book_id) as total
from book
group by publisher

--4. (1 đ) Liệt kê top 5 cuốn sách (ID, title) “hottest”
--trong năm 2020 (top 5 cuốn sách được mượn
--nhiều nhất trong năm 2020)
select b.book_id as ID, title, total_number_of_copies - current_number_of_copies as left
from book b, borrowcard bc, borrowcarditem bi
where b.book_id=bi.book_id and bc.card_id=bi.card_id
	and date_part('year', borrow_date)='2020'
order by (total_number_of_copies - current_number_of_copies) desc
limit 5

--5. (1 đ) Liệt kê tất cả bạn đọc
--(id, name, telephone number, address) chưa trả sách.
select b.borrower_id, name, telephone_number, address
from borrower b, borrowcard bc
where b.borrower_id=bc.borrower_id
	and actual_return_date is null
	
--6. (1 đ) Liệt kê tất cả bạn đọc
--(id, name, telephone number, address) trả sách muộn,
--sắp xếp theo thứ tự alphabet của tên.
select b.borrower_id, name, telephone_number, address
from borrowcard bc join borrower b
on  b.borrower_id=bc.borrower_id
where actual_return_date>expected_return_date
union
select b.borrower_id, name, telephone_number, address
from borrowcard bc join borrower b
on  b.borrower_id=bc.borrower_id
where actual_return_date is null
	and current_date>expected_return_date
	
--7.(1 đ) Xóa những cuốn sách không có ai mượn
delete from book
where book_id not in (select book_id from borrowcarditem);
	
--8. (1 đ) Thêm 10 copies cho 5 cuốn sách được
--mượn nhiều nhất của nhà xuất bản Wiley
select b.book_id as ID, title, total_number_of_copies, total_number_of_copies+10 as new_total_number_of_copies
from book b, borrowcard bc, borrowcarditem bi
where b.book_id=bi.book_id and bc.card_id=bi.card_id
	and date_part('year', borrow_date)='2020'
order by (total_number_of_copies - current_number_of_copies) desc
limit 5

--9. (1 đ) Liệt kê các bạn đọc (id, name) mượn sách của
--cả nhà xuất bản Wiley và nhà xuất bản
--Addison-Wesley
select br.borrower_id, br.name
from borrowcarditem bi, book b, borrowcard bc, borrower br
where  b.book_id=bi.book_id
	and bc.card_id=bi.card_id
	and bc.borrower_id = br.borrower_id
	and publisher = 'Wiley' 
intersect
select br.borrower_id, br.name
from borrowcarditem bi, book b, borrowcard bc, borrower br
where  b.book_id=bi.book_id
	and bc.card_id=bi.card_id
	and bc.borrower_id = br.borrower_id
	and publisher = 'Addison-Wesley';

