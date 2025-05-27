-- 제약 조건이 없을때 추가하는 방법

-- not null 제약 조건 추가
alter table author modify column name varchar(255) not null;
-- not null 제약 조건 제거
alter table author modify column name varchar(255);
-- not null, unique 제약 조건 추가
alter table author modify column email varchar(255) not null unique;

-- 테이블 차원의 제약조건, pk, fk 추가 제거 방법
-- 제약조건 삭제(fk)
alter table 테이블명 drop foreign key 제약조건명; -- 제약조건명은 컬럼명이 아니라 조회해서 나온 값으로 해야함
alter table 테이블명 drop constraint 제약조건명;
-- 제약조건 삭제(pk)
alter table 테이블명 drop primary key;

-- 제약조건 추가
alter table 테이블명 add constraint 제약조건명 primary key(id); -- 제약조건명은 컬럼명이 아니라 조회해서 나온 값으로 해야함(추가할때는 post_pk 같이 임의로 작성해주면 됨)
alter table post add constraint post_fk foreign key(author_id) references author(id);

-- on delete/update 제약조건 테스트
-- 부모테이블 delete 시에 자식 fk 칼럼 set null, update시에 자식 fk칼럼 cascade
alter table post add constraint 제약조건명 foreign key(author_id) references author(id) on delete set null on update cascade;

-- default 옵션
-- enum 타입 및 현재시간(current_timestamp)에서 많이 사용
alter table author modify column name varchar(255) default 'anonymous';
-- auto_increment : 입력을 안했을때 마지막에 입력된 가장 큰 값에서 +1만큼 자동으로 증가된 값을 적용하겠다
alter table author modify column id bigint auto_increment;
alter table post modify column id bigint auto_increment;

-- uuid 타입
alter table post add column user_id char(36) default (uuid());