# Faa Magisk Rclone

Rclone v1.75.0 (linux/arm64-v8a) + fusermount sebagai binary sistem (`/system/bin`). Khusus untuk perangkat **ARM64 (arm64-v8a)**. Termasuk daemon opsional rclone rcd (API/Web GUI di `127.0.0.1:5572`) yang bisa dinyalakan lewat tombol Action di Magisk.

## Fitur

- Binary `rclone` v1.75.0 (linux/arm64-v8a)
- Binary `fusermount` (tidak perlu fuser dari Termux)
- Config persisten di `/data/adb/rclone/rclone.conf`
- Autostart daemon rclone rcd via tombol Action di Magisk

## Cara Install

### 1. Clone repository

```bash
git clone https://github.com/FaaRamadhan2/Magisk-Rclone.git
cd Magisk-Rclone
```

### 2. Buat zip dari source

**Linux / macOS:**
```bash
zip -r rclone-v1.75.0-fusermount-arm64.zip . -x ".git/*" ".gitignore" "README.md"
```

**Windows (Python):**
```bash
python -c "
import zipfile, os
root = os.getcwd()
exclude = {'.git', '.gitignore', 'README.md', 'rclone-v1.75.0-fusermount-arm64.zip'}
with zipfile.ZipFile('rclone-v1.75.0-fusermount-arm64.zip', 'w', zipfile.ZIP_DEFLATED) as zf:
    for dirpath, dirs, files in os.walk(root):
        dirs[:] = [d for d in dirs if d not in exclude]
        for f in files:
            if f in exclude or f.endswith('.zip'): continue
            zf.write(os.path.join(dirpath, f), os.path.relpath(os.path.join(dirpath, f), root).replace(os.sep, '/'))
"
```

> **PENTING:** Jangan pakai `Compress-Archive` (PowerShell) karena path-nya pake backslash, Magisk tidak bisa extract dengan benar.

### 3. Install ke device

Copy file zip ke device lalu install lewat Magisk App:
- Buka Magisk App → **Install** → pilih file zip

Atau via ADB:
```bash
adb push rclone-v1.75.0-fusermount-arm64.zip /sdcard/
```
Lalu install dari Magisk App.

### 4. Verifikasi

```bash
su -c 'rclone version'
su -c 'fusermount --version'
```

## Struktur Module

```
├── META-INF/          # Magisk installer script
├── system/
│   └── bin/
│       ├── rclone     # Binary rclone
│       └── fusermount # Binary fusermount
├── customize.sh       # Install script
├── service.sh         # Autostart daemon saat boot
├── action.sh          # Toggle daemon via tombol Action
├── module.prop        # Module info
└── uninstall.sh       # Cleanup saat uninstall
```

## Config

- **Config file:** `/data/adb/rclone/rclone.conf`
- **Log file:** `/data/adb/rclone/rcd.log`
- **Autostart toggle:** tombol ACTION di Magisk App
- **Web GUI:** `/data/adb/rclone/.webgui` (buat file ini untuk aktifkan)

## Author

**faa_ramadhan**

## License

[MIT](LICENSE)
