-- Table Nasabah
CREATE TABLE Nasabah (
    id SERIAL PRIMARY KEY,
    nama VARCHAR(255) NOT NULL,
    alamat TEXT,
    nomor_telepon VARCHAR(20),
    email VARCHAR(100),
    createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedAt TIMESTAMP,
    deletedAt TIMESTAMP
);

-- Table Akun
CREATE TABLE Akun (
    id SERIAL PRIMARY KEY,
    nomor_akun VARCHAR(20) NOT NULL,
    saldo DECIMAL(10, 2) NOT NULL,
    nasabah_id INT REFERENCES Nasabah(id),
    createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedAt TIMESTAMP,
    deletedAt TIMESTAMP,
    UNIQUE (nomor_akun)
);

-- Table Transaksi
CREATE TYPE transaction_type AS ENUM ('deposit', 'withdraw', 'transfer');
CREATE TABLE Transaksi (
    id SERIAL PRIMARY KEY,
    jenis transaction_type NOT NULL,
    jumlah DECIMAL(10, 2) NOT NULL,
    tanggal DATE NOT NULL,
    akun_id INT REFERENCES Akun(id),
    createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedAt TIMESTAMP,
    deletedAt TIMESTAMP
);

-- INSERT data nasabah
INSERT INTO Nasabah (nama, alamat, nomor_telepon, email)
VALUES ('John Doe', '123 Main St', '123-456-7890', 'john.doe@email.com');

-- SELECT data nasabah
SELECT * FROM Nasabah;

-- UPDATE data nasabah
UPDATE Nasabah
SET alamat = '456 Elm St'
WHERE id = 1;

-- DELETE data nasabah
DELETE FROM Nasabah WHERE id = 1;

-- INSERT data nasabah
INSERT INTO Nasabah (nama, alamat, nomor_telepon, email)
VALUES ('John Doe', '123 Main St', '123-456-7890', 'john.doe@email.com');

-- INSERT data akun
INSERT INTO Akun (nomor_akun, saldo, nasabah_id)
VALUES ('ACC123', 10000.00, 1);

-- INSERT data transaksi (contoh: deposit)
INSERT INTO Transaksi (jenis, jumlah, tanggal, akun_id)
VALUES ('deposit', 500.00, '2023-10-17', 1);

-- INSERT data transaksi (contoh: withdraw)
INSERT INTO Transaksi (jenis, jumlah, tanggal, akun_id)
VALUES ('withdraw', 200.00, '2023-10-18', 1);

-- Buat stored procedure untuk menghitung total saldo di akun
CREATE OR REPLACE FUNCTION calculate_account_balance(account_id INT)
RETURNS DECIMAL(10, 2) AS $$
DECLARE
    total_balance DECIMAL(10, 2);
BEGIN
    SELECT SUM(saldo) INTO total_balance
    FROM Akun
    WHERE id = account_id;
    RETURN total_balance;
END;
$$ LANGUAGE plpgsql;

-- Tambahkan constraint pada tabel Akun
ALTER TABLE Akun
ADD CONSTRAINT check_balance_non_negative
CHECK (saldo >= 0);