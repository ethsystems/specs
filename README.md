# EthSystems Specifications

Specifications for confidential systems for institutions on Ethereum, by [EthSystems](https://ethsystems.org).
We design each protocol, test it in [proof of concepts](https://github.com/ethsystems/pocs), and maintain it as editors.

Each specification states its trust model, threat model, and compliance boundary,
so engineers, auditors, and regulators can read the same document.
ERCs and other ecosystem standards _may be_ outputs of this process.

The process is [1/COSS](./specs/1): one responsible editor per specification, and a lifecycle of raw → draft → stable.
A Standards Track draft needs a reference implementation and an adversarial review.
Stable needs independent third-party use.


Source is [ethsystems/specs](https://github.com/ethsystems/specs).
See [CONTRIBUTING.md](./CONTRIBUTING.md) to propose a specification.

## Specifications

| No | Spec | Title | Status | Editor |
|----|------|-------|--------|--------|
| 1 | [1/COSS](./specs/1) | Consensus-Oriented Specification System | draft | Oskar Thoren |
| 2 | [2/SHIELDED-POOL](./specs/2) | Shielded Pool | draft | Oskar Thoren |
| 3 | [3/ATTESTED-POOL](./specs/3) | Attested Shielded Pool | draft | Oskar Thoren |

## Build

The site is rendered from these Markdown files with [pandoc](https://pandoc.org) 3.x.

```bash
bash scripts/render.sh                                 # writes build/
bash scripts/check-build.sh                            # assert build/ matches the source tree
python3 -m http.server 8765 --bind 127.0.0.1 -d build  # open http://127.0.0.1:8765
```

`build/` is git-ignored. Do not commit rendered output.

## Release

Nothing syncs to the public mirror automatically.
To publish, run one command:

```bash
scripts/release.sh              # embargo default: newest commit older than 7 days
scripts/release.sh origin/main  # release everything on main
```

It arms `SYNC_ENABLED`, dispatches the Release workflow (fast-forward push of one sha
to [ethsystems/specs](https://github.com/ethsystems/specs)), waits for it, and disarms.
The public deploy then rebuilds [specs.ethsystems.org](https://specs.ethsystems.org).

## Planned

Further specifications are promoted from PoC and engagement work as they mature. The working queue is internal.

## Related

- [ethsystems/map](https://github.com/ethsystems/map): use cases, patterns, and approaches. Patterns say what and why; specs here are the canonical normative protocols.
- [ethsystems/pocs](https://github.com/ethsystems/pocs): proof of concepts. Each PoC's SPEC.md is an instance of (or a candidate for) a spec here.
- [ethsystems/works](https://github.com/ethsystems/works): reusable Rust building blocks implementing these protocols.

## License

Documents use [CC0 1.0](./LICENSE) by default.
[1/COSS](./specs/1) is the sole exception, under GPL-3.0-or-later.
