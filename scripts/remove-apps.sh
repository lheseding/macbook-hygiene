#!/bin/bash
# remove-apps.sh – Entfernt Apps und zugehörige Daten laut Manifest.
#
# Zweck:   Zeilenweise Pfade aus einem Manifest in den PAPIERKORB verschieben
#          (nicht endgültig löschen!). Hintergrunddienste werden vorher entladen.
# Nutzung: ./remove-apps.sh                  # Dry-Run (Default): zeigt nur, was passieren würde
#          ./remove-apps.sh --execute        # Verschiebungen ausführen (ohne sudo-Pfade)
#          ./remove-apps.sh --execute --sudo # inkl. root-eigener Pfade (fragt nach Passwort)
# Risiken: Gelöschtes liegt im Papierkorb (~/.Trash/hygiene-...) und ist
#          wiederherstellbar, bis der Papierkorb geleert wird.
# Manifest: config/removal-plan.local.list
#   - Eine Zeile = ein Pfad. `$HOME` wird expandiert. `#` = Kommentar.
#   - Präfix `AGENT:`  → User-LaunchAgent, wird vor dem Löschen entladen.
#   - Präfix `SUDO:`   → Systempfad, braucht sudo (nur mit --sudo).
#   - Präfix `SAGENT:` → System-LaunchAgent/Daemon, entladen + löschen mit sudo.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"
MANIFEST="${MANIFEST:-$ROOT_DIR/config/removal-plan.local.list}"

MODE="dry-run"; WITH_SUDO=0
for arg in "$@"; do
  case "$arg" in
    --execute) MODE="execute" ;;
    --sudo)    WITH_SUDO=1 ;;
    *) echo "Unbekanntes Argument: $arg"; echo "Nutzung: $0 [--execute] [--sudo]"; exit 1 ;;
  esac
done

if [[ ! -f "$MANIFEST" ]]; then
  echo "❌ Manifest nicht gefunden: $MANIFEST" >&2
  echo "   Vorlage: cp config/removal-plan.list.example config/removal-plan.local.list" >&2
  exit 1
fi

STAMP="$(date +%Y%m%d-%H%M%S)"
TRASH_DIR="$HOME/.Trash/hygiene-$STAMP"

echo "🗑  macbook-hygiene – remove-apps (Modus: $MODE)"
echo "   Manifest:  $MANIFEST"
[[ $MODE == execute ]] && echo "   Ziel:      $TRASH_DIR"
echo

moved_total=0; skipped_sudo=0; freed_mb=0

process_path() {
  local kind="$1" path="$2" label="$3" size

  # Nur sudo-fähige Arten überspringen, wenn --sudo nicht gesetzt ist
  if [[ ( $kind == SUDO || $kind == SAGENT ) && $WITH_SUDO -ne 1 ]]; then
    printf '  ⏭  %-7s %s  (übersprungen – nur mit --sudo)\n' "$label" "$path"
    skipped_sudo=$((skipped_sudo+1)); return
  fi

  if [[ ! -e "$path" ]]; then
    printf '  –   %-7s %s  (existiert nicht)\n' "$label" "$path"; return
  fi

  size=$(du -sm "$path" 2>/dev/null | awk '{print $1}'); size=${size:-0}

  if [[ $MODE == dry-run ]]; then
    printf '  🔍  %-7s %6s MB  %s\n' "$label" "$size" "$path"
    freed_mb=$((freed_mb+size)); return
  fi

  # LaunchAgent/Daemon vorher entladen
  if [[ $kind == AGENT ]]; then
    local plist_id; plist_id=$(basename "$path" .plist)
    launchctl bootout "gui/$(id -u)/$plist_id" 2>/dev/null || true
  elif [[ ( $kind == SAGENT || $kind == SUDO ) && $WITH_SUDO -eq 1 ]]; then
    local base; base=$(basename "$path")
    if [[ $base == *.plist ]]; then
      sudo launchctl bootout "system/$(basename "$base" .plist)" 2>/dev/null || true
    fi
  fi

  if mv "$path" "$TRASH_DIR/" 2>/dev/null; then
    printf '  🗑  %-7s %6s MB  %s\n' "$label" "$size" "$path"
    freed_mb=$((freed_mb+size)); moved_total=$((moved_total+1))
  elif [[ $WITH_SUDO -eq 1 ]] && sudo mv "$path" "$TRASH_DIR/" 2>/dev/null; then
    printf '  🗑  %-7s %6s MB  %s  (root, via sudo)\n' "$label" "$size" "$path"
    freed_mb=$((freed_mb+size)); moved_total=$((moved_total+1))
  else
    printf '  ⚠️  %-7s %6s MB  %s  (verschieben fehlgeschlagen – läuft die App oder fehlen Rechte?)\n' "$label" "$size" "$path"
  fi
}

if [[ $MODE == execute ]]; then
  mkdir -p "$TRASH_DIR"
fi

while IFS= read -r line || [[ -n "$line" ]]; do
  line="${line%%#*}"
  line="$(printf '%s' "$line" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')"
  [[ -z "$line" ]] && continue
  case "$line" in
    AGENT:*)  process_path AGENT   "$HOME/Library/LaunchAgents/$(basename "${line#AGENT:}")" agent ;;
    SAGENT:*) process_path SAGENT  "${line#SAGENT:}" sysagent ;;
    SUDO:*)   process_path SUDO    "${line#SUDO:}"   sysdata ;;
    *)        path="${line/\$HOME/$HOME}"; process_path LOCAL "$path" datei ;;
  esac
done < <(grep -v '^[[:space:]]*$' "$MANIFEST")

echo
if [[ $MODE == dry-run ]]; then
  echo "🔍 Dry-Run: Es wurde NICHTS verändert. Gesamtpotenzial: ~${freed_mb} MB"
  [[ $skipped_sudo -gt 0 ]] && echo "   ($skipped_sudo Systempfade nur mit --sudo sichtbar/behandelbar)"
  echo "   Ausführen:  $0 --execute        (ohne Systempfade)"
  echo "               $0 --execute --sudo (inkl. Systempfade, fragt Passwort ab)"
else
  echo "✅ $moved_total Elemente in den Papierkorb verschoben. Freigebbar: ~${freed_mb} MB"
  [[ $WITH_SUDO -eq 0 && $skipped_sudo -gt 0 ]] && echo "   ⚠️  $skipped_sudo Systempfade übersprungen (ohne --sudo)."
  echo "   → Platz wird frei, sobald der Papierkorb geleert wird."
fi
