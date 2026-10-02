# VerifiScore

### A Full Account of the Problem, the Research, the Mechanism, and the Build

---

## A Word Before Beginning

This project did not arrive from nowhere. It began as a question, grew through seven days of real, tested, and often difficult work, and now stands as a working piece of infrastructure, deployed live and permanently to a public blockchain. Every stage of it, from the first search for a genuine problem to the final line of this document, was built in good conscience, under YAHWEH's guidance, by Innocent Taylor, known also as Figadstro, as the final capstone project for a web3 and blockchain development course.

It is offered here not as a finished commercial product, but as a complete, honest, and working proof of a specific idea. May it serve any reader, any forker, and any scholar who comes across it well.

---

## Abstract

VerifiScore is a smart contract system, written in Solidity and deployed live to the Sepolia testnet, that addresses a specific, documented failure in how continuous assessment and practical scores are recorded across Nigerian tertiary institutions. Rather than securing the finished academic transcript, which is the point at which most existing blockchain education research and industry work is aimed, VerifiScore secures the earlier and more vulnerable moment: the point at which a score is first recorded by a lecturer and first received by a student. A score submitted by a lecturer remains pending until the student's own digital wallet signs to confirm it. Once signed, that score is locked permanently. If a genuine correction is later required, the original is never erased or overwritten. The correction is appended beside it, with a required reason and a timestamp, so that the full history remains visible to anyone who looks.

---

## I. The Problem

Nigerian tertiary institutions carry a well documented, decades old pattern of grade manipulation, sometimes referred to as "sorting," in which bribery and relational access override merit based academic assessment. This is not a fringe concern. In 2026, a Dean at Abia State University was publicly accused of charging final year students as much as ₦350,000 to clear academic projects, a practice students themselves described as a pay to pass system.

Beneath that visible corruption sits a quieter, more mechanical failure, and it is this failure that VerifiScore was built to address directly. A Daily Trust investigation documented the case of a Bayero University Kano graduate, named in the report as Rose Daniel, whose exam score for a course had simply been omitted from her final transcript. Correcting it took nearly a year of follow up. The investigation noted that this reflects a wider, structural pattern of poor academic record keeping across Nigerian universities, one that causes real delays in graduation and in the decisions built on top of academic records.

Continuous assessment and practical work sit alongside examinations as core components of a Nigerian degree grade. In practice, a lecturer or laboratory demonstrator records a score on paper or in a private spreadsheet. That score is later handed to a course coordinator, who compiles it by hand into a register. That register eventually feeds the transcript. Every single hand off in that chain is a point at which a score can be silently altered, lost, or quietly adjusted, with no trace left behind of what the original grade actually was. This is the exact mechanism that both enables casual corruption and produced the kind of accidental, undocumented loss that happened to Rose Daniel.

---

## II. The Research Behind This Work

Before any code was written, real effort went into confirming that this specific contribution was genuine, and not simply a relabeling of something already built by others. Several separate rounds of research were carried out, and each one is accounted for honestly here, including the places where existing work came close.

The general category of using blockchain technology to secure academic records is well established. Several Nigerian academic papers propose blockchain based transcript systems, including a 2025 paper from the Nigerian Defence Academy describing a modified blockchain architecture for academic transcripts, and a University of Ibadan journal paper describing a Solidity based transcript verification system built on a private Ethereum network. A Nigerian startup called QuickCredentia is independently pursuing blockchain based transcript processing. Internationally, MIT has deployed Blockcerts, a real and working system for issuing and verifying diplomas on the Bitcoin blockchain, and a platform called SmartCert, used at Al Zaytoonah University of Jordan, performs credential verification using cryptographic signatures at genuine institutional scale. A Portuguese case study known as FenixEdu, part of the QualiChain project, documents a further working deployment in this same category.

All of this work shares a common shape. Each one secures the finished credential, the diploma or the transcript, after it has already been compiled. None of it addresses the earlier and more fragile moment that this project is concerned with: the point at which a raw score is first written down and first received.

A broader academic literature does exist on blockchain based grade management that goes beyond the finished transcript. Research teams in Germany, Vietnam, Portugal, Paraguay, and Spain have each published work in this area. One paper, by Ramos Sosa and colleagues, proposes that student results require the student's prior consent before being recorded. A Vietnamese study on blockchain based grade management explicitly notes that most existing solutions in this space focus on credential verification rather than the continuous, secure management of student grades as they are first produced, which is precisely the gap this project targets. A separate study from the University of Glasgow, led by Rooksby and Dimitrov, built and tested a real, working Ethereum based tamper proof grading system, and found in their own evaluation that students did not fully trust it, and that the grading process itself lacked an agreed formula for the system to enforce. That finding was taken seriously here, and shaped the decision to keep this project's logic deliberately simple and auditable rather than ambitious for its own sake.

After all of this searching, one specific mechanism did not appear anywhere in the research gathered: a system in which a score remains unofficial until the student's own wallet signs to confirm it, with any later correction preserved beside the original rather than replacing it. That specific mechanism, and the honest acknowledgment of everything that came before it, is what this project contributes.

---

## III. The Mechanism

The contract is built around a small number of deliberate, carefully tested steps.

A department administrator first registers each student, linking their matric number to their own wallet address. The same administrator authorizes specific wallets as lecturers, permitted to submit scores. When an authorized lecturer submits a score, it is tied to a specific student, a specific course code, and a specific assessment name, and it enters the ledger in a pending state. It is not yet official.

The student, and only the student, using their own wallet, then calls a function to acknowledge that score. The moment that signature is recorded, the score locks permanently. No lecturer, administrator, or outside party can alter it from that point forward.

If a genuine correction becomes necessary later, an authorized lecturer may submit one, but only together with a required written reason. That correction does not overwrite the original score. It is appended as a new, separate, timestamped entry sitting alongside the original, which remains visible and untouched. Anyone reading the record afterward sees both the original score and the full history of any correction made to it, in order, with the stated reason attached to each.

A final function allows an Exam Officer, or any authorized reader, to pull a student's complete, verified record for a given course and assessment in a single call: the original score, whether it was acknowledged, how many corrections exist, and the current, most up to date score to actually use. This replaces the manual act of compiling scores by hand from paper, the exact step at which Rose Daniel's score disappeared.

---

## IV. What Is Genuinely New Here

It would be dishonest to claim that blockchain based academic record keeping is an unexplored field. It is not. Real institutions, including MIT, and real research groups, across several countries, have already proven that the broader category works, and works at scale.

What has not appeared anywhere in the research gathered for this project is the specific pairing used here: making the student's own cryptographic signature the condition for a score becoming final, applied at the exact moment the score is first recorded rather than after it has already been compiled into a transcript, combined with a correction mechanism that preserves history instead of replacing it. That narrow, specific contribution is what this project adds to work that already exists, built honestly on top of it rather than in denial of it.

---

## V. Architecture and Technical Specification

| Function | Purpose |
|---|---|
| registerStudent | Links a matric number to a student's wallet. Administrator only. |
| addLecturer | Authorizes a wallet to submit scores. Administrator only. |
| submitScore | Records a pending score for a registered student. Authorized lecturers only. |
| acknowledgeScore | The student's own wallet signs to lock their score permanently. |
| correctScore | Appends a corrected score with a required reason. The original score is never overwritten. |
| getScore | Returns a student's basic score record. |
| getFullRecord | Returns a student's complete verified record, including correction history and current score. |

Language: Solidity, version 0.8.19 and above.
Tooling: Foundry, specifically Forge for building and testing, and Cast for wallet and chain interaction.
Access control: OpenZeppelin Contracts, using the Ownable pattern.

---

## VI. Testing and Verification

The contract is covered by nineteen separate tests, run using Forge. These tests confirm the full intended path of the system, including registration, authorization, score submission, student acknowledgment, correction without data loss, and the compiled full record view. They also confirm the system's edge cases: rejection of a zero address during registration, rejection of a duplicate matric number, rejection of a second wallet attempting to claim an already registered matric number, rejection of an unauthorized party attempting to submit or correct a score, and correct behavior when several corrections are stacked on top of a single original score. Every test passes.

    forge test

---

## VII. Live Deployment

VerifiScore is deployed and permanently live on the Sepolia test network.

Network: Sepolia Testnet, Chain ID 11155111.
Contract Address: 0x5f843d236e1764cBC839c108B7190cD31cA23f19
Etherscan Record: https://sepolia.etherscan.io/address/0x5f843d236e1764cBC839c108B7190cD31cA23f19
Repository: https://github.com/InnocentInnocentdb/verifiscore

---

## VIII. For Those Who Fork This Work

This project is shared openly, and any scholar, builder, or student encountering it is welcome to study it, test it, and build upon it.

    git clone https://github.com/InnocentInnocentdb/verifiscore.git
    cd verifiscore
    forge install
    forge build
    forge test

---

## IX. Closing Note

Seven days stand behind this document. What began as a search for a worthwhile idea became real research into a documented, lived problem, then became tested, working code, then became a live, permanent deployment, and now becomes this account of the whole journey. Every claim made in this document has been checked, not assumed, and every piece of prior work that informed it has been named honestly, not hidden.

To YAHWEH be the praise, for the guidance, the patience, and the completion of this work.

---

## References

1. Grokipedia, "Academic grading in Nigeria": https://grokipedia.com/page/Academic_grading_in_Nigeria
2. 247ureports, ABSU corruption scandal: https://247ureports.com/2026/05/absu-corruption-scandal-mass-comm-dean-accused-of-%E2%82%A6350k-project-racketeering/
3. Sapientia Global Journal, "Assessment of Corruption in Nigeria": https://www.sgojahds.com/index.php/SGOJAHDS/article/download/364/391
4. Daily Trust, "Concerns over clumsy record keeping in Nigerian universities": https://dailytrust.com/concerns-over-clumsy-record-keeping-in-nigerian-universities/
5. University of Nigeria Nsukka, Accountancy programme structure: https://accountancy.unn.edu.ng/programme/
6. IISTE, "Corrupt Academic Practices: A Tragedy in Nigerian Education": https://www.iiste.org/Journals/index.php/JEP/article/download/9888/10109
7. Nigerian Defence Academy, modified blockchain transcript architecture: https://jasic.kiu.ac.ug/assets/articles/1768039414_an-academic-transcript-system-based-on-a-modified-blockchain-architecture.pdf
8. QuickCredentia: https://startupper.totalenergies.com/en/juries/VDpd_EeIJHI1R5trxfIluw/participations/22248/vote
9. University of Ibadan journal, Solidity based transcript verification: https://journals.ui.edu.ng/index.php/uijslictr/article/download/2252/1735/5945
10. Blockscripts, a blockchain system for university transcripts: https://www.academia.edu/92989071/Blockscripts_a_Blockchain_System_for_University_Transcripts
11. Nairametrics, blockchain in Nigerian tertiary institutions: https://nairametrics.com/?p=384966
12. Ramos Sosa et al., "Blockchain and smart contracts for education": https://ideas.repec.org/p/pra/mprapa/101518.html
13. Vietnamese grade management blockchain study: https://vjol.info.vn/tcdaihochkythuatcongngheCanTho/article/download/133324/109515
14. MIT Blockcerts, discussed in academic paper: https://arxiv.org/pdf/2410.20605
15. University of Glasgow tamper proof grading study, discussed in academic paper: https://arxiv.org/pdf/2310.09136
16. SmartCert, Al Zaytoonah University of Jordan, discussed in academic paper: https://www.researchgate.net/publication/355113778_Verification_of_University_Student_and_Graduate_Data_using_Blockchain_Technology
17. FenixEdu and QualiChain, Portugal case study: https://www.sciencedirect.com/science/article/pii/S2096720922000409
