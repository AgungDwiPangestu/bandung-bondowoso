# 3 Ide Proyek untuk PortalDot Online S1

---

## Ide 1: ethers.js v5 → v6 Full Migration Recipe

**Detail:** ./ide-1-ethers-v5-ke-v6.md

### Deskripsi
Membangun codemod komprehensif untuk migrasi `ethers.js` dari versi 5 ke versi 6 — salah satu library Web3/Ethereum paling populer dengan jutaan pengguna.

### Mengapa Ini Pilihan Kuat
- `ethers.js` dipakai di hampir semua project DeFi dan Web3
- Perubahan v5 → v6 sangat signifikan: perubahan nama class, API yang di-rename, cara import yang berubah (ESM-only), BigNumber diganti dengan BigInt native
- Ribuan repo open-source masih terjebak di v5 karena migrasinya menyulitkan
- Potensi **framework adoption** sangat tinggi karena bisa diajukan ke maintainer ethers.js

### Perubahan Utama yang Diotomatisasi
| v5 | v6 | Jenis |
|---|---|---|
| `ethers.providers.Web3Provider` | `ethers.BrowserProvider` | Rename class |
| `ethers.utils.parseEther()` | `ethers.parseEther()` | Flatten namespace |
| `BigNumber.from(x)` | `BigInt(x)` | Type replacement |
| `provider.getGasPrice()` | `provider.getFeeData()` | Method rename |
| `signer.getAddress()` | `signer.getAddress()` (async) | Signature change |
| `ContractFactory.deploy()` | Cara baru via `waitForDeployment()` | API change |

### Target Ukuran: **L ($400)**
Estimasi ~2 minggu pengerjaan, dengan case study tambahan ($200) = potensi total **$600**

### Repo untuk Testing
- `scaffold-eth/scaffold-eth-2`
- `Uniswap/interface`
- Berbagai repo DeFi di GitHub yang masih pakai ethers v5

---

## Ide 2: wagmi v1 → v2 Full Migration Recipe

**Detail:** ./ide-2-wagmi-v1-ke-v2.md

### Deskripsi
Codemod untuk migrasi `wagmi` dari v1 ke v2 — library React hooks untuk Ethereum yang sangat populer di ekosistem frontend Web3.

### Mengapa Ini Pilihan Kuat
- `wagmi` adalah standar de-facto untuk React + Web3
- wagmi v2 adalah rewrite besar dengan pendekatan baru: modular, multi-chain by default
- Banyak project frontend Web3 yang "stuck" di v1 karena migrasinya menyita waktu
- Berkaitan erat dengan `viem` (dependency baru di v2) — bisa bundel dua migrasi sekaligus

### Perubahan Utama yang Diotomatisasi
| v1 | v2 | Jenis |
|---|---|---|
| `import { useAccount } from 'wagmi'` | Import path baru | Import change |
| `useContractRead` | `useReadContract` | Hook rename |
| `useContractWrite` | `useWriteContract` | Hook rename |
| `usePrepareContractWrite` | Dihapus, logika dimerge | API removal |
| `chain.id` comparison patterns | `chainId` unification | Pattern change |
| `WagmiConfig` | `WagmiProvider` | Component rename |
| Config setup | `createConfig` baru | Config restructure |

### Target Ukuran: **L ($400)**
Dengan tambahan case study ($200) dan potensi adopsi resmi dari wagmi team = total bisa **$600–$2,400**

### Repo untuk Testing
- `scaffold-eth/scaffold-eth-2`
- `rainbow-me/rainbowkit` (contoh penggunaan)
- Berbagai DApp frontend di GitHub

---

## Ide 3: web3.py v6 → v7 Python Migration Recipe

**Detail:** ./ide-3-web3py-v6-ke-v7.md

### Deskripsi
Codemod untuk ekosistem Python: migrasi `web3.py` dari v6 ke v7 — library utama untuk interaksi dengan Ethereum di Python, dipakai oleh backend engineer, data scientist, dan script automation di DeFi.

### Mengapa Ini Pilihan Kuat
- Satu-satunya pilihan Python di daftar — **persaingan lebih sedikit**
- `web3.py` dipakai di ribuan script backend, bot trading, dan tooling DeFi
- v6 → v7 membawa perubahan besar: async-first, type hints diperketat, middleware stack baru
- Segmen Python di hackathon ini kemungkinan paling sedikit pesaingnya

### Perubahan Utama yang Diotomatisasi
| v6 | v7 | Jenis |
|---|---|---|
| `web3.eth.getBalance(addr)` | `web3.eth.get_balance(addr)` | Method naming (snake_case) |
| `w3.toWei(1, 'ether')` | `Web3.to_wei(1, 'ether')` | Static method move |
| `w3.fromWei(x, 'ether')` | `Web3.from_wei(x, 'ether')` | Static method move |
| Sync provider patterns | Async-first patterns | Async migration |
| `contract.functions.method().call()` | Updated call patterns | API update |
| Middleware setup | New middleware stack | Config change |

### Target Ukuran: **M ($200)**
Python AST codemod bisa dibangun lebih cepat, ditambah case study ($200) = total **$400**

### Repo untuk Testing
- `vyperlang/vyper` tooling scripts
- Berbagai DeFi Python scripts di GitHub
- `brownie`-based projects yang sedang migrasi

---

## Perbandingan Ketiga Ide

| Aspek | Ide 1: ethers.js v5→v6 | Ide 2: wagmi v1→v2 | Ide 3: web3.py v6→v7 |
|---|---|---|---|
| **Bahasa** | TypeScript/JS | TypeScript/JS (React) | Python |
| **Popularitas library** | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐ |
| **Kompleksitas migrasi** | Tinggi | Tinggi | Sedang |
| **Estimasi ukuran** | L ($400) | L ($400) | M ($200) |
| **Persaingan peserta** | Sedang | Sedang | Rendah |
| **Potensi adoption** | Tinggi | Tinggi | Sedang |
| **Potensi total** | $600–$2,400 | $600–$2,400 | $400 |

---

## Rekomendasi

**Jika mau potensi prize terbesar:** Pilih **Ide 1 (ethers.js)** atau **Ide 2 (wagmi)** — keduanya dipakai secara masif dan ada jalur menuju framework adoption ($2,000 bonus).

**Jika mau cepat selesai dengan persaingan rendah:** Pilih **Ide 3 (web3.py)** — Python codemod lebih niche, segmen ini kemungkinan sedikit pesaing.

**Strategi optimal:** Mulai dengan **Ide 2 (wagmi)** karena scope-nya lebih terbatas dari ethers.js tapi tetap memiliki dampak besar dan potensi adopsi resmi dari wagmi/viem team.
