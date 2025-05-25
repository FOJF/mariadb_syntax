-- insert : 테이블에 데이터 삽입
insert into 테이블명(칼럼1,칼럼2, 칼럼3) values (데이터1, 데이터2, 데이터3);
insert into author(id,name,email) values (2,'hong','hong@naver.com'); --문자열은 일반적으로 작은 따옴표 사용

-- update, set : 테이블에 데이터 변경
update 테이블명 set 변경할컬럼명=데이터, ... where row조건;
update author set name='홍길동', email='hong100@naver.com' where id=3;

-- select : 조회
select 칼럼1, 칼럼2, ... from 테이블명;
select name, email from author;
select * from author;

-- delete : 삭제
delete from 테이블명 where row조건;
delete from author where id=3;

-- 테스트 데이터 삽입
-- insert문을 활용해서 author데이터 3개, post데이터 5개
insert into author(id, name, email) values (3,'hong3','hong3@naver.com');
insert into author(id, name, email) values (4,'hong4','hong4@naver.com');
insert into author(id, name, email) values (5,'hong5','hong5@naver.com');

insert into post(id, title) values(2,'2');
insert into post(id, title) values(3,'3');
insert into post(id, title) values(4,'4');
insert into post(id, title) values(5,'5');
insert into post(id, title) values(6,'6');
 
-- select 조건절 활용해서 조회
select 칼럼1, ... from 테이블명 [where row조건]; -- 모든 칼럼을 조회하고 싶으면 *를 사용하기
-- where 조건에 and, or를 사용하여 조건 추가 가능
select * from author where id > 2 and name = 'hong4';

-- distinct: 중복제거 조회
select distinct name from author;

-- order by + 컬럼명: 정렬
-- asc : 오름차순1234, desc : 내림차순4321, 안 붙이면 오름차순(default)
-- 아무 조건이 없을 경우 pk 기준 오름차순
select * from author order by name;
select * from author order by name desc;

-- 멀티칼럼 order by : 여러컬럼으로 정렬시에, 먼저쓴 컬럼 우선적용. 중복시 그다음 정렬옵션 적용
select * from author order by name desc, email asc; --name으로 먼저 정렬 후 name이 중복되면 email로 정렬

--  결과갑 개수 제한
select * from author order by name desc limit 1;

-- 별칭(alias)를 이용한 select as 상략 가능
select name as '이름', email as '이메일'    from author;
select name, email, title, contents from author as a inner join as p;
-- 강의 녹화본 봐야할듯.. 졸아서 놓침


-- null을 조회조건으로 활용
select * from author whre password is null;
select * from author whre password is not null;