---
shortname: N/SHORTNAME
title: Full Specification Name
status: raw
category: Standards Track
tags:
editor: Name <email>
contributors:
---

One-paragraph abstract:
what protocol this document specifies, and the one-sentence version of what it guarantees.

## 1. Introduction

### 1.1 Motivation

What problem this protocol solves and why it matters.

### 1.2 Constraints

The requirements the protocol MUST meet:

- Privacy: what must stay confidential, from whom.
- Regulatory: compliance requirements, disclosure obligations.
- Operational: integration, performance, usability needs.
- Trust: who can and cannot be trusted.

### 1.3 Relationship to Existing Standards

Prior art and adjacent standards (ERCs, IETF RFCs, other domain specs),
and why this specification exists next to them.
If this section cannot be filled in convincingly, the specification should not exist.

## 2. Conventions and Terminology

The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD", "SHOULD NOT", "RECOMMENDED", "MAY", and "OPTIONAL" in this document are to be interpreted as described in [RFC 2119](https://www.rfc-editor.org/rfc/rfc2119).

- **Term**: definition. Define every term with a protocol-specific meaning before first use.

## 3. Architecture

### 3.1 Participants and Roles

Who is involved and what each role can do.

### 3.2 Trust Model

What each participant is trusted with, and what the protocol guarantees when that trust fails.

### 3.3 Overview

The protocol phases at a high level, with a diagram where it helps.

## 4. Protocol Operations

Normative step-by-step flows, one subsection per flow.
Tag each step with the acting participant:

1. [user] ...
2. [contract] ...

## 5. Data Formats

### 5.1 Data Structures

Wire and storage formats, field by field.

### 5.2 On-Chain State

What lives on-chain and why.

### 5.3 Cryptographic Primitives

Specific algorithms, curves, hash functions, and parameter choices.
For ZK protocols: the statements each circuit proves.

## 6. Security Considerations

### 6.1 Threat Model

The adversaries considered, and their capabilities.

### 6.2 Guarantees

The security properties that hold, each stated precisely and tied to the mechanism that provides it.
Mark each property as asserted, tested, or machine-checked.

### 6.3 Limitations

What the protocol does not protect against, stated plainly.

## 7. Implementation Notes

Reference implementations and their status,
plus known shortcuts an implementer must not copy into production.

## 8. References

Normative and informative references, separated.

## 9. Acknowledgments

## Change Process

This document is governed by [1/COSS](../1).

## Copyright

This specification is released to the public domain under [CC0 1.0](../../LICENSE).
