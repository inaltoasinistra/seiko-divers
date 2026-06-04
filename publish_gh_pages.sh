#!/usr/bin/env bash
set -euo pipefail

# ONE-TIME SETUP: enables GitHub Pages for the repository.
# After running this script once, every "git push origin master" will
# automatically trigger a new Pages build and deploy the updated site
# within ~1 minute at https://inaltoasinistra.github.io/seiko-divers/.
#
# GITHUB_TOKEN — how to generate:
#   1. Go to: github.com → Settings → Developer settings →
#              Personal access tokens → Tokens (classic)
#      NOTE: use a *classic* token, not a fine-grained token.
#   2. Click "Generate new token (classic)".
#   3. Check the top-level "repo" scope (not just sub-scopes).
#   4. Copy the generated token (shown only once).
#   5. Export it before running this script:
#        export GITHUB_TOKEN=ghp_...

OWNER="inaltoasinistra"
REPO="seiko-divers"
BRANCH="master"

if [[ -z "${GITHUB_TOKEN:-}" ]]; then
  echo "Error: set GITHUB_TOKEN before running this script."
  echo "  export GITHUB_TOKEN=ghp_..."
  exit 1
fi

echo "Enabling GitHub Pages for ${OWNER}/${REPO} (branch: ${BRANCH}, path: /)..."

curl -sS --fail-with-body \
  -X POST \
  -H "Authorization: Bearer ${GITHUB_TOKEN}" \
  -H "Accept: application/vnd.github+json" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  "https://api.github.com/repos/${OWNER}/${REPO}/pages" \
  -d "{\"source\":{\"branch\":\"${BRANCH}\",\"path\":\"/\"}}"

echo ""
echo "Done. Site will be live at: https://${OWNER}.github.io/${REPO}/"
echo "(GitHub takes ~1 minute to build and deploy.)"
