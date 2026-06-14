---
title: Konfiguration
description: Die in der Konsole festgelegten Team-Richtlinien und die in der Umgebung festgelegten Deployment-Stellschrauben der Community Edition.
---

Diese Seite beschreibt das konfigurierbare Verhalten der Community Edition — die
in der Konsole festgelegten Team-Richtlinien und die in der Umgebung festgelegten
Deployment-Stellschrauben. Die maßgebliche, stets aktuelle Liste der
Umgebungsvariablen liegt beim deploybaren Stack im
[`kumbuka-server` README](https://github.com/kumbuka-ai/kumbuka-server#quick-start-dev);
diese Seite erläutert die Konzepte dahinter.

## Hostnamen sind Konfiguration

Hostnamen sind **niemals fest codiert**. Jedes Deployment legt seine eigenen fest:

| Host | Zweck | Beispiel |
|---|---|---|
| Console | Die Admin-Oberfläche | `kumbuka.ai` |
| MCP-Endpunkt | Die `/mcp`-Oberfläche, mit der sich KI-Clients verbinden | `memory.kumbuka.ai` |
| Keycloak | Der Identity-Provider / Anmelde-Host | `auth.kumbuka.ai` |

Die obigen Beispiele sind nur Beispiele. Legen Sie Ihre eigenen in `.env` fest;
Caddy stellt TLS für die von Ihnen konfigurierten Hostnamen bereit, sobald diese
auf Ihren Host auflösen.

## Team-Richtlinien (in der Konsole festgelegt)

Dies sind Laufzeit-Richtlinien, die ein Admin über die **Einstellungen**
verwaltet. Sie ändern das Verhalten sofort.

### Standard-Schreib-Scope-Richtlinie

Wohin der Assistent schreibt, wenn ihm **kein** Scope mitgeteilt wird:

| Value | Verhalten |
|---|---|
| `ask` *(Standard)* | Der Assistent schlägt ein Ziel vor und das Mitglied bestätigt. Am sichersten für gemischte Teams. |
| `project` | Der aktive Projekt-Scope, mit einem Laufzeit-Fallback, falls er fehlt. |
| `global` | Die organisationsweite Baseline. |

**Private ist niemals das Standardziel des Teams.** Es ist jedem Mitglied stets
direkt verfügbar; die Schreibrichtlinie regelt ausschließlich *geteilte*
Schreibvorgänge.

### Wer Projekt-Scopes erstellen darf

| Value | Verhalten |
|---|---|
| `admins` *(Standard)* | Nur Admins erstellen neue `project`-Scopes. |
| `members` | Jedes Mitglied darf `project`-Scopes erstellen. |

Der einzelne `global`-Scope ist fest — er kann unabhängig von dieser Richtlinie
weder erstellt noch entfernt werden.

### Ungültiger Standard-Scope (Laufzeit-Fallback)

Wird der konfigurierte Standard-Scope ungültig (zum Beispiel weil er archiviert
oder gelöscht wurde), fällt das Backend **zur Laufzeit auf `ask` zurück, ohne die
gespeicherte Konfiguration zu verändern**, zeigt ein Admin-Banner und warnt
proaktiv beim Archivieren/Löschen. Die gespeicherte Richtlinie bleibt intakt,
damit sie bewusst korrigiert werden kann.

### Connector-Details

Die **Einstellungen → connector**-Karte zeigt die Endpunkt-URL, die Client-ID,
ein maskiertes Client-Secret und eine **rotate**-Aktion. Das Rotieren des Secrets
**macht das alte sofort ungültig** — es ist der Notausschalter auf
Connector-Ebene.

## Deployment-Stellschrauben (in `.env` festgelegt)

In der Umgebung vor `docker compose up` festgelegt. Typische Kategorien (siehe das
`kumbuka-server` README für genaue Namen und Standardwerte):

- **Domain / Hostnamen** — die drei oben genannten Hosts.
- **Secrets** — Datenbank-Anmeldedaten, Keycloak-Admin- und Client-Secrets, das
  Connector-Secret. Verwenden Sie starke Werte für alles, was aus dem Internet
  erreichbar ist.
- **Datenbank** — PostgreSQL-Verbindungseinstellungen (die App-DB ist `kumbuka`;
  das Schema wird von Flyway verwaltet).
- **Identität** — Keycloak-Realm- und Client-Konfiguration (Realm `kumbuka`;
  Clients `kumbuka-backend`, `kumbuka-admin`, `kumbuka-connector`).

Siehe [Schnellstart](/de/get-started/quickstart/), um diese für einen ersten Lauf
zusammenzustellen, und [Sicherheit & Datenschutz](/de/operations/security/) für die
Invarianten, die eine Konfiguration nicht verletzen darf.
