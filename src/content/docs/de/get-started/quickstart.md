---
title: Schnellstart
description: Hosten Sie die Community Edition selbst als einzelnen Docker-Compose-Stack.
---

Die Community Edition ist der kostenlose, selbst gehostete, mandantenfreie
Gedächtniskern. Sie läuft als einzelner Docker-Compose-Stack: das Quarkus-Backend,
PostgreSQL, Keycloak (der Identitätsanbieter), ein Caddy-Edge und die Next.js-Admin-Konsole,
die unter dem Wurzelpfad ausgeliefert wird.

Der bereitstellbare Stack liegt im Repository
[`kumbuka-server`](https://github.com/kumbuka-ai/kumbuka-server). Diese
Seite ist die Einführung auf Projektebene; das
[`kumbuka-server`-Runbook](https://github.com/kumbuka-ai/kumbuka-server#quick-start-dev)
ist die maßgebliche, stets aktuelle Referenz für Umgebungsvariablen und die
Produktivbereitstellung.

## Voraussetzungen

- **Docker** und **Docker Compose** (eine aktuelle Docker Engine enthält Compose v2).
- Ein erreichbarer Host und — für einen echten Connector von claude.ai — **DNS und
  TLS** für die von Ihnen konfigurierten Hostnamen. Caddy stellt Zertifikate
  automatisch bereit, sobald die Hostnamen auf Ihren Host auflösen.

Die Hostnamen sind Konfiguration, niemals fest verdrahtet (siehe
[Konfiguration](/de/reference/configuration/)). Die unten genannten Standardwerte —
`kumbuka.ai`, `memory.kumbuka.ai`, `auth.kumbuka.ai` — sind Beispiele; legen Sie
Ihre eigenen fest.

## 1. Den Stack beschaffen

Klonen Sie den Server und die Konsole **nebeneinander** — die Konsole ist über
einen relativen Pfad in den Compose-Stack des Servers eingebunden (Schritt 4):

```bash
git clone https://github.com/kumbuka-ai/kumbuka-server
git clone https://github.com/kumbuka-ai/kumbuka-console
cd kumbuka-server
```

## 2. Konfigurieren

```bash
cp .env.example .env
```

Bearbeiten Sie `.env` und setzen Sie mindestens Ihre Domain und die Secrets. Für
die lokale Entwicklung können Sie die Dev-Standardwerte übernehmen; für alles, was
über das Internet erreichbar ist, setzen Sie echte Hostnamen und starke Secrets.
Die vollständige Liste der Stellschrauben ist in
[Konfiguration](/de/reference/configuration/) und in der
[`kumbuka-server`-README](https://github.com/kumbuka-ai/kumbuka-server#quick-start-dev)
dokumentiert.

## 3. Den Backend-Stack starten

Die Backend-Dienste sind hinter dem Compose-Profil `app` gekapselt:

```bash
docker compose --profile app up -d
```

Dies startet das Backend, PostgreSQL, Keycloak (mit importiertem `kumbuka`-Realm)
und Caddy. Prüfen Sie Zustand und Logs:

```bash
docker compose ps
docker compose logs -f kumbuka-backend
```

Zu diesem Zeitpunkt sind die Admin-API und der `/mcp`-Endpunkt aktiv, aber der
**Wurzelpfad (`/`) liefert einen 502** — das ist der erwartete „Backend-only“-Zustand,
bis Sie im nächsten Schritt die Konsole hinzufügen.

## 4. Die Admin-Konsole hinzufügen

Die Konsole (ein Next.js-BFF) liegt in einem eigenen Repository und wird über eine
`compose.override.yml` im Verzeichnis `kumbuka-server` in denselben Stack
eingebunden. Compose führt diese Datei automatisch zusammen:

```yaml
# kumbuka-server/compose.override.yml
services:
  kumbuka-console:
    build: ../kumbuka-console        # or: image: ghcr.io/kumbuka-ai/kumbuka-console:latest
    environment:
      NEXT_PUBLIC_APP_NAME: kumbuka.ai
      KUMBUKA_BACKEND_URL: http://kumbuka-backend:8080
    networks: [internal]
    depends_on: [kumbuka-backend]
    profiles: ["app"]
```

Caddy leitet den Wurzelpfad bereits an diesen Dienst weiter, sodass keine
Routing-Änderungen nötig sind. Starten Sie die Konsole mit demselben Befehl —
Compose übernimmt das Override:

```bash
docker compose --profile app up -d
```

Der Wurzelpfad liefert nun die Konsole. Sie bindet sich nur an das interne
Docker-Netzwerk; Caddy bleibt der einzige öffentliche Einstiegspunkt. (Für die
lokale Entwicklung gegen ein laufendes oder gemocktes Backend ohne Docker siehe
die [`kumbuka-console`-README](https://github.com/kumbuka-ai/kumbuka-console#running).)

## 5. Erster Start

1. **Melden Sie sich an der Admin-Konsole an** unter Ihrem konfigurierten
   Konsolen-Host (z. B. `https://kumbuka.ai`). Der erste Administrator wird während
   der Stack-Einrichtung bereitgestellt — den genauen Bootstrap-Schritt finden Sie
   im `kumbuka-server`-Runbook.
2. **Bestätigen Sie, dass der `global`-Scope existiert** — er ist die stets aktive
   Grundlage; es gibt genau einen, und er kann nicht entfernt werden.
3. **Erstellen Sie einen `project`-Scope** oder zwei, wenn Sie das geteilte
   Gedächtnis organisieren möchten (z. B. `billing-platform`).
4. **Laden Sie Teammitglieder ein** über **Team & users**; jedes erhält einen
   Registrierungslink von Keycloak (es wird kein Passwort in ihrem Namen gesetzt).
5. **Öffnen Sie die Connector-Karte** unter **Settings**, um die Endpunkt-URL, die
   Client-ID und das Client-Secret zu erhalten, die Sie einem AI-Client übergeben.

## 6. Einen Assistenten verbinden

Sobald der Stack läuft und Sie die Connector-Details zur Hand haben, fügen Sie
kumbuka zu Ihrem AI-Client hinzu — siehe
[Einen Assistenten verbinden](/de/get-started/connecting-an-assistant/).

## Nächste Schritte

- [Konfiguration](/de/reference/configuration/) — Richtlinien und Umgebungs-Stellschrauben.
- [Architektur](/de/operations/architecture/) — was jeder Container tut und wie Anfragen
  fließen.
- [Sicherheit & Datenschutz](/de/operations/security/) — die Garantie des privaten
  Gedächtnisses und die operativen Invarianten, die einzuhalten sind.
