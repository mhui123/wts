# WTS (Wealth Tracking System)

개인 투자 포트폴리오를 분석하기 위한 웹 애플리케이션입니다.

증권사제공 거래내역을 바탕으로
- 포트폴리오 현황파악
- 현금흐름 추적
을 제공하여 투자 관리를 목적으로 한 시스템입니다.

Tech Stack
- Backend : Spring Boot, JPA, MySQL
- Frontend : React + TypeScript + Vite
- Python : python, FastAPI, Redis, Websocket
---

## 빠른 시작

```bash
# 1. 저장소 클론 (submodule 포함 — 권장)
git clone --recurse-submodules https://github.com/mhui123/wts.git
cd wts

# 2. 이력서에 동봉된 .env파일을 동일 디렉토리에 위치시켜 주세요. (환경변수파일 압축 해제)
# - 구글 Oauth 키값은 비포함

# 3. 전체 서비스 빌드 및 기동
docker-compose up -d --build

# 4. 로그 확인 (선택)
docker-compose logs -f
```
| 서비스 | URL |
|--------|-----|
| Spring Boot Backend | http://localhost:9789 |

```
 게스트모드로 로그인하여 기능을 확인해보실 수 있습니다.
```

## 구조
```
WTS
├── wts-frontend (React + TypeScript + Vite )
├── wts-backend ( Spring Boot, JPA )
└── wts-python ( yfinance, FinanceDataReader 등 데이터 처리)
```

wts-front : Front end
- 투자원금 현황 파악
- 월별 현금흐름 시각화
- 보유 종목 비중 시각화
- 실현손익, 배당수익 현황 파악

Python
- 배당 데이터 수집
- 거래내역 파싱 (pdf, csv)
- 주가데이터, 기술적지표 조회 및 데이터처리 (yfinance, FinanceDataReader)
- 실시간 주가 데이터 구독 및 발행 (kiwoom REST api, REDIS)

Spring Boot
- 대시보드 / 포트폴리오 데이터 : 
    - 거래내역 기반 포트폴리오 집계
    - 월별 현금흐름 집계
- 키움 API 연동 (현재 관심종목과 실시간 가격데이터 구독)
- 스케줄러 작업
- 인증 / 사용자 관리
    - Google OAuth 간편 로그인
    - 이메일 / 비밀번호 로그인
    - 게스트모드
    - jwt 활용

## What I learned

이 프로젝트를 통해

- 금융 데이터 모델링
- 다중 통화(KRW/USD) 처리
- 배당 데이터 수집 및 분석
- 클린 아키텍처 설계

를 경험해볼 수 있었으며 문제를 어떻게 정의하느냐에 따라 생산성의 차이를 경험해볼 수 있었습니다.