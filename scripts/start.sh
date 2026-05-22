#!/bin/bash
set -euo pipefail

APP_NAME="user-management"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

# ---- 默认配置 ----
PORT="${PORT:-8080}"
PROFILE="${PROFILE:-dev}"
JAVA_HOME="${JAVA_HOME:-}"
MAVEN_HOME="${MAVEN_HOME:-}"
SKIP_TESTS="${SKIP_TESTS:-true}"

# ---- 检测 JAVA_HOME ----
if [ -z "$JAVA_HOME" ]; then
  if command -v java &>/dev/null; then
    JAVA_HOME="$(dirname "$(dirname "$(readlink -f "$(command -v java)")")")"
  else
    echo "Error: JAVA_HOME not set and java not found in PATH" >&2
    exit 1
  fi
fi
JAVA_BIN="$JAVA_HOME/bin/java"
if [ ! -x "$JAVA_BIN" ]; then
  echo "Error: java not found at $JAVA_BIN" >&2
  exit 1
fi
echo "[OK] JAVA_HOME=$JAVA_HOME"

# ---- 检测 MAVEN_HOME ----
MVN_BIN=""
if [ -n "$MAVEN_HOME" ]; then
  MVN_BIN="$MAVEN_HOME/bin/mvn"
elif command -v mvn &>/dev/null; then
  MVN_BIN="$(command -v mvn)"
fi

if [ -z "$MVN_BIN" ]; then
  echo "Warning: Maven not found, using ./mvnw wrapper" >&2
  MVN_BIN="$PROJECT_DIR/mvnw"
  if [ ! -f "$MVN_BIN" ]; then
    echo "Error: no mvnw wrapper found at $MVN_BIN" >&2
    exit 1
  fi
elif [ ! -x "$MVN_BIN" ]; then
  echo "Error: mvn not executable at $MVN_BIN" >&2
  exit 1
fi
echo "[OK] MAVEN_HOME=$(dirname "$(dirname "$MVN_BIN")")"

# ---- 参数化 ----
while [ $# -gt 0 ]; do
  case "$1" in
    --profile) PROFILE="$2"; shift 2 ;;
    --port)    PORT="$2";    shift 2 ;;
    --skip-tests) SKIP_TESTS="$2"; shift 2 ;;
    --help|-h)
      echo "Usage: $0 [options]"
      echo "  --profile <dev|prod>   Active profile (default: dev)"
      echo "  --port <port>          Server port (default: 8080)"
      echo "  --skip-tests <bool>    Skip tests (default: true)"
      exit 0 ;;
    *) echo "Unknown option: $1"; exit 1 ;;
  esac
done

# ---- 构建与启动 ----
SKIP_FLAG=""
[ "$SKIP_TESTS" = "true" ] && SKIP_FLAG="-DskipTests"

echo ">>> Building $APP_NAME (profile=$PROFILE, port=$PORT) ..."
"$MVN_BIN" clean package $SKIP_FLAG -B

JAR_FILE=$(find "$PROJECT_DIR/target" -name "*.jar" ! -name "*-sources.jar" | head -1)
if [ -z "$JAR_FILE" ]; then
  echo "Error: no jar found in target/" >&2
  exit 1
fi

echo ">>> Starting $APP_NAME ..."
exec "$JAVA_BIN" -jar "$JAR_FILE" \
  --server.port="$PORT" \
  --spring.profiles.active="$PROFILE"
