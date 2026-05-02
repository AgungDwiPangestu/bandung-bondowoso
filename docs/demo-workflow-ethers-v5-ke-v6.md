# Demo Workflow: ethers.js v5 -> v6

Dokumen ini dipakai untuk **demo ulang** workflow migrasi `ethers.js` v5 -> v6 dengan repo target yang fresh, supaya kelihatan bahwa codemod ini **repeatable**, **deterministik**, dan bisa dipakai ulang di repo lain.

Dokumen ini fokus ke **alur demo publik**, jadi command dibuat sesederhana mungkin dan memakai path relatif dari root repo ini.

---

## Tujuan Demo

Yang ingin ditunjukkan saat demo:

- workflow codemod bisa dijalankan dari repo terpisah
- repo target di-clone fresh
- migrasi terjadi otomatis pada source file yang relevan
- hasil perubahan bisa diverifikasi lewat `git diff`

---

## Folder Penting

- Workflow codemod: `./codemods/ethers-v5-to-v6`
- Repo demo target: `./targets/alchemy-goerli-sample-demo`

---

## Repo Demo yang Dipakai

Repo demo:

- `https://github.com/sangjunlim-dev/alchemy-goerli-sample`

Alasan dipilih:

- kecil dan gampang didemokan
- masih pakai `ethers` v5
- punya pola nyata yang sekarang sudah ditangani workflow:
  - `ethers.providers.AlchemyProvider(...)`

---

## Script Demo Singkat

Jalankan dari root project:

```bash
cd e:/smweb/bandung-bondowoso
```

### 1. Clone repo demo fresh

Kalau folder demo belum ada:

```bash
git clone https://github.com/sangjunlim-dev/alchemy-goerli-sample.git ./targets/alchemy-goerli-sample-demo
```

Kalau folder demo sudah ada dan mau ulang demo dari nol:

```bash
rm -rf ./targets/alchemy-goerli-sample-demo
git clone https://github.com/sangjunlim-dev/alchemy-goerli-sample.git ./targets/alchemy-goerli-sample-demo
```

---

### 2. Validasi workflow

```bash
npx codemod workflow validate -w "./codemods/ethers-v5-to-v6/workflow.yaml"
```

Expected:

- workflow valid
- schema passed

---

### 3. Jalankan dry-run

```bash
npx codemod workflow run -w "./codemods/ethers-v5-to-v6/workflow.yaml" -t "./targets/alchemy-goerli-sample-demo" --dry-run
```

Tujuan:

- membuktikan workflow bisa scan repo target
- belum menulis perubahan ke file

---

### 4. Terapkan codemod

```bash
npx codemod workflow run -w "./codemods/ethers-v5-to-v6/workflow.yaml" -t "./targets/alchemy-goerli-sample-demo"
```

---

### 5. Cek file yang berubah

```bash
git -C ./targets/alchemy-goerli-sample-demo status --short
```

Expected minimal:

```bash
M scripts/interact.js
```

---

### 6. Tampilkan diff hasil migrasi

```bash
git -C ./targets/alchemy-goerli-sample-demo diff -- scripts/interact.js
```

Expected diff utama:

```diff
-const alchemyProvider = new ethers.providers.AlchemyProvider(network="goerli", API_KEY);
+const alchemyProvider = new ethers.AlchemyProvider(network="goerli", API_KEY);
```

---

## Narasi Demo yang Bisa Dipakai

Contoh narasi singkat saat presentasi:

1. "Ini workflow codemod terpisah dari repo target, jadi bisa dipakai ulang."
2. "Aku clone repo ethers v5 yang fresh."
3. "Workflow divalidasi dulu."
4. "Aku dry-run untuk memastikan scan jalan."
5. "Aku apply codemod ke repo target."
6. "Hasilnya hanya source file yang relevan yang berubah."
7. "Diff menunjukkan migrasi namespace provider dari v5 ke v6 dilakukan otomatis."

---

## Poin Penting untuk Ditekankan

- Workflow ini **bukan edit manual**
- Workflow ini **repeatable**
- Workflow ini **lebih aman** karena sekarang tidak menyentuh `node_modules`
- Workflow ini **bisa diperluas** untuk pattern migrasi ethers v5 lain
- Ini sesuai arah hackathon: codemod deterministik dulu, lalu coverage diperluas

---

## Kalau Mau Ulang Demo

Reset paling aman adalah clone ulang repo demo:

```bash
rm -rf ./targets/alchemy-goerli-sample-demo
git clone https://github.com/sangjunlim-dev/alchemy-goerli-sample.git ./targets/alchemy-goerli-sample-demo
```

Lalu ulangi langkah 2 sampai 6.

---

## Setelah Demo

Kalau mau bawa demo ini ke arah submission yang lebih kuat:

- jalankan audit edge cases
- simpan hasil `git diff`
- jalankan compile/build repo target
- ulangi di repo v5 kedua

Command audit:

```bash
powershell -ExecutionPolicy Bypass -File "./codemods/ethers-v5-to-v6/scripts/audit-edge-cases.ps1" -TargetPath "./targets/alchemy-goerli-sample-demo"
```

---

## Next Demo Improvement

Setelah demo dasar ini stabil, tahap berikutnya yang bisa ditambahkan:

- repo target kedua
- transform `ethers.utils.*` yang kena source nyata
- verifikasi compile/build
- report edge cases untuk langkah AI/manual
