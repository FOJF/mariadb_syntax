-- 사용자 관리

-- 사용자 목록 조회
select * from mysql.user;

-- 사용자 생성
create user 'fojf'@'%' identified by '4321';  -- %는 원격접속을 가능하게 함을 의미한다

-- 사용자에게 권한부여
grant select on board.author to 'fojf'@'%'; -- select 권한만 부여
grant select, insert on board.* to 'fojf'@'%'; -- select, insert 권한 부여
grant all privileges on board.* to 'fojf'@'%'; -- 모든 권한 부여

-- 사용자에게 권한 회수
revoke select on board.author from 'fojf'@'%';

-- 사용자 권한 조회
show grants for 'fojf'@'%';

-- 사용자 계정 삭제
drop user 'fojf'@'%';