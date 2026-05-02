# Repo Ethers v6 — Kandidat (Ide 1)

Dokumen ini berisi 3 repo public yang sudah menggunakan `ethers` v6 (bukan v5) untuk dijadikan repo referensi/perbandingan pola v6, serta sebagai target validasi workflow (build/test) setelah migrasi.

## 3 Repo Terbaik (Ethers v6)

### 1) dappnode/DNP_DAPPMANAGER
- Repo: https://github.com/dappnode/DNP_DAPPMANAGER
- Bukti v6: https://github.com/dappnode/DNP_DAPPMANAGER/pull/2260/files/923fb5f964b3697b260f80052413e1da568e2d34
- Kenapa dipilih:
  - Codebase backend/Node yang cukup production-grade
  - Bagus untuk mengamati pola Provider v6 (`JsonRpcProvider`, request flow, error handling)

### 2) cowprotocol/mevblocker-dune
- Repo: https://github.com/cowprotocol/mevblocker-dune
- Bukti v6: https://github.com/cowprotocol/mevblocker-dune/pull/24/files/eb661bff0a299f5a48aad5492f6b83e2693ac2f8
- Kenapa dipilih:
  - Gaya project scripts/pipeline yang sering memakai utilitas ethers (format/parse units, RPC calls)
  - Cocok untuk menguji hasil migrasi yang menyentuh banyak callsite util/provider

### 3) ant-design/ant-design-web3
- Repo: https://github.com/ant-design/ant-design-web3
- Bukti v6: https://github.com/ant-design/ant-design-web3/commit/f391190ad69c19cb275def63e3dd6e8e53b1620c
- Kenapa dipilih:
  - Library/monorepo dengan workspace & peerDependencies
  - Bagus untuk melihat dampak packaging/import v6 pada library yang dikonsumsi pihak lain

## Cara Pakai Repo v6 Ini dalam Workflow Ide 1

- Repo v6 ini cocok untuk:
  - Referensi pola akhir yang diharapkan setelah migrasi dari v5 → v6
  - Membandingkan style import, penggunaan Provider/Signer, dan utilitas v6
- Repo v6 ini kurang cocok untuk:
  - Mengukur coverage codemod v5 → v6 secara end-to-end (karena baseline-nya bukan v5)

Jika butuh repo uji utama untuk codemod v5 → v6, pilih minimal 2–3 repo yang masih memakai ethers v5, jalankan codemod sampai repo tersebut benar-benar upgrade ke v6, lalu verifikasi build/test.
