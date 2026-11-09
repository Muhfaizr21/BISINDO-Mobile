# 🤟 BISINDO-Mobile

> **Aplikasi Penerjemah & Pembelajaran Bahasa Isyarat Indonesia (BISINDO) Berbasis Flutter Mobile/Web dan Backend Golang Bersih (MVC + SOLID) Terintegrasi Supabase Cloud.**

[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.x-0175C2?logo=dart&logoColor=white)](https://dart.dev)
[![Go](https://img.shields.io/badge/Go-1.22+-00ADD8?logo=go&logoColor=white)](https://golang.org)
[![Supabase](https://img.shields.io/badge/Supabase-Cloud%20Database%20%26%20RLS-3ECF8E?logo=supabase&logoColor=white)](https://supabase.com)
[![MediaPipe](https://img.shields.io/badge/AI-MediaPipe%20Landmarker-FF6F00?logo=google&logoColor=white)](https://ai.google.dev/edge/mediapipe)
[![Mobile Architecture](https://img.shields.io/badge/Mobile-Clean%20Architecture-blue)](#arsitektur-sistem)
[![Backend Architecture](https://img.shields.io/badge/Backend-MVC%20%2B%20SOLID-teal)](#arsitektur-sistem)
[![Tests](https://img.shields.io/badge/Tests-Passing%20100%25-brightgreen)](#pengujian-testing)

---

## 📌 Daftar Isi
- [Tentang Proyek](#tentang-proyek)
- [Fitur Utama](#fitur-utama)
- [Arsitektur Sistem](#arsitektur-sistem)
- [Struktur Proyek](#struktur-proyek)
- [Dataset & Model AI BISINDO](#dataset--model-ai-bisindo)
- [Panduan Instalasi & Menjalankan](#panduan-instalasi--menjalankan)
  - [1. Konfigurasi Backend (Golang)](#1-konfigurasi-backend-golang)
  - [2. Migrasi Database (Supabase)](#2-migrasi-database-supabase)
  - [3. Konfigurasi Aplikasi Mobile / Web (Flutter)](#3-konfigurasi-aplikasi-mobile--web-flutter)
- [Dokumentasi API Backend](#dokumentasi-api-backend)
- [Pengujian (Testing)](#pengujian-testing)
- [Keamanan & Integritas](#keamanan--integritas)

---

## 📖 Tentang Proyek

**BISINDO-Mobile** dikembangkan untuk menjembatani komunikasi inklusif antara komunitas Teman Tuli dengan masyarakat umum di Indonesia. Aplikasi ini mengombinasikan pelacakan gestur tangan secara *real-time* berbasis **MediaPipe 21-Landmark**, klasifikasi gestur abjad BISINDO A–Z dengan filter anti deteksi palsu, arsitektur *offline-first* dengan penyimpanan lokal Hive, serta sinkronisasi awan ke backend **Golang** yang terhubung dengan **Supabase**.

---

## ✨ Fitur Utama

1. **Terjemahkan (Real-Time Camera Hand Gesture Translation)**
   * Pelacakan 21 titik sendi tangan *real-time* (1 atau 2 tangan) menggunakan **MediaPipe Tasks Vision**.
   * Klasifikator geometris presisi tinggi untuk 26 abjad BISINDO (A–Z) yang dikalibrasi terhadap dataset foto nyata.
   * *Anti-False Positive Filter*: Gerakan acak atau pose tangan santai otomatis ditolak (`confidence: 0.0`), hanya pose mantap dan stabil yang dikonfirmasi.
   * Visualisasi HUD interaktif: overlay kerangka sendi, indikator kestabilan, dan preview hasil terjemahan.

2. **Belajar Bahasa Isyarat (Learn Module)**
   * Katalog materi interaktif 26 abjad BISINDO (A sampai Z), angka 1–5, dan sapaan dasar.
   * Panduan visual dilengkapi deskripsi posisi tangan (1 tangan & 2 tangan) yang selaras dengan data set riil.
   * Dukungan mode *offline* dengan *automatic fallback* lokal.

3. **Riwayat Terjemahan (History & Cloud Sync)**
   * *Offline-first storage* menggunakan database NoSQL **Hive**.
   * Sinkronisasi data dua arah ke Backend Golang dan Cloud Database **Supabase**.
   * Fitur salin ke clipboard, penghapusan satuan, serta pembersihan riwayat secara aman.

4. **Pemantau Kesehatan Sistem (Live Health Indicator)**
   * Indikator status koneksi di AppBar yang memantau ketersediaan Backend Golang dan Supabase secara *real-time*.

---

## 🏛 Arsitektur Sistem

### 1. Mobile (Clean Architecture & BLoC Pattern)
Arsitektur mobile memisahkan kode ke dalam lapisan yang independen per fitur:
* **Domain Layer**: Entitas (`Gesture`, `HandSkeleton`, `HistoryItem`, `LearnItem`), kontrak abstract repository, dan use cases murni Dart tanpa dependensi framework.
* **Data Layer**: Data sources (MediaPipe Web JS interop, TFLite Native/Web abstraction, Hive local cache, HTTP client) dan implementasi repository konkret.
* **Presentation Layer**: State management terstandarisasi dengan **flutter_bloc**, halaman modular, dan widget komponen reusabel.

### 2. Backend (Golang MVC + SOLID Principles)
* **Model**: Representasi entitas data (`HistoryItem`, `LearnItem`, `SystemHealth`).
* **View**: Standarisasi format respons JSON API (`views.RenderSuccess`, `views.RenderError`).
* **Controller**: HTTP request decoders dan router dispatcher.
* **Service & Repository Layer**: Abstraksi akses data dan klien Supabase REST PostgREST.

---

## 📁 Struktur Proyek

```text
BISINDO-Mobile/
├── backend/                       # REST API Server (Golang)
│   ├── cmd/                       # (Opsional) CLI tools
│   ├── internal/
│   │   ├── config/                # Environment variable loader (.env)
│   │   ├── controllers/           # HTTP Handlers (Health, History, Learn)
│   │   ├── middleware/            # CORS & Request logging
│   │   ├── models/                # Domain models
│   │   ├── repositories/          # Abstraksi database & data source
│   │   ├── routes/                # Router & endpoint mapping
│   │   ├── services/              # Business logic & integrasi Supabase
│   │   └── views/                 # JSON presenter standar
│   ├── migrations/                # Skrip SQL DDL
│   ├── main.go                    # Entrypoint server & dependency injection
│   └── go.mod                     # Dependensi Go
│
├── mobile/                        # Aplikasi Klien (Flutter)
│   ├── lib/
│   │   ├── core/                  # Konstanta, DI (GetIt), Network client, Themes
│   │   └── features/
│   │       ├── history/           # Fitur Riwayat (Clean Architecture)
│   │       ├── learn/             # Fitur Belajar (Clean Architecture)
│   │       ├── navigation/        # Navigasi & Bottom Bar
│   │       └── translate/         # Fitur Terjemah Kamera & Landmark Tracking
│   ├── web/                       # Konfigurasi Web & MediaPipe Vision runtime
│   ├── test/                      # Unit test & widget test suite
│   └── pubspec.yaml               # Dependensi Flutter
│
├── datasets/                      # Dataset Abjad BISINDO
│   ├── bisindo_detection/         # 520+ citra BISINDO A–Z
│   └── bisindo_dataset_summary.json # Metadata & panduan posisi tangan
│
└── supabase/                      # Konfigurasi Supabase CLI
    └── migrations/                # Skrip migrasi terkelola
```

---

## 🤖 Dataset & Model AI BISINDO

Proyek ini menggunakan referensi dataset bahasa isyarat BISINDO Indonesia:
* [Indonesian Sign Language BISINDO Hand Sign Detection Dataset](https://github.com/rhiosutoyo/Indonesian-Sign-Language-BISINDO-Hand-Sign-Detection-Dataset)
* [Alfabet BISINDO Kaggle](https://www.kaggle.com/datasets/achmadnoer/alfabet-bisindo)

Algoritma pengenalan gestur mengekstrak 21 titik koordinat normalisasi (0.0 sampai 1.0) per tangan, menghitung sudut antar ruas jari, rasio panjang sendi, orientasi vektor, dan irisan garis (misal persilangan telunjuk pada huruf **X** vs pembentukan alas segitiga jempol pada huruf **A**).

---

## 🚀 Panduan Instalasi & Menjalankan

### Prasyarat
* **Flutter SDK**: 3.x ke atas
* **Go**: 1.22 ke atas
* **Browser**: Google Chrome (mendukung WebAssembly & WebRTC webcam)

---

### 1. Konfigurasi Backend (Golang)

1. Masuk ke direktori backend:
   ```bash
   cd backend
   ```
2. Buat file `.env` (atau sesuaikan dari `.env.example`):
   ```env
   SUPABASE_URL=https://<your-project-ref>.supabase.co
   SUPABASE_PUBLISHABLE_KEY=<your-anon-key>
   SUPABASE_SECRET_KEY=<your-service-role-key>
   SUPABASE_JWKS_URL=https://<your-project-ref>.supabase.co/auth/v1/.well-known/jwks.json
   PORT=8080
   ```
3. Unduh dependensi dan jalankan server:
   ```bash
   go mod download
   go run main.go
   ```
4. Pastikan server berjalan di `http://localhost:8080/api/health`.

---

### 2. Migrasi Database (Supabase)

Migrasi skema database dapat dijalankan secara instan menggunakan Supabase CLI:
```bash
# Link ke project Anda
npx supabase link --project-ref <your-project-ref>

# Terapkan migrasi ke remote database
npx supabase db push --remote --yes
```
*Atau jalankan file SQL `supabase/migrations/20261109000000_create_tables.sql` melalui SQL Editor di Supabase Dashboard.*

---

### 3. Konfigurasi Aplikasi Mobile / Web (Flutter)

1. Masuk ke direktori mobile:
   ```bash
   cd mobile
   ```
2. Pasang paket dependensi Flutter:
   ```bash
   flutter pub get
   ```
3. Jalankan aplikasi pada Chrome (Web):
   ```bash
   flutter run -d chrome
   ```
4. Izinkan akses kamera pada browser saat halaman Terjemahkan dibuka.

---

## 📡 Dokumentasi API Backend

| Metode | Endpoint | Deskripsi | Status Sukses |
|---|---|---|---|
| `GET` | `/api/health` | Status kesehatan backend & konektivitas Supabase | `200 OK` |
| `GET` | `/api/history` | Mengambil seluruh riwayat terjemahan | `200 OK` |
| `POST` | `/api/history` | Menyimpan hasil terjemahan baru | `201 Created` |
| `DELETE` | `/api/history/:id` | Menghapus riwayat terjemahan berdasarkan ID | `200 OK` |
| `GET` | `/api/learn` | Mengambil katalog materi belajar BISINDO | `200 OK` |

---

## 🧪 Pengujian (Testing)

Semua komponen telah melalui pengujian unit dan integrasi otomatis:

```bash
# Menjalankan pengujian backend Go
cd backend && go test -v ./...

# Menjalankan analisis dan pengujian Flutter
cd mobile && flutter analyze && flutter test
```

Status pengujian:
* **Backend**: `TestHealthController`, `TestHistoryController`, `TestHistoryService` berstatus **PASS**.
* **Mobile**: 17 unit test (termasuk klasifikasi akurasi tinggi BISINDO Landmark) berstatus **PASS 100%**.

---

## 🛡️ Keamanan & Integritas
* Seluruh kredensial sensitif dikelola via Environment Variables (`.env`) dan dikecualikan dari Git.
* Row Level Security (RLS) diaktifkan secara ketat pada tabel `public.history` dan `public.learn_materials` di Supabase.
* Klasifikasi AI berjalan secara *client-side* (*on-device*), sehingga data privasi streaming video kamera pengguna tidak pernah dikirim ke server luar.

---

**Dibuat untuk Tugas Besar Pemrograman Mobile.**
