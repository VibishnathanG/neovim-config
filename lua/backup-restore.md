### Backup Script (`backup_nvim.sh

* Linux

```bash
#!/usr/bin/env bash
set -euo pipefail

### CONFIG ###
BACKUP_ROOT="${HOME}/nvim-backups"
TIMESTAMP="$(date +%Y%m%d_%H%M%S)"
BACKUP_DIR="${BACKUP_ROOT}/backup_${TIMESTAMP}"

NVIM_CONFIG="${HOME}/.config/nvim"
NVIM_SHARE="${HOME}/.local/share/nvim"
NVIM_STATE="${HOME}/.local/state/nvim"
NVIM_CACHE="${HOME}/.cache/nvim"

### CREATE DIR ###
mkdir -p "${BACKUP_DIR}"

### FUNCTION ###
backup_dir() {
  local SRC="$1"
  local DEST_NAME="$2"

  if [ -d "${SRC}" ]; then
    echo "[+] Backing up ${SRC}"
    tar -czf "${BACKUP_DIR}/${DEST_NAME}.tar.gz" -C "$(dirname "${SRC}")" "$(basename "${SRC}")"
  else
    echo "[!] Skipping missing: ${SRC}"
  fi
}

### BACKUP EXECUTION ###
backup_dir "${NVIM_CONFIG}" "config_nvim"
backup_dir "${NVIM_SHARE}" "share_nvim"
backup_dir "${NVIM_STATE}" "state_nvim"
backup_dir "${NVIM_CACHE}" "cache_nvim"

### OPTIONAL: NVIM BINARY ###
if command -v nvim >/dev/null 2>&1; then
  NVIM_BIN_PATH="$(command -v nvim)"
  echo "[+] Backing up nvim binary: ${NVIM_BIN_PATH}"
  cp "${NVIM_BIN_PATH}" "${BACKUP_DIR}/nvim_binary"
fi

### METADATA ###
echo "[+] Capturing environment metadata"

{
  echo "### NVIM VERSION ###"
  nvim --version || true
  echo

  echo "### SYSTEM ###"
  uname -a
  echo

  echo "### NODE ###"
  node -v || true
  echo

  echo "### PYTHON ###"
  python3 --version || true
  echo

  echo "### PIP FREEZE ###"
  pip3 freeze || true
  echo

  echo "### NPM GLOBAL ###"
  npm list -g --depth=0 || true
} > "${BACKUP_DIR}/environment.txt"

echo "[✓] Backup completed: ${BACKUP_DIR}"
```

---

### Restore Script (`restore_nvim.sh`)

Assumptions:

* Backup directory exists
* Same OS/architecture (important for `mason/` + binary)
* User has permissions

```bash
#!/usr/bin/env bash
set -euo pipefail

### INPUT ###
if [ $# -ne 1 ]; then
  echo "Usage: $0 <backup_directory>"
  exit 1
fi

BACKUP_DIR="$1"

### PATHS ###
NVIM_CONFIG="${HOME}/.config/nvim"
NVIM_SHARE="${HOME}/.local/share/nvim"
NVIM_STATE="${HOME}/.local/state/nvim"
NVIM_CACHE="${HOME}/.cache/nvim"

### FUNCTION ###
restore_dir() {
  local ARCHIVE="$1"
  local TARGET_PARENT="$2"

  if [ -f "${ARCHIVE}" ]; then
    echo "[+] Restoring ${ARCHIVE} -> ${TARGET_PARENT}"
    mkdir -p "${TARGET_PARENT}"
    tar -xzf "${ARCHIVE}" -C "${TARGET_PARENT}"
  else
    echo "[!] Missing archive: ${ARCHIVE}"
  fi
}

### SAFETY CHECK ###
echo "[!] This will overwrite existing Neovim data"
read -rp "Continue? (yes/no): " CONFIRM
[ "${CONFIRM}" = "yes" ] || exit 1

### RESTORE EXECUTION ###
restore_dir "${BACKUP_DIR}/config_nvim.tar.gz" "${HOME}/.config"
restore_dir "${BACKUP_DIR}/share_nvim.tar.gz" "${HOME}/.local/share"
restore_dir "${BACKUP_DIR}/state_nvim.tar.gz" "${HOME}/.local/state"
restore_dir "${BACKUP_DIR}/cache_nvim.tar.gz" "${HOME}/.cache"

### RESTORE NVIM BINARY ###
if [ -f "${BACKUP_DIR}/nvim_binary" ]; then
  echo "[+] Restoring nvim binary to /usr/local/bin (requires sudo)"
  sudo cp "${BACKUP_DIR}/nvim_binary" /usr/local/bin/nvim
  sudo chmod +x /usr/local/bin/nvim
fi

### FIX PERMISSIONS ###
echo "[+] Fixing ownership"
chown -R "${USER}:${USER}" \
  "${NVIM_CONFIG}" \
  "${NVIM_SHARE}" \
  "${NVIM_STATE}" \
  "${NVIM_CACHE}" || true

### POST-RESTORE VALIDATION ###
echo "[+] Validating installation"

nvim --version || {
  echo "[!] Neovim not working"
  exit 1
}

echo "[✓] Restore complete"
echo "[i] Run :checkhealth inside nvim"
```

---

### Optional Hardening (Recommended)

#### Integrity Check (add in backup)

```bash
sha256sum "${BACKUP_DIR}"/*.tar.gz > "${BACKUP_DIR}/checksums.sha256"
```

#### Validate in restore

```bash
cd "${BACKUP_DIR}"
sha256sum -c checksums.sha256
```

---

### Execution

```bash
chmod +x backup_nvim.sh restore_nvim.sh

./backup_nvim.sh
./restore_nvim.sh ~/nvim-backups/backup_YYYYMMDD_HHMMSS
```

---
