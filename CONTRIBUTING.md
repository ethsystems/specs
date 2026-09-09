# Contributing

The process is [1/COSS](./specs/1). The short version:

- One responsible editor per specification.
  The editor is the only person who changes its lifecycle status.
- Lifecycle: raw → draft → stable → deprecated → retired.
  - **raw**: complete against the [template](./template/README.md), merged after editor review.
    No contractual weight; rough is fine. Anyone can open one.
  - **draft**: a reference implementation exists and the specification has passed an [adversarial review](#adversarial-review).
  - **stable**: an independent third-party implementation or a production deployment exists.
- Standards Track specifications MUST use the [template](./template/README.md).
- Use RFC 2119 keywords for normative statements.
  Semantic line breaks are recommended.
- Protocol specifications use [CC0 1.0](./LICENSE).
  Contributions use the license of the document being changed.

## Proposing a specification

1. Copy `template/README.md` to `specs/<next number>/README.md`.
2. Fill in the metadata header. Set `status: raw`. Name an editor (usually yourself).
3. Open a pull request. The assigned editor reviews and merges.

Raw specifications are cheap by design.
If a protocol idea is worth discussing, it is worth a raw spec.

New to the team?
Drafting or reviewing a specification in your first weeks is the expected onboarding path.

## Adversarial review

The review is the gate between raw and draft.

A reviewer reads the specification and the implementation against it, and tries to break the stated guarantees.
Record the findings in the pull request that promotes the specification.
The editor closes each finding before the status changes.
