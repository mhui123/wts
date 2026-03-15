#!/bin/bash
# =============================================================
# MySQL 초기화 스크립트
# - 01_schma.sql: 첫 줄("Enter password:") artifact 제거 후 실행
# - 02_seed_data.sql: 시드 데이터 삽입
# =============================================================
set -e

echo ">>> [mysql-init] 스키마 초기화 시작..."

# 01_schma.sql 첫 줄("Enter password: ")은 mysqldump 실행 시 생성된
# 터미널 출력 artifact 이므로 tail -n +2 로 건너뜀
tail -n +2 /tmp/sql/01_schma.sql | mysql --default-character-set=utf8mb4 -u root -p"${MYSQL_ROOT_PASSWORD}" "${MYSQL_DATABASE}"

echo ">>> [mysql-init] 스키마 초기화 완료. 시드 데이터 삽입 중..."

# --force: 에러 발생 시에도 다음 SQL 문으로 계속 진행 (배치 모드 기본값은 첫 에러에서 즉시 종료)
mysql --default-character-set=utf8mb4 --force -u root -p"${MYSQL_ROOT_PASSWORD}" "${MYSQL_DATABASE}" < /tmp/sql/02_seed_data.sql

echo ">>> [mysql-init] 초기화 완료!"
