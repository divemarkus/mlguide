
# Bitcoin encyrption comparison, using tables
- RTX 3070 Ti
- deepseek-r1:latest
- Small-med local LLM
- Fits 8GB VRAM or Shared RAM

## Prompt
- 1156 tokens
- 23.59 prompt token/sec
- 25 prompt tokens

---

# Bitcoin vs. Credit Card Companies: Encryption Comparison

| Feature                  | Bitcoin                                  | Credit Card Companies                        |
|-------------------------|------------------------------------------|---------------------------------------------|
| **Encryption Type**      | **Elliptic Curve Digital Signature Algorithm (ECDSA)** for transaction signing and SHA-256 for block hashing | **Hybrid: AES (symmetric) + RSA (asymmetric)** for tokenization; **TLS/SSL** for secure communication |
| **Data Security**        | **Decentralized**: Public blockchain; transactions immutable and pseudonymous | **Centralized**: Data stored on proprietary servers; strict PCI DSS compliance |
| **Transaction Security** | **End-to-end**: Digital signatures prevent tampering; no chargebacks | **Networked**: Multi-layered encryption; fraud detection algorithms; chargebacks available |
| **Key Management**       | **Decentralized**: Users control private keys (wallets); no central authority | **Centralized**: Issuers manage encryption keys via secure vaults; tokenization systems |
| **Encryption Use Cases**  | **Consent-based**: Users opt-in for full encryption; transparent cryptographic operations | **Automated**: Tokenization replaces sensitive data; encryption enforced by payment processors |
| **Vulnerability**        | **Network-level**: Vulnerable to 51% attacks; private key theft | **Server-level**: Vulnerable to breaches; tokenization mitigates direct exposure |

## Key Differences

### Bitcoin
- **Public Ledger**: Transactions are transparent but pseudonymous
- **User Responsibility**: Users must safeguard private keys (compromises lead to permanent loss)
- **No Central Authority**: No KYC/AML checks; encryption is peer-to-peer

### Credit Card Companies
- **Proprietary Systems**: Use hardware security modules (HSMs) for key management
- **Regulatory Compliance**: Adhere to PCI DSS standards for encryption and data protection
- **Hybrid Approach**: Combine symmetric (AES) and asymmetric (RSA) encryption for efficiency

## Conclusion

Bitcoin prioritizes **user autonomy** and **transparency** with decentralized encryption, while credit card companies emphasize **regulatory compliance** and **fraud mitigation** through centralized systems. Both leverage robust cryptographic standards but differ in implementation philosophy.