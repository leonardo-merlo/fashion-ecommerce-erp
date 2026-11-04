#!/usr/bin/env bash
# Monta um banco descartável com todas as migrations + o seed e roda os testes
# SQL de supabase/tests/*.test.sql.
#
# Precisa de um Postgres acessível pelas variáveis padrão do psql (PGHOST,
# PGPORT, PGUSER, PGPASSWORD) com um usuário que possa criar banco e papéis.
# Não toca em nenhum projeto Supabase.
set -euo pipefail

cd "$(dirname "$0")/.."
DB="${TEST_DB_NAME:-fashion_erp_test}"
export PGCLIENTENCODING=UTF8
# Esconde os avisos esperados das migrations (DROP ... IF EXISTS etc.).
export PGOPTIONS="-c client_min_messages=warning"

run_file() {
  psql -X -q -v ON_ERROR_STOP=1 -d "$DB" -f "$1" > /dev/null
}

psql -X -q -d postgres -c "DROP DATABASE IF EXISTS $DB" -c "CREATE DATABASE $DB" > /dev/null

run_file supabase/tests/supabase-stubs.sql
for migration in supabase/migrations/*.sql; do
  run_file "$migration"
done
echo "migrations: $(ls supabase/migrations/*.sql | wc -l | tr -d ' ') aplicadas"

run_file supabase/seed.sql
echo "seed: aplicado"

passed=0
for test_file in supabase/tests/*.test.sql; do
  echo "== $test_file"
  # Cada teste avisa "ok  ..." por RAISE NOTICE; o prefixo do aviso muda com o
  # idioma do servidor, então o filtro casa só a mensagem.
  output=$(PGOPTIONS="-c client_min_messages=notice" psql -X -q -v ON_ERROR_STOP=1 -d "$DB" -f "$test_file" 2>&1) || {
    echo "$output"
    exit 1
  }
  echo "$output" | sed -nE 's/.*:  (ok  .*)/  \1/p'
  passed=$((passed + $(echo "$output" | grep -c ':  ok  ')))
done
echo "$passed testes passaram"
