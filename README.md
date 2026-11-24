# macbook-hygiene

Werkzeuge zur **Hygiene eines macOS-Systems**: Aufräumen, Zustandsprüfung und automatisierte Wartung.

> 🚧 **Status:** Projekt-Grundgerüst. Die konkrete Funktionalität (Aufräum-Skripte, Health-Checks, launchd-Jobs) wird gerade festgelegt – Details siehe [docs/ROADMAP.md](docs/ROADMAP.md).

## Ziel des Projekts

- **Festplatte freihalten**: Caches, Logs, alte Build-Artefakte, verwaiste `node_modules` & Co. identifizieren und – auf Wunsch – bereinigen.
- **Zustand prüfen**: Speicherplatz, macOS-Updates, Backups (Time Machine) und Security-Basics auf einen Blick berichten.
- **Automatisieren**: Wiederkehrende Wartung per `launchd` statt Handarbeit.
- **Sicher bleiben**: Jede Bereinigung ist standardmäßig *dry-run*; echtes Löschen nur nach expliziter Freigabe.

## Geplante Struktur

```
macbook-hygiene/
├── README.md            # Dieses Dokument
├── .gitignore           # macOS- und Editor-Ausschlüsse
├── bin/                 # Ausführbare Einstiegspunkte (CLI)
├── scripts/             # Einzelne Hygiene- und Prüfskripte
├── config/              # Konfiguration (z. B. Ausschlusslisten, launchd-Plists)
└── docs/                # Dokumentation (Roadmap, How-tos)
```

## Schnellstart

Noch nichts zu starten – sobald die ersten Skripte liegen, hier:

```bash
git clone https://github.com/lheseding/macbook-hygiene.git
cd macbook-hygiene
./bin/macbook-hygiene --dry-run   # geplant
```

## Leitlinien

1. **Keine Überraschungen:** Skripte zeigen zuerst, *was* sie tun würden (`--dry-run` als Default).
2. **Nur macOS-Bordmittel:** Bash/Zsh + Standard-Unix-Tools, keine Abhängigkeiten, die man erst installieren muss.
3. **Rückgängig machen wo möglich:** Löschen bevorzugt in den Papierkorb bzw. mit Log und Wiederherstellungshinweisen.
4. **Dokumentiert:** Jedes Skript bekommt einen kurzen Header mit Zweck, Nutzung und Risiken.

## Mitwirken

Issues und Pull Requests sind willkommen. Für größere Änderungen bitte vorher kurz das Konzept in einem Issue skizzieren.

## Lizenz

Noch nicht festgelegt – Vorschlag: MIT (wird beim ersten Release ergänzt).
