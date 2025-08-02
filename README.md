# 📊 Customer Card Analysis – SQL Technical Assessment

Dokumentasi ini menjelaskan tahapan pembuatan dan pembersihan data dalam proyek analisis kartu dan transaksi pelanggan. Semua skrip ditulis dalam SQL dan dirancang untuk dijalankan di pgAdmin 4.

Daftar Isi
    - 🧭 STEP 1 – CREATE TABLES (Raw Import, PK, FK)      = Membuat struktur awal dari 3 tabel utama
    - 🧹 STEP 2 – CLEANING / PREPROCESSING                = Membersihkan data mentah
    - 📊 STEP 3 – DISTRIBUSI DATA                         = Melakukan analisis eksplorasi data basic dari masing2 tabel
    - ❌ STEP 4 – FILTERING DATA                          = Memfilter data transaksi yang error dan membuat tabel baru yang bersih
    - 🔍 STEP 5 – ANALISIS DATA: SEGMENTAS                = Melakukan segmentasi dan klasifikasi pelanggan
    - 💰 STEP 6 – ANALISIS DATA: CONSUMPTION              = Mengevaluasi pola penggunaan kartu dan perilaku transaksi pelanggan
    - ⚠️ STEP 7 – ANALISIS DATA: ANOMALIES                = Melakukan analisis mendalam untuk mengidentifikasi anomali
    - 🥇 STEP 8 – ANALISIS DATA: NEXTS STEP (CRV Score)   = Memetakan customer berdasarkan potensi nilai dan tingkat risiko
    - 🛒 STEP 9 – ANALISIS DATA: NEXTS STEP (MCC & Merch) = Menganalisis performa merchant dan jenis transaksi (MCC)
    - 📌

---

Siapkan tiga file CSV berikut:
   - `users_data.csv`
   - `cards_data.csv`
   - `transactions_data.csv`

----

## 🧭 STEP 1 – CREATE TABLES (Raw Import, PK, FK)

**🎯 Tujuan:**  
Membuat struktur awal dari 3 tabel utama dan mendefinisikan relasi antar entitas melalui primary key dan foreign key.

**Rincian:**
- **`users_data`**: berisi data demografis dan finansial pengguna.
- **`cards_data`**: menyimpan informasi kartu (brand, jenis, limit, masa berlaku, CVV, dsb).
- **`transactions_data`**: berisi transaksi yang dilakukan dengan kartu, mencakup waktu, nominal, dan lokasi merchant.

**Catatan Penting:**
- Banyak kolom masih disimpan sebagai `TEXT` karena berisi simbol `$`, format non-standar (misal `MM/YYYY`), atau data mentah.
- Relasi tabel:
  - `cards_data.client_id` → `users_data.client_id`
  - `transactions_data.client_id` → `users_data.client_id`
  - `transactions_data.card_id` → `cards_data.card_id`
- Import file-file csv ke dalam masing-masing tabel yang sudah dibuat.

----

## 🧹 STEP 2 – CLEANING / PREPROCESSING

**🎯 Tujuan:**  
Membersihkan data mentah agar siap digunakan untuk analisis lanjutan.

**Langkah-langkah:**
1. **Hapus simbol `$`** pada kolom keuangan seperti `yearly_income`, `total_debt`, `credit_limit`, dan `amount`.
2. **Rapikan CVV** agar selalu 3 digit menggunakan fungsi `LPAD()`.
3. **Isi lokasi merchant kosong** (`merchant_city`, `merchant_state`, `zip`) dengan `'ONLINE'` karena transaksi bersifat online.
4. **Konversi kolom**  yang sudah di hapus simbol ke tipe data `NUMERIC` untuk perhitungan yang lebih akurat.
5. **Validasi hasil pembersihan** dengan `SELECT` dan `COUNT()`.

----

## 📊 STEP 3 – DISTRIBUSI DATA (`users_data`, `cards_data`, `transactions_data`)

**🎯 Tujuan:**  
Melakukan analisis eksplorasi data (exploratory data analysis) untuk memahami sebaran, statistik deskriptif, dan pola awal dari masing-masing tabel utama: `users_data`, `cards_data`, dan `transactions_data`.

---

### 👤 Analisis Distribusi – `users_data`

1. **Total Pengguna**
   - Menghitung jumlah unik `client_id`.

2. **Statistik Umur**
   - Menampilkan nilai minimum, maksimum, dan rata-rata dari kolom `current_age`.

3. **Distribusi Gender**
   - Menghitung jumlah pengguna berdasarkan `gender` beserta persentasenya.

4. **Distribusi Alamat**
   - Mengekstrak bagian akhir alamat (biasanya nama kota atau daerah) dan menghitung 10 alamat terbanyak.
   - analisis ini tidak efektif jika menggunakan alamat dari `address` dan harus di analisis lebih mendalam di dashboard.

5. **Statistik Pendapatan**
   - `per_capita_income`, `yearly_income`, dan `total_debt`: dihitung nilai minimum, maksimum, rata-rata, serta total (untuk `total_debt`).

6. **Distribusi Jumlah Kartu (`num_credit_cards`)**
   - Mengelompokkan pengguna berdasarkan jumlah kartu kredit yang dimiliki.
   - Menghitung statistik min, max, dan rata-rata dari kolom ini.

---

### 💳 Analisis Distribusi – `cards_data`

1. **Total Kartu**
   - Menghitung jumlah total baris dalam `cards_data`.

2. **Distribusi Merek Kartu (`card_brand`)**
   - Mengelompokkan kartu berdasarkan mereknya dan menghitung total serta persentasenya.

3. **Distribusi Tipe Kartu (`card_type`)**
   - Sama seperti `card_brand`, namun berdasarkan tipe kartu.

4. **Distribusi Kartu Berchip (`has_chip`)**
   - Menampilkan persentase kartu yang memiliki chip vs tidak.

5. **Distribusi Kartu di Dark Web (`card_on_dark_web`)**
   - Mengetahui proporsi kartu yang ditemukan di dark web.

6. **Statistik `credit_limit`**
   - Menghitung nilai min, max, rata-rata, dan total dari `credit_limit`.

7. **Distribusi Tahun Expired**
   - Mengekstrak bagian tahun dari `expires` dan menghitung jumlah kartu berdasarkan tahun kadaluarsa.

8. **Distribusi Tahun Pembukaan Akun**
   - Mengekstrak tahun dari `acct_open_date` dan menghitung jumlah akun berdasarkan tahun pembukaan.

9. **Distribusi Jumlah Kartu per `card_id` (`num_cards_issued`)**
   - Menampilkan frekuensi jumlah kartu yang diterbitkan untuk satu entitas ID kartu.

---

### 💰 Analisis Distribusi – `transactions_data`

1. **Total Transaksi & Total Nilai Transaksi**
   - Menghitung jumlah transaksi (`transactions_id`) dan total nominal transaksi (`amount`).

2. **Distribusi Jenis Transaksi (`use_chip`)**
   - Membandingkan jenis transaksi yang menggunakan chip vs swipe vs online.

3. **Distribusi Lokasi Merchant (`merchant_state`)**
   - Menghitung jumlah merchant state unik.
   - Menampilkan 15 lokasi merchant teratas berdasarkan jumlah transaksi dan total nominal.

4. **Distribusi MCC (Merchant Category Code)**
   - Menghitung jumlah kategori MCC unik.
   - Menampilkan 15 kategori MCC teratas berdasarkan frekuensi dan nominal transaksi.

5. **Transaksi Error**
   - Menghitung jumlah transaksi dengan error (`errors` tidak null/kosong).
   - Menghitung total kerugian (`SUM(amount)`) akibat transaksi error.

6. **Distribusi Error**
   - Top 5 jenis error berdasarkan:
     - Jumlah transaksi
     - Total amount yang terdampak

----

## ❌ STEP 4 – FILTERING DATA (`transactions_data_filter`)

**🎯 Tujuan:**  
Memfilter data transaksi untuk menghilangkan baris-baris error dan menghasilkan tabel transaksi bersih.

**Langkah-langkah:**
1. Membuat tabel `transactions_data_filter` dari `transactions_data` dengan hanya memilih baris tanpa nilai error.
2. Kemudian menghitung total transaksi bersih dan total nominalnya (`amount`) untuk melihat perubahannya.

## 🔍 STEP 5 – ANALISIS DATA: SEGMENTASI 

**🎯 Tujuan:**

Melakukan segmentasi dan klasifikasi pelanggan berdasarkan umur, perilaku transaksi, dan skor kredit. Tujuannya untuk mengidentifikasi pola penting, pelanggan potensial, dan segmentasi strategis untuk pengambilan keputusan bisnis.

---

### 🧠 Segmentasi Usia – `users_data`

1. **Distribusi Usia**
   - Membuat kategori umur berdasarkan klasifikasi Kotler & Keller:
    
     | Kategori         | Umur   |
     |------------------|------- |
     | Remaja/Pelajar   | < 20   |
     | Dewasa Muda      | 20–29  |
     | Dewasa           | 30–49  |
     | Pra-Pensiun      | 50–59  |
     | Pensiun          | 60     |

   - Hitung total user dan persentase dari setiap kategori.

2. **Distribusi Usia vs Transaksi**
   - Menggabungkan data `transactions_data_filter` dengan kategori usia.
   - Menghitung:
     - Total user
     - Total transaksi
     - Total amount
     - Persentase masing-masing dari total keseluruhan

---

### 💳 Segmentasi Kredit (FICO) – `users_data`

3. **Klasifikasi FICO Score `credit_score_table`**
   - Kategori skor kredit berdasarkan standar FICO Score (`credit_score`):
     
     | FICO          | Score  |
     |---------------|--------|
     | Poor          | < 580  |
     | Fair          | 580–669|
     | Good          | 670–739|
     | Very Good:    | 740–799|
     | Exceptional   | ≥ 800  |

   - Hitung jumlah dan persentase user per kategori
   - Membuat tabel `credit_score_table`.

---

### 🥇 Customer Fokus – `transactions_data_filter`

4. **Top 10 Pelanggan Berdasarkan Total Amount**
   - Menghitung total `amount` per `client_id`.
   - Mengurutkan dan menampilkan 10 pelanggan teratas berdasarkan total transaksi.
   - Tambahkan persentase kontribusi terhadap total keseluruhan.

5. **Analisis Pareto 70/30**
   - Mengurutkan user berdasarkan kontribusi total transaksi (`amount`).
   - Hitung berapa jumlah pelanggan yang menyumbang 70% total transaksi.
   - Bandingkan dengan total keseluruhan user dan transaksi.

---

### 🧱 Matriks Segmentasi Pelanggan – `transactions_data_filter`

6. **Aktif/Pasif vs High/Low Spender `customer_matrix_tabel`**
   - Segmentasi pelanggan berdasarkan dua dimensi:
     - Frekuensi transaksi (`total_trx`)
     - Total nominal transaksi (`total_amount`)
   - 4 Segmen yang terbentuk:
   
      | Segmen                    | Logic                                               |
      |---------------------------|-----------------------------------------------------|
      | Aktif – High Spender (C1) | total_trx > avg_trx dan total_amount > avg_amount   |
      | Aktif – Low Spender (C3)  | total_trx > avg_trx dan total_amount <= avg_amount  |
      | Pasif – High Spender (C2) | total_trx <= avg_trx dan total_amount > avg_amount  |
      | Pasif – Low Spender (C4)  | total_trx <= avg_trx dan total_amount <= avg_amount |

   - Hitung:
     - Jumlah user per segmen
     - Rata-rata transaksi dan nominal
     - Total dan persentase nominal dari tiap segmen
   - Membuat tabel `customer_matrix_tabel`.

---

### 🚀 Identifikasi Pelanggan Potensial

7. **Customer Potensial**
   - Kriteria: Frekuensi transaksi di bawah rata-rata, namun nominal per transaksi di atas rata-rata.
   - Hitung:
     - Jumlah pelanggan potensial
     - Rata-rata transaksi & total nominal dari mereka
     - Kontribusi mereka terhadap total transaksi perusahaan

8. **Distribusi Customer Potensial di Segmen Matriks**
   - Menggabungkan `customer_matrix_table` dengan pelanggan potensial.
   - Hitung jumlah pelanggan potensial pada setiap segmen:
     - Apakah mereka lebih banyak di C1, C2, C3, atau C4?

---

## 💰 STEP 6 – ANALISIS DATA: CONSUMPTION

**🎯 Tujuan:**

Mengevaluasi pola penggunaan kartu dan perilaku transaksi pelanggan untuk mengidentifikasi efisiensi penggunaan kartu kredit, segmentasi pengguna aktif, dan performa kredit secara keseluruhan.

---

### 💳 Analisis Penggunaan Kartu – `cards_data`

1. **Mapping Penggunaan Kartu (Keseluruhan)**
   - Menggabungkan `card_brand` dan `card_type` menjadi `card_group`.
   - Hitung:
     - Jumlah unik pelanggan (`total_customer`)
     - Total kartu (`total_cards`)
   - Urutkan berdasarkan `total_customer` secara menurun.

2. **Mapping Penggunaan Kartu pada Customer Fokus**
   - Berdasarkan segmen "Aktif – High Spender (C1)".
   - Menggabungkan segmentasi pelanggan dengan data kartu.
   - Hitung:
     - Jumlah pelanggan segmen "Aktif – High Spender (C1)"
     - Total kartu berdasarkan brand dan tipe

---

### 🧾 Analisis Jenis Transaksi – `transactions_data_filter`

3. **Mapping Jenis Transaksi**
   - Kelompokkan jenis transaksi berdasarkan `use_chip` (chip vs swipe vs online).
   - Hitung total transaksi dan persentasenya terhadap seluruh transaksi.

---

### 📆 Analisis Waktu Transaksi – `transactions_data_filter`

4. **Transaksi Per Hari**
   - Hitung rata-rata harian untuk:
     - Jumlah transaksi (`avg_transaction_per_day`)
     - Total nominal (`avg_amount_per_day`)
     - Jumlah user unik (`avg_user_per_day`)

5. **Transaksi Per Jam**
   - Kelompokkan berdasarkan jam (`hour_of_day`).
   - Hitung:
     - Total transaksi
     - Rata-rata nominal
     - Jumlah user unik

6. **Transaksi per Segmen Waktu (Pagi, Siang, Sore, Malam)**
   - Segmentasi jam ke dalam waktu:
     
     | Segmen | Waktu   |
     |--------|---------|
     | Pagi   | 05–10   |
     | Siang  | 11–14   |
     | Sore   | 15–18   |
     | Malam  | lainnya |

   - Hitung rata-rata harian untuk:
     - Jumlah transaksi
     - Total nominal
     - Jumlah user unik

7. **Transaksi Per Bulan**
   - Kelompokkan berdasarkan nama bulan.
   - Hitung rata-rata harian untuk:
     - Jumlah transaksi
     - Total nominal
     - Jumlah user unik

8. **Transaksi Per Tahun**
   - Kelompokkan berdasarkan tahun.
   - Hitung:
     - Jumlah transaksi
     - Total nominal
     - Jumlah user unik

---

### 📈 Analisis Kredit Limit – `cards_data`

9. **Statistika Kredit Limit (Keseluruhan)**
   - Hitung:
     - Minimum, maksimum, rata-rata, dan total `credit_limit`.

10. **Statistika Kredit Limit per Brand & Tipe**
    - Kelompokkan berdasarkan `card_brand` dan `card_type`.
    - Hitung:
      - Jumlah kartu
      - Rata-rata, minimum, dan maksimum `credit_limit`

---

### ⚙️ Analisis Utilisasi Kredit Limit – `transactions_data`, `cards_data`

11. **Kategori Utilisasi Kredit Limit `credit_utilization_tabel`**
    - Gabungkan total penggunaan per kartu dan `credit_limit`.
    - Hitung `utilization_ratio` dan kategorikan:
      
      | Utilization   | ratio  |
      |---------------|--------|
      | Optimal       | > 90%  |
      | Under Control | 70–90% |
      | Idle Use      | < 70%  |

    - Membuat tabel `credit_utilization_tabel`

12. **Statistik Rata-rata Utilisasi**
    - Hitung rata-rata:
      - `credit_limit`, total penggunaan, dan `utilization_ratio`

13. **Segmentasi Customer vs Utilisasi Kartu**
    - Gabungkan dengan `customer_matrix_table`.
    - Hitung per segmen:
      - Total kartu
      - Rata-rata `credit_limit`, `usage`, dan `utilization_ratio`

---

### 🛑 Analisis Inaktivitas Pelanggan/Kartu – `transactions_data`

14. **Tanggal Transaksi Terakhir**
    - Ambil tanggal transaksi terakhir dari semua data transaksi.

15. **Jumlah Kartu Tidak Aktif (≥ 1 Tahun)**
    - Kartu yang tidak memiliki transaksi sejak sebelum `2018-10-31`.

16. **Jumlah Pelanggan Tidak Aktif (≥ 1 Tahun)**
    - Pelanggan yang tidak memiliki transaksi sejak sebelum `2018-10-31`.

## ⚠️ STEP 7 – ANALISIS DATA: ANOMALIES

**Tabel digunakan:** `cards_data`, `transactions_data`

**🎯 Tujuan:**  
Melakukan analisis mendalam untuk mengidentifikasi anomali penggunaan kartu dan potensi risiko fraud berdasarkan kombinasi data kartu dan transaksi.

---

### 📊 Analisis Umur dan Status Kartu

1. **Distribusi Tahun Expired**  
   - Menghitung jumlah kartu berdasarkan tahun kedaluwarsa (`expires`)  

2. **Umur Rata-Rata Kartu**  
   - Menghitung umur kartu dengan selisih antara `expires` dan `acct_open_date`  

---

### 🔍 Klasifikasi Status Kartu

1. **Status Aktif vs Expired**  
   - Kartu dikelompokkan menjadi:  
     - `Expired`: tahun expired < 2019  (berdasarkan tahun transaksi paling terakhir)
     - `Active`: tahun expired ≥ 2019  (berdasarkan tahun transaksi paling terakhir)

2. **Validasi Aktivitas Kartu**  
   - Logic kategori klasifikasi:
     - expired – tidak pernah transaksi  
     - expired – masih transaksi  
     - expired – normal (selain logic diatas)
     - not expired – belum pernah transaksi  
     - not expired – tidak transaksi > 2 tahun  
     - not expired – normal (masih aktif transaksi/selain logic diatas)

---

### ⚠️ Deteksi Anomali Spesifik

1. **Transaksi Setelah Kartu Expired**  
   - Menemukan kartu yang tetap digunakan untuk bertransaksi (berdasarkan `date`) setelah tanggal expired-nya terlewati

2. **Kartu Aktif Tapi Tidak Pernah Transaksi**  
   - Deteksi kartu aktif (`not expired`) namun belum pernah memiliki histori transaksi

3. **Kartu Aktif Tapi Tidak Transaksi Selama >2 Tahun**  
   - Identifikasi kartu `not expired` namun tidak melakukan transaksi sejak lebih dari 2 tahun

4. **Rata-Rata Jarak Antar Transaksi**  
   - Hitung selisih rata-rata hari antar transaksi (`date`) per kartu  
   - Memberikan insight mengenai pola intensitas transaksi pengguna

---

### 🕵️‍♀️ Skor Risiko Fraud

1. **7 Indikator Deteksi Risiko Fraud**  
   Skoring dilakukan berdasarkan indikator berikut:

   | No | Indikator                                                | Penjelasan                                                  |
   |----|----------------------------------------------------------|-------------------------------------------------------------|
   | 1  | Transaksi setelah kartu expired                          | Kartu tetap digunakan walau sudah tidak berlaku             |
   | 2  | Outlier transaksi (Z-Score > 10)                         | Nilai transaksi tidak wajar dibanding rata-rata pengguna    |
   | 3  | PIN salah > 3x/hari atau >10x/bulan                      | Tanda percobaan tidak sah                                   |
   | 4  | Kartu tidak menggunakan chip (`has_chip = FALSE`)        | Lebih rentan terhadap skimming                              |
   | 5  | PIN belum diganti selama > 1 tahun                       | Keamanan lemah                                              |
   | 6  | Jarak antar transaksi > 365 hari                         | Aktivitas mencurigakan                                      |
   | 7  | Nomor kartu duplikat / bocor di dark web                 | Kartu terekspos di lingkungan tidak aman                    |

2. **Skor dan Kategori Risiko**

   | Skor Fraud | Kategori Risiko |
   |------------|-----------------|
   | 0–2        | Aman            |
   | 3–4        | Waspada         |
   | ≥5         | Risiko Tinggi   |

   - Skor total dihitung sebagai penjumlahan poin dari indikator yang terpenuhi

---

### 📌 Output & Tabel Final

1. **fraud_risk_score_table**  
   - Berisi: `client_id`, `card_id`, score per indikator, `fraud_score`, dan `fraud_category`  
   - Tabel ini bisa digunakan untuk investigasi lanjutan oleh tim anti-fraud

---

## 🥇 STEP 8 – ANALISIS DATA: NEXTS STEP (CRV Score)

**Tabel digunakan:**  
- `customer_matrix_tabel`, `credit_score_table`, `credit_utilization_tabel`, `fraud_risk_score_table`, `users_data`, & `cards_data` 

**🎯 Tujuan:**  
Customer Risk & Value Score (CRV Score) menggabungkan dan mengklasifikasikan customer berdasarkan kombinasi 4 dimensi penting: *customer matrix*, *credit score*, *credit utilization*, dan *fraud risk* untuk mengidentifikasi potensi dan risiko customer secara menyeluruh untuk mendukung pengambilan keputusan strategis dengan pendekatan customer berbasis data. 

| Indikator                  | Kategori/Segmen           | Skor |  
|----------------------------|---------------------------|------|       
| Customer Matrix Score      | Aktif - High Spender (C1) | 4    |
| (Skor 1-4)                 | Pasif - High Spender (C2) | 3    |
|                            | Aktif - Low Spender  (C3) | 2    |
|                            | Pasif - Low Spender (C4)  | 1    |
|----------------------------|---------------------------|------|
| Credit Score               | Exceptional               | 5    | 
| (Skor 1-5)                 | Very Good                 | 4    |
|                            | Good                      | 3    |
|                            | Fair                      | 2    |
|                            | Poor                      | 1    |
|----------------------------|---------------------------|------|
| Credit Utilization         | Optimal                   | 3    |
| dihitung Avg per client_id | Under Control             | 2    |
| (Skor 1-3)                 | Idle Use                  | 1    |
|----------------------------|---------------------------|------|
| Fraud Risk Score           | Aman                      | 3    |
| dihitung Avg per client_id | Waspada                   | 2    |
| (Skor 1-3)                 | Potensi Tinggi            | 1    |

- Jumlahkan 4 skor di atas → CRV Score (1–15)
- Customer diklasifikasikan menjadi:
  - 13–15 : **Platinum**  
  - 11–12 : **Gold**  
  - 9–10  : **Silver**  
  - 1-8   : **Watchlist**
- Output Tabel: `crv_score_table`
- Hitung jumlah dan persentase dari user maupun amount per kategorinya

---

## 🛒 STEP 9 – ANALISIS DATA: NEXTS STEP (MCC & MERCHANT ANALYSIS)

**Tabel digunakan:**  
- `transactions_data_filter`

**🎯 Tujuan:**  
Menganalisis performa merchant dan jenis transaksi (Merchant Category Code) untuk menemukan konsentrasi transaksi dan peluang partnership strategis.

---

### 🔄 Tranformasi Data MCC & Merchant State

1. **Download data unik** dari kolom `mcc` dan `merchant_state` dari tabel transaksi.
2. **Transformasi data MCC**:
   - Gunakan referensi file *Visa International Merchant Category Code (MCC) Listing*.
   - Lakukan *vlookup* `mcc` dengan file referensi untuk mendapatkan `mcc_name` dan `irl_description`.
   - Karena `irl_description` masih terlalu luas, lakukan kategorisasi ulang menjadi `mcc_category` yang lebih ringkas:
     - Retail
     - Government & Utilities
     - Financial Services
     - Healthcare
     - Entertainment & Media
     - Food & Beverage
     - Transportation
     - Professional Services
     - Hospitality
3. **Transformasi data Merchant State**:
   - Ubah kode negara bagian AS pada `merchant_state` menjadi nama lengkap pada kolom `merchant_state_desc`.
4. **Struktur tabel**:
   - Buat dua tabel untuk menyimpan hasil transformasi:
     - `data_mcc` (berisi `mcc`, `mcc_name`, `irl_description`, `mcc_category`)
     - `data_merchant_state` (berisi `merchant_state`, `merchant_state_desc`, `continent`, `america_class`)
5. **Import data hasil transformasi** ke dalam tabel-tabel tersebut.

---

### 🌎 Top Merchant State

1. **Analisis frekuensi dan total transaksi** per `merchant_state`:
   - Diurutkan berdasarkan transaksi terbanyak.
2. **Analisis geografis lanjutan**:
   - Distribusi per negara maupun negara bagian berdasarkan frekuensi dan total transaksi
3. **Analisis geografis lanjutan (excel)**:
   - Tambahkan dimensi `continent` untuk membandingkan aktivitas antar benua.
   - Klasifikasikan wilayah Transaksi menjadi:
     - U.S.
     - Other Nation
     - Online Transaction
4. **Tujuan**: Menilai penyebaran transaksi secara geografis dan membantu strategi ekspansi atau pengawasan berdasarkan lokasi.

---

### 🏷️ Top Merchant Category Code (MCC)

1. **Sebaran MCC berdasarkan `irl_description`**:
   - Lihat jumlah transaksi dan total nominal per MCC.
2. **Sebaran MCC berdasarkan `mcc_category`**:
   - Bandingkan antar kategori umum untuk melihat dominasi jenis merchant.
3. **Hubungan dengan CSV Score (Customer Segmentation)**:
   - Lakukan analisis korelasi antara segmen CRV-Score dengan MCC:
     - Top 3–5 `irl_description` paling sering muncul untuk tiap segmen.
     - Top 3–5 `mcc_category` paling sering muncul untuk tiap segmen.
4. **Tujuan**: Memahami pola konsumsi customer berdasarkan kategori merchant serta mengidentifikasi potensi segmen untuk kerjasama merchant/promo.
---
