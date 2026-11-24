# Roadmap – macbook-hygiene

## Phase 1 – Grundgerüst ✅
- [x] Repo & Projektstruktur (`bin/`, `scripts/`, `config/`, `docs/`)
- [x] README mit Projektziel und Leitlinien
- [x] `.gitignore` (macOS, Editor, Projekt-Logs)

## Phase 2 – Health-Check (nur lesen, nichts verändern)
- [ ] `scripts/check-disk.sh` – Speicherplatz, größte Verzeichnisse/APFS-Snapshots
- [ ] `scripts/check-updates.sh` – macOS- & App-Updates, restart-pending
- [ ] `scripts/check-backup.sh` – Time-Machine-Status & Alter des letzten Backups
- [ ] `scripts/check-security.sh` – FileVault, Firewall, Gatekeeper-Basics
- [ ] `bin/macbook-hygiene` – Einstiegspunkt, bündelt Checks zu einem Report

## Phase 3 – Aufräumen (dry-run first)
- [ ] `scripts/clean-cache.sh` – User-/System-Caches mit Ausschlussliste
- [ ] `scripts/clean-logs.sh` – rotierte Logs
- [ ] `scripts/clean-dev.sh` – `node_modules`/Build-Artefakte alter Projekte
- [ ] Trash-basiertes Löschen statt `rm -rf` wo sinnvoll

## Phase 4 – Automatisierung
- [ ] `config/launchd/` – Plist-Templates für tägliche/wöchentliche Jobs
- [ ] Install-/Uninstall-Skript für die launchd-Integration

## Offene Fragen
- [ ] Lizenz final festlegen (Vorschlag: MIT)
- [ ] CLI-Namen und Optionen (`--dry-run` Default?) bestätigen
