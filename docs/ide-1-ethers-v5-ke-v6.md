# Ide 1 — ethers.js v5 → v6 (Full Migration Recipe)

**Target:** Production-grade migration workflow untuk repo TypeScript/JavaScript yang masih memakai `ethers` v5 agar bisa upgrade ke v6 dengan perubahan deterministik (codemod) + penanganan edge cases via AI.

**Referensi utama:** Migration Guide resmi ethers.js (v5 → v6).

---

## Output yang Diharapkan

- Satu codemod yang bisa dijalankan berulang (idempotent) untuk mengubah pola-pola v5 ke v6.
- Instruksi AI yang jelas untuk edge cases yang tidak aman/ambigu untuk diubah deterministik.
- Bukti jalan di beberapa repo dunia nyata (PR/commit), termasuk build dan tests lulus.
- Dokumentasi: apa yang diubah, apa yang tidak diubah, dan cara verifikasi.

---

## Kenapa Ide Ini Kuat

- `ethers` adalah dependency inti di banyak proyek Ethereum/Web3.
- Migrasi v5 → v6 terkenal “painful” karena banyak perubahan API dan perubahan packaging (ESM).
- Dampaknya besar: sekali bagus, bisa dipakai lintas repo dan berpotensi direferensikan komunitas/maintainer.

---

## Fokus Migrasi (Scope yang Praktis)

Migrasi v5 → v6 luas. Supaya realistis dan bisa lulus kriteria “zero false positives”, scope awal yang biasanya paling bernilai:

- Flatten namespace `ethers.utils.*` → `ethers.*` untuk fungsi utilitas yang jelas.
- Rename class/provider yang eksplisit dan punya mapping yang kuat.
- Perubahan import dan pola penggunaan yang bisa dipastikan dari AST.
- Menandai (bukan memaksa mengubah) kasus yang butuh keputusan developer (contoh: BigNumber → BigInt).

---

## Peta Perubahan Utama (Contoh Pola)

| Pola v5 | Target v6 | Strategi |
|---|---|---|
| `ethers.utils.parseEther(x)` | `ethers.parseEther(x)` | Deterministik |
| `ethers.utils.formatEther(x)` | `ethers.formatEther(x)` | Deterministik |
| `ethers.utils.id(x)` | `ethers.id(x)` | Deterministik |
| `ethers.utils.getAddress(x)` | `ethers.getAddress(x)` | Deterministik |
| `new ethers.providers.JsonRpcProvider(url)` | `new ethers.JsonRpcProvider(url)` | Deterministik (rename namespace) |
| `new ethers.providers.Web3Provider(p)` | `new ethers.BrowserProvider(p)` | Deterministik (rename + beda semantics, butuh verifikasi) |
| `ethers.BigNumber.from(x)` | `BigInt(x)` / alternatif | Jangan auto; jadikan “needs review” |
| `ContractFactory.deploy()` | `deploy()` + `waitForDeployment()` | Semi-deterministik; butuh konteks `await` |

Catatan: Table ini contoh; daftar final sebaiknya mengikuti apa yang paling sering muncul di repo target.

---

## Deteksi & Transformasi (Breakdown Implementasi)

### 1) Import/Namespace Normalization

Tujuan: memastikan codemod bisa mengenali referensi `ethers` dengan benar.

- Deteksi variasi import:
  - `import { ethers } from "ethers"`
  - `import * as ethers from "ethers"`
  - `const { ethers } = require("ethers")` (kalau target repo masih CJS)
- Normalisasi internal representation: “identifier mana yang dianggap ethers namespace”.

### 2) Flatten `ethers.utils.*`

Transformasi aman karena:
- Nama function di v6 memang dipromosikan ke top-level.
- Panggilan function biasanya tidak perlu konteks tambahan.

Contoh transformasi deterministik:
- `ethers.utils.parseUnits(a, b)` → `ethers.parseUnits(a, b)`

### 3) `ethers.providers.*` → `ethers.*Provider`

Deteksi instansiasi provider:
- `new ethers.providers.JsonRpcProvider(...)` → `new ethers.JsonRpcProvider(...)`

Perhatikan:
- Provider tertentu berubah kelasnya (contoh Web3Provider → BrowserProvider) dan bisa berdampak pada async behavior. Tetap bisa diubah otomatis, tapi wajib ada checklist verifikasi.

### 4) Contract/Signer Patterns (Optional tahap lanjut)

Ini biasanya paling tricky karena menyentuh flow async.

- Ubah pola yang jelas dan terisolasi.
- Kalau butuh menyisipkan `await`/`waitForDeployment()`, pastikan berada di fungsi `async` dan ada `await` chain yang konsisten; kalau tidak aman, tandai untuk AI/manual.

---

## Edge Cases (Diserahkan ke AI)

Gunakan AI untuk kasus yang butuh pemahaman konteks:

- BigNumber → BigInt (butuh audit overflow/format/compat).
- Perubahan return type yang berdampak ke arithmetic atau serialization.
- Pindah ke ESM-only (repo CJS) dan konfigurasi tooling/build.

Format keluaran yang enak untuk AI:
- Kumpulkan lokasi file + potongan kode minimal + alasan “tidak aman di-auto-fix”.
- Berikan instruksi: “jangan ubah behavior”, “buat tests”, “pastikan build lulus”.

---

## Strategi Testing & Validasi

- Jalankan codemod dua kali: hasil run kedua harus no-op (idempotent).
- Verifikasi “zero false positives”:
  - Transformasi hanya berlaku saat AST match kuat (bukan text replace).
  - Hindari mengubah identifier yang kebetulan bernama sama tapi bukan `ethers`.
- Uji minimal di 2–3 repo yang berbeda gaya kodenya:
  - repo React/Next
  - repo Node backend / scripts
  - repo library/package

---

## Repo Kandidat untuk Uji (Contoh)

- scaffold-eth project
- Uniswap interface / contoh dApp populer
- repo open-source yang pinned ke ethers v5

Pilih repo yang:
- punya tests, atau minimal build step yang jelas
- cukup besar untuk mengandung variasi pattern

---

## Checklist Submission (Khusus Ide Ini)

- Codemod deterministik menutup pattern paling umum (target 80%+ untuk repo yang diuji).
- Ada daftar pattern yang sengaja tidak diubah otomatis, plus alasan.
- Ada “AI instructions” untuk edge cases + bukti AI dipakai untuk menyelesaikan sisa perubahan.
- Ada minimal satu case study ringkas: sebelum/after, coverage %, dan risiko yang dihindari.
