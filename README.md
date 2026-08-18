# EthSystems Specifications

Specifications for confidential systems for institutions on Ethereum:
protocols we design, battle-test in [proof of concepts](https://github.com/ethsystems/pocs), and maintain as editors.
Each specification makes the trust model, threat model, and compliance boundary explicit,
so engineers, auditors, and regulators can each read it.
ERCs and other ecosystem standards are outputs of this process, not the working format.

The process is [1/COSS](./specs/1):
one responsible editor per specification,
lifecycle raw → draft → stable, with each transition tied to artifacts.
A draft requires a reference implementation and an adversarial review.
Stable requires independent third-party use.
See [CONTRIBUTING.md](./CONTRIBUTING.md) to propose a specification.

## Specifications

| No | Spec | Title | Status | Editor |
|----|------|-------|--------|--------|
| 1 | [1/COSS](./specs/1) | Consensus-Oriented Specification System | draft | Oskar Thoren |

## Planned

Promotion candidates from existing PoC specs and engagement work, in rough order:

- Shielded-pool compliance with selective disclosure
- Portable private authentication / selective disclosure
- Viewing-key semantics
- Escape hatches and forced exits

## Related

- [ethsystems/map](https://github.com/ethsystems/map): use cases, patterns, and approaches. Patterns say what and why; specs here are the canonical normative protocols.
- [ethsystems/pocs](https://github.com/ethsystems/pocs): proof of concepts. Each PoC's SPEC.md is an instance of (or a candidate for) a spec here.
- [ethsystems/works](https://github.com/ethsystems/works): reusable Rust building blocks implementing these protocols.

## License

[CC0 1.0](./LICENSE), except [1/COSS](./specs/1) which is GPL-3.0 by lineage.
