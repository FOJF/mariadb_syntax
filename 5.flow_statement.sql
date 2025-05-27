-- 흐름제어 : case when, if, ifnull
-- if(a,b,c) : a조건이 참이면 b, 아니면 c
select id, if(name is null, '익명사용자', name) from author;

-- ifnull(a,b) : a가 null이면 b, 아니면 그대로 a
select id, ifnull(name, '익명사용자') from author;
select id,
case 
    when name is null then '익명사용자' 
    when name='hong5' then '홍길동' 
    else name
end as name
from author;

-- 경기도에 위치한 식품창고 목록 출력하기
-- 조건에 부합하는 중고거래 상태 조회하기
-- 12세 이하인 여자 환자 목록 출력하기