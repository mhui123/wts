# WTS Docker 통합 실행 가이드

## 빠른 시작

```bash
# 1. 저장소 클론 (submodule 포함 — 권장)
git clone --recurse-submodules https://github.com/mhui123/wts.git
cd wts

# 또는 이미 clone한 경우 submodule 초기화
# git submodule update --init

# 2. (선택) Google OAuth2 / Kiwoom 키 설정
cp .env.example .env
# .env 파일을 열어 실제 키 값 입력 — 미설정 시 해당 기능만 비활성화됨

# 3. 전체 서비스 빌드 및 기동
docker-compose up -d --build

# 4. 로그 확인 (선택)
docker-compose logs -f
```

| 서비스 | URL |
|--------|-----|
| Spring Boot Backend | http://localhost:9789 |
| Python FastAPI | http://localhost:19789 |
| MySQL | localhost:3546 (root / `$MYSQL_ROOT_PASSWORD`, 기본값: `1234`) |
| Redis | localhost:6379 |

> **최초 빌드 시 소요 시간**: Gradle 의존성 다운로드(~2분) + Spring Boot 컴파일(~3분) 포함, 약 5–8분 예상  
> 재빌드 시 Docker 레이어 캐시로 1–2분 이내 완료

---

## 변경 사항 및 이유

### 1. `wts-backend/Dockerfile` — 멀티스테이지 빌드로 전환

**문제**: 기존 Dockerfile은 `COPY build/libs/*.jar app.jar` 로 **사전 컴파일된 JAR**을 기대함.  
채용담당자 환경에서는 JDK·Gradle 없이 `docker-compose up`만 실행하므로 JAR이 없어 빌드 실패.

**해결**: 2단계 멀티스테이지 빌드 적용

```
Stage 1 (builder): eclipse-temurin:17-jdk
  └─ gradlew dependencies  → 의존성 다운로드 (레이어 캐시)
  └─ gradlew bootJar -x test → JAR 생성

Stage 2 (runtime): eclipse-temurin:17-jre  ← JDK 대신 JRE로 이미지 경량화
  └─ JAR 복사 → ENTRYPOINT
```

**추가 효과**: `netcat-traditional`, `redis-tools` 제거 → 런타임 이미지 약 40MB 절감

---

### 2. `docker-compose.yml` (루트) — 전면 개선

#### 2-1. MySQL DB 자동 초기화
**문제**: 기존은 빈 DB로 시작. 스키마·시드 데이터를 수동으로 넣어야 했음.

**해결**: `docker-entrypoint-initdb.d` 메커니즘 활용
- MySQL 컨테이너 *최초* 기동 시 `/docker-entrypoint-initdb.d/` 내 `.sh`·`.sql` 파일을 자동 실행
- `mysql-init/init.sh` 를 통해 스키마(01_schma.sql) · 시드(02_seed_data.sql) 자동 적용

> `mysql-data` 볼륨이 이미 존재하면 initdb 스크립트는 **재실행되지 않음** (멱등성 보장)  
> 초기화를 다시 하려면: `docker-compose down -v` (볼륨 삭제 후 재기동)

#### 2-2. `01_schma.sql` 첫 줄 문제 처리
**문제**: `mysqldump` 실행 시 터미널에 출력된 `Enter password:` 문자열이  
SQL 파일 1번 줄에 포함되어 MySQL이 구문 오류로 초기화 실패.

**해결**: `mysql-init/init.sh` 에서 `tail -n +2`로 첫 줄을 건너뛰어 실행

#### 2-3. 헬스체크 & 기동 순서 보장
**문제**: 기존 `depends_on: [mysql, redis]`는 컨테이너 **시작**만 기다릴 뿐  
MySQL이 실제로 요청을 받을 준비가 됐는지 확인하지 않음 → 백엔드가 먼저 뜨면 DB 연결 실패.

**해결**: 각 서비스에 `healthcheck` + `depends_on.condition: service_healthy` 적용

```
mysql ready → redis ready → python started → backend 기동
```

#### 2-4. 백엔드 DataSource URL 수정
**문제**: `application-docker.yml`이 `host.docker.internal:3546`으로 하드코딩.  
Docker 네트워크 내에서는 서비스 이름으로 통신해야 함.

**해결**: 환경변수 오버라이드
```yaml
SPRING_DATASOURCE_URL: jdbc:mysql://mysql:3306/stockdb
```
Spring Boot는 환경변수를 `application.yml` 보다 우선 적용하므로 파일 수정 불필요.

#### 2-5. `.env` 파일 옵션 지원
```yaml
env_file:
  - path: ./.env
    required: false   # .env 없어도 기본값으로 실행
```
OAuth2·Kiwoom 키가 없어도 앱이 기동되고, 해당 기능만 사용 불가 상태로 표시됨.

---

### 3. `mysql-init/init.sh` — 신규 생성

DB 초기화 전용 shell script. docker-entrypoint-initdb.d에 마운트됨.

---

### 4. `.env.example` — 신규 생성

커밋 가능한 환경변수 템플릿. `cp .env.example .env` 후 실제 값 입력.  
실제 `.env` 파일은 `.gitignore` 에 의해 커밋 차단.

---

### 5. `.gitignore` (루트) — 신규 생성

`.env` 파일(시크릿 포함)이 실수로 커밋되는 것을 방지.

---

## 서비스별 독립 실행 (개발자용)

각 서비스의 개별 `docker-compose.yml`은 그대로 유지됨.  
개발 중에는 각 디렉토리에서 따로 기동 가능:

```bash
# 백엔드만
cd wts-backend && docker-compose up -d

# Python만
cd wts-python && docker-compose up -d
```

루트 `docker-compose.yml`은 **통합 배포(채용담당자 데모)**용으로 구분.

---

## 문제 해결

| 증상 | 원인 | 조치 |
|------|------|------|
| `wts-backend` Exit 1 | MySQL 준비 전 연결 시도 | `docker-compose logs mysql` 확인 후 `docker-compose restart backend` |
| DB가 비어 있음 | 볼륨이 이미 존재해 initdb 건너뜀 | `docker-compose down -v && docker-compose up -d --build` |
| 백엔드 빌드 오랜 시간 | 최초 Gradle 의존성 다운로드 중 | 정상 — 5–8분 대기 |
| OAuth2 로그인 안됨 | `.env`에 Google 키 미설정 | `.env.example` 참고 후 `.env` 작성 |
| 개별 compose 잔재로 네트워크 오류 | 이전 컨테이너가 네트워크 미연결 상태로 충돌 | 아래 클린 재시작 참고 |

### 클린 재시작 (개별 compose 잔재 충돌 시)

```bash
# 1. 루트 compose 컨테이너 전부 제거
docker-compose down --remove-orphans

# 2. 이전 개별 compose 잔재 강제 삭제
docker rm -f wts-python-app wts-backend-container wts-backend-redis mysql8
docker network rm wts-backend_wts-network wts-python_wts-network

# 3. 클린 재시작
docker-compose up -d --build
```
