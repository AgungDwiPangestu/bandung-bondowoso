# PortalDot Online S1 — Hackathon Overview

**Platform:** DoraHacks  
**Link:** https://dorahacks.io/hackathon/boring-ai/detail

## Link Terkait

- Apa itu hackathon? https://guide.mlh.io/overview/why-organize-a-hackathon
- Aturan kompetisi (contoh standar): https://github.com/MLH/mlh-policies/blob/main/standard-hackathon-rules.md
- Cari hackathon lain (MLH): https://mlh.io/events
- Cari hackathon lain (Devpost): https://devpost.com/
- Direktori hackathon: https://www.hackathon.com/
- Inspirasi proyek & referensi: https://github.com/topics/hackathon

---

## Tentang Hackathon Ini

Hackathon ini berfokus pada satu masalah nyata yang dihadapi setiap tim engineering: **pemeliharaan software yang lambat dan menyita waktu**.

Setiap upgrade library, refactor, atau migrasi bisa memakan waktu berhari-hari bahkan berminggu-minggu. Tujuan hackathon ini adalah mengubah itu dengan cara:

- Menggunakan **AI + codemods** untuk mengotomatisasi pemeliharaan software
- Mengubah migrasi yang kompleks menjadi workflow yang cepat dan andal
- Membangun tools yang bisa dipakai tim di production

Di akhir hackathon, targetnya bukan sekadar “jadi project”, tapi menghasilkan workflow migrasi yang production-grade: **codemod deterministik** menangani mayoritas perubahan dengan cepat dan reliabel, lalu **AI** menutup edge cases, dan semuanya terbukti jalan di repo dunia nyata.

Kamu juga akan belajar **Codemod open-source toolkit** (dipakai oleh Node.js, React, Express, React Router, Nuxt.js, pnpm, Webpack, MSW, i18next, dan lainnya) dan menjadikannya “superpower” untuk kariermu.

---

## Yang Harus Dibangun

1. Pilih migrasi nyata dari daftar yang sudah disetujui
2. Bangun codemods untuk mengotomatisasinya
3. Gunakan AI untuk menangani edge cases
4. Buktikan bahwa ia bekerja di repository nyata

**Target:** Otomatisasi 80%+ dari migrasi tersebut, meminimalkan pekerjaan manual, dan cukup andal untuk tim nyata.

---

## Tool yang Digunakan

- **Codemod toolkit** (open-source, dipakai oleh Node.js, React, Express, React Router, Nuxt.js, pnpm, Webpack, MSW, i18next, dll.)
- Gunakan **`jssg`** untuk mendeteksi dan melakukan migrasi — **BUKAN `jscodeshift`**
- Publish ke **Codemod Registry** setelah selesai

---

## Daftar Migrasi yang Disetujui

### TypeScript / JavaScript
| Migrasi | Referensi |
|---|---|
| `@solana/web3.js` v1 → `@solana/kit` | Docs · Announcement |
| `ethers.js` v5 → v6 (full recipe) | Migration Guide |
| `wagmi` v1 → v2 | Migration Guide |

### Python
| Migrasi | Referensi |
|---|---|
| Brownie → Ape Framework | Ape Docs |
| `web3.py` v6 → v7 | Migration Guide |

### Rust / Config
| Migrasi | Referensi |
|---|---|
| Anchor IDL v0 → v1 (JSON schema migration) | — |
| Anchor v0.29 → v0.30 Rust API changes | Changelog |

> **Catatan:** Jika codemods resmi sudah ada (contoh: React v18 → v19), pilih yang lain.

---

## Hadiah (Prizes)

### Total: hingga $3,000 per peserta terbaik

#### 1. Production-grade Migration Recipes
| Ukuran | Estimasi Waktu | Hadiah |
|---|---|---|
| S | ~2 hari | $100 |
| M | ~1 minggu | $200 |
| L | ~2 minggu | $400 |
| XL | 2+ minggu | $800 |

#### 2. Public Case Studies
- **$200** per case study yang dipublikasikan
- Isi: pendekatan migrasi, % cakupan otomatisasi, AI vs manual effort, dan dampak nyata

#### 3. Official Framework Adoption
- Hingga **$2,000** per adopsi sukses
- Syarat: framework maintainer meng-host codemod di org mereka atau mereferensikannya di upgrade guide resmi

---

## Kriteria Penilaian

### Kriteria Utama
- **Accuracy:** Nol perubahan yang salah (false positives)
- **Coverage:** Seberapa banyak migrasi yang diotomatisasi
- **Reliability:** Bekerja di berbagai repository nyata, bukan hanya satu test case

### Proses Evaluasi
1. Codemod dijalankan di repository nyata dan commit perubahan
2. AI agent menangani edge cases yang tersisa
3. Fix manual (jika perlu) sampai build dan test lulus

### Formula Skor
```
Score = 100 × (1 − ((FP × wFP) + (FN × wFN)) ÷ (N × (wFP + wFN)))
```
- **FP (False Positives):** Perubahan yang salah — penalti besar
- **FN (False Negatives):** Pola yang terlewat — penalti lebih kecil
- **N:** Total pola di repo
- **w_fp / w_fn:** Bobot penalti

### Checklist Submission
- [ ] Berhasil dijalankan di repo nyata
- [ ] Menyertakan tests (kredit penuh jika ada)
- [ ] Semua tests lulus
- [ ] Perubahan deterministik memiliki nol false positives
- [ ] Mencakup sebanyak mungkin pola, menyisakan edge cases untuk AI

---

## Standar Kualitas Terbaik

- 80–95% dari migrasi terotomatisasi
- Nol false positives
- Bekerja di berbagai repository nyata
- Minimal cleanup oleh AI dan manual
- Tests dan dokumentasi yang jelas

---

## Quickstart

1. Pelajari Codemod toolkit
2. Pilih migrasi dari daftar yang disetujui
3. Cek registry — pastikan belum ada
4. Bangun codemod workflow di repository sendiri
5. Test di project open-source nyata
6. Publish codemod ke registry (panduan tersedia)

---

## Kenapa Ini Penting

Setiap perusahaan kesulitan dengan maintenance: dependency upgrade, API changes, dan refactor besar. Ini problem besar yang masih belum “beres”.

Kalau kamu berhasil bikin migrasi yang benar-benar andal, kamu bukan cuma bikin proyek hackathon — kamu sedang membangun infrastruktur yang dibutuhkan banyak tim engineering. Codemod kamu bisa jadi jalur migrasi default yang dipakai ribuan developer.
