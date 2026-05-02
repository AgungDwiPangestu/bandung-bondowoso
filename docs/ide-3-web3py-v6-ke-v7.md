# Ide 3 — web3.py v6 → v7 (Python Migration Recipe)

**Target:** Codemod Python untuk membantu upgrade `web3.py` dari v6 ke v7, dengan fokus pada perubahan API yang bisa diubah deterministik (rename/symbol move) dan eskalasi kasus async/behavioral ke AI/manual.

**Referensi utama:** Migration Guide resmi web3.py (v6 → v7).

---

## Output yang Diharapkan

- Codemod berbasis AST Python yang mengubah pola API yang jelas (snake_case changes, pemindahan static methods).
- Laporan hasil: apa yang sudah diubah deterministik + daftar lokasi yang butuh refactor async/manual.
- Bukti jalan di repo nyata (minimal 1–2 repo) dengan tests/build lulus bila tersedia.
- Dokumentasi mapping perubahan + checklist verifikasi.

---

## Kenapa Ide Ini Kuat

- Satu-satunya jalur Python di daftar ide: kompetisi biasanya lebih rendah.
- Banyak tooling/bot/script DeFi memakai web3.py dan sering tidak punya bandwidth untuk migrasi besar.
- Banyak perubahan v6→v7 berupa rename yang cocok untuk codemod.

---

## Fokus Migrasi (Scope yang Praktis)

- Rename method ke snake_case yang jelas.
- Pindahkan pemanggilan util yang menjadi static method di `Web3`.
- Hindari “memaksa” migrasi sync → async secara otomatis kecuali benar-benar aman.

---

## Peta Perubahan Utama (Contoh Pola)

| v6 | v7 | Strategi |
|---|---|---|
| `web3.eth.getBalance(addr)` | `web3.eth.get_balance(addr)` | Deterministik (rename) |
| `w3.toWei(1, "ether")` | `Web3.to_wei(1, "ether")` | Deterministik (symbol move) |
| `w3.fromWei(x, "ether")` | `Web3.from_wei(x, "ether")` | Deterministik (symbol move) |
| Sync provider patterns | Async-first patterns | Jangan auto; tandai “needs async refactor” |

---

## Deteksi & Transformasi (Breakdown Implementasi)

### 1) Rename di `web3.eth.*`

Transformasi AST-level (call expr):
- Jika menemukan `X.eth.getBalance(...)`, ubah menjadi `X.eth.get_balance(...)`.

Untuk menjaga zero false positives:
- Pastikan `X` adalah instance yang diimport/dibuat dari `Web3` atau variabel yang jelas berasal dari `Web3` (best-effort).
- Kalau tidak yakin, masukkan ke laporan sebagai “candidate”.

### 2) Pemindahan `toWei/fromWei`

Pola yang sering muncul:
- `w3.toWei(...)` dan `w3.fromWei(...)`

Strategi:
- Ubah jadi `Web3.to_wei(...)` dan `Web3.from_wei(...)`.
- Pastikan `Web3` tersedia (diimport) atau tambahkan import bila aman (tetap tanpa mengubah style import yang sudah ada).

### 3) Middleware & Provider (Report-first)

Bagian ini biasanya sangat spesifik ke app.

- Codemod mendeteksi pemakaian API middleware/provider yang berubah.
- Jangan auto-refactor; keluarkan daftar lokasi untuk AI/manual dengan rekomendasi langkah.

---

## Edge Cases (Diserahkan ke AI)

- Migrasi sync → async: perlu keputusan arsitektur (event loop, framework, concurrency).
- Perubahan tipe/return yang berdampak ke serialization JSON / database / logging.
- Penyesuaian contract call patterns yang bergantung ke versi ABI/codec.

---

## Strategi Testing & Validasi

- Jalankan codemod dua kali (idempotent).
- Jalankan minimal:
  - lint/format (kalau ada)
  - unit tests (kalau ada)
  - minimal satu script smoke test yang memanggil node RPC / provider dummy

---

## Repo Kandidat untuk Uji (Contoh)

- Repo Python yang punya script DeFi / data pipeline berbasis web3.py
- Tooling Vyper/Brownie ecosystem yang relevan (yang masih memakai web3.py v6)

Pilih repo yang:
- punya minimal test suite atau runnable scripts
- punya variasi pemakaian `web3.eth.*` dan util conversions

---

## Checklist Submission (Khusus Ide Ini)

- Codemod menangani rename utama yang sering muncul (coverage tinggi untuk pola rename).
- Tidak ada perubahan yang ambigu dipaksa otomatis.
- Ada laporan lokasi yang butuh refactor async/manual, plus arahan AI yang jelas.
- Ada bukti jalan di repo nyata dan perubahan deterministik dominan.
