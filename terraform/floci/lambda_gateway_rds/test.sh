#!/bin/bash
set -e

FUNCTION="alunos-api"
FLOCI="http://localhost:4566"
INVOKE="$FLOCI/2015-03-31/functions/$FUNCTION/invocations"

# Monta um evento HTTP API Gateway v2 e invoca a Lambda diretamente
invoke() {
  local method=$1
  local path=$2
  local start end ms payload

  start=$(date +%s%N)
  payload=$(curl -sf -X POST "$INVOKE" \
    -H "Content-Type: application/json" \
    -d "{
      \"version\": \"2.0\",
      \"rawPath\": \"$path\",
      \"rawQueryString\": \"\",
      \"headers\": {\"content-type\": \"application/json\"},
      \"requestContext\": {
        \"http\": { \"method\": \"$method\", \"path\": \"$path\" },
        \"stage\": \"\$default\"
      },
      \"isBase64Encoded\": false
    }" 2>&1)
  end=$(date +%s%N)
  ms=$(( (end - start) / 1000000 ))

  local status body
  status=$(echo "$payload" | python3 -c "import sys,json; print(json.load(sys.stdin).get('statusCode','?'))" 2>/dev/null || echo "?")
  body=$(echo "$payload"   | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('body',''))" 2>/dev/null || echo "$payload")

  echo "  HTTP $status | ${ms}ms"
  echo "$body" | python3 -m json.tool 2>/dev/null || echo "  $body"
}

echo "======================================"
echo "  Teste Serverless — Floci Lambda"
echo "  Funcao: $FUNCTION"
echo "======================================"

# ── Monitorar eventos Docker ───────────────────────────────────────────────
TMP=$(mktemp)
docker events \
  --filter "event=start" \
  --filter "event=die" \
  --format "  [docker] {{.Action}} → {{.Actor.Attributes.name}}" \
  >> "$TMP" 2>&1 &
DOCKER_PID=$!
trap "kill $DOCKER_PID 2>/dev/null; rm -f $TMP" EXIT

echo ""
echo "── Containers antes da invocacao ──"
docker ps --format "  {{.Names}}" | grep -v "^$"

echo ""
echo "── [1] Cold start — GET /health ──"
invoke GET /health

sleep 1
echo ""
echo "── Container Lambda subiu ──"
docker ps --format "  {{.Names}}" | grep -E "lambda|alunos" || echo "  (container ja encerrou)"

echo ""
echo "── [2] Warm — GET /health novamente ──"
invoke GET /health

echo ""
echo "── [3] GET /alunos ──"
invoke GET /alunos

echo ""
echo "── [4] GET /alunos/1 ──"
invoke GET /alunos/1

echo ""
echo "── [5] GET /alunos/9999 — espera 404 ──"
invoke GET /alunos/9999

# ── Aguardar container Lambda descer ──────────────────────────────────────
echo ""
echo "── Aguardando Lambda encerrar (idle timeout do Floci)... ──"
WAIT=0
while docker ps --format "{{.Names}}" | grep -qiE "lambda|alunos-api"; do
  sleep 2
  WAIT=$((WAIT + 2))
  printf "  %ds...\r" $WAIT
  if [ $WAIT -ge 360 ]; then
    echo "  (timeout de espera — Lambda pode ter TTL longo)"
    break
  fi
done
[ $WAIT -lt 360 ] && echo "" && echo "  Lambda encerrado apos ${WAIT}s de inatividade."

echo ""
echo "── Containers apos encerramento ──"
docker ps --format "  {{.Names}}" | grep -v "^$"

echo ""
echo "── [6] Segundo cold start — GET /health ──"
invoke GET /health

sleep 1
kill $DOCKER_PID 2>/dev/null || true
echo ""
echo "── Eventos Docker capturados ──"
cat "$TMP" | grep -iE "lambda|alunos" || echo "  (nenhum evento lambda capturado)"

echo ""
echo "======================================"
echo "  Teste concluido!"
echo "======================================"
