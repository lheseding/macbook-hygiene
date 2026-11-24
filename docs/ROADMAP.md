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

## Phase 3 – Aufräumen (dry-run first) – **teilweise erledigt, 24.11.2026**
- [x] `scripts/remove-apps.sh` – Manifest-basiertes Entfernen in den Papierkorb (Dry-Run-Default, `--execute`, `--sudo`-Modus)
- [x] `config/removal-plan.list.example` – Vorlage; persönliche Liste: `config/removal-plan.local.list` (gitignored)
- [x] App-Diät 24.11.2026: Ollama-Modelle (9,2 GB), Gaming-Leichen, Adobe-User-Daten u. a. in den Papierkorb verschoben (siehe `reports/app-inventory-2026-11-24.md`)
- [ ] Rest per `--sudo` (root-eigene Apps + Adobe-Systemdaten, ~19 GB) – manuell im Terminal
- [ ] `scripts/clean-cache.sh` – Browser-/pip-/Updater-Caches mit Ausschlussliste
- [ ] `scripts/clean-dev.sh` – `node_modules`/Build-Artefakte alter Projekte
- [ ] Trash-basiertes Löschen statt `rm -rf` wo sinnvoll (remove-apps.sh macht das bereits)

## Phase 4 – Automatisierung
- [ ] `config/launchd/` – Plist-Templates für tägliche/wöchentliche Jobs
- [ ] Install-/Uninstall-Skript für die launchd-Integration

## Offene Fragen
- [ ] Lizenz final festlegen (Vorschlag: MIT)
- [ ] CLI-Namen und Optionen (`--dry-run` Default?) bestätigen
