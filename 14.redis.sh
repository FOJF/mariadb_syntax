# 도커 설치(windows에서는 기본적으로 설치가 안되서 docker에다 설치)
docker run --name redis-container -d -p 6379:6379 redis

# redis 접속
redis-cli

# docker redis 접속 명령어
docker exec -it 컨테이너id redis-cli

# redis는 0 ~ 15번까지의 db로 구성 (default는 0번 db)
# db번호 선택
select db번호

# db내의 모든 키 조회
keys *

# 가장 일반적인 String 자료 구조

# set을 통해 key:value 세팅 (이미 존재하는 키에 다시 set 하면 덮어쓰기 됨)
set user:email:1 hong1@naver.com
set user1 hong1@naver.com

# 키가 존재 하지 않는 경우에만 set을 하고 싶을 경우 : nx 옵션을 추가
set user:email:1 hong1@naver.com nx

# 만료시간(TTL : TIME TO LIVE) 설정(초단위) : ex 원하는시간초 옵션을 추가
set user:email:5 hong5@naver.com ex 10
# TTL 실전활용법 : token등 사용자 인증정보 저장
set user:1:refresh_token abcdefg1234 ex 10

# key를 통해 value get
get user:email:1
get user1

# 특정 key 삭제
del user:email:1
del user1

# 현재 DB내 모든 key값 삭제
flushdb

# redis 실전 활용 : 좋아요 기능 구현 -> 동시성 이슈 해결
set likes:posting:1 0 # redis는 기본적으로 모든 key:value가 문자열. 내부적으로는 "0"으로 저장
incr likes:posting:1 # 특정 key값의 value를 1만큼 증가
decr likes:posting:1 # 특정 key값의 value를 1만큼 감소

# redis 실전활용 : 재고관리 구현 -> 동시성 이슈 해결
set stocks:product:1 100
decr stocks:product:1
incr stocks:product:1

# 캐싱 기능 구현 : 캐싱 기능 구현
# 1번 회원 정보 조회 : select name, email, age from member where id=1;
# 위 데이터의 결과값을 spring 서버를 통해 json으로 변형하여, redis에 캐싱
# 최종적인 데이터 형식 : {"name":"hong", "email":"hong@daum.net", "age":30}
set member:info:1 "{\"name\":\"hong\", \"email\":\"hong@daum.net\", \"age\":30}" ex 1000

# list 자료구조
# redis의 list는 deque와 같은 자료구조. 즉 double-ended queue 구조  
# lpush : 데이터를 list 자료구조에 왼쪽부터 삽입
# lpush : 데이터를 list 자료구조에 오른쪽부터 삽입
lpush hongs hong1
lpush hongs hong2
rpush hongs hong3

# list 조회 :  0은 리스트의 시작인덱스를 의미. -1은 리스트의 마지막인덱스를 의미
lrange hongs 0 -1 # 전체조회
lrange hongs -1 -1 # 마지막 값 조회
lrange hongs 0 0 # 첫번째 값 조회
lrange hongs -2 -1 # 마지막 2번째부터 마지막 까지
lrange hongs 0 2 # 처음부터 3번째 까지(0번부터 2번까지)

# list 값 꺼내기. 꺼내면서 삭제
rpop hongs
lpop hongs
rpoplpush hongs #오른쪽에서 뺴서 왼쪽에 넣음

# list의 데이터 개수 조회
llen hongs

# ttl 적용
expire hongs 20

# ttl 조회
ttl hongs

# redis 실전활용 : 최근 조회한 상품 목록
rpush user:1:recent:product apple
rpush user:1:recent:product banana
rpush user:1:recent:product orange
rpush user:1:recent:product melon
rpush user:1:recent:product mango

# 최근 본 상품 3개 조회
lrange user:1:recent:product -3 -1

# set 자료구조 : 중복없음, 순서 없음
sadd memberlist m1
sadd memberlist m2
sadd memberlist m3

# set 조회
smembers memberlist

# set 맴버 개수 조회
scard memberlist

# 특정멤버가 set안에 있는지 존재 여부
sismember memberlist m2

# redis 실전활용 : 좋아요 구현
# 게시글상세보기에 들어가면
scard posting:likes:1
sismember posting:likes:1 a1@naver.com
# 게시글에 좋아요를 하면
sadd posting;likes:1 a1@naver.com
# 좋아요한 사람을 클릭하면
smembers posting:likes:1

# zset : sorted set
# zset을 활용해서 최근시간순으로 정렬가능
zadd user:1:recent:product 091330 mango
zadd user:1:recent:product 091331 apple
zadd user:1:recent:product 091332 banana
zadd user:1:recent:product 091333 orange
zadd user:1:recent:product 091327 apple

# zset 조회 : zrange(score 기준 오름차순), zrevrange(내림차순)
zrange user:1:recent:product 0 2