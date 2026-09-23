#!/usr/bin/env bash
set -euo pipefail

tmp_dir="$(mktemp -d)"
tmp_site="${tmp_dir}/site"

cleanup() {
  rm -rf "${tmp_dir}"
}
trap cleanup EXIT

bundle exec jekyll build -d "${tmp_site}" >/dev/null

if [ -f "${tmp_site}/blog/index.html" ]; then
  echo "blog page should not be generated" >&2
  exit 1
fi

if grep -q 'href="/blog/"' "${tmp_site}/index.html"; then
  echo "blog link should not be present in main navigation" >&2
  exit 1
fi

if ! file assets/img/prof_pic.jpg | grep -q 'JPEG image data'; then
  echo "profile image must be a valid JPEG file" >&2
  exit 1
fi

repositories_page="${tmp_site}/repositories/index.html"
grep -q 'id="repositories-fallback-list"' "${repositories_page}"
grep -q 'https://github.com/peterdunson/factorverse' "${repositories_page}"
grep -q 'https://github.com/peterdunson/renderarxiv' "${repositories_page}"
grep -q 'https://github.com/peterdunson/iphs_391_final_project_market_uncertainty' "${repositories_page}"
grep -q 'https://github.com/peterdunson/renderscholar' "${repositories_page}"

echo "personal section integration checks passed"
