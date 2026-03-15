# Git 커밋 대상 목록 및 설명

## 커밋 명령어

```bash
# 루트 파일
git add docker-compose.yml .env.example .gitignore DOCKER_GUIDE.md
git add 01_schma.sql 02_seed_data.sql mysql-init/

# 백엔드 전체 (각 서브 .gitignore가 build/, .gradle/ 등 자동 제외)
git add wts-backend/

# Python 전체 (서브 .gitignore가 __pycache__, .env, venv/ 자동 제외)
git add wts-python/

git commit -m "feat: Docker 통합 배포 환경 구성 (docker-compose up 단일 명령으로 전체 실행)"
```

---

## 반드시 커밋해야 하는 것

| 경로 | 이유 |
|------|------|
| `docker-compose.yml` | 핵심 — `docker-compose up` 진입점 |
| `.env.example` | 환경변수 템플릿 (시크릿 없는 버전) |
| `.gitignore` | `.env` 커밋 차단 |
| `DOCKER_GUIDE.md` | 채용담당자 실행 안내 |
| `01_schma.sql` | DB 스키마 자동 초기화 소스 |
| `02_seed_data.sql` | DB 시드 데이터 자동 초기화 소스 |
| `mysql-init/init.sh` | DB 초기화 스크립트 |
| `mysql-init/utf8mb4.cnf` | MySQL 한글 인코딩 설정 |
| `wts-backend/` | Spring Boot 소스 + 빌드된 프론트 정적파일 포함 |
| `wts-python/` | FastAPI 소스 |

---

## 커밋 불필요

| 경로 | 이유 |
|------|------|
| `wts-frontend/` | 빌드 결과물이 `wts-backend/src/main/resources/static/`에 이미 존재 |
| `[0312] 문의*.md` | 내부 작업 메모 |
| `.env` | 시크릿 포함 — `.gitignore`로 차단 |
| `wts-backend/build/` | 빌드 산출물 — Docker 내부에서 생성 |
| `wts-backend/.gradle/` | Gradle 캐시 |
| `wts-python/__pycache__/` | 컴파일 캐시 |
| `wts-python/logs/` | 런타임 로그 |

---

## `wts-frontend/`를 커밋하지 않아도 되는 이유

Vite 빌드 결과물(`index.html`, `assets/`)이 이미 `wts-backend/src/main/resources/static/`에
복사되어 있고, Spring Boot가 이를 정적 파일로 서빙합니다.

채용담당자는 `http://localhost:9789` 에서 UI까지 바로 확인 가능합니다.

> **프론트엔드 소스를 수정한 경우**:  
> `npm run build` 후 결과물을 `wts-backend/src/main/resources/static/`에 복사하고  
> 백엔드와 함께 커밋해야 합니다.
