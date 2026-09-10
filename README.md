# EthSystems Specifications

Specifications for confidential systems on Ethereum, written for institutional requirements.
Each one makes its trust model, threat model, and compliance boundary explicit.
We design, test, and maintain them under [1/COSS](./specs/1).
See [CONTRIBUTING.md](./CONTRIBUTING.md) to propose a specification.

## Specifications

| No | Spec | Title | Status | Editor |
|----|------|-------|--------|--------|
| 1 | [1/COSS](./specs/1) | Consensus-Oriented Specification System | draft | Oskar Thoren |
| 2 | [2/SHIELDED-POOL](./specs/2) | Shielded Pool | draft | Oskar Thoren |
| 3 | [3/ATTESTED-POOL](./specs/3) | Attested Shielded Pool | draft | Oskar Thoren |

## Planned

Further specifications are promoted from PoC and engagement work as they mature. The working queue is internal.

## Related

- [ethsystems/map](https://github.com/ethsystems/map): use cases, patterns, and approaches. Patterns say what and why; specs here are the canonical normative protocols.
- [ethsystems/pocs](https://github.com/ethsystems/pocs): proof of concepts. Each PoC's SPEC.md is an instance of (or a candidate for) a spec here.
- [ethsystems/works](https://github.com/ethsystems/works): reusable Rust building blocks implementing these protocols.

## License

Documents use [CC0 1.0](./LICENSE) by default.
[1/COSS](./specs/1) is the sole exception, under GPL-3.0-or-later.
