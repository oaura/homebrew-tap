cask "oaura" do
  version "1.1.0"
  sha256 "54cbe31e4cd7c9245a702bcce87cde826189b664f14928fc278bf771a15f7b4d"

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
