# ethers.js v5 -> v6 Migration Workflow

Repo ini berisi workflow codemod untuk membantu migrasi `ethers.js` dari v5 ke v6 dengan pendekatan:

- **deterministik dulu**
- **source-only**
- **whitelist-based**
- **audit/report** untuk edge cases

Targetnya bukan sekadar demo satu kali, tapi workflow yang bisa dipakai ulang di banyak repo publik.

## Mulai Dari Mana

- Quickstart teknis: [README codemod](file:///e:/smweb/bandung-bondowoso/codemods/ethers-v5-to-v6/README.md)
- Demo step-by-step: [demo-workflow-ethers-v5-ke-v6.md](file:///e:/smweb/bandung-bondowoso/docs/demo-workflow-ethers-v5-ke-v6.md)
- Konteks ide dan scope: [ide-proyek.md](file:///e:/smweb/bandung-bondowoso/docs/ide-proyek.md)

## Yang Sudah Didukung

Workflow saat ini aman untuk subset pattern berikut:

- `ethers.utils.parseEther` -> `ethers.parseEther`
- `ethers.utils.parseUnits` -> `ethers.parseUnits`
- `ethers.utils.formatEther` -> `ethers.formatEther`
- `ethers.utils.formatUnits` -> `ethers.formatUnits`
- `ethers.utils.id` -> `ethers.id`
- `ethers.utils.getAddress` -> `ethers.getAddress`
- `ethers.utils.isAddress` -> `ethers.isAddress`
- `ethers.utils.keccak256` -> `ethers.keccak256`
- `ethers.providers.JsonRpcProvider` -> `ethers.JsonRpcProvider`
- `ethers.providers.AlchemyProvider` -> `ethers.AlchemyProvider`
- `ethers.providers.InfuraProvider` -> `ethers.InfuraProvider`
- `ethers.providers.EtherscanProvider` -> `ethers.EtherscanProvider`
- `ethers.providers.WebSocketProvider` -> `ethers.WebSocketProvider`
- `ethers.providers.StaticJsonRpcProvider` -> `ethers.StaticJsonRpcProvider`
- `ethers.providers.JsonRpcBatchProvider` -> `ethers.JsonRpcBatchProvider`
- `ethers.providers.FallbackProvider` -> `ethers.FallbackProvider`

## Yang Belum Diubah Otomatis

Bagian berikut sengaja tidak di-auto-fix:

- `ethers.providers.Web3Provider` -> `ethers.BrowserProvider`
- `BigNumber` -> `BigInt`
- deploy flow yang mungkin butuh `waitForDeployment()`
- perubahan ESM/CJS dan config build
- pola `ethers.utils.*` yang belum ada di whitelist

## Syarat Minimal

- `Node.js` dan `npx`
- `git`
- akses internet untuk install `codemod` via `npx`
- terminal yang bisa menjalankan command shell biasa
- untuk audit script: `PowerShell`

## Struktur Repo

```text
.
├── codemods/
│   └── ethers-v5-to-v6/
├── docs/
│   ├── demo-workflow-ethers-v5-ke-v6.md
│   ├── etherjs-v5/
│   └── repo ethers v6/
├── README.md
└── push.sh
```

## Target Repo Referensi

- Repo v5 untuk target uji: [ethersjs-v5-projects.md](file:///e:/smweb/bandung-bondowoso/docs/etherjs-v5/ethersjs-v5-projects.md)
- Repo v6 untuk pola hasil akhir: [repo-ethers-v6.md](file:///e:/smweb/bandung-bondowoso/docs/repo%20ethers%20v6/repo-ethers-v6.md)

## Status Saat Ini

Workflow ini sudah:

- lolos validasi workflow
- terbukti apply bersih di repo target nyata pertama
- hanya menyentuh source file, bukan `node_modules`
- menghasilkan report edge cases untuk langkah manual/AI

## Next Step untuk Public User

1. buka [README codemod](file:///e:/smweb/bandung-bondowoso/codemods/ethers-v5-to-v6/README.md)
2. clone satu repo `ethers` v5 dari daftar referensi
3. jalankan validate -> dry-run -> apply -> audit
4. cek `git diff`
5. lanjutkan compile/build/test repo target
