-- view : 실제데이터를 참조만 하는 가상의 테이블. SELECT 만 가능
-- 사용목적 : 1) 복잡한 쿼리를 사전 생성 
--          2) 권한 분리

-- view 생성
create view author_for_view as
select name, email from author;

-- view 조회
select * from author_for_view;

-- view의 권한 부여(그냥 권한 부여하는 것이랑 똑같음)
grant select on board.author_for_view to '게정명'@'%';
grant select on board.author_for_view to '게정명'@'localhost';

-- view 삭제
drop view author_for_view;

-- 프로시저 생성
DELIMITER //
create procedure hello_procedure()
begin
    select "hello world";
end
// DELIMITER ;

-- 프로시저 호출
call hello_procedure();

-- 프로시저 삭제
drop procedure hello_procedure;

-- 회원 목록 조회 (한글 프로시저명 가능)
DELIMITER //
create procedure 회원목록조회()
begin
    select * from author;
end
// DELIMITER ;

-- 회원 상세 조회 (Input값 사용 가능), 사용할 타입과 인풋의 타입이 같아야하는데 varchar의 길이는 문제가 되지 않는다
DELIMITER //
create procedure 회원상세조회(in emailInput varchar(255))
begin
    select * from author where email = emailInput;
end
// DELIMITER ;

-- 글쓰기
DELIMITER //
create procedure 글쓰기(in emailInput varchar(255), in titleInput varchar(255), in contentsInput varchar(255))
begin
    -- declare는 첫 begin 바로 다음에 위치
    declare postIdInput bigint;
    declare authorIdInput bigint;
    declare exit handler for SQLEXCEPTION
    begin
        rollback;
    end;
    start transaction;
        insert into post(title, contents) values(titleInput, contentsInput);
        select id into authorIdInput from author where email=emailInput;
        select id into postIdInput from post order by id desc limit 1;
        insert into author_post(author_id, post_id) values(authorIdInput, postIdInput);
    commit;
end
// DELIMITER ;

-- 글 삭제
DELIMITER //
create procedure 글삭제(in postIdInput bigint, in emailInput varchar(255))
begin
    -- 글쓴이가 나밖에 없으면 : author_post에서 삭제, post에서 삭제
    -- 이외에 누군가가 더 있으면 : author_post에서만 삭제
    declare authorPostCount bigint;
    declare authorId bigint;
    select count(*) into authorPostCount from author_post where post_id=postIdInput;
    select id into authorId from author where email=emailInput;
    
    delete from author_post where post_id=postIdInput and author_id=authorId;
    
    if authorPostCount=1 then -- 글쓴이가 나 밖에 없는 경우
        delete from post where id=postIdInput;
    end if;
end
// DELIMITER ;

-- 반복문을 통한 글 대량생성
DELIMITER //
create procedure 대량글쓰기(in emailInput varchar(255), in countInput bigint)
begin
    -- declare는 첫 begin 바로 다음에 위치
    declare postIdInput bigint;
    declare authorIdInput bigint;
    declare i bigint default 0;
    declare exit handler for SQLEXCEPTION
    begin
        rollback;
    end;
    while i < countInput do
        start transaction;
            insert into post(title) values('안녕하세요 도배글');

            select id into authorIdInput from author where email=emailInput;
            select id into postIdInput from post order by id desc limit 1;
            insert into author_post(author_id, post_id) values(authorIdInput, postIdInput);
        commit;
        set i = i + 1;
    end while;
end
// DELIMITER ;