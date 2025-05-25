-- 마리아 DB 서버에 접속
mariadb -u root -p -- 입력 후 비밀번호 별도 입력

-- 스키마(database) 생성
create database 스키마명;

-- 스키마 삭제
drop database 스키마명;

-- 스키마 목록 조회
show databases;

-- 스키마 선택;
use 스키마명;

-- 문자인코딩 변경
alter database board default character set = utf8mb4;

-- 캐릭터 셋 조회
show variables like 'character_set_server';

-- 테이블 생성
create table 테이블명(컬럼1 타입, 컬럼2 타입, 컬럼3 타입 , ...)
create table author(id int primary key, name varchar(255), email varchar(255), password varchar(255));

-- 테이블 목록 조회
show tables;

-- 테이블 컬럼 정보 조회
describe author;

-- 테이블 생성 명령문 조회
show create table author;

-- post 테이블 신규 생성(id, title, contents, author_id)
create table posts (
    id int,
    title varchar(255),
    contents varchar(255),
    author_id int,
    primary key(id),
    foreign key(author_id) references author(id)
);

-- 테이블 제약조건 조회
select * from information_schema.key_column_usage where table_name='테이블명';

-- 테이블 인덱스 조회
show index from 테이블명;

-- alter : 테이블의 구조 변경
-- 테이블의 이름 변경
alter table 테이블명 rename 변경할이름;
-- 테이블의 컬럼 추가
alter table 테이블명 add column 추가할컬럼명 타입 [제약조건];
-- 테이블의 컬럼 삭제
alter table 테이블명 drop column 삭제할컬럼명;
-- 테이블의 컬럼명 변경
alter table 테이블명 change column 변경해야할컬럼명 변경할컬럼명 타입;
-- 테이블 컬럼의 타입과 제약조건 변경 => 덮어쓰기
alter table 테이블명 modify column 컬럼명 타입 [제약조건];

-- author 테이블에 address칼럼을 추가 (varchar 255)
alter table author add column address varchar(255);
-- post 테이블에 title은 not null로 변경, content는 길이 3000자로 변경
alter table post modify column title varchar(255) not null;
alter table post modify column content varchar(3000);

alter table post modify column title varchar(255) not null, modify column content varchar(3000);

-- drop : 테이블 삭제
drop table 삭제할테이블; -- 존재하지 않으면 에러가 발생해서 아래의 방법을 더 많이 사용(쉘프로그래밍 하듯이 여러 쿼리를 실행시킬때 에러가 발생하지 않도록)
drop table if exists 삭제할테이블명; -- 존재하면 삭제
