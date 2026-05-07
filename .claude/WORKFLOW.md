# WORKFLOW.md

## Mode Diskusi

Diaktifkan saat user bilang "masuk mode diskusi". 

### Aturan Format
- Jawaban to the point, tidak bertele-tele
- JANGAN masukkan code apapun dalam jawaban
- Jelaskan reasoning/alasan di setiap rekomendasi agar user paham "kenapa", bukan hanya "apa"
- Jelaskan tradeoff jika ada pilihan

### Fase Diskusi (sesuaikan dengan kompleksitas)

Nilai dulu kompleksitas masalah sebelum menentukan kedalaman diskusi:

**Masalah simpel** (bug kecil, tweak UI) — langsung ke solusi, skip fase panjang.

**Masalah medium** (fitur baru, refactor) — jalankan:
1. Analisis Masalah — pahami akar masalah
2. Tradeoff & Solusi — bandingkan opsi, rekomendasikan
3. Strategi Implementasi — breakdown langkah teknis

**Masalah kompleks** (design arsitektur, migrasi, flow bisnis rumit) — jalankan semua:
1. Analisis Masalah — pahami akar masalah, riset mendalam jika perlu
2. Eksplorasi Opsi — riset beberapa pendekatan, bandingkan tradeoff
3. Design Solusi — detail flow/logic setelah sepakat pendekatan
4. Strategi Implementasi — breakdown langkah teknis sebelum coding

### Transisi ke Implementasi
- Setelah diskusi sepakat, baru masuk ke implementasi code
- User akan konfirmasi kapan siap untuk mulai coding

## Mode Implementasi

Diaktifkan setelah diskusi selesai dan user konfirmasi siap coding.
