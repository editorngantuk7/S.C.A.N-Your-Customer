# 📊 S.C.A.N. Your Customer (Segmentation, Consumption, Anomalies, and Next Steps)

S.C.A.N Your Customer adalah kerangka analisis yang mencakup empat pilar utama: Segmentation, Consumption, Anomalies, dan Next Steps. Pendekatan ini membantu memahami karakteristik dan perilaku pelanggan (Segmentasi & Consumption), mendeteksi potensi risiko atau fraud (Anomalies), serta menyusun strategi bisnis yang tepat seperti retensi, promosi, dan mitigasi risiko (Next Steps). S.C.A.N. bertujuan untuk mengenal pelanggan secara menyeluruh dan meningkatkan kualitas pengambilan keputusan berbasis data.

## 📁 Dokumentasi Analisis

Dokumentasi ini menyajikan hasil-hasil analisis yang telah dilakukan pada beberapa tahap sebelumnya, meliputi eksplorasi data pengguna, transaksi, kartu, serta berbagai segmentasi dan deteksi anomali. Semua temuan telah dikonversi ke dalam format Markdown agar dapat langsung digunakan dalam laporan atau presentasi.

---

## 📊 STEP 3 – DISTRIBUSI DATA (`users_data`, `cards_data`, `transactions_data`)

**🎯 Tujuan:**  
Melakukan analisis eksplorasi data (exploratory data analysis) untuk memahami sebaran, statistik deskriptif, dan pola awal dari masing-masing tabel utama: `users_data`, `cards_data`, dan `transactions_data`.

---

### 👤 Distribusi `users_data`

- **Total Users:** 2,000

#### 📊 Umur
- Min: 18 | Max: 101 | Average: 45.39

#### 🚻 Gender

| Gender | Jumlah | Persentase |
|--------|--------|------------|
| Female | 1,016  | 50.80%     |
| Male   | 984    | 49.20%     |

#### 🏠 Alamat
- Terlalu bervariasi, walaupun sudah menghapus nomor jalan. Persentase tertinggi hanya 0.60% (tidak representatif).

#### 💵 Income dan Debt (USD)

- **Per Capita Income:** Min: 0 | Max: 163,145 | Avg: 23,141.90  
- **Yearly Income:** Min: 1 | Max: 307,018 | Avg: 45,715.90  
- **Total Debt:** Min: 0 | Max: 516,263 | Avg: 63,709.69 | Sum: 127,419,388

#### 🔢 Jumlah Kartu per User

- Min: 1 | Max: 9 | Avg: 3

| Jumlah Kartu | Jumlah User   |
|--------------|--------------|
| 1            | 416          |
| 2            | 388          |
| 3            | 449          |
| 4            | 376          |
| 5            | 206          |
| 6            | 105          |
| 7            | 40           |
| 8            | 17           |
| 9            | 3            |

---

### 💳 Distribusi `cards_data`

- **Total Kartu:** 6,146

#### 🏷️ Card Brand

| Brand     | Jumlah | Persentase |
|-----------|--------|------------|
| Mastercard| 3,209  | 52.21%     |
| Visa      | 2,326  | 37.85%     |
| Amex      | 402    | 6.54%      |
| Discover  | 209    | 3.40%      |

#### 🧾 Card Type

| Tipe             | Jumlah | Persentase |
|------------------|--------|------------|
| Debit            | 3,511  | 57.13%     |
| Credit           | 2,057  | 33.47%     |
| Debit (Prepaid)  | 578    | 9.40%      |

#### 💡 Chip Availability

| Chip | Jumlah | Persentase |
|------|--------|------------|
| YES  | 5,500  | 89.49%     |
| NO   | 646    | 10.51%     |

#### 🌐 Dark Web Flag
- Semua kartu: Tidak ditemukan di dark web (100%).

#### 💰 Credit Limit (USD)
- Min: 0 | Max: 151,223 | Avg: 14,347.49 | Total: 88,179,698

#### 📆 Account Open Year & Expired Year

| Tahun | Open | Expired |
|-------|------|---------|
| 1991  | 3    | 3       |
| 1992  | 2    | 4       |
| 1993  | 3    | 2       |
| 1994  | 10   | 2       |
| 1995  | 6    | 7       |
| 1996  | 16   | 9       |
| 1997  | 27   | 8       |
| 1998  | 42   | 11      |
| 1999  | 61   | 28      |
| 2000  | 64   | 36      |
| 2001  | 121  | 39      |
| 2002  | 147  | 62      |
| 2003  | 197  | 62      |
| 2004  | 246  | 64      |
| 2005  | 300  | 97      |
| 2006  | 359  | 76      |
| 2007  | 408  | 84      |
| 2008  | 487  | 97      |
| 2009  | 466  | 101     |
| 2010  | 545  | 86      |
| 2011  | 335  | 122     |
| 2012  | 188  | 114     |
| 2013  | 199  | 1,314   |
| 2014  | 178  | 909     |
| 2015  | 148  | 939     |
| 2016  | 120  | 908     |
| 2017  | 101  | 962     |
| 2018  | 101  | -       |
| 2019  | 88   | -       |
| 2020  | 1,178| -       |
| **Total** | 6,146 | 6,146 |

#### 🪪 Jumlah Kartu per ID

| Kartu per ID | Jumlah ID |
|--------------|------------|
| 1            | 3,114      |
| 2            | 2,972      |
| 3            | 60         |

---

### 💸 Distribusi `transactions_data`

- **Total Transaksi:** 13,305,915  
- **Total Amount:** USD 571,835,522.28

#### 💳 Jenis Transaksi (Use Chip)

| Jenis Transaksi     | Jumlah     | Persentase |
|---------------------|------------|------------|
| Swipe Transaction   | 6,967,185  | 52.36%     |
| Chip Transaction    | 4,780,818  | 35.93%     |
| Online Transaction  | 1,557,912  | 11.71%     |

#### 🌎 Top 15 Merchant State (by amount)

| State  | Transaksi | Amount           | % of Total Amount |
|--------|-----------|------------------|-------------------|
| ONLINE | 1,563,700 | 88,896,665.09    | 15.55%            |
| CA     | 1,427,087 | 59,084,616.19    | 10.33%            |
| TX     | 1,010,207 | 42,477,208.43    | 7.43%             |
| NY     | 857,510   | 39,721,647.77    | 6.95%             |
| FL     | 701,623   | 28,603,402.23    | 5.00%             |
| IL     | 467,931   | 19,500,277.78    | 3.41%             |
| PA     | 417,766   | 18,234,988.56    | 3.19%             |
| NC     | 429,427   | 16,790,704.15    | 2.94%             |
| OH     | 484,122   | 16,225,273.04    | 2.84%             |
| MI     | 397,970   | 15,051,464.03    | 2.63%             |
| NJ     | 322,227   | 14,904,752.92    | 2.61%             |
| GA     | 368,206   | 13,617,942.73    | 2.38%             |
| TN     | 284,709   | 12,717,884.02    | 2.22%             |
| VA     | 230,685   | 12,113,811.78    | 2.12%             |
| IN     | 312,470   | 11,282,055.46    | 1.97%             |
| **Total** | 10,275,940 | 409,242,694.18 | 71.56%         |

#### 🛍️ Top 15 Merchant Category Code (MCC)

| MCC   | Transaksi | Amount           | % of Total Amount |
|-------|-----------|------------------|-------------------|
| 4829  | 589,140   | 53,158,515.64    | 9.30%             |
| 5411  | 1,592,584 | 40,970,754.15    | 7.16%             |
| 5300  | 601,942   | 37,697,546.74    | 6.59%             |
| 5912  | 772,913   | 35,113,527.69    | 6.14%             |
| 5541  | 1,424,711 | 29,570,426.66    | 5.17%             |
| 4900  | 242,993   | 27,650,038.08    | 4.84%             |
| 5311  | 475,384   | 27,031,968.70    | 4.73%             |
| 5812  | 999,738   | 26,348,225.47    | 4.61%             |
| 7538  | 478,263   | 24,955,640.73    | 4.36%             |
| 4814  | 218,243   | 24,726,472.83    | 4.32%             |
| 4784  | 674,135   | 23,859,531.67    | 4.17%             |
| 5499  | 1,460,875 | 15,562,571.48    | 2.72%             |
| 5814  | 499,659   | 13,127,455.77    | 2.30%             |
| 4121  | 500,662   | 11,874,249.58    | 2.08%             |
| 6300  | 51,242    | 11,888,066.98    | 2.08%             |
| **Total** | 11,512,484 | 403,534,991.29 | 70.51%         |

#### ⚠️ TRANSAKSI ERROR

- **Jumlah Error:** 211,393 transaksi  
- **Total kerugian:** USD 12,680,297.55

##### 📉 Jenis Error (by Jumlah)

| Error               | Jumlah  | % Total |
|---------------------|---------|---------|
| Insufficient Balance| 130,902 | 61.92%  |
| Bad PIN             | 32,119  | 15.19%  |
| Technical Glitch    | 26,271  | 12.43%  |
| Bad Card Number     | 7,767   | 3.67%   |
| Bad Expiration      | 6,161   | 2.91%   |

##### 💸 Jenis Error (by Nominal Amount)

| Error               | Total Amount     | % Total |
|---------------------|------------------|---------|
| Insufficient Balance| 8,910,062.00     | 70.27%  |
| Bad PIN             | 1,280,652.65     | 10.10%  |
| Technical Glitch    | 1,183,549.14     | 9.33%   |
| Bad Card Number     | 460,217.13       | 3.63%   |
| Bad CVV             | 377,380.82       | 2.98%   |

---

## ❌ STEP 4 – FILTERING DATA

**🎯 Tujuan:**  
Memfilter data transaksi untuk menghilangkan baris-baris error dan menghasilkan tabel transaksi bersih.

---

### 💸 Transaksi Setelah Filtering (`transactions_data_filter`)

| Kategori                      | Transaksi   | Total Amount        |
|------------------------------|-------------|----------------------|
| Filter (tanpa error)         | 13,094,522  | USD 559,155,224.73  |

---

## 🧩 STEP 5 – SEGMENTATION DATA ANALYSIS

**🎯 Tujuan:**

Melakukan segmentasi dan klasifikasi pelanggan berdasarkan umur, perilaku transaksi, dan skor kredit. Tujuannya untuk mengidentifikasi pola penting, pelanggan potensial, dan segmentasi strategis untuk pengambilan keputusan bisnis.

---

#### 👥 Klasifikasi Umur (Kotler & Keller – Marketing Management edisi 15)

| Kategori        | Usia    | Jumlah | Persentase |
|----------------|---------|--------|------------|
| Remaja/Pelajar | < 20    | 111    | 5.55%      |
| Dewasa Muda     | 20–29   | 369    | 18.45%     |
| Dewasa          | 30–49   | 722    | 36.10%     |
| Pra-Pensiun     | 50–59   | 352    | 17.60%     |
| Pensiun         | > 59    | 446    | 22.30%     |


#### 📊 SEGMEN CUSTOMER BERDASARKAN USIA  
(Klasifikasi berdasarkan total user, transaksi, dan amount)

| Kategori     | Jumlah User | % User  | Transaksi | % Transaksi | Amount (USD)         | % Amount |
|--------------|-------------|---------|-----------|--------------|----------------------|----------|
| Dewasa Muda  | 369         | 18.45%  | 295,334   | 2.26%        | 12,916,635.47        | 2.31%    |
| Dewasa       | 722         | 36.10%  | 5,466,919 | 41.75%       | 231,339,347.24       | 41.37%   |
| Pra-Pensiun  | 352         | 17.60%  | 3,111,605 | 23.76%       | 134,680,291.18       | 24.09%   |
| Pensiun      | 446         | 22.30%  | 4,220,664 | 32.23%       | 180,218,950.84       | 32.23%   |


#### 💳 Credit Score (FICO Classification)

| Kategori     | Score   | Jumlah | Persentase |
|--------------|---------|--------|------------|
| Poor         | < 580   | 81     | 4.05%      |
| Fair         | 580–669 | 348    | 17.40%     |
| Good         | 670–739 | 931    | 46.55%     |
| Very Good    | 740–799 | 474    | 23.70%     |
| Exceptional  | > 799   | 166    | 8.30%      |


#### 💼 TOP 10 CUSTOMER – Berdasarkan Nominal Transaksi

| Client ID | Total Amount (USD) | % dari Total Amount |
|-----------|--------------------|----------------------|
| 96        | 2,379,590.52       | 0.43%                |
| 1686      | 2,117,376.13       | 0.38%                |
| 1340      | 1,965,920.96       | 0.35%                |
| 840       | 1,913,431.59       | 0.34%                |
| 464       | 1,754,976.07       | 0.31%                |
| 490       | 1,673,449.86       | 0.30%                |
| 704       | 1,611,919.69       | 0.29%                |
| 285       | 1,599,778.91       | 0.29%                |
| 488       | 1,590,722.96       | 0.28%                |
| 1168      | 1,554,142.10       | 0.28%                |


#### 📈 CUSTOMER PARETO (70%) – Berdasarkan Total Nominal Transaksi

- **Jumlah Customer (Setelah Filter):** 1,219  
- **Pareto Customer:** 581 (47.66%)  
- **Total Amount Pareto:** USD 391,139,036.89 (69.95%)

#### 🧭 MATRICS CUSTOMER – Aktif/Pasif vs High/Low Spender

| Segmen               | Jumlah Cust | % Cust | Avg Transaksi | Avg Amount | Total Amount (USD) | % Amount |
|----------------------|-------------|--------|---------------|------------|---------------------|----------|
| Aktif - High Spender | 337         | 27.65% | 16,869.47     | 792,536.86 | 267,084,920.59      | 47.77%   |
| Aktif - Low Spender  | 155         | 12.72% | 13,278.79     | 352,914.75 | 54,701,786.64       | 9.78%    |
| Pasif - High Spender | 118         | 9.68%  | 9,064.25      | 593,099.75 | 69,985,770.68       | 12.52%   |
| Pasif - Low Spender  | 609         | 49.96% | 7,030.73      | 274,848.52 | 167,382,746.82      | 29.93%   |

#### 🌱 CUSTOMER POTENSIAL – Berdasarkan Rata-Rata Transaksi & Nominal

- **Kriteria:** Di bawah rata-rata transaksi, di atas rata-rata nominal  
- **Avg Transaksi Keseluruhan:** 10,742.02  
- **Avg Amount Keseluruhan:** 458,699.94

| Statistik               | Nilai              |
|-------------------------|--------------------|
| Customer Potensial      | 322                |
| Avg Transaksi Potensial | 7,250.44           |
| Avg Amount Potensial    | 428,256.70         |
| Total Amount Potensial  | USD 137,898,656.28 |

**Customer Potensial berdasarkan Segmen Matriks:**
- Pasif - Low Spender: 204
- Pasif - High Spender: 118

---

## 🧮 STEP 6 – ANALYSIS DATA – CONSUMPTION

**🎯 Tujuan:**
Mengevaluasi pola penggunaan kartu dan perilaku transaksi pelanggan untuk mengidentifikasi efisiensi penggunaan kartu kredit, segmentasi pengguna aktif, dan performa kredit secara keseluruhan.

---

#### 💳 PENGGUNAAN KARTU – Semua Customer

| Brand - Tipe                  | Total Customer | Total Card |
|------------------------------|----------------|------------|
| Mastercard - Debit           | 1,375          | 2,191      |
| Visa - Debit                 | 949            | 1,320      |
| Visa - Credit                | 674            | 811        |
| Mastercard - Credit          | 552            | 635        |
| Amex - Credit                | 358            | 402        |
| Mastercard - Debit (Prepaid) | 355            | 383        |
| Discover - Credit            | 199            | 209        |
| Visa - Debit (Prepaid)       | 189            | 195        |


#### 🌟 PENGGUNAAN KARTU – Customer Fokus (Top Spender / Pareto)

| Brand - Tipe                  | Total Customer | Total Card |
|------------------------------|----------------|------------|
| Mastercard - Debit           | 276            | 497        |
| Visa - Debit                 | 203            | 310        |
| Visa - Credit                | 146            | 175        |
| Mastercard - Credit          | 105            | 122        |
| Amex - Credit                | 74             | 87         |
| Mastercard - Debit (Prepaid) | 79             | 85         |
| Discover - Credit            | 36             | 39         |
| Visa - Debit (Prepaid)       | 34             | 35         |


#### 🔄 TRANSACTION TYPE DISTRIBUTION

| Jenis Transaksi     | Jumlah    | Persentase |
|---------------------|-----------|------------|
| Chip Transaction    | 4,708,524 | 35.96%     |
| Online Transaction  | 1,522,351 | 11.63%     |
| Swipe Transaction   | 6,863,647 | 52.42%     |


#### 🕒 TIME DISTRIBUTION

📅 **Per Hari**  
- Avg Transaksi: **3.18**  
- Avg Amount: **135.72**  
- Avg User: **3.16**

🕐 **Per Jam**

| Waktu | Transaksi | Amount   | User   |
|-------|-----------|----------|--------|
| Pagi  | 1,226.90  | 42,980.44| 681.54 |
| Siang | 1,010.15  | 42,875.08| 600.78 |
| Sore  | 733.17    | 34,924.88| 467.84 |
| Malam | 676.26    | 34,929.77| 459.03 |

📅 **Transaksi per Bulan (rata-rata harian per user)**

| Bulan      | Transaksi | Amount | User |
|------------|-----------|--------|------|
| January    | 3.16      | 134.20 | 3.14 |
| February   | 3.16      | 135.68 | 3.14 |
| March      | 3.17      | 135.64 | 3.15 |
| April      | 3.16      | 135.88 | 3.15 |
| May        | 3.17      | 135.13 | 3.15 |
| June       | 3.19      | 137.26 | 3.17 |
| July       | 3.18      | 136.30 | 3.16 |
| August     | 3.19      | 135.72 | 3.17 |
| September  | 3.19      | 135.98 | 3.17 |
| October    | 3.18      | 135.82 | 3.16 |
| November   | 3.19      | 135.43 | 3.17 |
| December   | 3.19      | 135.60 | 3.18 |

📆 **Transaksi per Tahun**

| Tahun | Transaksi | Amount (USD) | User |
|-------|-----------|---------------|------|
| 2010  | 1,221,497 | 53,050,032    | 1,137|
| 2011  | 1,270,206 | 54,527,878    | 1,167|
| 2012  | 1,300,851 | 55,578,857    | 1,177|
| 2013  | 1,331,226 | 57,002,841    | 1,190|
| 2014  | 1,343,995 | 57,309,666    | 1,195|
| 2015  | 1,365,712 | 58,174,274    | 1,204|
| 2016  | 1,369,872 | 58,527,213    | 1,210|
| 2017  | 1,377,019 | 58,318,684    | 1,209|
| 2018  | 1,372,832 | 58,305,272    | 1,208|
| 2019  | 1,141,312 | 48,360,502    | 1,206|


#### 📊 Statistik Credit Limit

- **Min:** USD 0  
- **Max:** USD 151,223  
- **Rata-rata:** USD 14,347.49  
- **Total:** USD 88,179,698


#### 📌 Statistik per Brand & Tipe Kartu

| Brand       | Tipe                | Total Kartu | Avg Limit (USD) | Min | Max     |
|-------------|---------------------|-------------|------------------|-----|---------|
| Visa        | Debit               | 1,320       | 19,019.62        | 1   | 132,439 |
| Mastercard  | Debit               | 2,191       | 18,279.71        | 0   | 151,223 |
| Amex        | Credit              | 402         | 11,436.32        | 0   | 89,900  |
| Visa        | Credit              | 811         | 11,295.56        | 0   | 98,100  |
| Mastercard  | Credit              | 635         | 10,971.65        | 0   | 55,300  |
| Discover    | Credit              | 209         | 10,816.27        | 0   | 44,200  |
| Mastercard  | Debit (Prepaid)     | 383         | 64.78            | 0   | 130     |
| Visa        | Debit (Prepaid)     | 195         | 63.80            | 0   | 145     |


#### 📉 Utilisasi Credit Limit

- **Total kartu:** 6,146  
- **Rata-rata limit:** USD 14,347  
- **Rata-rata penggunaan (usage):** USD 93,042  
- **Rata-rata utilisasi:** 65.93%


#### 📌 Matriks Customer – Berdasarkan Utilisasi

| Segmen                       | Total Kartu | Avg Limit | Avg Usage | Utilisasi |
|-----------------------------|-------------|-----------|-----------|-----------|
| Aktif - High Spender (C1)   | 1,350       | 17,927    | 202,524   | 117.73%   |
| Pasif - High Spender (C2)   | 431         | 19,340    | 166,035   | 117.64%   |
| Aktif - Low Spender (C3)    | 641         | 11,856    | 87,081    | 81.91%    |
| Pasif - Low Spender (C4)    | 2,092       | 12,382    | 81,763    | 68.23%    |


#### 📌 Kategori Utilisasi Kartu

- **Optimal (utilisasi wajar):** 3,862 kartu  
- **Under Control (rendah):** 36 kartu  
- **Idle Use (tidak digunakan):** 616 kartu

📅 **Tanggal Transaksi Terakhir:** 31 Oktober 2019  
📌 **Kartu Tidak Aktif (>1 tahun tidak transaksi):**  
- Jumlah kartu: 2,689  
- Jumlah nasabah: 794

---

## 📉 STEP 7: ANALYSIS DATA – ANOMALIES

**🎯 Tujuan:**  
Melakukan analisis mendalam untuk mengidentifikasi anomali penggunaan kartu dan potensi risiko fraud berdasarkan kombinasi data kartu dan transaksi.

---

#### 📊 Umur Kartu  
- **Rata-rata:** 9.78 tahun


#### 🛑 Status Kartu

| Status  | Card ID | Jumlah |
|---------|---------|--------|
| Active  | 5,153   | 7,750  |
| Expired | 993     | 1,488  |


#### 🧯 Detail Status Anomali

| Status                                         | Card ID | Jumlah |
|-----------------------------------------------|---------|--------|
| Expired – tidak pernah transaksi              | 360     | 551    |
| Expired – masih transaksi (anomali)           | 4       | 5      |
| Expired – normal                              | 629     | 932    |
| Belum expired – tidak pernah transaksi        | 1,715   | 2,550  |
| Belum expired – tidak transaksi > 2 thn       | 1       | 2      |
| Belum expired – normal                        | 3,437   | 5,198  |


#### 📍 Anomali: Transaksi Setelah Kartu Expired

- **Jumlah kartu:** 4  
- **Jumlah transaksi:** 8

| Card ID | Client ID | Expired  | Transaksi   | Amount  | Keterangan                    |
|---------|-----------|----------|-------------|---------|-------------------------------|
| 3858    | 1076      | 12/2017  | 2018-01-01  | 478.00  | ❌ transaksi setelah expired  |
| 3858    | 1076      | 12/2017  | 2018-01-05  | 184.59  | ❌ transaksi setelah expired  |
| 3994    | 1104      | 12/2012  | 2013-01-08  | 109.03  | ❌ transaksi setelah expired  |
| 3994    | 1104      | 12/2012  | 2013-01-08  | -398.00 | ❌ transaksi setelah expired  |
| 4830    | 1258      | 12/2014  | 2015-01-06  | -488.00 | ❌ transaksi setelah expired  |
| 4830    | 1258      | 12/2014  | 2015-01-06  | 142.48  | ❌ transaksi setelah expired  |
| 5264    | 1770      | 12/2017  | 2018-01-02  | -113.00 | ❌ transaksi setelah expired  |
| 5264    | 1770      | 12/2017  | 2018-01-02  | 225.91  | ❌ transaksi setelah expired  |


#### 📌 Kartu Belum Expired Tapi Tidak Transaksi > 2 Tahun

| Card ID | Client ID | Expired  | Last Transaksi |
|---------|-----------|----------|----------------|
| 5781    | 1942      | 06/2024  | 2016-04-20     |


#### 📊 Error & Fraud Monitoring

- **Rata-rata error Bad PIN per kartu:** 7.89  
- **Rata-rata jarak antar transaksi:** 0.52 hari


#### 🔐 Kategori Risiko Fraud

| Kategori | Jumlah Kartu |
|----------|---------------|
| Aman     | 5,883         |
| Waspada  | 263           |

---

## 💎 STEP 8: Customer Risk & Value Score (CRV)

**🎯 Tujuan:**  
Customer Risk & Value Score (CRV Score) menggabungkan dan mengklasifikasikan customer berdasarkan kombinasi 4 dimensi penting: *customer matrix*, *credit score*, *credit utilization*, dan *fraud risk* untuk mengidentifikasi potensi dan risiko customer secara menyeluruh untuk mendukung pengambilan keputusan strategis dengan pendekatan customer berbasis data. 

---

#### 📊 Customer Risk & Value Score (CRV)

| CRV Category | Total User | % User | Total Amount     | % Amount |
|--------------|------------|--------|------------------|----------|
| Platinum     | 307        | 25.18% | 235,825,213.45   | 41.24%   |
| Gold         | 463        | 37.98% | 206,600,143.27   | 36.13%   |
| Silver       | 426        | 34.95% | 122,880,373.94   | 21.49%   |
| Watchlist    | 23         | 1.89%  | 6,529,791.62     | 1.14%    |

---

## 🗺️ STEP 9: Next Steps - Mapping Your Market

**🎯 Tujuan:**  
Menganalisis performa merchant dan jenis transaksi (Merchant Category Code) untuk menemukan konsentrasi transaksi dan peluang partnership strategis.

---

#### 🌍 Sebaran Merchant Berdasarkan Wilayah

- **Total Merchant:** 124,581  
- **Negara Tercakup:** 200

| Benua         | Jumlah Merchant | Jumlah Transaksi | Total Amount    |
|---------------|------------------|------------------|-----------------|
| North America | 122,184          | 11,521,738       | 470,736,158     |
| Online        | 218              | 1,528,138        | 86,584,443      |
| Europe        | 1,098            | 27,087           | 1,194,403       |
| Asia          | 533              | 11,495           | 432,133         |
| South America | 160              | 2,398            | 77,438          |
| Middle East   | 111              | 1,639            | 54,494          |
| Oceania       | 107              | 910              | 35,274          |
| Africa        | 169              | 1,111            | 40,758          |
| Other         | 1                | 6                | 124             |


#### 🛒 Sebaran IRL Description: 109


#### 🛒 Top 15 MCC Berdasarkan IRL Description (% dari total amount)

| IRL Description                                      | ID MCC | Jumlah Transaksi | Total Amount     | % Amount |
|-----------------------------------------------------|--------|------------------|------------------|----------|
| Wires, Money Orders                                 | 1      | 570,934          | 51,445,222.99    | 9.20%    |
| Grocery Stores, Supermarkets                        | 1      | 1,574,435        | 40,083,548.06    | 7.17%    |
| Wholesale Clubs                                     | 1      | 589,761          | 36,751,810.42    | 6.57%    |
| Drug Stores and Pharmacies                          | 1      | 760,152          | 34,233,787.93    | 6.12%    |
| Service Stations                                    | 1      | 1,400,762        | 28,705,641.24    | 5.13%    |
| Utilities                                           | 1      | 236,951          | 26,986,594.58    | 4.83%    |
| Department Stores                                   | 1      | 465,303          | 26,326,849.53    | 4.71%    |
| Eating Places, Restaurants                          | 1      | 989,378          | 25,948,610.92    | 4.64%    |
| Auto Service Shops                                  | 1      | 470,632          | 24,475,549.67    | 4.38%    |
| Telecommunication Services                          | 1      | 212,804          | 24,143,360.60    | 4.32%    |
| Tolls/Bridge Fees                                   | 1      | 660,480          | 23,347,634.27    | 4.18%    |
| Airlines                                            | 15     | 25,680           | 18,797,615.70    | 3.36%    |
| Miscellaneous Food Stores - Convenience & Specialty | 1      | 1,439,981        | 15,056,036.39    | 2.69%    |
| Fast Food Restaurants                               | 1      | 494,475          | 12,930,835.33    | 2.31%    |
| Insurance Underwriting, Premiums                    | 1      | 50,271           | 11,718,183.21    | 2.10%    |


#### 📦 Distribusi MCC Category (% dari total amount)

| MCC Category           | ID MCC | Jumlah Transaksi | Total Amount     | % Amount |
|------------------------|--------|------------------|------------------|----------|
| Retail                 | 28     | 5,198,260        | 162,418,874.37   | 29.05%   |
| Government & Utilities | 4      | 2,396,823        | 80,512,615.29    | 14.40%   |
| Financial Services     | 3      | 624,681          | 63,797,597.62    | 11.41%   |
| Healthcare             | 8      | 871,403          | 52,736,538.34    | 9.43%    |
| Entertainment & Media  | 11     | 586,604          | 52,193,741.35    | 9.33%    |
| Food & Beverage        | 3      | 1,730,282        | 45,087,978.91    | 8.06%    |
| Transportation         | 21     | 608,292          | 41,519,045.26    | 7.43%    |
| Professional Services  | 12     | 822,879          | 40,258,952.08    | 7.20%    |
| Hospitality            | 19     | 255,298          | 20,629,881.51    | 3.69%    |


#### 🏷️ Top 3 CRV Score per IRL Description

| CRV Score   | IRL Description              | Transaksi | ID MCC | Amount       | % Amount |
|-------------|------------------------------|-----------|--------|--------------|----------|
| Gold        | Wires, Money Orders          | 217,196   | 1      | 20,241,074.97| 10.01%   |
| Gold        | Grocery Stores, Supermarkets| 608,877   | 4943   | 14,585,987.05| 7.21%    |
| Gold        | Wholesale Clubs             | 225,913   | 1479   | 13,283,721.11| 6.57%    |
| Platinum    | Wires, Money Orders         | 228,685   | 1      | 21,308,729.24| 9.25%    |
| Platinum    | Grocery Stores, Supermarkets| 568,052   | 4650   | 17,841,550.06| 7.75%    |
| Platinum    | Wholesale Clubs             | 216,855   | 1450   | 16,186,001.00| 7.03%    |
| Silver      | Wires, Money Orders         | 116,643   | 1      | 9,145,761.05 | 7.61%    |
| Silver      | Utilities                   | 76,759    | 1539   | 8,293,723.41 | 6.90%    |
| Silver      | Telecommunication Services  | 70,687    | 4      | 7,645,224.86 | 6.36%    |
| Watchlist   | Wires, Money Orders         | 8,410     | 1      | 749,657.73   | 11.71%   |
| Watchlist   | Utilities                   | 3,782     | 142    | 409,874.83   | 6.40%    |
| Watchlist   | Grocery Stores, Supermarkets| 18,347    | 454    | 398,741.58   | 6.23%    |



#### 🏷️ Top 3 CRV Score per MCC Category

| CRV Score | MCC Category           | Transaksi | ID MCC | Amount        | % Amount |
|-----------|------------------------|-----------|--------|---------------|----------|
| Gold      | Retail                 | 2,097,795 | 14,735 | 60,072,865.04 | 29.71%   |
| Gold      | Government & Utilities | 898,104   | 1,849  | 28,459,322.40 | 14.07%   |
| Gold      | Financial Services     | 237,473   | 441    | 24,682,711.10 | 12.21%   |
| Platinum  | Retail                 | 1,778,785 | 13,228 | 68,198,816.16 | 29.61%   |
| Platinum  | Government & Utilities | 959,776   | 1,635  | 34,686,974.01 | 15.06%   |
| Platinum  | Financial Services     | 244,248   | 350    | 25,862,339.74 | 11.23%   |
| Silver    | Retail                 | 1,265,303 | 12,360 | 32,538,212.67 | 27.07%   |
| Silver    | Government & Utilities | 514,022   | 1,558  | 16,513,941.01 | 13.74%   |
| Silver    | Entertainment & Media  | 177,006   | 2,016  | 13,795,870.81 | 11.48%   |
| Watchlist | Retail                 | 56,377    | 1,110  | 1,608,980.50  | 25.13%   |
| Watchlist | Financial Services     | 9,239     | 44     | 968,039.84    | 15.12%   |
| Watchlist | Government & Utilities | 24,921    | 157    | 852,377.87    | 13.31%   |
