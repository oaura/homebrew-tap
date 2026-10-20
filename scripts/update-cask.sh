#!/usr/bin/env bash
# Points Casks/oaura.rb at the latest oAura GitHub release.
# Usage: scripts/update-cask.sh [version]   (default: latest release)
# Needs: gh (authenticated, read access to oaura/oAura), shasum or sha256sum.
set -euo pipefail
repo=oaura/oAura
cd "$(dirname "$0")/.."

tag=${1:+v$1}
tag=${tag:-$(gh release view -R "$repo" --json tagName -q .tagName)}
version=${tag#v}
current=$(sed -nE 's/^  version "([^"]+)"/\1/p' Casks/oaura.rb 2>/dev/null || true)
if [[ "$current" == "$version" ]]; then
  echo "Cask already at $version"
  exit 0
fi

asset="oAura-${version}-macOS.zip"
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT
gh release download "$tag" -R "$repo" -p "$asset" -D "$tmp"
if command -v sha256sum >/dev/null; then sha=$(sha256sum "$tmp/$asset" | awk '{print $1}'); else sha=$(shasum -a 256 "$tmp/$asset" | awk '{print $1}'); fi

mkdir -p Casks
cat > Casks/oaura.rb <<CASK
cask "oaura" do
  version "${version}"
  sha256 "${sha}"

  url "https://github.com/oaura/oAura/releases/download/v#{version}/oAura-#{version}-macOS.zip"
  name "oAura"
  desc "Visual diary for migraine auras and seizures"
  homepage "https://github.com/oaura/oAura"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :sequoia"

  app "oAura.app"

  # The app is ad-hoc signed, not notarized: clear the download quarantine so it opens.
  postflight do
    system_command "/usr/bin/xattr",
                   args: ["-dr", "com.apple.quarantine", "#{appdir}/oAura.app"]
  end

  zap trash: [
    "~/Library/Application Support/oAura",
    "~/Library/Caches/io.github.oaura.oaura.mac",
    "~/Library/Preferences/io.github.oaura.oaura.mac.plist",
    "~/Library/Saved Application State/io.github.oaura.oaura.mac.savedState",
  ]
end
CASK
echo "Updated cask: ${current:-none} -> ${version}"
