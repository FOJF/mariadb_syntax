-- read uncommitted : commit되지 않은 데이터까지 read 가능 -> dirty read
-- 실습 절차
-- 1) 워크벤치에서 auto commit 해제 -> update -> commit 하지 않음(transaction1)
-- 2) 터미널을 열어 select 했을때 위 변경사항이 읽히는 지 확인(transaction2)
-- 결론 : mariadb는 기본이 repeatable read이므로 dirty read가 발생하지 않음

docker ps
docker exec -it 프로세스ID /bin/sh
mariadb -u root -p

-- read committed : commit한 데이터만 read 가능 -> phantom read 발생(또는 non-repeatable read 발생)

-- workbench에서 실행
start transaction;
select count(*) from author;
do sleep(15); -- 15초 슬립
select count(*) from author;
commit;

-- 터미널에서 실행
insert into author(email) values('sdfewradfc234@naver.com');

-- repeatable read : 읽기의 일관성 보장(phantom read 해결) -> lost update(ex. 1개 남아있는 재고에 두개의 트랜잭션이 동시에 구매를 처리해버리를 수 있는) 문제는 그대로 뱔생 -> 배타적 잠금으로 해결
-- lost update 문제 발생 시켜보기
-- workbench
DELIMITER //
create procedure concurrent_test1()
begin
    declare count int;
    start transaction;
    insert into post(title, author_id) values('hello_world_concurrent_test1', 1);
    select post_count into count from author where id=1;
    do sleep(15);
    update author set post_count=count+1 where id=1;
    commit;
end //
DELIMITER ;
-- 터미널
select post_count from author where id=1;

-- lost update 문제 해결 시켜보기 : select for update시 트랜잭션이 종료 후에 특정 행에 대한 lock 풀림
-- workbench
DELIMITER //
create procedure concurrent_test2()
begin
    declare count int;
    start transaction;
    insert into post(title, author_id) values('hello_world_concurrent_test2', 1);
    select post_count into count from author where id=1 for update;
    do sleep(15);
    update author set post_count=count+1 where id=1;
    commit;
end //
DELIMITER ;
-- 터미널
select post_count from author where id=1 for update;
-- serializable : 모든 트랜젝션 순차적 실행 -> 동시성 문제 없으나 너무 엄격해서 성능이 매우 저하됨
