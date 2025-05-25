-- tinyint : -128 ~ 127까지 표현
-- author 테이블에 age컬럼 변경
alter table author modify age tinyint unsigned;


-- int : 4바이트

-- bigint : 8바이트
-- author, post테이블의 id값 bigint로 변경
alter table post modify id bigint;

-- author의 id는 post의 author_id의 외래키라서 변경 불가 / 외래키 관계를 해제하고 변경해야함
alter table post drop constraint post_ibfk_1; -- 외래키 해제
alter table post modify column author_id bigint;
alter table author modify column id bigint;
alter table post add constraint post_ibfk_1 foreign key(author_id) references author(id); -- 외래키 다시 설정

-- decimal(총자리수, 소수부자리수)
alter table post add column price decimal(10,3);
insert into post (id,title,price, author_id) values (7,'hello python',10.33412,3);

-- 문자 타입 : 고정길이(char), 가변길이(varchar, text)가 있음
alter table author add column genter char var(10);
alter table author add column self_introduction text;

-- blob(바이너리데이터) 타입 실습
-- 일반적으로 blob으로 저장하기 보다, varchar로 설계하고 이미지경로만을 저장함
alter table author add column profile_image longblob;
insert into author(id, email, profile_image) values (8, 'aaa@naver.com', LOAD_FILE('/Users/jjw/Pictures/ScreenShot.png')); -- 안 됨

-- enum : 삽입될 수 있는 데이터의 종류를 한정하는 데이터 타입
-- role 컬럼을 추가한다고 했을때
alter table author add column role enum ('admin', 'user') not null default 'user';

-- enum에 지정된 값이 아닌 경우 : 에러 발생
insert into author(id, email, role) values (11, 'dfadf@naver.com', 'admin2');
-- role을 지정 안한 경우 : default 값으로 들어감
insert into author(id, email) values (11, 'dfadf@naver.com');
-- enum에 지정된 값인 경우
insert into author(id, email, role) values (11, 'dfadf@naver.com', 'admin');

-- date와 datetime
-- 날짜 타입에 입력, 수정, 조회시에 문자열 형식을 사용 ('2025-05-23 14:36:30')
alter table author add column birthday date;
alter table post add column created_time datetime defualt current_timestamp();
insert into post (id, title, author_id, created_time) values (7,'hello',3,'2025-05-23 14:36:30');

-- 비교연산자
select * from author where id >= 2 and id <= 4;
select * from author where id between 2 and 4;

-- like : 특정 문자를 포함하는 데이터를 조회하기 위한 키워드
select * from post where title like 'h%';
select * from post where title not like 'h%';

-- regexp: 정규표현식을 활용한 조회
select * from post where title regexp '[a-Z]' -- 하나라도 알파벳 소문자가 들어있으면
select * from post where title regexp '[가-힣]' -- 하나라도 한글이 들어있으면

-- 날짜변환 : 숫자 -> 날짜
select cast(202050523 as date);

-- 날짜변환 : 문자 -> 날짜
select cast('20250523' as date);

-- 숫자변환 : 12 -> 숫자
select cast('12' as unsigned);

-- 날짜 조회 방법
-- like패턴, 부등호 활용, date_format
select * from post where created_time like '2025-05%'; -- 문자열처럼 조회

-- %Y%m%d
select * from post where date_format(created_time, '%m') = '05';
select * from post where cast(date_format(created_time, '%m') as unsigned) = 5;
select date_format(created_time, '%Y-%m-%d') from post;
select date_format(created_time, '%H:%i:%s') as '시간만' from post;
