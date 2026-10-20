# oAura Homebrew Tap

Homebrew cask for [oAura](https://github.com/oaura/oAura), a visual diary for migraine auras and seizures.

## Install

```bash
brew install --cask oaura/tap/oaura
```

Update with `brew upgrade --cask oaura`. To remove the app and its data: `brew uninstall --zap --cask oaura`.

> The macOS app is ad-hoc signed and not notarized. The cask clears the download quarantine after installing so the app opens normally.

## Maintenance

`Casks/oaura.rb` follows the latest [oAura release](https://github.com/oaura/oAura/releases) automatically. The *Update cask* workflow runs every 3 hours and can also be started by hand. To update locally: `scripts/update-cask.sh [version]`.
