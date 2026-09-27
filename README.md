# VerifiScore

**On-chain academic score ledger: grades lock only when the student signs, corrections are signature-appended, not overwritten, never silently altered again. Built to close the exact gap where Nigerian university grades quietly vanish or get altered unseen.**

---

## The Problem

Nigerian tertiary institutions carry a well-documented pattern of grade manipulation, sometimes called "sorting" where bribery and relational access override merit-based assessment. In 2026, a Dean at Abia State University was accused of charging final-year students up to ₦350,000 to clear academic projects.

But the deeper, more mechanical failure sits earlier in the pipeline. A Daily Trust investigation documented a Bayero University Kano graduate whose exam score was simply omitted from her final transcript, a correction that took nearly a year to resolve. The piece noted this reflects a wider pattern of poor academic record-keeping causing delays in graduation and decision-making across Nigerian universities.

Continuous assessment and practical scores are recorded on paper or spreadsheets by individual lecturers and demonstrators, then manually compiled by a coordinator into a register, which later feeds the transcript. Every hand-off in that chain is a point where a score can be silently altered, lost, or "adjusted" with no trace of what the original grade actually was.

## The Mechanism

VerifiScore intervenes at the exact moment a score is first recorded, not after it has already been compiled and handed over, which is where existing blockchain-transcript research (including work from the Nigerian Defence Academy and the University of Ibadan) focuses instead.

1. A lecturer submits a student's score, tied to a specific course and assessment. It sits **pending** not yet official.
2. The **student's own wallet** signs to acknowledge the score. Only then does it lock, permanently.
3. If a genuine correction is needed later, it is never overwritten. It is **appended** alongside the original, fully visible, with a required reason and timestamp, so nothing can be quietly swapped in the dark.
4. An Exam Officer reads a student's full, verified record directly from the ledger, original score, acknowledgment status, correction history, and current score, replacing manual compilation from paper entirely.

## What's Genuinely New

Blockchain-based academic transcript verification is an active area of research and industry work, institutions like MIT (Blockcerts) and platforms like SmartCert have proven the category works at scale. What none of that work does is make the **student's own signature** the condition for a score becoming final, at the point of grading rather than after compilation, with corrections preserved rather than replaced. That is the specific, narrow contribution this project makes.

## Live Deployment

**Network:** Sepolia Testnet (Chain ID 11155111)
**Contract Address:** [`0x5f843d236e1764cBC839c108B7190cD31cA23f19`](https://sepolia.etherscan.io/address/0x5f843d236e1764cBC839c108B7190cD31cA23f19)

## Contract Overview

| Function | Purpose |
|---|---|
| `registerStudent` | Links a matric number to a student's wallet (admin-only) |
| `addLecturer` | Authorizes a wallet to submit scores (admin-only) |
| `submitScore` | Records a pending score for a registered student (authorized lecturers only) |
| `acknowledgeScore` | Student signs to lock their own score permanently |
| `correctScore` | Appends a corrected score with a required reason, original is never overwritten |
| `getScore` / `getFullRecord` | Read a student's verified score and correction history |

## Tech Stack

- **Solidity** ^0.8.19
- **Foundry** (Forge, Cast) build, test, and deployment tooling
- **OpenZeppelin Contracts** — `Ownable` for access control

## Testing

19 tests, covering the full happy path, access control, duplicate protection, and edge cases including zero-address handling and multiple stacked corrections.

    forge test

## Local Setup

    git clone https://github.com/InnocentInnocentdb/verifiscore.git
    cd verifiscore
    forge install
    forge build
    forge test

## Author

Conceived and built by Innocent Etim Taylor Edung (Figadstro) as a final capstone project for a Web3 and Blockchain Development course.
