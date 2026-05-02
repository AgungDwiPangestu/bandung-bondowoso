# ethers.js v5 -> v6 Codemod Workflow

Workflow ini adalah fondasi migrasi `ethers.js` v5 -> v6 yang diarahkan ke standar hackathon:

- transform **deterministik** dulu
- hindari **false positives**
- scan hanya **source files**
- sediakan **audit/report** untuk edge cases yang belum aman di-auto-fix

## Cocok Untuk Siapa

Workflow ini cocok untuk:

- maintainer open-source yang ingin bantu user upgrade ke `ethers` v6
- peserta hackathon yang butuh bukti migrasi nyata di repo publik
- developer yang mau automasi migrasi aman sebelum masuk ke fix manual/AI

## Prasyarat

Sebelum menjalankan workflow, siapkan:

- `Node.js` dan `npx`
- `git`
- terminal shell biasa
- `PowerShell` untuk audit report

Jalankan semua command dari **root repo ini**, kecuali kalau disebut lain.

## Scope Aman Saat Ini

Workflow inti saat ini hanya me-rewrite pola whitelist yang aman:

- `ethers.utils.parseEther` -> `ethers.parseEther`
- `ethers.utils.parseUnits` -> `ethers.parseUnits`
- `ethers.utils.formatEther` -> `ethers.formatEther`
- `ethers.utils.formatUnits` -> `ethers.formatUnits`
- `ethers.utils.id` -> `ethers.id`
- `ethers.utils.getAddress` -> `ethers.getAddress`
- `ethers.utils.isAddress` -> `ethers.isAddress`
- `ethers.utils.keccak256` -> `ethers.keccak256`
- `ethers.providers.JsonRpcProvider` -> `ethers.JsonRpcProvider`
- `ethers.providers.JsonRpcBatchProvider` -> `ethers.JsonRpcBatchProvider`
- `ethers.providers.WebSocketProvider` -> `ethers.WebSocketProvider`
- `ethers.providers.StaticJsonRpcProvider` -> `ethers.StaticJsonRpcProvider`
- `ethers.providers.FallbackProvider` -> `ethers.FallbackProvider`
- `ethers.providers.AlchemyProvider` -> `ethers.AlchemyProvider`
- `ethers.providers.InfuraProvider` -> `ethers.InfuraProvider`
- `ethers.providers.EtherscanProvider` -> `ethers.EtherscanProvider`

## Belum Diotomatisasi

Pola berikut **tidak** diubah otomatis dan harus masuk audit:

- `ethers.providers.Web3Provider` -> `ethers.BrowserProvider`
- `BigNumber` -> `BigInt`
- deploy flow yang mungkin butuh `waitForDeployment()`
- ESM/CJS dan perubahan tooling/build
- pola `ethers.utils.*` yang belum ada di whitelist

## File yang Diproses

Workflow hanya memproses:

- `**/*.js`
- `**/*.jsx`
- `**/*.ts`
- `**/*.tsx`

Workflow mengecualikan:

- `**/node_modules/**`
- `**/artifacts/**`
- `**/cache/**`
- `**/.git/**`

## Struktur

```text
codemods/ethers-v5-to-v6/
├── README.md
├── codemod.yaml
├── workflow.yaml
├── scripts/
│   ├── codemod.ts
│   └── audit-edge-cases.ps1
└── tests/
    └── fixtures/
        ├── input.ts
        ├── expected.ts
        ├── input.js
        └── expected.js
```

## Run Workflow

## Quickstart Publik

Kalau kamu baru pertama pakai, alur paling aman:

1. clone repo target v5 ke folder terpisah
2. validate workflow
3. dry-run
4. apply
5. cek `git diff`
6. jalankan audit edge cases
7. lanjut ke compile/build/test repo target

### 1. Validasi workflow

```bash
npx codemod workflow validate -w "./codemods/ethers-v5-to-v6/workflow.yaml"
```

### 2. Dry-run

```bash
npx codemod workflow run -w "./codemods/ethers-v5-to-v6/workflow.yaml" -t "./targets/alchemy-goerli-sample-demo" --dry-run
```

### 3. Apply

```bash
npx codemod workflow run -w "./codemods/ethers-v5-to-v6/workflow.yaml" -t "./targets/alchemy-goerli-sample-demo"
```

### 4. Cek perubahan

```bash
git -C ./targets/alchemy-goerli-sample-demo status --short
git -C ./targets/alchemy-goerli-sample-demo diff
```

## Run Audit untuk Edge Cases

Setelah codemod apply, jalankan audit untuk pola yang belum aman diubah otomatis:

```bash
powershell -ExecutionPolicy Bypass -File "./codemods/ethers-v5-to-v6/scripts/audit-edge-cases.ps1" -TargetPath "./targets/alchemy-goerli-sample-demo"
```

Output report akan dibuat di repo target:

- `codemod-reports/ethers-v5-to-v6-edge-cases.md`
- `codemod-reports/ethers-v5-to-v6-edge-cases.json`

## Test Local Fixtures

### JavaScript fixture

```bash
npx codemod jssg run ./codemods/ethers-v5-to-v6/scripts/codemod.ts ./codemods/ethers-v5-to-v6/tests/fixtures/input.js --language javascript
```

### TypeScript fixture

```bash
npx codemod jssg run ./codemods/ethers-v5-to-v6/scripts/codemod.ts ./codemods/ethers-v5-to-v6/tests/fixtures/input.ts --language typescript
```

## Minimum Production-Grade Checklist

- Workflow valid
- Source-only scan
- Transform deterministik dengan whitelist
- Repo target fresh clone
- Dry-run sukses
- Apply sukses
- `git diff` menunjukkan perubahan yang relevan
- Audit edge cases menghasilkan report
- Repo target diverifikasi dengan compile/build/test jika tersedia
- Uji di lebih dari satu repo nyata

## Referensi Tambahan

- Demo presentasi: [demo-workflow-ethers-v5-ke-v6.md](file:///e:/smweb/bandung-bondowoso/docs/demo-workflow-ethers-v5-ke-v6.md)
- Daftar repo v5: [ethersjs-v5-projects.md](file:///e:/smweb/bandung-bondowoso/docs/etherjs-v5/ethersjs-v5-projects.md)
- Referensi pola v6: [repo-ethers-v6.md](file:///e:/smweb/bandung-bondowoso/docs/repo%20ethers%20v6/repo-ethers-v6.md)
