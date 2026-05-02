# ethers.js v5 -> v6 Codemod Workflow

Workflow ini adalah paket awal untuk hackathon yang fokus ke migrasi `ethers.js` v5 -> v6 dengan prinsip:

- hanya mengubah pola yang aman dan deterministik
- menghindari false positives
- siap dipakai sebagai fondasi workflow production-grade

## Scope v1

Workflow ini saat ini hanya mengotomatisasi pola yang aman:

- `ethers.utils.parseEther(...)` -> `ethers.parseEther(...)`
- `ethers.utils.parseUnits(...)` -> `ethers.parseUnits(...)`
- `ethers.utils.formatEther(...)` -> `ethers.formatEther(...)`
- `ethers.utils.formatUnits(...)` -> `ethers.formatUnits(...)`
- `ethers.utils.id(...)` -> `ethers.id(...)`
- `ethers.utils.getAddress(...)` -> `ethers.getAddress(...)`
- `ethers.utils.isAddress(...)` -> `ethers.isAddress(...)`
- `ethers.utils.keccak256(...)` -> `ethers.keccak256(...)`
- `new ethers.providers.JsonRpcProvider(...)` -> `new ethers.JsonRpcProvider(...)`

## Belum Diotomatisasi

Bagian berikut sengaja belum diubah otomatis karena berisiko mengubah behavior:

- `BigNumber` -> `BigInt`
- `Web3Provider` -> `BrowserProvider`
- flow async seperti `waitForDeployment()`
- perubahan ESM/CJS dan config build
- alias import `ethers` yang tidak memakai bentuk standar

## Struktur

```text
codemods/ethers-v5-to-v6/
├── README.md
├── codemod.yaml
├── workflow.yaml
├── scripts/
│   └── codemod.ts
└── tests/
    └── fixtures/
        ├── input.ts
        └── expected.ts
```

## Cara Menjalankan

### 1. Validasi workflow

```bash
npx codemod workflow validate -w ./codemods/ethers-v5-to-v6/workflow.yaml
```

### 2. Dry-run ke repo target

```bash
npx codemod workflow run -w ./codemods/ethers-v5-to-v6/workflow.yaml -t ../target-repo --dry-run
```

### 3. Terapkan ke repo target

```bash
npx codemod workflow run -w ./codemods/ethers-v5-to-v6/workflow.yaml -t ../target-repo
```

### 4. Tes cepat transform lokal

```bash
npx codemod jssg run ./codemods/ethers-v5-to-v6/scripts/codemod.ts ./codemods/ethers-v5-to-v6/tests/fixtures/input.ts --language typescript
```

## Cara Pakai dengan Repo Referensi di Repo Ini

Gunakan daftar repo v5 sebagai target uji utama:

- [ethersjs-v5-projects.md](file:///e:/smweb/bandung-bondowoso/etherjs-v5/ethersjs-v5-projects.md)

Gunakan daftar repo v6 sebagai referensi pola hasil akhir:

- [repo-ethers-v6.md](file:///e:/smweb/bandung-bondowoso/repo%20ethers%20v6/repo-ethers-v6.md)

## Target Hackathon

Supaya memenuhi kriteria hackathon, workflow ini harus dikembangkan lanjut ke tahap berikut:

1. tambah coverage transform yang tetap aman
2. buat report untuk edge cases
3. uji di minimal 1-3 repo nyata
4. pastikan build/tests lulus
5. jalankan codemod dua kali dan pastikan run kedua no-op atau hampir no-op
