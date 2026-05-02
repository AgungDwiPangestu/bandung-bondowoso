# Fokus Proyek: ethers.js v5 → v6 Migration Workflow

Dokumen ini sekarang difokuskan penuh ke **satu implementasi utama**: migrasi `ethers.js` dari v5 ke v6 menggunakan **codemod workflow** yang sesuai kriteria hackathon.

**Dokumen detail:** `./ide-1-ethers-v5-ke-v6.md`

---

## Tujuan

Membangun workflow migrasi yang:

- memakai **codemod deterministik** untuk perubahan yang aman
- memakai **AI/manual step** hanya untuk edge cases
- terbukti jalan di **repo nyata**
- cukup andal untuk dipakai ulang di banyak project

---

## Kenapa Fokus ke ethers.js

- `ethers.js` dipakai luas di ekosistem Web3
- migrasi v5 → v6 cukup menyakitkan dan bernilai tinggi untuk diotomatisasi
- ada peluang kuat untuk memenuhi target hackathon:
  - **80%+ otomatisasi**
  - **zero false positives**
  - **reliability di repo nyata**

---

## Scope Awal Implementasi

Fase pertama hanya menangani transformasi yang aman dan jelas:

- `ethers.utils.*` → `ethers.*`
- `ethers.providers.JsonRpcProvider` → `ethers.JsonRpcProvider`
- normalisasi import `ethers` agar transform konsisten
- report untuk kasus yang tidak aman diubah otomatis

Kasus berikut **tidak** akan diubah otomatis di fase awal:

- `BigNumber` → `BigInt`
- perubahan async flow
- perubahan yang menyentuh tooling/build config

---

## Deliverables

- satu package codemod berbasis `jssg`
- satu `workflow.yaml` untuk menjalankan migrasi
- fixture tests untuk before/after transform
- report hasil migrasi + daftar edge cases
- dokumentasi cara run di repo target

---

## Target Verifikasi

- codemod bisa dijalankan dengan `--dry-run`
- run kedua harus no-op atau hampir no-op
- minimal 1 repo nyata berhasil dimigrasi
- build/tests repo target lulus setelah codemod + fix edge cases

---

## Langkah Berikutnya

Setelah rapih di dokumentasi, implementasi akan bergerak ke urutan ini:

1. pilih repo target `ethers` v5
2. scaffold package codemod
3. implement transform AST yang deterministik
4. buat output report untuk edge cases
5. uji di repo nyata
6. rapikan dokumentasi dan case study
