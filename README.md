# mirror-nodejs

OCX mirror for [Node.js](https://nodejs.org). Publishes the official
`nodejs.org/dist` archives to `ocx.sh/nodejs` with cascade tags after a
smoke test per `(version, platform)`.

The release index lives at `https://nodejs.org/dist/index.json`, not on
GitHub — so this mirror runs a small `generate.py` script that emits a
`url_index` JSON document. The script uses
[`ocx-mirror-sdk`](https://github.com/ocx-sh/ocx-mirror-sdk) (pinned to
the published wheel via PEP 723 inline metadata).

## Editing

| File | Edit | Regenerate after |
|------|------|------------------|
| `mirror.yml` | hand | `ocx-mirror pipeline generate ci` |
| `generate.py` | hand | — |
| `tests/smoke.star` | hand | — |
| `metadata.json`, `CATALOG.md`, `logo.svg` | hand | — |
| `.github/workflows/*.yml` | generated | re-run when `mirror.yml` changes |

CI fails on drift via `ocx-mirror pipeline generate ci --check`.

## Bumping the SDK pin

Edit the `[tool.uv.sources]` block at the top of `generate.py` to point at
a newer wheel:

```toml
ocx-mirror-sdk = { url = "https://github.com/ocx-sh/ocx-mirror-sdk/releases/download/vX.Y.Z/ocx_mirror_sdk-X.Y.Z-py3-none-any.whl" }
```

## Required secrets

| Secret | Use |
|--------|-----|
| `OCX_MIRROR_REGISTRY_TOKEN` + `OCX_MIRROR_REGISTRY_USER` | `ocx package push` to `ocx.sh` |
| `OCX_MIRROR_DISCORD_HOOK` | notify-stage Discord webhook URL |

## License

Apache-2.0 — see [`LICENSE`](LICENSE). Upstream assets (Node.js logo,
mirrored binaries) are out of scope; see [`NOTICE.md`](NOTICE.md).
