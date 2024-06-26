CREATE TABLE TBL_MEMBER
(
    MEMBER_ID          VARCHAR(50)  NOT NULL PRIMARY KEY,     # 회원 아이디
    MEMBER_PWD         VARCHAR(255) NOT NULL,                 # 회원 비밀번호
    NAME               VARCHAR(20)  NOT NULL,                 # 회원 이름
    EMAIL              VARCHAR(50)  NOT NULL,                 # 회원 이메일
    PHONE              VARCHAR(13)  NOT NULL,                 # 회원 전화번호
    LEVEL              VARCHAR(30) DEFAULT 'NEW',             # 회원 등급
    POINT              BIGINT      DEFAULT 0,                 # 회원 포인트
    AGREE_MARKETING_YN CHAR(1)     DEFAULT 'N',               # 마케팅 동의 여부
    ACC_INACTIVE_YN    CHAR(1)     DEFAULT 'N',               # 회원 탈퇴 여부
    TEMP_PWD_YN        CHAR(1)     DEFAULT 'N',               # 임시 비밀번호 여부
    ACC_LOGIN_COUNT    BIGINT      DEFAULT 0,                 # 로그인 횟수
    LOGIN_FAIL_COUNT   BIGINT      DEFAULT 0,                 # 로그인 실패 횟수
    LAST_LOGIN_DATE    DATETIME,                              # 마지막 로그인 날짜
    ACC_REGISTER_DATE  DATETIME    DEFAULT CURRENT_TIMESTAMP, # 회원 가입 날짜
    ACC_UPDATE_DATE    DATETIME,                              # 회원 정보 수정 날짜
    ACC_DELETE_DATE    DATETIME                               # 회원 탈퇴 날짜
);

CREATE TABLE TBL_ADDRESS
(
    MEMBER_ID  VARCHAR(20)  NOT NULL,             # 회원 아이디
    ADDRESS    VARCHAR(255) NOT NULL,             # 주소
    RECEIVER   VARCHAR(20)  NOT NULL,             # 받는 사람
    PHONE      VARCHAR(13)  NOT NULL,             # 전화번호
    REQUEST    VARCHAR(255),                      # 요청사항
    DEFAULT_YN CHAR(1)      NOT NULL DEFAULT 'N', # 기본 배송지 여부
    FOREIGN KEY (MEMBER_ID) REFERENCES TBL_MEMBER (MEMBER_ID)
);

CREATE TABLE TBL_PRODUCT
(
    PRODUCT_ID                VARCHAR(50)  NOT NULL PRIMARY KEY,   # 상품 아이디, 이미지 주소 공통 사용
    MEMBER_ID                 VARCHAR(255) NOT NULL,               # 판매자 아이디
    PRODUCT_NAME              VARCHAR(255) NOT NULL,               # 상품 이름
    PRODUCT_PRICE             INT          NOT NULL,               # 상품 가격
    PRODUCT_REGISTRATION_DATE DATETIME     NOT NULL DEFAULT NOW(), # 상품 등록 날짜
    PRODUCT_CHANGED_DATE      DATE,                                # 상품 수정 날짜
    PRODUCT_SALES_STATUS_YN   CHAR(1)      NOT NULL DEFAULT 'Y',   # 상품 판매 여부
    PRODUCT_DISCOUNT_RATE     INT          NOT NULL DEFAULT 0,     # 상품 할인율
    NUMBER_OF_PRODUCT         BIGINT       NOT NULL DEFAULT 0,     # 상품 수량
    PRODUCT_VIEWS             BIGINT       NOT NULL DEFAULT 0,     # 상품 조회수
    PRODUCT_CATEGORY          VARCHAR(50)  NOT NULL,               # 상품 카테고리
    FOREIGN KEY (MEMBER_ID) REFERENCES TBL_MEMBER (MEMBER_ID)
);

CREATE TABLE TBL_CART
(
    MEMBER_ID     VARCHAR(50) NOT NULL,  # 회원 아이디
    PRODUCT_ID    VARCHAR(50) NOT NULL,  # 상품 아이디
    CART_QUANTITY INT         NOT NULL,  # 상품 수량
    PRIMARY KEY (MEMBER_ID, PRODUCT_ID), # 복합키
    FOREIGN KEY (MEMBER_ID) REFERENCES TBL_MEMBER (MEMBER_ID),
    FOREIGN KEY (PRODUCT_ID) REFERENCES TBL_PRODUCT (PRODUCT_ID)
);

CREATE TABLE TBL_ROLE
(
    MEMBER_ID   VARCHAR(50) NOT NULL,                     # 회원 아이디
    AUTHORITIES VARCHAR(50) NOT NULL DEFAULT 'ROLE_USER', # 권한
    PRIMARY KEY (MEMBER_ID, AUTHORITIES),
    FOREIGN KEY (MEMBER_ID) REFERENCES TBL_MEMBER (MEMBER_ID)
);

CREATE TABLE TBL_ADVERTISEMENTS
(
    ADVERTISEMENT_ID         VARCHAR(50) PRIMARY KEY, -- 광고 아이디 (프라이머리 키)
    MEMBER_ID                VARCHAR(50) NOT NULL,    -- 광고주
    ADVERTISEMENT_START_DATE DATE        NOT NULL,    -- 광고 시작 날짜
    ADVERTISEMENT_END_DATE   DATE        NOT NULL,    -- 광고 종료 날짜
    ADVERTISEMENT_STATUS_YN  CHAR(1)     NOT NULL,    -- 광고 상태 여부 (Y/N)
    ADVERTISEMENT_SEQUENCE   INT         NOT NULL,    -- 광고 순서
    FOREIGN KEY (MEMBER_ID) REFERENCES TBL_MEMBER (MEMBER_ID)
);

CREATE TABLE TBL_OAUTH2_MEMBER
(
    MEMBER_ID VARCHAR(50) NOT NULL PRIMARY KEY,
    NAME      VARCHAR(50) NOT NULL,
    EMAIL     VARCHAR(50) NOT NULL
);

CREATE TABLE TBL_OAUTH2_ROLE
(
    MEMBER_ID   VARCHAR(50) NOT NULL,
    AUTHORITIES VARCHAR(50) NOT NULL,
    FOREIGN KEY (MEMBER_ID) REFERENCES TBL_OAUTH2_MEMBER (MEMBER_ID)
);

INSERT INTO TBL_MEMBER (MEMBER_ID, MEMBER_PWD, NAME, EMAIL, PHONE, LAST_LOGIN_DATE, ACC_REGISTER_DATE, ACC_UPDATE_DATE)
VALUES ('user', '$2a$10$HdOg00x3nTNCO06RwdeiA.dsWWJlWLHpx9jM8qVnQp35H3cxjDfCy', '유저', 'abc@example.com',
        '010-1234-5678', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
       ('admin', '$2a$10$HdOg00x3nTNCO06RwdeiA.dsWWJlWLHpx9jM8qVnQp35H3cxjDfCy', '어드민', 'def@example.com',
        '010-1234-5678', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

INSERT INTO TBL_ADDRESS (MEMBER_ID, ADDRESS, RECEIVER, PHONE, REQUEST, DEFAULT_YN)
VALUES ('user', '서울시 강남구 역삼동 123-456', '유저', '010-1234-5678', '문 앞에 놔주세요', 'Y'),
       ('admin', '서울시 강남구 역삼동 123-456', '어드민', '010-1234-5678', '문 앞에 놔주세요', 'Y');

INSERT INTO TBL_ROLE (MEMBER_ID, AUTHORITIES)
VALUES ('user', 'ROLE_USER'),
       ('admin', 'ROLE_USER'),
       ('admin', 'ROLE_ADMIN');

INSERT INTO TBL_PRODUCT (`PRODUCT_ID`, `MEMBER_ID`, `PRODUCT_NAME`, `PRODUCT_PRICE`, `PRODUCT_REGISTRATION_DATE`,
                         `PRODUCT_CHANGED_DATE`, `PRODUCT_SALES_STATUS_YN`, `PRODUCT_DISCOUNT_RATE`,
                         `NUMBER_OF_PRODUCT`, `PRODUCT_VIEWS`, `PRODUCT_CATEGORY`)
VALUES ('0ff3f590-f5b7-4521-86c7-6afbe7d4dec0', 'user', '가필드 카사바 모래 보라 굵은입자 4.55kg', 24900, '2024-06-10 00:59:41', NULL,
        'Y', 0, 50, 752, '고양이 모래'),
       ('2375e2b0-837e-4d43-b8a9-f13090cc7c38', 'user', '비타폴 카르마 핀치 새모이', 13900, '2024-06-10 01:15:10', NULL, 'Y', 5,
        1600, 42356, '조류 사료'),
       ('2daec62a-e6ce-4a1e-94cd-e26d0b70c880', 'user', '두부랑 캣츠 이코노미 오리지날 7L', 7000, '2024-06-10 01:00:58', NULL, 'Y',
        0, 30, 32667, '고양이 모래'),
       ('53c09767-7ae4-4b0e-b5ce-318557795d62', 'user', '뉴트리나 비스트로 4가지맛 캔 24개입', 26000, '2024-06-10 00:56:35', NULL,
        'Y', 18, 600, 3456, '고양이 간식'),
       ('53f5f9d8-c644-4718-89c7-78f1a448cf66', 'user', '빅사이즈 솔방울 새모이 피더', 65500, '2024-06-10 01:17:14', NULL, 'Y', 22,
        998, 3466, '조류 장난감'),
       ('553e2eb7-751c-4bd9-aafd-550a5429103e', 'user', '국내산 고추씨 500g 앵무새 영양간식', 5900, '2024-06-10 01:15:51', NULL, 'Y',
        10, 1574, 1233, '조류 간식'),
       ('55d75261-2c8f-4f2f-95e8-689b1e4e393c', 'user', '캐츠랑 전연령 20kg', 64000, '2024-06-10 00:49:34', NULL, 'Y', 18,
        200, 12774, '고양이 사료'),
       ('58ee090a-7401-43ea-98fa-4c8c119d5f7e', 'user', '앵무새 새장 횃대 스탠드 놀이터 나무 대형', 32700, '2024-06-10 01:16:36', NULL,
        'Y', 13, 298, 536, '조류 장난감'),
       ('775655e2-8ecd-458b-bb72-644024991032', 'user', '[소포장 1kg/5kg] 병아리사료', 2600, '2024-06-10 01:18:43', NULL, 'Y',
        0, 127, 34366, '조류 사료'),
       ('87bf1f0e-3d0c-4861-947a-ade64980120a', 'user', '하겐 도메스틱 버드베스 170g 앵무새 샴푸 진드게 제거 새용품 앵무새용품', 19500,
        '2024-06-10 01:21:38', NULL, 'Y', 4, 78, 43, '조류 미용'),
       ('87d5a8e7-7b32-4f40-ac79-9d884eeca0a9', 'user', '퓨리나 프리스키 파티믹스 오리지날 60g', 6000, '2024-06-10 00:54:57', NULL,
        'Y', 8, 2100, 9821, '고양이 간식'),
       ('8fa5755d-0c55-4e17-84b2-b45eb01e2608', 'user', '프로베스트 캣 블루 20kg', 62000, '2024-06-10 00:51:07', NULL, 'Y', 11,
        350, 23, '고양이 사료'),
       ('91812da7-65a9-4b14-afca-67a9355d4238', 'user', '이나바 챠오 츄르 참치 4개입, 4개 묶음', 12000, '2024-06-10 00:53:12', NULL,
        'Y', 5, 1400, 4556, '고양이 간식'),
       ('9d18fb59-e6dc-4bb1-b8b7-959ca523419d', 'user', '오리젠 오리지널 캣 5.4kg', 93000, '2024-06-10 01:05:54', NULL, 'Y', 0,
        5, 567, '고양이 사료'),
       ('9dbd81ad-a380-4848-bdc1-3d7ed3ad90b5', 'user', '스테인리스 대형새장 앵무세 케이지 날림장', 39900, '2024-06-10 01:17:51', NULL,
        'Y', 26, 12, 3454, '조류 새장'),
       ('9e62772a-ed6e-4502-84e2-6e032737bdc6', 'user', '트릭시 나무롤링 앵무새 장난감 천연 목재 장구방울', 3500, '2024-06-10 01:20:55',
        NULL, 'Y', 3, 988, 4367, '조류 장난감'),
       ('a17950cd-518c-4ecd-a3c8-73da170b42aa', 'user', '리오 영양 비스킷 깃털건강 5P 앵무새 간식 ', 4600, '2024-06-10 01:19:22', NULL,
        'Y', 0, 288, 567, '조류 간식'),
       ('ade83186-67ce-40ad-aff5-f08fcb504e15', 'user', '로얄캐닌 인도어 4kg 변냄새 감소', 72000, '2024-06-10 00:45:29', NULL, 'Y',
        25, 100, 1438, '고양이 사료'),
       ('bb0172da-83f7-4e78-a922-657f37bab888', 'user', '레토 박스형 화장실 65cm 특대형', 29900, '2024-06-10 01:04:04', NULL, 'Y',
        29, 90, 234, '고양이 화장실'),
       ('d3174dd0-12b0-4fcc-80fa-20d03f0577fa', 'user', '베트남 접시둥지(소) 앵무새 둥지', 2900, '2024-06-10 01:14:31', NULL, 'Y', 1,
        600, 416, '조류 새장'),
       ('d4f59e0e-f3d0-49c9-85aa-2ab11d88fe9f', 'user', '넥톤 S 330g 앵무새 비타민 영양제 면역력강화 편식예방 종합영양제', 91900,
        '2024-06-10 01:20:14', NULL, 'Y', 10, 88, 7, '조류 영양제'),
       ('ee53c40e-1ab5-4793-a7b9-e1b35e18dff3', 'user', '사각앵무새장 무지개은신처', 48900, '2024-06-10 01:13:49', NULL, 'Y', 5,
        500, 230, '조류 새장'),
       ('1f7832af-e587-495e-bf00-b14f9f3bf137', 'user', '주트립 조인트 컨트롤 시니어 (7세 이상) (관절 건강에 좋은 강아지 기능성 사료)', 30000,
        '2024-06-10 00:56:34', null, 'Y', 0, 5, 0, '강아지'),
       ('34913009-d6b8-4403-9e78-21e8eed07d34', 'user', '페츠베리머치 알러지 앤 티어스테인 케어 (연어) 사료 1kg', 39000,
        '2024-06-10 01:13:23', null, 'Y', 0, 5, 0, '강아지'),
       ('353f4573-9af6-4296-a297-506112f3680d', 'user', '프라임 밸런스 15kg 대용량 강아지사료 대형견 중형견 소형견 전연령 성견 뉴트리', 70000,
        '2024-06-10 01:10:15', null, 'Y', 0, 5, 0, '강아지'),
       ('41bc6a7a-bbea-4cbe-9001-a8fe0ba3daed', 'user', '지위픽 독 소고기 1kg', 20000, '2024-06-10 01:02:08', null, 'Y', 0, 5,
        0, '강아지'),
       ('800f0f28-1947-49bd-bb48-ccfaadaad760', 'user', '로얄캐닌 강아지사료 푸들 어덜트 3kg + 샘플2개', 60000, '2024-06-10 01:08:31',
        null, 'Y', 0, 5, 0, '강아지'),
       ('89f4597f-b459-4c1c-a2d5-e956ad083af7', 'user', '프라임 퍼포먼스 플러스 20kg 대형견 사료 대용량 강아지사료', 49999,
        '2024-06-10 01:11:12', null, 'Y', 0, 5, 0, '강아지'),
       ('a49e922f-3196-488c-93c6-635b6877413c', 'user', '시저 건사료 1kgx2개 골라담기+물티슈1팩', 10000, '2024-06-10 01:09:21', null,
        'Y', 0, 5, 0, '강아지'),
       ('ba48fb59-c0cd-40ec-98f2-ce6385ded8eb', 'user', '힐스 강아지사료 어덜트 라이트 스몰포 1.5kg', 50000, '2024-06-10 00:54:15',
        null, 'Y', 0, 5, 0, '강아지'),
       ('c5b2cf0a-07e9-4b78-a915-1456aca46a47', 'user', '프라임 퍼포먼스 20kg 대용량 강아지사료 대형견 큰개 특수견 진도 뉴트리나', 90000,
        '2024-06-10 01:12:08', null, 'Y', 0, 5, 0, '강아지'),
       ('fbe9f994-2a81-439d-9974-5f802fe10b98', 'user', '보노네이처 강아지 인도어(면역&체중) & 스킨앤코트(피부&모질)', 40000,
        '2024-06-10 01:07:12', null, 'Y', 0, 5, 0, '강아지');