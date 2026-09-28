#!/usr/bin/env bash
set -euo pipefail

site_root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$site_root"
state_dir="$site_root/.local"
pid_file="$state_dir/preview.pid"
mode="${1:-preview}"

preview_running() {
  [[ -f "$pid_file" ]] || return 1
  read -r preview_pid < "$pid_file"
  [[ "$preview_pid" =~ ^[0-9]+$ ]] || return 1
  kill -0 "$preview_pid" 2>/dev/null || return 1
  [[ "$(readlink -f "/proc/$preview_pid/cwd" 2>/dev/null)" == "$site_root" ]] || return 1
  grep -azq 'jekyll' "/proc/$preview_pid/cmdline" 2>/dev/null
}

case "$mode" in
  stop)
    if preview_running; then
      kill -TERM "$preview_pid"
      printf 'Stopped this project preview (PID %s).\n' "$preview_pid"
    else
      printf 'No active preview for this project.\n'
    fi
    exit 0
    ;;
  setup|build|preview) ;;
  *)
    printf 'Usage: site.cmd [preview [PORT] | build | setup | stop]\n' >&2
    exit 2
    ;;
esac

if ! command -v ruby >/dev/null || ! command -v bundle >/dev/null; then
  printf 'Ruby and Bundler are required in Ubuntu. See LOCAL_DEVELOPMENT.md.\n' >&2
  exit 1
fi

mkdir -p "$state_dir"
# Keep the source on Windows and load Ruby gems from Linux for faster startup.
cache_key="$(printf '%s' "$site_root" | sha256sum | cut -c1-16)"
runtime_bundle="/tmp/zhiming-jekyll-${UID}-${cache_key}"
runtime_ready="${runtime_bundle}.ready"
if [[ ! -f "$runtime_ready" ]]; then
  mkdir -p "$runtime_bundle"
  if [[ -f "$state_dir/bundle-cache.tar" ]]; then
    printf 'Preparing the Ubuntu dependency cache (first start only)...\n'
    tar -xf "$state_dir/bundle-cache.tar" -C "$runtime_bundle"
    touch "$runtime_ready"
  elif [[ -d "$state_dir/bundle/ruby" ]]; then
    printf 'Preparing the Ubuntu dependency cache (first start only)...\n'
    cp -a "$state_dir/bundle/." "$runtime_bundle/"
    touch "$runtime_ready"
  fi
fi
export BUNDLE_PATH="$runtime_bundle"
export BUNDLE_USER_HOME="$state_dir/bundler"
export BUNDLE_APP_CONFIG="$state_dir/bundle-config"
export BUNDLE_TIMEOUT=30
export LANG=C.UTF-8

if [[ "$mode" == setup ]]; then
  ruby --version
  bundle --version
  bundle install --jobs 4 --retry 2
  tar -cf "$state_dir/bundle-cache.tar" -C "$runtime_bundle" .
  touch "$runtime_ready"
  exit 0
fi

if ! bundle check; then
  printf 'Installing missing dependencies...\n'
  bundle install --jobs 4 --retry 2
fi
touch "$runtime_ready"

if [[ "$mode" == build ]]; then
  JEKYLL_ENV=production bundle exec jekyll build --strict_front_matter
  exit 0
fi

port="${2:-4000}"
if [[ ! "$port" =~ ^[0-9]+$ ]] || ((port < 1024 || port > 33799)); then
  printf 'Preview port must be an integer between 1024 and 33799.\n' >&2
  exit 2
fi
if preview_running; then
  printf 'This project already has an active preview. Run site.cmd stop first.\n'
  exit 0
fi

printf '%s\n' "$$" > "$pid_file"
printf 'Preview: http://localhost:%s/\nKeep this terminal open. Press Ctrl+C to stop.\n' "$port"
export JEKYLL_ENV=development
exec bundle exec jekyll serve --config _config.yml,.scripts/preview.yml \
  --port "$port" --livereload-port "$((port + 31729))" --strict_front_matter
