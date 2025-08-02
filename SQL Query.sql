-- ============================
-- STEP 1: CREATE TABLES (RAW IMPORT,PK,FK)
-- ============================
CREATE TABLE users_data (
    client_id TEXT PRIMARY KEY,
    current_age INT,
    retirement_age INT,
    birth_year INT,
    birth_month INT,
    gender VARCHAR(10),
    address TEXT,
    latitude NUMERIC,
    longitude NUMERIC,
    per_capita_income TEXT,  -- Ada simbol $, perlu dibersihkan nanti
    yearly_income TEXT,  -- Ada simbol $, perlu dibersihkan nanti
    total_debt TEXT,  -- Ada simbol $, perlu dibersihkan nanti
    credit_score INT,
    num_credit_cards INT
);
CREATE TABLE cards_data (
    card_id TEXT PRIMARY KEY,
    client_id TEXT REFERENCES users_data(client_id),
    card_brand TEXT,
    card_type TEXT,
    card_number TEXT,
    expires TEXT,                -- Format MM/YYYY, simpan sementara sebagai TEXT
    cvv TEXT,                    -- Simpan sebagai TEXT, saat praproses munculkan landing zone
    has_chip TEXT,              
    num_cards_issued INT,
    credit_limit TEXT,          -- Ada simbol $, perlu dibersihkan nanti
    acct_open_date TEXT,        -- Format MM/YYYY, simpan sebagai TEXT dulu
    year_pin_last_changed INT,
    card_on_dark_web TEXT       
);
CREATE TABLE transactions_data (
    transactions_id TEXT PRIMARY KEY,
    date TIMESTAMP,                     
    client_id TEXT REFERENCES users_data(client_id),
    card_id TEXT REFERENCES cards_data(card_id),
    amount TEXT,                   -- Mengandung $ dan minus, simpan sebagai TEXT dulu
    use_chip TEXT,               
    merchant_id TEXT,
    merchant_city TEXT,				-- Jika Kosong berarti transaksi online
    merchant_state TEXT,			-- Jika Kosong berarti transaksi online
    zip TEXT,						-- Jika Kosong berarti transaksi online
    mcc TEXT,
    errors TEXT                    -- Kosong atau berisi string error
);
-- Setelah berhasil import file csv

-- ============================
-- STEP 2: CLEANING / PREPROCESSING
-- ============================
-- users_data: Hapus simbol $
UPDATE users_data
SET 
    per_capita_income = REPLACE(per_capita_income, '$', ''),
    yearly_income     = REPLACE(yearly_income, '$', ''),
    total_debt        = REPLACE(total_debt, '$', '')
;
-- cards_data: Hapus $ dan rapikan CVV (3 digit)
UPDATE cards_data
SET
    credit_limit = REPLACE(credit_limit, '$', ''),
    cvv = LPAD(TRIM(cvv), 3, '0')
;
-- transactions_data: Bersihkan $ dan isi  merchant_city_state_zip kosong jadi 'ONLINE'
UPDATE transactions_data
SET 
    amount = REPLACE(amount, '$', ''),
    merchant_city  = CASE WHEN COALESCE(TRIM(merchant_city), '') = '' THEN 'ONLINE' ELSE merchant_city END,
    merchant_state = CASE WHEN COALESCE(TRIM(merchant_state), '') = '' THEN 'ONLINE' ELSE merchant_state END,
    zip            = CASE WHEN COALESCE(TRIM(zip), '') = '' THEN 'ONLINE' ELSE zip END
;
-- Konversi tipe kolom jadi NUMERIC 
ALTER TABLE users_data
    ALTER COLUMN per_capita_income TYPE NUMERIC USING per_capita_income::NUMERIC,
    ALTER COLUMN yearly_income     TYPE NUMERIC USING yearly_income::NUMERIC,
    ALTER COLUMN total_debt        TYPE NUMERIC USING total_debt::NUMERIC
;
ALTER TABLE cards_data
    ALTER COLUMN credit_limit TYPE NUMERIC USING credit_limit::NUMERIC
;
ALTER TABLE transactions_data
    ALTER COLUMN amount TYPE NUMERIC USING amount::NUMERIC
;
-- Check salah satu Update Data 
SELECT * FROM transactions_data LIMIT 10;
-- Check salah satu missing/null value, kecuali kolom error 
SELECT COUNT(*) FROM users_data WHERE yearly_income IS NULL;

-- ============================
-- STEP 3 : DISTRIBUSI DATA - users_data
-- ============================
-- Total user
SELECT COUNT(DISTINCT client_id) AS total_users FROM users_data;
-- Statistik umur (min, max, average)
SELECT
  MIN(current_age) AS min_age,
  MAX(current_age) AS max_age,
  ROUND(AVG(current_age), 2) AS avg_age
FROM users_data;
-- Distribusi Gender
SELECT
  gender,
  COUNT(*) AS total_users,
  ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS percentage
FROM users_data
GROUP BY gender
ORDER BY total_users DESC;
-- Distribusi Address
SELECT
  TRIM(SUBSTRING(address FROM POSITION(' ' IN address) + 1)) AS address_group,
  COUNT(*) AS total_users,
  ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS percentage
FROM users_data
WHERE address IS NOT NULL AND address != ''
GROUP BY address_group
ORDER BY total_users DESC
LIMIT 10;
-- Statistik Per capita income stats
SELECT MIN(per_capita_income), MAX(per_capita_income), AVG(per_capita_income) FROM users_data;
-- Statistik Yearly income stats
SELECT MIN(yearly_income), MAX(yearly_income), AVG(yearly_income) FROM users_data;
-- Statistik Total debt stats
SELECT MIN(total_debt), MAX(total_debt), AVG(total_debt), SUM(total_debt) FROM users_data;
-- Distribusi credit cards 
SELECT num_credit_cards, COUNT(*) AS jumlah FROM users_data GROUP BY num_credit_cards;
SELECT
  MIN(num_credit_cards) AS min_cards,
  MAX(num_credit_cards) AS max_cards,
  ROUND(AVG(num_credit_cards), 2) AS avg_cards
FROM users_data; -- min, max, average

-- ============================
-- STEP 3 : DISTRIBUSI DATA - cards_data
-- ============================
-- Total kartu
SELECT COUNT(*) AS total_cards FROM cards_data;
-- Distribusi card_brand
SELECT 
  card_brand,
  COUNT(*) AS total,
  ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS percentage
FROM cards_data
GROUP BY card_brand
ORDER BY total
;
-- Distribusi card_type
SELECT 
  card_type,
  COUNT(*) AS total,
  ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS percentage
FROM cards_data
GROUP BY card_type
ORDER BY total
;
-- Distribusi has_chip
SELECT 
  has_chip,
  COUNT(*) AS total,
  ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS percentage
FROM cards_data
GROUP BY has_chip
ORDER BY total DESC;
-- Distribusi card_on_dark_web
SELECT 
  card_on_dark_web,
  COUNT(*) AS total,
  ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS percentage
FROM cards_data
GROUP BY card_on_dark_web
ORDER BY total DESC;
-- Statistik Credit limit
SELECT MIN(credit_limit), MAX(credit_limit), AVG(credit_limit), SUM(credit_limit) FROM cards_data;
-- Sebaran Expired year
SELECT SPLIT_PART(expires, '/', 2) AS expired_year, COUNT(*) FROM cards_data GROUP BY expired_year ORDER BY expired_year;
-- Sebaran Account open year
SELECT SPLIT_PART(acct_open_date, '/', 2) AS open_year, COUNT(*) FROM cards_data GROUP BY open_year ORDER BY open_year;
-- Jumlah kartu yang dikeluarkan untuk 1 id kartu
SELECT num_cards_issued, COUNT(*) FROM cards_data GROUP BY num_cards_issued ORDER BY num_cards_issued;

-- ============================
-- STEP 3 : DISTRIBUSI DATA - transactions_data
-- ============================
-- Total transaksi dan total amount
SELECT 
  COUNT(transactions_id) AS total_transactions,
  SUM (amount) AS total_amount
FROM transactions_data
;
-- Distribusi jenis transaksi
SELECT 
  use_chip, 
  COUNT(*) AS total,
  ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS percentage
FROM transactions_data 
GROUP BY use_chip 
ORDER BY total DESC
;
-- Distribusi Merchant state
SELECT 
  COUNT(DISTINCT merchant_state) AS jumlah_merchant_state
FROM transactions_data
WHERE merchant_state IS NOT NULL AND merchant_state <> '';
SELECT 
  merchant_state,
  COUNT(*) AS total_transactions,
  SUM(amount::numeric) AS total_amount,
  ROUND(100.0 * SUM(amount::numeric) / SUM(SUM(amount::numeric)) OVER (), 2) AS percentage_amount
FROM transactions_data
WHERE merchant_state IS NOT NULL AND merchant_state <> ''
GROUP BY merchant_state
ORDER BY percentage_amount DESC
LIMIT 15
;
-- Distribusi MCC
SELECT 
  COUNT(DISTINCT mcc) AS jumlah_kategori_mcc
FROM transactions_data
WHERE mcc IS NOT NULL AND mcc <> '';
SELECT 
  mcc,
  COUNT(*) AS total_transactions,
  SUM(amount::numeric) AS total_amount,
  ROUND(100.0 * SUM(amount::numeric) / SUM(SUM(amount::numeric)) OVER (), 2) AS percentage_amount
FROM transactions_data
WHERE mcc IS NOT NULL AND mcc <> ''
GROUP BY mcc
ORDER BY percentage_amount DESC
LIMIT 15
;
-- Total transaksi error
SELECT COUNT(*) AS total_error_transactions
FROM transactions_data
WHERE errors IS NOT NULL AND errors <>''
;
-- Total Kerugian karena error
SELECT 
  SUM(amount::numeric) AS total_loss_due_to_errors
FROM transactions_data
WHERE errors IS NOT NULL AND errors <> ''
;
-- Distribusi jenis error berdasarkan jumlah transaksi (tanpa NULL)
SELECT 
  errors,
  COUNT(*) AS total_transactions,
  ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS percentage_transactions
FROM transactions_data
WHERE errors IS NOT NULL AND errors <> ''
GROUP BY errors
ORDER BY total_transactions DESC
LIMIT 5
;
-- Distribusi jenis error berdasarkan nominal amount (tanpa NULL)
SELECT 
  errors,
  SUM(amount::numeric) AS total_amount,
  ROUND(100.0 * SUM(amount::numeric) / SUM(SUM(amount::numeric)) OVER (), 2) AS percentage_amount
FROM transactions_data
WHERE errors IS NOT NULL AND errors <> ''
GROUP BY errors
ORDER BY total_amount DESC
LIMIT 5
;

-- ============================
-- STEP 4: FILTERING DATA - transactions_data_filter
-- ============================
-- Membuat tabel baru yang berisi transaksi bersih (tanpa error)
CREATE TABLE transactions_data_filter AS
SELECT *
FROM transactions_data
WHERE errors IS NULL OR TRIM(errors) = ''
;
Select * from transactions_data_filter;
-- Total transaksi bersih dan total amount
SELECT 
  COUNT(transactions_id) AS total_transactions_filter,
  SUM (amount) AS total_amount_filter
FROM transactions_data_filter
;

-- ============================
-- STEP 5: ANALISYST DATA - Segmentation
-- ============================
-- Distribusi umur dengan klasifikasi umur berdasarkan Kotler & Keller – Marketing Management (edisi 15)
WITH age_grouped AS (
  SELECT
    client_id,
    CASE
      WHEN current_age < 20 THEN 'Remaja/Pelajar'
      WHEN current_age BETWEEN 20 AND 29 THEN 'Dewasa Muda'
      WHEN current_age BETWEEN 30 AND 49 THEN 'Dewasa'
      WHEN current_age BETWEEN 50 AND 59 THEN 'Pra-Pensiun'
      ELSE 'Pensiun'
    END AS age_group
  FROM users_data
)

SELECT
  age_group,
  COUNT(*) AS total_users,
  ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS percentage
FROM age_grouped
GROUP BY age_group
ORDER BY 
  CASE age_group
    WHEN 'Remaja/Pelajar' THEN 1
    WHEN 'Dewasa Muda' THEN 2
    WHEN 'Dewasa' THEN 3
    WHEN 'Pra-Pensiun' THEN 4
    WHEN 'Pensiun' THEN 5
  END;
-- Klasifikasi Usia Customer by total user, transaksi, amount 
WITH age_grouped AS (
  SELECT
    client_id,
    CASE
      WHEN current_age < 20 THEN 'Remaja/Pelajar'
      WHEN current_age BETWEEN 20 AND 29 THEN 'Dewasa Muda'
      WHEN current_age BETWEEN 30 AND 49 THEN 'Dewasa'
      WHEN current_age BETWEEN 50 AND 59 THEN 'Pra-Pensiun'
      ELSE 'Pensiun'
    END AS age_group
  FROM users_data
),
trx_with_age AS (	
  SELECT 
    t.*,
    a.age_group
  FROM transactions_data_filter t
  JOIN age_grouped a ON t.client_id = a.client_id
),
user_count AS (
  SELECT 
    age_group,
    COUNT(*) AS total_users,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS percentage_users
  FROM age_grouped
  GROUP BY age_group
)

SELECT
  t.age_group,
  u.total_users,
  u.percentage_users,
  COUNT(*) AS total_transactions,
  ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS percentage_transactions,
  SUM(amount::numeric) AS total_amount,
  ROUND(100.0 * SUM(amount::numeric) / SUM(SUM(amount::numeric)) OVER (), 2) AS percentage_amount
FROM trx_with_age t
JOIN user_count u ON t.age_group = u.age_group
GROUP BY t.age_group, u.total_users, u.percentage_users
ORDER BY 
  CASE t.age_group
    WHEN 'Remaja/Pelajar' THEN 1
    WHEN 'Dewasa Muda' THEN 2
    WHEN 'Dewasa' THEN 3
    WHEN 'Pra-Pensiun' THEN 4
    WHEN 'Pensiun' THEN 5
  END
;
-- Klasifikasi Credit Score (FICO)
CREATE TABLE credit_score_table AS -- Membuat tabel credit_score_table dengan klasifikasi FICO per client
SELECT
  client_id,
  credit_score,
  CASE
    WHEN credit_score < 580 THEN 'Poor'
    WHEN credit_score BETWEEN 580 AND 669 THEN 'Fair'
    WHEN credit_score BETWEEN 670 AND 739 THEN 'Good'
    WHEN credit_score BETWEEN 740 AND 799 THEN 'Very Good'
    ELSE 'Exceptional'
  END AS fico_category
FROM users_data;
SELECT -- Distribusi FICO Category: Total User dan Persentase
  fico_category,
  COUNT(*) AS total_users,
  ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS percentage
FROM credit_score_table
GROUP BY fico_category
ORDER BY
  CASE fico_category
    WHEN 'Poor' THEN 1
    WHEN 'Fair' THEN 2
    WHEN 'Good' THEN 3
    WHEN 'Very Good' THEN 4
    WHEN 'Exceptional' THEN 5
  END;
-- Analisis Customer Fokus – Top 10 Pelanggan berdasarkan Total Amount (Nominal)
WITH customer_amount_summary AS (
  SELECT 
    t.client_id,
    SUM(t.amount::numeric) AS total_amount
  FROM transactions_data_filter t
  JOIN users_data u ON t.client_id = u.client_id
  GROUP BY t.client_id
),
total_all AS (
  SELECT 
    SUM(total_amount) AS grand_total_amount
  FROM customer_amount_summary
)

SELECT 
  c.client_id,
  c.total_amount,
  ROUND(100.0 * c.total_amount / t.grand_total_amount, 2) AS percentage_amount
FROM customer_amount_summary c
CROSS JOIN total_all t
ORDER BY c.total_amount DESC
LIMIT 10
;
-- Analisis Customer Fokus - Customer yang Menyumbang 70% (Pareto) Total Transaksi (Amount)
WITH customer_amount_summary AS (
  SELECT 
    t.client_id,
    SUM(t.amount::numeric) AS total_amount
  FROM transactions_data_filter t
  GROUP BY t.client_id
),
ranked_customers AS (
  SELECT
    client_id,
    total_amount,
    ROUND(100.0 * total_amount / SUM(total_amount) OVER (), 2) AS percentage_amount,
    SUM(total_amount) OVER (ORDER BY total_amount DESC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) 
      AS cumulative_amount,
    SUM(total_amount) OVER () AS grand_total
  FROM customer_amount_summary
),
cutoff AS (
  SELECT 
    *,
    ROUND(100.0 * cumulative_amount / grand_total, 2) AS cumulative_percentage
  FROM ranked_customers
),
pareto_customers AS (
  SELECT *
  FROM cutoff
  WHERE cumulative_percentage <= 70
),
final_summary AS (
  SELECT 
    COUNT(*) AS customer_count_70,
    SUM(total_amount) AS total_amount_70
  FROM pareto_customers
),
total_summary AS (
  SELECT 
    COUNT(*) AS total_customer,
    SUM(total_amount) AS grand_total
  FROM customer_amount_summary
)

SELECT 
  f.customer_count_70,
  t.total_customer,
  ROUND(100.0 * f.customer_count_70::numeric / t.total_customer, 2) AS percentage_customer_contributor,
  f.total_amount_70,
  t.grand_total,
  ROUND(100.0 * f.total_amount_70 / t.grand_total, 2) AS percentage_amount_contributed
FROM final_summary f, total_summary t
;
-- Analisis Maktriks Customer - Aktif/Pasif vs High/Low Spender
CREATE TABLE customer_matrix_table AS
-- Summary transaksi per client
WITH trx_summary AS ( 
  SELECT
    client_id,
    COUNT(*) AS total_trx,
    SUM(amount::numeric) AS total_amount
  FROM transactions_data_filter
  GROUP BY client_id
),
-- Hitung rata-rata frekuensi dan amount sebagai ambang batas
thresholds AS (
  SELECT 
    AVG(total_trx) AS avg_trx,
    AVG(total_amount) AS avg_amt
  FROM trx_summary
),
-- Segmentasi berdasarkan dua dimensi
segmented AS (
  SELECT
    t.client_id,
    t.total_trx,
    t.total_amount,
    CASE 
      WHEN t.total_trx > th.avg_trx THEN 'Aktif'
      ELSE 'Pasif'
    END AS activity_level,
    CASE 
      WHEN t.total_amount > th.avg_amt THEN 'High Spender'
      ELSE 'Low Spender'
    END AS spending_level,
    CASE
      WHEN t.total_trx > th.avg_trx AND t.total_amount > th.avg_amt THEN 'Aktif - High Spender (C1)'
      WHEN t.total_trx > th.avg_trx AND t.total_amount <= th.avg_amt THEN 'Aktif - Low Spender (C3)'
      WHEN t.total_trx <= th.avg_trx AND t.total_amount > th.avg_amt THEN 'Pasif - High Spender (C2)'
      ELSE 'Pasif - Low Spender (C4)'
    END AS customer_segment
  FROM trx_summary t, thresholds th
)
SELECT
  client_id,
  total_trx,
  total_amount,
  activity_level,
  spending_level,
  customer_segment
FROM segmented;
SELECT 
  customer_segment,
  COUNT(*) AS total_customers,
  ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS percentage_customers,
  ROUND(AVG(total_trx), 2) AS avg_transaction,
  ROUND(AVG(total_amount), 2) AS avg_amount,
  SUM(total_amount) AS total_amount_segment,
  ROUND(100.0 * SUM(total_amount) / SUM(SUM(total_amount)) OVER (), 2) AS percentage_total_amount
FROM customer_matrix_table
GROUP BY customer_segment
ORDER BY 
  CASE customer_segment
    WHEN 'Aktif - High Spender' THEN 1
    WHEN 'Aktif - Low Spender' THEN 2
    WHEN 'Pasif - High Spender' THEN 3
    WHEN 'Pasif - Low Spender' THEN 4
  END;
-- Analisis Customer Potensial by avg_transaction_per_customer & avg_total_amount_per_customer 
WITH trx_summary AS (
  SELECT
    client_id,
    COUNT(*) AS total_trx,
    AVG(amount::numeric) AS avg_amount,
    SUM(amount::numeric) AS total_amount
  FROM transactions_data_filter
  GROUP BY client_id
),
-- Hitung rerata transaksi dan amount untuk seluruh customer
all_customer_stats AS (
  SELECT 
    ROUND(AVG(total_trx), 2) AS avg_transaction_per_customer,
    ROUND(AVG(total_amount), 2) AS avg_total_amount_per_customer
  FROM trx_summary
),
-- Threshold untuk klasifikasi potensial: di bawah rata-rata frekuensi, di atas rata-rata nominal
thresholds AS (
  SELECT
    AVG(total_trx) AS avg_total_trx,
    AVG(avg_amount) AS avg_trx_amount
  FROM trx_summary
),
-- Customer Potensial = sedikit transaksi, tapi nilai per transaksi besar
potential_customers AS (
  SELECT 
    t.client_id,
    t.total_trx,
    t.avg_amount,
    t.total_amount
  FROM trx_summary t, thresholds th
  WHERE t.total_trx < th.avg_total_trx
    AND t.avg_amount > th.avg_trx_amount
),
-- Statistik untuk customer potensial
potential_stats AS (
  SELECT 
    COUNT(*) AS potential_customer_count,
    ROUND(AVG(total_trx), 2) AS avg_transaction_per_customer_potential,
    ROUND(AVG(total_amount), 2) AS avg_total_amount_per_customer_potential,
    ROUND(SUM(total_amount), 2) AS total_amount_from_potential
  FROM potential_customers
)

-- Gabungkan hasil dari kedua kelompok
SELECT 
  a.avg_transaction_per_customer,
  a.avg_total_amount_per_customer,
  p.potential_customer_count,
  p.avg_transaction_per_customer_potential,
  p.avg_total_amount_per_customer_potential,
  p.total_amount_from_potential
FROM all_customer_stats a, potential_stats p
;
-- Customer Potensial vs Maktriks Customer
WITH trx_summary AS (
  SELECT
    client_id,
    COUNT(*) AS total_trx,
    SUM(amount::numeric) AS total_amount,
    AVG(amount::numeric) AS avg_amount
  FROM transactions_data_filter
  GROUP BY client_id
),

-- Hitung threshold rata-rata nasional
thresholds AS (
  SELECT 
    AVG(total_trx) AS avg_trx,
    AVG(avg_amount) AS avg_amount_per_trx
  FROM trx_summary
),

-- Identifikasi customer potensial:
-- Transaksinya < rata-rata, tetapi nominal per transaksi > rata-rata
potential_customers AS (
  SELECT 
    t.client_id
  FROM trx_summary t
  JOIN thresholds th ON TRUE
  WHERE t.total_trx < th.avg_trx
    AND t.avg_amount > th.avg_amount_per_trx
)

-- Gabungkan customer potensial dengan segmentasi dari customer_matrix_table
SELECT 
  s.customer_segment,
  COUNT(*) AS total_potential_customers_in_segment
FROM potential_customers p
JOIN customer_matrix_table s ON p.client_id = s.client_id
GROUP BY s.customer_segment
ORDER BY total_potential_customers_in_segment DESC;

-- ============================
-- STEP 6: ANALISYST DATA - Consumption
-- ============================
-- Mapping Penggunaan Kartu all
 SELECT
  c.card_brand || ' - ' || c.card_type AS card_group,
  COUNT(DISTINCT c.client_id) AS total_customer,
  COUNT(*) AS total_cards
FROM cards_data c
GROUP BY card_group
ORDER BY total_customer DESC
;
-- Mapping Penggunaan Kartu Customer Fokus by jumlah kartu
WITH customer_transaction_summary AS (
-- 1. Hitung total transaksi dan nominal per customer
  SELECT
    client_id,
    COUNT(*) AS total_transaction,
    SUM(amount::numeric) AS total_amount
  FROM transactions_data_filter
  GROUP BY client_id
),

-- 2. Hitung rata-rata dari seluruh customer
avg_stats AS (
  SELECT 
    AVG(total_transaction) AS avg_transaction,
    AVG(total_amount) AS avg_amount
  FROM customer_transaction_summary
),

-- 3. Segmen customer berdasarkan avg
customer_segments AS (
  SELECT 
    cts.client_id,
    CASE 
      WHEN cts.total_transaction >= a.avg_transaction AND cts.total_amount >= a.avg_amount THEN 'Aktif - High Spender'
      WHEN cts.total_transaction >= a.avg_transaction AND cts.total_amount < a.avg_amount THEN 'Aktif - Low Spender'
      WHEN cts.total_transaction < a.avg_transaction AND cts.total_amount >= a.avg_amount THEN 'Pasif - High Spender'
      ELSE 'Pasif - Low Spender'
    END AS customer_segment
  FROM customer_transaction_summary cts, avg_stats a
),

-- 4. Gabungkan dengan data kartu
segment_card AS (
  SELECT 
    cs.customer_segment,
    cd.card_brand,
    cd.card_type,
    COUNT(DISTINCT cd.client_id) AS total_customer,
    COUNT(*) AS total_cards
  FROM customer_segments cs
  JOIN cards_data cd ON cs.client_id = cd.client_id
  WHERE cs.customer_segment = 'Aktif - High Spender'
  GROUP BY cs.customer_segment, cd.card_brand, cd.card_type
)

-- 5. Tampilkan hasil akhir
SELECT * FROM segment_card
ORDER BY total_cards DESC
;
-- Mapping Jenis Transaksi
SELECT 
  use_chip,
  COUNT(*) AS total_transaction,
  ROUND(100.0 * COUNT(*) / (SELECT COUNT(*) FROM transactions_data_filter), 2) AS percentage
FROM transactions_data_filter
GROUP BY use_chip
;
-- Sebaran Waktu Transaksi
-- Transaksi Per Hari 
SELECT 
  ROUND(AVG(tx_count), 2) AS avg_transaction_per_day,
  ROUND(AVG(tx_amount), 2) AS avg_amount_per_day,
  ROUND(AVG(tx_user), 2) AS avg_user_per_day
FROM (
  SELECT 
    date,
    COUNT(*) AS tx_count,
    SUM(amount) AS tx_amount,
    COUNT(DISTINCT client_id) AS tx_user
  FROM transactions_data_filter
  GROUP BY date
) daily_stats;
-- Transaksi Per Jam 
SELECT 
    EXTRACT(HOUR FROM date) AS hour_of_day,
    COUNT(*) AS total_transactions,
    ROUND(AVG(amount), 2) AS avg_amount,
    COUNT(DISTINCT client_id) AS unique_users
FROM transactions_data_filter
GROUP BY hour_of_day
ORDER BY hour_of_day;
-- Transaksi segementasi Per Jam
WITH waktu_trans AS (
    SELECT 
        *,
        EXTRACT(HOUR FROM date) AS jam,
        DATE(date) AS tanggal,
        CASE 
            WHEN EXTRACT(HOUR FROM date) BETWEEN 5 AND 10 THEN 'Pagi'
            WHEN EXTRACT(HOUR FROM date) BETWEEN 11 AND 14 THEN 'Siang'
            WHEN EXTRACT(HOUR FROM date) BETWEEN 15 AND 18 THEN 'Sore'
            ELSE 'Malam'
        END AS waktu_segment
    FROM transactions_data_filter
),
daily_stats AS (
    SELECT 
        tanggal,
        waktu_segment,
        COUNT(*) AS daily_transactions,
        SUM(amount) AS daily_amount,
        COUNT(DISTINCT client_id) AS daily_users
    FROM waktu_trans
    GROUP BY tanggal, waktu_segment
)

SELECT 
    waktu_segment,
    ROUND(AVG(daily_transactions), 2) AS avg_transactions_per_day,
    ROUND(AVG(daily_amount), 2) AS avg_amount_per_day,
    ROUND(AVG(daily_users), 2) AS avg_users_per_day
FROM daily_stats
GROUP BY waktu_segment
ORDER BY 
    CASE waktu_segment
        WHEN 'Pagi' THEN 1
        WHEN 'Siang' THEN 2
        WHEN 'Sore' THEN 3
        WHEN 'Malam' THEN 4
    END;
-- Transaksi Per Bulan 
SELECT 
  TO_CHAR(date, 'Month') AS month_name,
  ROUND(AVG(tx_count), 2) AS avg_transaction,
  ROUND(AVG(tx_amount), 2) AS avg_amount,
  ROUND(AVG(tx_user), 2) AS avg_user
FROM (
  SELECT 
    EXTRACT(MONTH FROM date) AS month_num,
    date,
    COUNT(*) AS tx_count,
    SUM(amount) AS tx_amount,
    COUNT(DISTINCT client_id) AS tx_user
  FROM transactions_data_filter
  GROUP BY date
) monthly_base
GROUP BY month_name, month_num
ORDER BY month_num;
-- Transaksi Per Tahun 
SELECT 
  EXTRACT(YEAR FROM date) AS year,
  COUNT(*) AS total_transactions,
  SUM(amount) AS total_amount,
  COUNT(DISTINCT client_id) AS total_users
FROM transactions_data_filter
GROUP BY EXTRACT(YEAR FROM date)
ORDER BY year;
-- Statistika credit limit
SELECT 
  MIN(credit_limit) AS min_limit,
  MAX(credit_limit) AS max_limit,
  ROUND(AVG(credit_limit), 2) AS avg_limit,
  SUM(credit_limit) AS total_credit_limit
FROM cards_data;
-- Statistika credit limit per branch_card & type_card
SELECT 
  card_brand,
  card_type,
  COUNT(*) AS total_cards,
  ROUND(AVG(credit_limit), 2) AS avg_credit_limit,
  MIN(credit_limit) AS min_credit_limit,
  MAX(credit_limit) AS max_credit_limit
FROM cards_data
GROUP BY card_brand, card_type
ORDER BY avg_credit_limit DESC;
-- Analisis kategori utilisasi credit limit (non-revolve)
CREATE TABLE credit_utilization_table AS
WITH card_usage AS (
  SELECT 
    c.card_id,
    c.client_id,
    c.credit_limit,
    COALESCE(SUM(t.amount), 0) AS total_usage
  FROM cards_data c
  LEFT JOIN transactions_data t ON c.card_id = t.card_id
  GROUP BY c.card_id, c.client_id, c.credit_limit
),

final_table AS (
  SELECT 
    *,
    ROUND(total_usage * 1.0 / NULLIF(credit_limit, 0), 2) AS utilization_ratio
  FROM card_usage
),

categorized AS (
  SELECT 
    *,
    CASE 
      WHEN utilization_ratio > 0.9 THEN 'Optimal'
      WHEN utilization_ratio BETWEEN 0.9 AND 0.7 THEN 'Under Control'
      ELSE 'Idle Use'
    END AS utilization_category
  FROM final_table
)

SELECT 
  client_id,
  card_id,
  credit_limit,
  total_usage,
  utilization_ratio,
  utilization_category
FROM categorized;
SELECT * From credit_utilization_table;
-- Analisis utilisasi credit limit by total amount per card
SELECT
  COUNT(*) AS total_cards,
  ROUND(AVG(credit_limit)) AS avg_limit,
  ROUND(AVG(total_usage)) AS avg_transaction,
  ROUND(AVG(utilization_ratio), 2) AS avg_utilization_ratio
FROM credit_utilization_table;
-- Gabungkan segmentasi customer dengan data utilisasi kartu
SELECT 
  cm.customer_segment,
  COUNT(cu.card_id) AS total_cards,
  ROUND(AVG(cu.credit_limit)) AS avg_limit,
  ROUND(AVG(cu.total_usage)) AS avg_usage,
  ROUND(AVG(cu.utilization_ratio), 2) AS avg_utilization_ratio
FROM credit_utilization_table cu
JOIN customer_matrix_table cm ON cu.client_id = cm.client_id
GROUP BY cm.customer_segment
ORDER BY avg_utilization_ratio DESC;
-- Menentukan Tanggal Terakhir Transaksi (data all no filter error)
SELECT 
    MAX(date) AS last_transaction_date
FROM transactions_data;
-- Analisis card yg tidak bertransaksi sampai 1 tahun lalu (2018-10-31) (data all no filter error)
SELECT COUNT(*) AS inactive_cards
FROM (
  SELECT 
    c.card_id,
    MAX(t.date) AS last_tx_date
  FROM cards_data c
  LEFT JOIN transactions_data t ON c.card_id = t.card_id
  GROUP BY c.card_id
  HAVING MAX(t.date) IS NULL OR MAX(t.date) < '2018-10-31'
) sub;
-- Analisis customer yg tidak bertransaksi sampai 1 tahun lalu (2018-10-31) (data all no filter error)
SELECT COUNT(*) AS inactive_clients
FROM (
  SELECT 
    u.client_id,
    MAX(t.date) AS last_tx_date
  FROM users_data u
  LEFT JOIN transactions_data t ON u.client_id = t.client_id
  GROUP BY u.client_id
  HAVING MAX(t.date) IS NULL OR MAX(t.date) < '2018-10-31'
) sub;

-- ============================
-- STEP 7: ANALISYST DATA - Anomalies (data all no filter error)
-- ============================
-- Rata-rata Umur Kartu
SELECT 
  CAST('20' || RIGHT(expires, 2) AS INT) AS year_expired,
  COUNT(*) AS total_cards
FROM cards_data
GROUP BY year_expired
ORDER BY year_expired;
SELECT 
  ROUND(AVG(
    CAST('20' || RIGHT(expires, 2) AS INT) 
    - CAST(SPLIT_PART(acct_open_date, '/', 2) AS INT)
  ), 2) AS avg_card_age_years
FROM cards_data;
-- menghitung yg expired dan masih aktif 
SELECT 
  CASE 
    WHEN ('20' || RIGHT(expires, 2))::INT < 2019 THEN 'Expired'
    ELSE 'Active'
  END AS card_status,
  COUNT(DISTINCT card_id) AS jumlah_card_id,
  SUM(num_cards_issued) AS total_num_cards_issued
FROM cards_data
GROUP BY card_status;
-- menghitung detail anomali expired dan masih aktif 
WITH trans_last AS (
  SELECT 
    card_id,
    MAX(date) AS last_transaction
  FROM transactions_data
  GROUP BY card_id
),
card_base AS (
  SELECT 
    c.card_id,
    c.client_id,
    c.num_cards_issued,
    ('20' || RIGHT(c.expires, 2))::INT AS expired_year,
    c.card_number,
    t.last_transaction
  FROM cards_data c
  LEFT JOIN trans_last t ON c.card_id = t.card_id
),
labelled AS (
  SELECT *,
    CASE
      -- 1. Expired - Tidak Pernah Transaksi
      WHEN expired_year < 2019 AND last_transaction IS NULL THEN 'expired - tidak pernah transaksi'
	  
	  -- 2. Expired - Masih Transaksi
      WHEN expired_year < 2019 AND last_transaction IS NOT NULL AND EXTRACT(YEAR FROM last_transaction) > expired_year THEN 'expired - masih transaksi'

      -- 3. Expired - Normal
      WHEN expired_year < 2019 THEN 'expired - normal'
      
	  -- 4. Not Expired - Tidak Pernah Transaksi
      WHEN expired_year >= 2019 AND last_transaction IS NULL THEN 'not expired - belum pernah transaksi'
	  
	  -- 5. Not Expired - Tidak Transaksi > 2 Tahun
      WHEN expired_year >= 2019 AND last_transaction < DATE '2017-10-31' THEN 'not expired - sudah tidak transaksi > 2 tahun'

      -- 6. Not Expired - Normal
      WHEN expired_year >= 2019 THEN 'not expired - normal'

      ELSE 'lainnya'
    END AS keterangan
  FROM card_base
)

SELECT 
  keterangan,
  COUNT(DISTINCT card_id) AS jumlah_card_id,
  SUM(num_cards_issued) AS jumlah_num_cards_issued
FROM labelled
GROUP BY keterangan
ORDER BY 
  CASE 
    WHEN keterangan = 'expired - tidak pernah transaksi' THEN 1
    WHEN keterangan = 'expired - masih transaksi' THEN 2
    WHEN keterangan = 'expired - normal' THEN 3
    WHEN keterangan = 'not expired - belum pernah transaksi' THEN 4
    WHEN keterangan = 'not expired - sudah tidak transaksi > 2 tahun' THEN 5
    WHEN keterangan = 'not expired - normal' THEN 6
    ELSE 7
  END;
-- kartu expired dan tapi masih terdeteksi bertransaksi 
SELECT 
  COUNT(DISTINCT t.card_id) AS jumlah_kartu_expired_tapi_dipakai,
  COUNT(*) AS jumlah_transaksi_setelah_expired
FROM transactions_data t
JOIN cards_data c ON t.card_id = c.card_id
WHERE 
  EXTRACT(YEAR FROM t.date) > CAST('20' || RIGHT(c.expires, 2) AS INT);
SELECT 
  c.card_id,
  c.client_id,
  c.card_number,
  c.expires,
  c.acct_open_date,
  t.transactions_id,
  t.date,
  t.amount,
  CASE
    WHEN EXTRACT(YEAR FROM t.date) > ('20' || RIGHT(c.expires, 2))::INT 
    THEN 'Error: transaksi setelah expired'
    ELSE NULL
  END AS keterangan
FROM transactions_data t
JOIN cards_data c ON t.card_id = c.card_id
WHERE 
  EXTRACT(YEAR FROM t.date) > ('20' || RIGHT(c.expires, 2))::INT
ORDER BY c.card_id, t.date;
-- kartu belum expired dan belum ada transaksi sama sekali
SELECT 
  c.card_id,
  c.client_id,
  c.card_number,
  c.expires,
  c.acct_open_date
FROM cards_data c
LEFT JOIN transactions_data t ON c.card_id = t.card_id
WHERE t.card_id IS NULL
ORDER BY c.card_id;
-- kartu belum expired tapi Tidak ada transaksi lagi dalam 2 tahun terakhir 
SELECT 
  c.card_id,
  c.client_id,
  c.card_number,
  c.expires,
  c.acct_open_date,
  MAX(t.date) AS last_transaction_date
FROM cards_data c
LEFT JOIN transactions_data t ON c.card_id = t.card_id
GROUP BY c.card_id, c.client_id, c.card_number, c.expires, c.acct_open_date
HAVING 
  MAX(t.date) < DATE '2018-10-31'  -- Tidak ada transaksi 1 tahun terakhir
  AND ('20' || RIGHT(c.expires, 2))::INT > 2019;  -- Kartu belum expired per 2019
-- Cek rata-rata jarak antar transaksi
WITH ranked_txn AS (
  SELECT 
    card_id,
    date,
    LAG(date) OVER (PARTITION BY card_id ORDER BY date) AS prev_date
  FROM transactions_data
),
intervals AS (
  SELECT 
    DATE_PART('day', date - prev_date) AS interval_days
  FROM ranked_txn
  WHERE prev_date IS NOT NULL
)
SELECT 
  ROUND(AVG(interval_days)::numeric, 2) AS avg_days_all_cards
FROM intervals;
-- Analisis Risiko Fraud
CREATE TABLE fraud_risk_score_table AS
-- CTE: deteksi jarak antar transaksi
WITH txn_with_gap AS (
  SELECT 
    card_id,
    date,
    LAG(date) OVER (PARTITION BY card_id ORDER BY date) AS prev_date
  FROM transactions_data
),

-- CTE: flag kartu dengan gap transaksi > 1 tahun
txn_gap_flag AS (
  SELECT 
    card_id,
    MAX(CASE 
          WHEN date - prev_date > INTERVAL '365 days' THEN 1 
          ELSE 0 
        END) AS has_gap_over_1_year
  FROM txn_with_gap
  WHERE prev_date IS NOT NULL
  GROUP BY card_id
),

-- CTE: deteksi transaksi outlier menggunakan z-score
outlier_table AS (
  SELECT 
    card_id
  FROM (
    SELECT 
      card_id,
      amount,
      (amount - AVG(amount) OVER(PARTITION BY card_id)) / 
        NULLIF(STDDEV(amount) OVER(PARTITION BY card_id), 0) AS z_score
    FROM transactions_data
  ) z
  WHERE z_score > 10
  GROUP BY card_id
),

-- CTE: menghitung jumlah error Bad PIN per kartu perhari dan perbulan
pin_error_daily AS (
  SELECT 
    card_id,
    DATE(date) AS txn_date,
    COUNT(*) AS bad_pin_count_day
  FROM transactions_data
  WHERE errors = 'Bad PIN'
  GROUP BY card_id, DATE(date)
  HAVING COUNT(*) > 3
),
pin_error_monthly AS (
  SELECT 
    card_id,
    DATE_TRUNC('month', date) AS txn_month,
    COUNT(*) AS bad_pin_count_month
  FROM transactions_data
  WHERE errors = 'Bad PIN'
  GROUP BY card_id, DATE_TRUNC('month', date)
  HAVING COUNT(*) > 10
),
bad_pin_flag AS (
  SELECT 
    card_id,
    1 AS many_bad_pin
  FROM (
    SELECT card_id FROM pin_error_daily
    UNION
    SELECT card_id FROM pin_error_monthly
  ) bp
  GROUP BY card_id
),

-- CTE: deteksi nomor kartu yang digunakan lebih dari 1x
duplicate_card_number AS (
  SELECT 
    card_number, 
    COUNT(*) AS count_distinct_card_number
  FROM cards_data
  GROUP BY card_number
),

last_transaction_date AS (
  SELECT 
    card_id,
    MAX(date) AS last_txn_date
  FROM transactions_data
  GROUP BY card_id
),

-- CTE: menghitung skor fraud berbasis 7 indikator
fraud_scores AS (
  SELECT 
    c.card_id,
    c.client_id,
    tx.last_txn_date,

    -- Ambil bulan dan tahun expired
    LEFT(c.expires, 2)::INT AS exp_month,
    ('20' || RIGHT(c.expires, 2))::INT AS exp_year,

    -- Buat bentuk komparatif: YYYYMM
    (EXTRACT(YEAR FROM tx.last_txn_date) * 100 + EXTRACT(MONTH FROM tx.last_txn_date)) AS last_txn_yyyymm,
    (('20' || RIGHT(c.expires, 2))::INT * 100 + LEFT(c.expires, 2)::INT) AS exp_yyyymm,

    -- 1. Kartu digunakan setelah expired
    CASE 
      WHEN tx.last_txn_date IS NOT NULL 
           AND (EXTRACT(YEAR FROM tx.last_txn_date) * 100 + EXTRACT(MONTH FROM tx.last_txn_date)) > 
               (('20' || RIGHT(c.expires, 2))::INT * 100 + LEFT(c.expires, 2)::INT)
      THEN 1 ELSE 0 
    END AS used_after_expired,

    -- 2. Transaksi outlier
    CASE WHEN o.card_id IS NOT NULL THEN 1 ELSE 0 END AS is_outlier_txn,

    -- 3. Bad PIN > 3x sehari atau >10x sebulan
    CASE WHEN bp.many_bad_pin = 1 THEN 1 ELSE 0 END AS many_bad_pin,

    -- 4. Tidak pakai chip
    CASE WHEN LOWER(TRIM(c.has_chip)) IN ('no', 'false', '0') THEN 1 ELSE 0 END AS no_chip,

    -- 5. Cek logika penggantian PIN
    CASE 
      -- Jika expired: minimal 1 tahun sebelum expired (yaitu < (exp_year - 1))
      WHEN (('20' || RIGHT(c.expires, 2))::INT * 100 + LEFT(c.expires, 2)::INT) < 202001 
           AND (c.year_pin_last_changed IS NULL OR c.year_pin_last_changed < (('20' || RIGHT(c.expires, 2))::INT - 1))
        THEN 1
      -- Jika belum expired: minimal tahun 2019
      WHEN (('20' || RIGHT(c.expires, 2))::INT * 100 + LEFT(c.expires, 2)::INT) >= 202001
           AND (c.year_pin_last_changed IS NULL OR c.year_pin_last_changed < 2019)
        THEN 1
      ELSE 0
    END AS pin_not_recent,

    -- 6. Gap transaksi > 1 tahun
    CASE WHEN gap.has_gap_over_1_year = 1 THEN 1 ELSE 0 END AS gap_txn_over_1_year,

    -- 7. Kartu bocor / duplikat
    CASE 
      WHEN LOWER(TRIM(c.card_on_dark_web)) IN ('true', 'yes', '1') 
           OR dup.count_distinct_card_number > 1 THEN 1 
      ELSE 0 
    END AS risk_card_number,

    -- Total skor fraud
    (
      CASE 
        WHEN tx.last_txn_date IS NOT NULL 
             AND (EXTRACT(YEAR FROM tx.last_txn_date) * 100 + EXTRACT(MONTH FROM tx.last_txn_date)) > 
                 (('20' || RIGHT(c.expires, 2))::INT * 100 + LEFT(c.expires, 2)::INT)
        THEN 1 ELSE 0 
      END +
      CASE WHEN o.card_id IS NOT NULL THEN 1 ELSE 0 END +
      CASE WHEN bp.many_bad_pin = 1 THEN 1 ELSE 0 END +
      CASE WHEN LOWER(TRIM(c.has_chip)) IN ('no', 'false', '0') THEN 1 ELSE 0 END +
      CASE 
        WHEN (('20' || RIGHT(c.expires, 2))::INT * 100 + LEFT(c.expires, 2)::INT) < 202001 
             AND (c.year_pin_last_changed IS NULL OR c.year_pin_last_changed < (('20' || RIGHT(c.expires, 2))::INT - 1))
          THEN 1
        WHEN (('20' || RIGHT(c.expires, 2))::INT * 100 + LEFT(c.expires, 2)::INT) >= 202001 
             AND (c.year_pin_last_changed IS NULL OR c.year_pin_last_changed < 2019)
          THEN 1
        ELSE 0
      END +
      CASE WHEN gap.has_gap_over_1_year = 1 THEN 1 ELSE 0 END +
      CASE 
        WHEN LOWER(TRIM(c.card_on_dark_web)) IN ('true', 'yes', '1') 
             OR dup.count_distinct_card_number > 1 THEN 1 
        ELSE 0 
      END
    ) AS fraud_score

  FROM cards_data c
  LEFT JOIN last_transaction_date tx ON c.card_id = tx.card_id
  LEFT JOIN outlier_table o ON c.card_id = o.card_id
  LEFT JOIN bad_pin_flag bp ON c.card_id = bp.card_id
  LEFT JOIN txn_gap_flag gap ON c.card_id = gap.card_id
  LEFT JOIN duplicate_card_number dup ON dup.card_number = c.card_number
),

final_result AS (
  SELECT 
    *,
    CASE 
      WHEN fraud_score BETWEEN 0 AND 2 THEN 'Aman'
      WHEN fraud_score BETWEEN 3 AND 4 THEN 'Waspada'
      WHEN fraud_score >= 5 THEN 'Risiko Tinggi'
    END AS fraud_category
  FROM fraud_scores
)

SELECT 
  card_id,
  client_id,
  used_after_expired,
  is_outlier_txn,
  many_bad_pin,
  no_chip,
  pin_not_recent,
  gap_txn_over_1_year,
  risk_card_number,
  fraud_score,
  fraud_category
FROM final_result;
SELECT * FROM fraud_risk_score_table LIMIT 10;

-- Rekap Jumlah Kartu per Kategori Analisis Risiko Fraud
SELECT 
  fraud_category,
  COUNT(*) AS jumlah_kartu
FROM fraud_risk_score
GROUP BY fraud_category
ORDER BY 
  CASE 
    WHEN fraud_category = 'Risiko Tinggi' THEN 1
    WHEN fraud_category = 'Waspada' THEN 2
    WHEN fraud_category = 'Aman' THEN 3
  END;

SELECT * from fraud_risk_score_table WHERE fraud_category = 'Waspada';

-- ===============================================
-- STEP 8: Next Steps - Customer Risk & Value Score (CRV)
-- ===============================================
CREATE TABLE crv_score_table AS
WITH
-- ============================
-- CTE 1: Customer Matrix
-- ============================
customer_matrix_score AS (
  SELECT 
    client_id,
    customer_segment AS customer_matrix_category,
    CASE 
      WHEN customer_segment = 'Aktif - High Spender (C1)' THEN 4
      WHEN customer_segment = 'Pasif - High Spender (C2)' THEN 3
      WHEN customer_segment = 'Aktif - Low Spender (C3)' THEN 2
      WHEN customer_segment = 'Pasif - Low Spender (C4)' THEN 1
    END AS customer_matrix_score
  FROM customer_matrix_table
),
-- ============================
-- CTE 2: Credit Score
-- ============================
credit_score_fico AS (
  SELECT 
    client_id,
    fico_category AS credit_score_category,
    CASE 
      WHEN fico_category = 'Exceptional' THEN 5
      WHEN fico_category = 'Very Good' THEN 4
      WHEN fico_category = 'Good' THEN 3
      WHEN fico_category = 'Fair' THEN 2
      WHEN fico_category = 'Poor' THEN 1
    END AS credit_score_value
  FROM credit_score_table
),

-- ============================
-- CTE 3: Credit Utilization Score (Rata-rata per client_id)
-- ============================
credit_utilization_score AS (
  SELECT
    client_id,
    SUM(total_usage) AS total_usage,
    SUM(credit_limit) AS total_limit,
    ROUND(SUM(total_usage) * 1.0 / NULLIF(SUM(credit_limit), 0), 2) AS avg_utilization,

    CASE 
      WHEN ROUND(SUM(total_usage) * 1.0 / NULLIF(SUM(credit_limit), 0), 2) > 0.9 THEN 'Optimal'
      WHEN ROUND(SUM(total_usage) * 1.0 / NULLIF(SUM(credit_limit), 0), 2) BETWEEN 0.7 AND 0.9 THEN 'Under Control'
      ELSE 'Idle Use'
    END AS credit_utilization_category,

    CASE 
      WHEN ROUND(SUM(total_usage) * 1.0 / NULLIF(SUM(credit_limit), 0), 2) > 0.9 THEN 3
      WHEN ROUND(SUM(total_usage) * 1.0 / NULLIF(SUM(credit_limit), 0), 2) BETWEEN 0.7 AND 0.9 THEN 2
      ELSE 1
    END AS credit_utilization_score
  FROM credit_utilization_table
  GROUP BY client_id
),

-- ============================
-- CTE 4: Fraud Risk Score (rata-rata per jumlah kartu unik)
-- ============================
-- Hitung jumlah kartu unik per client_id
cards_per_client AS (
  SELECT client_id, COUNT(DISTINCT card_id) AS total_cards
  FROM cards_data
  GROUP BY client_id
),

fraud_risk_score AS (
  SELECT
    fr.client_id,
    SUM(fr.fraud_score) AS total_fraud_score,
    cp.total_cards,
    ROUND(SUM(fr.fraud_score) * 1.0 / NULLIF(cp.total_cards, 0), 2) AS fraud_score_per_card,

    CASE 
      WHEN ROUND(SUM(fr.fraud_score) * 1.0 / NULLIF(cp.total_cards, 0), 2) < 2.1 THEN 'Aman'
      WHEN ROUND(SUM(fr.fraud_score) * 1.0 / NULLIF(cp.total_cards, 0), 2) < 4.1 THEN 'Waspada'
      ELSE 'Risiko Tinggi'
    END AS fraud_risk_category,

    CASE 
      WHEN ROUND(SUM(fr.fraud_score) * 1.0 / NULLIF(cp.total_cards, 0), 2) < 2.1 THEN 3
      WHEN ROUND(SUM(fr.fraud_score) * 1.0 / NULLIF(cp.total_cards, 0), 2) < 4.1 THEN 2
      ELSE 1
    END AS fraud_risk_score

  FROM fraud_risk_score_table fr
  LEFT JOIN cards_per_client cp ON fr.client_id = cp.client_id
  GROUP BY fr.client_id, cp.total_cards
)

-- ============================
-- FINAL SELECT: Gabungkan Semua
-- ============================
SELECT 
  cm.client_id,

  -- Customer Matrix
  cm.customer_matrix_category,
  cm.customer_matrix_score,

  -- Credit Score
  cs.credit_score_category,
  cs.credit_score_value,

  -- Credit Utilization
  cu.credit_utilization_category,
  cu.credit_utilization_score,
  cu.avg_utilization,

  -- Fraud Risk
  fr.fraud_risk_category,
  fr.fraud_risk_score,

  -- Total CRV Score
  (cm.customer_matrix_score + cs.credit_score_value + cu.credit_utilization_score + fr.fraud_risk_score) AS crv_total_score,

  -- CRV Category
  CASE 
    WHEN (cm.customer_matrix_score + cs.credit_score_value + cu.credit_utilization_score + fr.fraud_risk_score) >= 13 THEN 'Platinum'
    WHEN (cm.customer_matrix_score + cs.credit_score_value + cu.credit_utilization_score + fr.fraud_risk_score) >= 11 THEN 'Gold'
    WHEN (cm.customer_matrix_score + cs.credit_score_value + cu.credit_utilization_score + fr.fraud_risk_score) >= 9 THEN 'Silver'
    ELSE 'Watchlist'
  END AS crv_category

FROM customer_matrix_score cm
LEFT JOIN credit_score_fico cs ON cm.client_id = cs.client_id
LEFT JOIN credit_utilization_score cu ON cm.client_id = cu.client_id
LEFT JOIN fraud_risk_score fr ON cm.client_id = fr.client_id;
-- Cek hasil
SELECT * FROM crv_score_table;
SELECT 
  crv.crv_category,
  COUNT(DISTINCT crv.client_id) AS jumlah_user,
  ROUND(
    COUNT(DISTINCT crv.client_id) * 100.0 / 
    (SELECT COUNT(DISTINCT client_id) FROM crv_score_table), 
    2
  ) AS persen_user,

  -- Total amount dan persen dari total amount (boleh tetap pakai SUM biasa)
  COALESCE(SUM(cu.total_usage), 0) AS total_amount,
  ROUND(
    COALESCE(SUM(cu.total_usage), 0) * 100.0 / 
    (SELECT SUM(total_usage) FROM credit_utilization_table), 
    2
  ) AS persen_amount

FROM crv_score_table crv
LEFT JOIN credit_utilization_table cu 
  ON crv.client_id = cu.client_id

GROUP BY crv.crv_category
ORDER BY 
  CASE crv.crv_category
    WHEN 'Platinum' THEN 1
    WHEN 'Gold' THEN 2
    WHEN 'Silver' THEN 3
    WHEN 'Watchlist' THEN 4
  END;

-- ===============================================
-- STEP 9: Next Steps - Mapping Your Market
-- ===============================================
-- Analisis sebaran mcc
SELECT COUNT(DISTINCT mcc) AS jumlah_mcc_unik
FROM data_mcc;
--Dowload mcc & merchant_state Uniq untuk nantinya di transforms dengan kamus
SELECT DISTINCT mcc
FROM transactions_data_filter
ORDER BY mcc;
SELECT DISTINCT merchant_state
FROM transactions_data_filter
ORDER BY merchant_state;
--upload kamus mcc & merchant_state yg sudah di transforms
CREATE TABLE data_mcc (
    mcc TEXT PRIMARY KEY,
	mcc_name TEXT,
    irl_description TEXT,
    mcc_category TEXT
);
CREATE TABLE data_merchant_state (
    merchant_state TEXT PRIMARY KEY,
	merchant_state_desc TEXT
);
-- Analisis sebaran mcc by irl_description
WITH trx_mcc_join AS (
  SELECT 
    t.*,
    d.mcc_name,
    d.irl_description,
    d.mcc_category
  FROM transactions_data_filter t
  LEFT JOIN data_mcc d ON t.mcc = d.mcc
),
irl_summary AS (
  SELECT 
    irl_description,
    COUNT(DISTINCT mcc) AS jumlah_mcc,
    COUNT(*) AS jumlah_transaksi,
    SUM(amount) AS total_amount
  FROM trx_mcc_join
  GROUP BY irl_description
),
total_amount_summary AS (
  SELECT SUM(total_amount) AS total_all FROM irl_summary
)
SELECT 
  s.*,
  ROUND(100.0 * s.total_amount / t.total_all, 2) AS pct_amount_total
FROM irl_summary s
CROSS JOIN total_amount_summary t
ORDER BY s.total_amount DESC;
-- Analisis sebaran mcc by mcc_category
WITH trx_mcc_join AS (
  SELECT 
    t.*,
    d.mcc_name,
    d.irl_description,
    d.mcc_category
  FROM transactions_data_filter t
  LEFT JOIN data_mcc d ON t.mcc = d.mcc
),
mcc_category_summary AS (
  SELECT 
    mcc_category,
    COUNT(DISTINCT mcc) AS jumlah_mcc,
    COUNT(*) AS jumlah_transaksi,
    SUM(amount) AS total_amount
  FROM trx_mcc_join
  GROUP BY mcc_category
),
total_amount_summary AS (
  SELECT SUM(total_amount) AS total_all FROM mcc_category_summary
)
SELECT 
  s.*,
  ROUND(100.0 * s.total_amount / t.total_all, 2) AS pct_amount_total
FROM mcc_category_summary s
CROSS JOIN total_amount_summary t
ORDER BY s.total_amount DESC;
-- TOP 3 irl_description in CSV-Score
WITH trx_mcc_join AS (
  SELECT 
    t.transactions_id,
    t.client_id,
    t.amount,
    t.merchant_id,
    cs.crv_category,
    dm.irl_description
  FROM transactions_data_filter t
  JOIN crv_score_table cs ON t.client_id = cs.client_id
  JOIN data_mcc dm ON t.mcc = dm.mcc
),
ranked_irl AS (
  SELECT
    crv_category,
    irl_description,
    COUNT(DISTINCT transactions_id) AS jumlah_transaksi,
    COUNT(DISTINCT merchant_id) AS jumlah_merchant,
    ROUND(SUM(amount), 2) AS total_amount,
    ROW_NUMBER() OVER (
      PARTITION BY crv_category
      ORDER BY SUM(amount) DESC
    ) AS rn
  FROM trx_mcc_join
  GROUP BY crv_category, irl_description
),
total_per_crv AS (
  SELECT 
    crv_category,
    SUM(total_amount) AS total_amount_crv
  FROM ranked_irl
  GROUP BY crv_category
)
SELECT 
  r.crv_category,
  r.irl_description,
  r.jumlah_transaksi,
  r.jumlah_merchant,
  r.total_amount,
  ROUND(100.0 * r.total_amount / t.total_amount_crv, 2) AS pct_amount_per_crv
FROM ranked_irl r
JOIN total_per_crv t ON r.crv_category = t.crv_category
WHERE r.rn <= 3
ORDER BY r.crv_category, r.total_amount DESC;
-- TOP 3 mcc_category in CSV-Score
WITH trx_mcc_join AS (
  SELECT 
    t.transactions_id,
    t.client_id,
    t.amount,
    t.merchant_id,
    cs.crv_category,
    dm.mcc_category
  FROM transactions_data_filter t
  JOIN crv_score_table cs ON t.client_id = cs.client_id
  JOIN data_mcc dm ON t.mcc = dm.mcc
),
mcc_summary AS (
  SELECT
    crv_category,
    mcc_category,
    COUNT(DISTINCT transactions_id) AS jumlah_transaksi,
    COUNT(DISTINCT merchant_id) AS jumlah_merchant,
    ROUND(SUM(amount), 2) AS total_amount
  FROM trx_mcc_join
  GROUP BY crv_category, mcc_category
),
total_per_crv AS (
  SELECT crv_category, SUM(total_amount) AS total_amount_crv
  FROM mcc_summary
  GROUP BY crv_category
),
ranked_mcc AS (
  SELECT 
    s.*,
    RANK() OVER (PARTITION BY crv_category ORDER BY total_amount DESC) AS urutan
  FROM mcc_summary s
)
SELECT 
  r.crv_category,
  r.mcc_category,
  r.jumlah_transaksi,
  r.jumlah_merchant,
  r.total_amount,
  ROUND(100.0 * r.total_amount / t.total_amount_crv, 2) AS pct_amount_per_crv
FROM ranked_mcc r
JOIN total_per_crv t ON r.crv_category = t.crv_category
WHERE r.urutan <= 3
ORDER BY r.crv_category, r.total_amount DESC;