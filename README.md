# 🤟 BISINDO-Mobile

> **Aplikasi Penerjemah & Pembelajaran Bahasa Isyarat Indonesia (BISINDO / SIBI) Berbasis Mobile (Flutter) dan Backend Golang dengan Integrasi Supabase Cloud.**

[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.x-0175C2?logo=dart&logoColor=white)](https://dart.dev)
[![Go](https://img.shields.io/badge/Go-1.22+-00ADD8?logo=go&logoColor=white)](https://golang.org)
[![Supabase](https://img.shields.io/badge/Supabase-Database%20%26%20Auth-3ECF8E?logo=supabase&logoColor=white)](https://supabase.com)
[![Architecture](https://img.shields.io/badge/Mobile%20Architecture-Clean%20Architecture-blue)](#arsitektur-sistem)
[![Backend Architecture](https://img.shields.io/badge/Backend%20Architecture-MVC%20%2B%20SOLID-teal)](#arsitektur-sistem)
[![Tests](https://img.shields.io/badge/Tests-Passing-brightgreen)](#pengujian-testing)

---

## 📌 Daftar Isi
- [Tentang Proyek](#tentang-proyek)
- [Fitur Utama](#fitur-utama)
- [Arsitektur Sistem](#arsitektur-sistem)
- [Struktur Folder](#struktur-folder)
- [Prasyarat Sistem](#prasyarat-sistem)
- [Panduan Instalasi & Menjalankan](#panduan-instalasi--menjalankan)
  - [1. Konfigurasi Backend](#1-konfigurasi-backend-golang)
  - [2. Konfigurasi Mobile](#2-konfigurasi-mobile-flutter)
- [Dokumentasi API Backend](#dokumentasi-api-backend)
- [Pengujian (Testing)](#pengujian-testing)
- [Roadmap Pengembangan](#roadmap-pengembangan)

---

## 📖 Tentang Proyek

**BISINDO-Mobile** dikembangkan untuk menjembatani komunikasi antara penyandang tunarungu/tuli dengan masyarakat umum. Aplikasi ini memanfaatkan pengenalan gestur tangan secara *real-time* berbasis *on-device machine learning* (MediaPipe Hand Landmarker & TFLite), penyimpanan lokal *offline-first* dengan Hive, serta sinkronisasi data cloud melalui backend Golang yang terhubung dengan Supabase.

---

## ✨ Fitur Utama

1. **Terjemahkan (Real-time Hand Gesture Translation)**
   * Antarmuka live camera preview dengan izin kamera terintegrasi.
   * Interface deteksi landmark tangan domain (*MediaPipe Hand Landmarker ready*).
   * Visualisasi sequence gesture dan hasil terjemahan instan.
   * Opsi simpan langsung ke riwayat terjemahan.

2. **Belajar Bahasa Isyarat (Learn Module)**
   * Katalog materi alfabet dan angka (BISINDO & SIBI).
   * Materi sapaan dan komunikasi sehari-hari.
   * Akses offline didukung sinkronisasi katalog dari backend server.

3. **Riwayat Terjemahan (History & Cloud Sync)**
   * *Offline-first storage* menggunakan **Hive NoSQL database**.
   * Sinkronisasi otomatis ke backend Golang dan Supabase saat online.
   * Fitur hapus item, salin ke papan klip (*clipboard*), dan bersihkan riwayat.

4. **Indikator Kesehatan Sistem (Real-time Health Badge)**
   * Status badge di AppBar yang memantau ketersediaan Backend Golang dan Supabase Database secara live.

---

## 🏛 Arsitektur Sistem

### Mobile (Clean Architecture & BLoC Pattern)
Mengikuti kaidah **Clean Architecture** (Robert C. Martin) yang memisahkan aplikasi ke dalam 3 lapisan inti per fitur:
* **Domain Layer**: Berisi `entities`, `repositories` (abstract contract), dan `usecases`. Murni kode Dart tanpa dependensi framework luar.
* **Data Layer**: Berisi `datasources` (local Hive & remote HTTP API) serta `repositories` (implementasi konkret).
* **Presentation Layer**: State management menggunakan **BLoC (`flutter_bloc`)**, halaman (`pages`), dan komponen UI reusabel (`widgets`).

### Backend (MVC + SOLID Principles)
Dibangun menggunakan **Golang** dengan pola **Model-View-Controller** yang menerapkan prinsip **SOLID**:
* **Model**: Struktur data domain (`HistoryItem`, `LearnItem`, `SystemHealth`).
* **View**: Standarisasi output presenter JSON (`views.RenderSuccess`, `views.RenderError`).
* **Controller**: Decoder HTTP request dan pengatur alur logic.
* **Service & Repository Layer**: Abstraksi data access dan integrasi API Supabase (Auth, REST PostgREST, dan RPC).

---

## 📁 Struktur Folder

```text
BISINDO-Mobile/
├── backend/                       # Server REST API (Golang)
│   ├── .env.example               # Contoh konfigurasi environment
│   ├── go.mod / go.sum            # Modul Go & dependensi
│   ├── package.json               # Paket @supabase/server
│   ├── main.go                    # Entry point server HTTP & Dependency Injection
│   └── internal/
│       ├── config/                # Environment variable loader
│       ├── controllers/           # HTTP Handlers (Health, History, Learn)
│       ├── middleware/            # CORS & Request loggers
│       ├── models/                # Domain & Request/Response Models
│       ├── repositories/          # Data Access Layer & Abstraksi
│       ├── routes/                # Mapping Endpoint & Router
│       ├── services/              # Business Logic & Supabase Service
│       └── views/                 # JSON Output Presenter
│
├── mobile/                        # Aplikasi Klien (Flutter)
│   ├── pubspec.yaml               # Dependensi & registrasi assets
│   ├── assets/
│   │   ├── images/                # Asset gambar & ikon
│   │   └── models/                # Model TFLite (.tflite) & label
│   ├── android/                   # Konfigurasi native Android & permissions
│   ├── ios/                       # Konfigurasi native iOS & permissions
│   ├── lib/
│   │   ├── main.dart              # Inisialisasi Hive, DI, dan Root Widget
│   │   ├── core/                  # Konstanta, DI container, Error handling, UseCase
│   │   └── features/
│   │       ├── navigation/        # BottomNavigationBar Shell
│   │       ├── translate/         # Fitur Terjemahkan (Domain, Data, Presentation)
│   │       ├── learn/             # Fitur Belajar (Domain, Data, Presentation)
│   │       └── history/           # Fitur Riwayat (Domain, Data, Presentation)
│   └── test/                      # Unit, BLoC, dan Widget Tests
└── README.md
```

---

## 🛠 Prasyarat Sistem

* **Flutter SDK**: `^3.24.0` atau versi stable terbaru
* **Dart SDK**: `^3.5.0`
* **Go**: `1.22+`
* **Node.js**: `v20+` (opsional untuk tools server Supabase)
* **Android Studio / Xcode** untuk emulator atau perangkat fisik

---

## 🚀 Panduan Instalasi & Menjalankan

### 1. Konfigurasi Backend (Golang)

1. Masuk ke direktori `backend/`:
   ```bash
   cd backend
   ```
2. Buat file `.env` dari contoh `.env.example`:
   ```bash
   cp .env.example .env
   ```
   *Isi `SUPABASE_URL`, `SUPABASE_PUBLISHABLE_KEY`, dan `SUPABASE_SECRET_KEY` sesuai project Supabase Anda.*

3. Unduh dependensi Go:
   ```bash
   go mod tidy
   ```

4. Jalankan server:
   ```bash
   go run main.go
   ```
   *Server akan aktif di `http://localhost:8080` dan otomatis memverifikasi koneksi ke Supabase.*

---

### 2. Konfigurasi Mobile (Flutter)

1. Masuk ke direktori `mobile/`:
   ```bash
   cd mobile
   ```

2. Unduh paket dependensi Flutter:
   ```bash
   flutter pub get
   ```

3. Jalankan aplikasi pada simulator / emulator / perangkat fisik:
   ```bash
   flutter run
   ```

> **Catatan Koneksi Emulator:**
> * Android Emulator secara otomatis dialihkan ke host machine via `http://10.0.2.2:8080`.
> * iOS Simulator & macOS Desktop menggunakan `http://127.0.0.1:8080`.

---

## 📡 Dokumentasi API Backend

| Method | Endpoint | Deskripsi | Status |
| :--- | :--- | :--- | :--- |
| `GET` | `/api/health` | Status server backend & koneksi Supabase | `200 OK` |
| `GET` | `/api/history` | Mengambil seluruh riwayat terjemahan | `200 OK` |
| `POST` | `/api/history` | Menyimpan terjemahan baru | `201 Created` |
| `DELETE` | `/api/history` | Menghapus seluruh riwayat terjemahan | `200 OK` |
| `GET` | `/api/learn` | Mengambil katalog materi bahasa isyarat | `200 OK` |

Contoh respon `/api/health`:
```json
{
  "status": "healthy",
  "service": "sign-language-translator-backend",
  "runtime": "golang",
  "timestamp": "2026-11-09T08:07:55Z",
  "supabase": {
    "connected": true,
    "url": "https://kdhsejrotfajtqygkcse.supabase.co",
    "auth_service": "healthy",
    "rest_service": "healthy"
  }
}
```

---

## 🧪 Pengujian (Testing)

### Pengujian Backend (Go)
```bash
cd backend
go test -v ./...
```
*Mencakup unit test untuk Controller, Service, dan Handler.*

### Pengujian Mobile (Flutter)
```bash
cd mobile
flutter analyze  # Memastikan 0 issue / lint error
flutter test     # Menjalankan 13 unit, BLoC, dan widget test
```

---

## 🗺 Roadmap Pengembangan

- [x] Setup Clean Architecture Mobile (Flutter BLoC, Hive, Camera, TFLite dependencies).
- [x] Setup Backend Golang MVC + SOLID terintegrasi dengan Supabase.
- [x] Sinkronisasi offline-first antara Mobile (Hive) & Backend REST API.
- [ ] Integrasi feed kamera nyata dan kontrol pergantian kamera (Depan/Belakang).
- [ ] Implementasi MediaPipe Hand Landmarker untuk deteksi 21 koordinat tangan secara real-time.
- [ ] Integrasi model klasifikasi gestur BISINDO/SIBI `.tflite`.
- [ ] Autentikasi Pengguna menggunakan Supabase Auth di aplikasi mobile.

---

## 📄 Lisensi

Proyek ini didistribusikan di bawah lisensi MIT. Silakan lihat file `LICENSE` untuk informasi lebih lanjut.
