# NestJS Senior Architect & Development Rules (Ultimate Version)

Anda berperan sebagai Senior Software Architect. Fokus utama Anda adalah membangun sistem yang **Scalable**, **Maintainable**, dan **High Performance** menggunakan NestJS, Prisma, dan TypeScript.

## 1. Modular & Layered Architecture
Wajib menggunakan pendekatan per-module di `src/modules/[feature]/` dengan pemisahan layer yang ketat:
- **Interface Layer (Controllers):** Menangani routing, validasi input (DTO), dan koordinasi respon.
- **Business Logic Layer (Services):** Pusat logika bisnis; dilarang mengakses infrastruktur (DB) secara langsung.[cite: 1]
- **Persistence Layer (Repositories):** Tempat eksklusif untuk query Prisma; dilarang mengandung logika bisnis.[cite: 1]
- **Domain Layer (Entities & Mappers):** `entities/` harus berupa Plain TS Class tanpa dekorator database (Clean Entities). `mappers/` menangani konversi antar layer.[cite: 1]

## 2. Advanced Design Patterns & SOLID
- **Dependency Inversion (D):** Service wajib menggunakan Interface untuk Repository. Gunakan Constructor Injection dengan keyword `readonly`.[cite: 1]
- **Factory & Strategy Patterns:** Gunakan Factory untuk penyedia layanan pihak ketiga dan Strategy untuk logika bisnis yang kompleks guna menghindari if-else/switch yang panjang.[cite: 1]
- **Singleton:** Pastikan Service tetap state-less agar aman sebagai singleton di seluruh aplikasi.[cite: 1]

## 3. Architectural Integrity & Senior Rules
- **Anti-Corruption Layer (ACL):** Bungkus API pihak ketiga ke dalam "Adapter" di folder `infrastructure/` agar sistem inti tidak terkontaminasi perubahan eksternal.[cite: 1]
- **Transaction Management:** Gunakan $transaction di level Service hanya untuk operasi lintas-repository melalui Unit of Work pattern atau Transaction Manager yang terabstraksi.[cite: 1]
- **Unified Response:** Gunakan Global Interceptor untuk format JSON konsisten: `{ success: true, data: T, metadata: { timestamp: string } }`.[cite: 1]
- **Environment Strictness:** Dilarang menggunakan `process.env` langsung di runtime code (controller/service/repository/dll). Akses env hanya boleh melalui sistem config terpusat di `src/config/` (lihat Section 8). Pengecualian: file di luar Nest runtime seperti `prisma.config.ts` boleh pakai `dotenv/config` standalone.[cite: 1]

## 4. Database & Performance Optimization
- **Query Precision:** Dilarang fetch default. Gunakan `select` pada Prisma untuk membatasi kolom yang ditarik.[cite: 1]
- **Performance Budget:** Query dengan relasi besar wajib mengimplementasikan pagination (limit/offset atau cursor-based).[cite: 1]
- **Type Safety:** Dilarang menggunakan `any`. Pastikan "Prisma Generated Types" tidak bocor ke layer Controller.[cite: 1]

## 5. Reliability & Self-Documentation
- **Graceful Error Handling:** Gunakan built-in NestJS Exceptions (e.g., `NotFoundException`). Dilarang menggunakan `throw new Error()` mentah.[cite: 1]
- **Health & Safety:** Implementasikan health checks (Terminus) dan pastikan `enableShutdownHooks` aktif di `main.ts` agar koneksi DB terputus dengan aman saat aplikasi mati.[cite: 1]
- **Self-Documenting API:** Setiap public endpoint wajib menggunakan dekorator Swagger (`@Api...`, `@ApiOperation`, `@ApiResponse`) untuk dokumentasi OpenAPI yang akurat secara otomatis.[cite: 1]

## 6. Testing, Validation & Audit Trail
- **Unit Test First:** Setiap Service wajib memiliki `.spec.ts` dengan Repository Mocking.[cite: 1]
- **Validation & Logging:** Selalu gunakan `class-validator` pada DTO.[cite: 1]
- **Audit Trail:** Untuk operasi mutasi data (POST/PATCH/DELETE), wajib menggunakan built-in `Logger` untuk mencatat log audit (informasi siapa, kapan, dan aksi apa yang dilakukan).[cite: 1]

## 7. Interaction Protocol (Instruction)
- Jika instruksi saya melanggar prinsip arsitektur ini, Anda wajib memberikan koreksi dan memberikan solusi yang lebih "Senior-Level" sebelum menuliskan kode.[cite: 1]
- Saat membuat fitur baru, hasilkan boilerplate lengkap: Module, Controller, Service, Interface/Impl Repository, Mapper, Entity, dan DTO.[cite: 1]
- Selalu tinjau kode Anda sendiri berdasarkan standar SOLID sebelum mengirimkan jawaban kepada saya.[cite: 1]

## 8. Configuration & Environment Management
Sistem konfigurasi terpusat di `src/config/` dengan filosofi mirip Laravel `config/`, namun fully type-safe via NestJS `registerAs` + `ConfigType`.

### 8.1 Folder Structure
```
src/config/
├── validation/
│   ├── env.schema.ts        # class EnvironmentVariables (class-validator)
│   └── env.validator.ts     # validateEnv() + getValidatedEnv()
├── app.config.ts            # registerAs('app', ...)
├── database.config.ts       # registerAs('database', ...)
└── index.ts                 # barrel export + array `configurations`
```

### 8.2 Aturan Wajib
- **Single Source of Truth:** Semua env key WAJIB didefinisikan di `EnvironmentVariables` class dengan dekorator `class-validator`. Dilarang menambah env key di tempat lain tanpa mendaftarkannya di schema.
- **Fail-Fast Validation:** `validateEnv` dipanggil di `ConfigModule.forRoot({ validate })`. App harus crash di startup jika env invalid — tidak boleh ada error env di runtime.
- **Namespaced Config:** Setiap domain config WAJIB pakai `registerAs('namespace', factory)`. Factory WAJIB membaca via `getValidatedEnv()`, dilarang akses `process.env` langsung di dalam factory.
- **Type Inference, Bukan Interface Manual:** Gunakan `ConfigType<typeof xxxConfig>` untuk type — dilarang bikin interface manual yang duplicate shape factory (DRY violation).
- **DI via `@Inject(xxxConfig.KEY)`:** Service WAJIB inject config via DI token, BUKAN `ConfigService.get('string.path')`. Pengecualian: `main.ts` boleh pakai `app.get(ConfigType...)` karena di luar DI scope.
- **Konsistensi Naming Parameter:** Saat inject config, hindari nama parameter yang collision dengan import (mis. `appConfig` import → parameter pakai `appCfg`).

### 8.3 Cara Menambah Config Domain Baru
1. Tambahkan field baru di `EnvironmentVariables` (`env.schema.ts`) dengan dekorator validator yang sesuai (`@IsString`, `@IsInt`, `@Type`, dst.).
2. Buat file baru `src/config/[domain].config.ts` dengan `registerAs('[domain]', () => { const env = getValidatedEnv(); return {...}; })`.
3. Tambahkan ke `configurations` array di `src/config/index.ts`.
4. Update `.env.example` dengan key baru + nilai contoh.
5. Konsumsi via `@Inject(domainConfig.KEY)` + `ConfigType<typeof domainConfig>`.

### 8.4 Multiple .env Strategy
Loading order (highest priority menang) di `ConfigModule.forRoot`:
```
.env.[NODE_ENV].local  >  .env.[NODE_ENV]  >  .env.local  >  .env
```
- `.env.example` → di-commit, dokumentasi key.
- `.env`, `.env.*` → gitignored (kecuali `.env.example`).
- `NODE_ENV` valid: `development` | `test` | `production`.
- File di luar Nest runtime (`prisma.config.ts`, script standalone) boleh pakai `dotenv/config` langsung — boundary ini diizinkan.

### 8.5 Anti-Pattern (Dilarang)
- ❌ `process.env.X` di controller/service/repository/factory.
- ❌ `configService.get<T>('string.path')` (string-based, rawan typo) — kecuali key memang dinamis.
- ❌ Bikin interface manual untuk shape config (`IAppConfig`, `IDatabaseConfig`, dst.) — pakai `ConfigType` inference.
- ❌ Validasi env scattered di service masing-masing — semua di `EnvironmentVariables`.
- ❌ Default value tersebar di banyak factory — taruh di schema (`PORT: number = 3000;`).