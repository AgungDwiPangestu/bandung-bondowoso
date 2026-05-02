# Ide 2 — wagmi v1 → v2 (Full Migration Recipe)

**Target:** Codemod untuk memigrasikan project React yang memakai `wagmi` v1 ke `wagmi` v2 dengan perubahan deterministik untuk hal-hal yang aman, dan eskalasi edge cases ke AI/manual.

**Referensi utama:** Migration Guide resmi wagmi (v1 → v2).

---

## Output yang Diharapkan

- Codemod yang menangani rename hooks, perubahan import path, dan perubahan konfigurasi yang bisa dipastikan.
- “AI playbook” untuk kasus yang butuh konteks aplikasi (contoh: perubahan behavior, dependency seperti `viem`, atau penyesuaian config).
- Bukti jalan di repo dunia nyata (commit/PR), minimal 1–2 aplikasi React.
- Dokumentasi mapping v1→v2 + checklist verifikasi.

---

## Kenapa Ide Ini Kuat

- `wagmi` adalah standar de-facto untuk React + Web3 di banyak dApp.
- Migrasi v2 adalah rewrite besar; banyak tim menunda karena memakan waktu.
- Pattern API v1→v2 cukup terstruktur (banyak rename) sehingga cocok untuk codemod deterministik.

---

## Fokus Migrasi (Scope yang Praktis)

- Rename hooks yang punya mapping 1:1.
- Update import yang bisa dipastikan dari AST.
- Update komponen provider/config pada kasus standar.
- Pastikan transformasi tidak menyentuh logika bisnis custom yang ambigu.

---

## Peta Perubahan Utama (Contoh Pola)

| v1 | v2 | Strategi |
|---|---|---|
| `useContractRead` | `useReadContract` | Deterministik (rename) |
| `useContractWrite` | `useWriteContract` | Deterministik (rename) |
| `usePrepareContractWrite` | (dihapus / digabung) | Jangan auto; tandai “needs refactor” |
| `WagmiConfig` | `WagmiProvider` | Deterministik (rename) |
| `configureChains(...)` patterns | `createConfig(...)` patterns | Semi-deterministik; butuh bentuk config |

---

## Deteksi & Transformasi (Breakdown Implementasi)

### 1) Import Graph & Renames

- Temukan import dari `wagmi`:
  - named imports (`import { useAccount } from "wagmi"`)
  - re-export lokal
- Rename identifier yang di-import + semua pemakaiannya (reference-safe).
- Hindari rename kalau identifier sudah dipakai untuk hal lain (shadowing).

### 2) Hooks Rename yang Aman

Transformasi AST-level:
- Identifier import: `useContractRead` → `useReadContract`
- Call sites ikut berubah otomatis karena rename symbol.

### 3) Provider & Config Migration

Untuk repo yang punya pola “standar”, codemod bisa:
- mengganti `WagmiConfig` → `WagmiProvider`
- mendeteksi pemakaian config lama dan menambahkan TODO output (bukan comment di code) berupa laporan file yang perlu ditinjau bila struktur terlalu custom

Karena format config v2 bisa bervariasi antar repo, bagian ini sering lebih aman dibuat “best-effort + report”.

---

## Edge Cases (Diserahkan ke AI)

- Penggantian `usePrepareContractWrite` (perlu refactor arsitektur call flow).
- Integrasi `viem` dan perubahan tipe parameter untuk read/write.
- Perubahan yang mempengaruhi behavior (contoh: chain selection, connectors).

Saran bentuk input ke AI:
- Beri daftar file + lokasi pemakaian API yang deprecated/hilang.
- Sertakan target behavior yang harus tetap sama (contoh: “signature flow”, “switch chain”).

---

## Strategi Testing & Validasi

- Jalankan codemod dua kali (idempotent).
- Jalankan typecheck (TS) dan minimal unit/integration test bila ada.
- Jalankan “happy path” UI yang menyentuh hooks utama:
  - connect wallet
  - read contract
  - write contract (tx)

---

## Repo Kandidat untuk Uji (Contoh)

- scaffold-eth project (umum dipakai untuk contoh dApp)
- dApp React open-source yang memakai wagmi v1

Pilih repo yang punya:
- TypeScript ketat
- minimal satu flow write tx untuk menguji perubahan v2

---

## Checklist Submission (Khusus Ide Ini)

- Mapping hook rename lengkap untuk pattern paling umum.
- Tidak ada perubahan yang ambigu dipaksa otomatis (zero false positives).
- Ada laporan (artifact) yang menyebutkan edge cases dan bagaimana AI menyelesaikannya.
- Ada bukti berjalan lintas repo (lebih dari satu) dan perubahan deterministik dominan.
