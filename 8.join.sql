-- inner join
-- 두 테이블사이에 지정된 조건에 맞는 레코드만을 반환. on 조건을 통해 교집합 찾기.
-- 즉, post 테이블에 글쓴 적 있는 author와 글쓴이가 author에 있는 post를 결합하여 출력
select * from author inner join post on author.id=post.author_id;
select * from author a inner join post p on a.id=p.author_id;
-- 출력순서만 달라질뿐 위 쿼리와 아래쿼리는 동일
select * from post p inner join author a on a.id=p.author_id;
-- 만약 같게 하고 싶다면
select a.*,p.* from post p inner join author a on a.id=p.author_id;

-- 글 쓴이가 있는 글 전체 정보와 글쓴이의 이메일만 출력하시오.
select * from post p inner join author a on a.id=p.author_id;
-- 글쓴이가 있는 글의 제목, 내용, 그리고 글쓴이의 이름만 출력하시오.
select p.title, p.content, a.name from post p inner join author a on a.id=p.author_id;

-- A left join B : A테이블의 데이터는 모두 조회하고, 관련있는(ON조건) B데이터도 출력
-- 글쓴이는 모두 출력하되, 글을 쓴적 있다면 관련글도 모두 출력
select * from author a left join post p on a.id=p.author_id;

-- 모든 글 목록을 출력하고, 만약 저자가 있다면 이메일 정보 출력
select p.*, a.email from post p left join author a on a.id=p.author_id;

-- 모든 글 목록을 출력하고, 관련된 저자 정보 출력.(author_id가 not null인 경우)
select * from post p left join author a on a.id=p.author_id;
select * from post p inner join author a on a.id=p.author_id;

-- 실습) 글쓴이가 있는 글 중에서 글의 title과 저자의 email을 출력하되, 저자의 나이가 30세 이상인글만 출력
select p.title, a.email from post p left join author a on a.id=p.author_id where a.age>=30;

-- 전체 글 목록을 조회하되, 글의 저자에 이름이 비어져있지 않은 글 목록만을 출력.
select p.*, a.name from post p inner join author a on a.id=p.author_id where a.name is not null;

-- 조건에 맞는 도서와 저자 리스트 출력

-- 없어진 기록 찾기

-- union : 두 테이블의 select 결과를 횡의로 결합(기본적으로 distinct 적용)
-- union 시킬때 컬럼의 개수와 컬럼의 타입이 같아야 함(타입이 같아야하는 부분 까먹지 말고 사용해야함)
select email, name from author union select title, content from post; -- 올바른 예제는 아니지만 현재 가지고 있는 테이블들로 그냥 테스트

-- union all : 중복까지 모두 포함
select email, name from author union all select title, content from post;

-- 서브쿼리 : select 문 안에 또 다른 select문을 서브 쿼리라고 한다.
-- where 절 안에 서브쿼리
-- 한번이라도 글을 쓴 author 목록 조회
select distinct a.* from author a inner join post p on a.id=p.author_id;
-- null값은 in 조건절에서 자동으로 제외
select * from author where id in (select author_id from post);

-- 컬럼위치에 서브쿼리
-- author의 email과 author 별로 본인의 쓴 글의 개수를 출력
select email, (select count(*) from post p where a.id=p.author_id) post_count from author a;

-- from 절 안에 서브쿼리
select a.* from (select * from author where id>5) as a;

-- group by 컬럼명 : 특정 컬럼으로 데이터를 그룹화 하여, 하나의 행(row)처럼 취급
select author_id from post group by author_id;
-- 보통 아래와 같이 집계함수와 같이 많이 사용한다.
select author_id, count(*) from post group by author_id; -- 그룹화한 것에 대한 count

-- 집계함수
-- null은 카운트에서 제외
select count(*) from author;
select sum(price) from post;
select avg(price) from post;
-- max, min도 있음
select round(avg(price), 1) from post; --round(값, 표시할 반올림한 소숫점 아래 n 자리), n이 1이면 소숫점 아래 1자리까지 표시

-- group by 와 집계함수
select author_id, count(price), sum(price) from post group by author_id;


-- 연도별 post 글의 개수
-- where와 group by 출력(날짜 값이 null은 제외)
select date_format(created_time, '%Y') as year, count(*) from post where created_time is not null group by year;

-- 자동차 종류 별 특정 옶션이 포함된 자동차 수 구하기
-- 입양 시각 구하기(1)

-- group by와 having
-- having은 group by를 통해 나온 집계값에 대한 조건
-- 글을 2번 이상쓴 사람 ID 찾기
select author_id from post group by author_id having count(*) >= 2;

-- 동명 동물 수 찾기
-- 카테고리 별 도서 판매량 집계하기
-- 조건에 맞는 사용자와 총 거래금액 조회하기

-- 다중열 group by 
-- group by 첫번째, 두번째 컬럼 : 첫번째 컬럼으로 먼저 그룹화 하고 두번째 컬럼으로 그룹화
select author_id, title, count(*) from post group by author_id, title;
-- 재구매가 일어난 상품과 회원 리스트 구하기