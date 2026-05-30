A decentralized public transport ticketing and commuter pass management protocol built on Ethereum using Solidity. This contract allows transport authorities to automate pass issuance, tracking, and cryptographic gate validation.

📌 Overview
The TransitPass smart contract provides a decentralized alternative to traditional automated fare collection (AFC) networks. Instead of relying on central tracking servers or physical, easily lost plastic smart cards, commuters buy or extend a 30-day digital subscription pass directly from their Web3 wallets. Physical turnstiles or digital terminal gates can check pass validity with zero-latency via on-chain queries, removing operational bottlenecks.

🛠 Features
Autonomous Digital Onboarding: Commuters purchase or extend passes via direct cryptographic interactions without needing to visit customer service desks.

Continuous Expiry Extension: Integrated logic checks for existing validity; if a user already has a valid pass, the newly purchased 30 days are appended seamlessly from the old expiration date.

Zero-Trust Turnstile Gate Validation: Automated entry checkpoints run low-overhead read functions to grant or block station entry based on global blockchain timestamps.

Immutable Treasury Management: All collection proceeds remain locked inside the contract state until securely withdrawn by the transit network administrator.

📄 Smart Contract Architecture
Data Structures
Pass (Struct)
Tracks individual passenger subscription records:

expiryTimestamp: A Unix Epoch timestamp marking the exact second the commuter's transit subscription privileges expire.

isActive: A boolean flag checking whether the pass profile is dynamically operational or structurally turned off.

State Variables
owner: The Ethereum address of the transit network administrator possessing exclusive control over pricing parameters and financial extractions.

passPrice: The active cost metric denominated in Wei required to initialize or purchase a 30-day transport pass cycle.

userPasses: A public mapping (address => Pass) associating an individual commuter’s public key address with their active transit pass profile.

⚙️ Core Functions
1. buyPass()
Permission: Public Payable

Description: Processes pass purchases. Validates that incoming Ether matches passPrice. If the user's current pass is valid, it appends 30 days to the existing expiryTimestamp; otherwise, it starts a 30-day countdown from block.timestamp.

2. validatePass(address _user)
Permission: External (Called by automated entry turnstiles)

Description: Evaluates if isActive is true and expiryTimestamp >= block.timestamp. If it fails due to timeout, it internally sets isActive = false to save future execution cycles and returns false.

3. updatePrice(uint256 _newPrice)
Permission: Only owner

Description: Dynamically modifies the global passPrice parameter to align with adjustments in transit network overhead or operational costs.

4. withdraw()
Permission: Only owner

Description: Triggers a low-level native cryptocurrency sweep, exporting the entire balance accumulated inside the contract directly to the administrator's wallet.

🔔 Events
PassPurchased(address indexed user, uint256 expiryTimestamp): Emitted upon successful payment allocation, logging commuter details and expiration markers.

PassValidated(address indexed user, bool isValid, uint256 expiryTimestamp): Emitted by turnstiles during point-of-entry scans for tracking historical transit traffic metrics.

PriceUpdated(uint256 newPrice): Emitted when administrative entities alter underlying entry fees.

🚀 Tech Stack & Setup
Language: Solidity ^0.8.20

Tools: Remix IDE / Hardhat / Foundry

Standard Deploy Instructions: Load TransitPass.sol into your compiler framework. Compile using version 0.8.20. Upon deployment, the executing key is bound as the contract owner.
