---
title: Einen Assistenten verbinden
description: Wie Sie kumbuka als benutzerdefinierten MCP-Connector in claude.ai hinzufügen und was ein Assistent kann, sobald er aktiv ist.
---

kumbuka wird von einem KI-Client als **benutzerdefinierter MCP-Connector**
erreicht: eine Endpunkt-URL, eine Client-ID und ein Client-Secret. Sobald die
Verbindung besteht, kann der Assistent die Gedächtnis-Tools in Ihrem Namen
aufrufen — einschließlich Ihres eigenen privaten Scopes, denn die Verbindung ist
auf *Sie*, den authentifizierten Benutzer, beschränkt.

Diese Seite beschreibt das Hinzufügen des Connectors in **claude.ai**. Für Claude
Desktop, Claude Code und Claude Mobile siehe die
[`kumbuka-server`-Anleitung](https://github.com/kumbuka-ai/kumbuka-server#connecting-claude-clients).

## Was Sie benötigen

Aus der Karte **Settings → connector** der Admin-Konsole (oder von Ihrem
Administrator):

- **Endpunkt-URL** — die `/mcp`-Adresse, z. B. `https://memory.kumbuka.ai/mcp`
  (der Host Ihrer Bereitstellung; sie ist Konfiguration, kein fester Wert).
- **Client-ID** — die OAuth-Client-ID des Connectors (`kumbuka-connector`).
- **Client-Secret** — ein vertrauliches Secret. Es kann über die Konsole rotiert
  werden, was das alte sofort ungültig macht.

> Remote-MCP-Connectoren in claude.ai erfordern einen kostenpflichtigen Plan. Ein
> im Web hinzugefügter Server wird von Claude Mobile übernommen.

## In claude.ai hinzufügen

1. Gehen Sie zu **Settings → Connectors → Add custom connector**.
2. Geben Sie die **Endpunkt-URL** und die **Client-ID** / das **Client-Secret**
   aus der Connector-Karte ein.
3. Speichern Sie und klicken Sie dann auf **Connect**. claude.ai ermittelt den
   Autorisierungsserver aus dem Endpunkt und startet den OAuth-Flow.
4. **Melden Sie sich** an Ihrem Keycloak-Host an (z. B. `https://auth.kumbuka.ai`)
   und genehmigen Sie den Zugriff. Sie werden zurückgeleitet und der Connector
   wird aktiv.

### Was im Hintergrund passiert

Der Connector ist ein vertraulicher Client, der zusätzlich **PKCE** sendet.
claude.ai ermittelt den Autorisierungsserver über OAuth Protected Resource
Metadata (`/.well-known/oauth-protected-resource` → der Keycloak-Realm `kumbuka`),
durchläuft den Authorization-Code-Flow und ruft dann `/mcp` mit einem
audience-gebundenen Bearer-Token auf. Das Subject des Tokens sind *Sie*; Ihre
Realm-Rolle (`member` oder `admin`) bestimmt, was Sie tun dürfen. Siehe
[Architektur](/de/operations/architecture/) für die vollständige Auth-Topologie.

## Was der Assistent dann tun kann

Mit aktivem Connector verfügt der Assistent über die fünf `memory_*`-Tools
(vollständige Referenz unter [MCP-Tools](/de/reference/mcp-tools/)):

- **Kontext laden** zu Beginn einer Sitzung mit `memory_load_context` — ein
  typisierter Auszug der Regeln, die seine Arbeit steuern sollen.
- **Abrufen** bestimmter Einträge mit `memory_recall` (Filter nach Scope, Typ
  oder einer Teilzeichenkette).
- **Merken** neuer Entscheidungen, Konventionen oder Status mit
  `memory_remember`.
- **Vergessen** von Einträgen, die nicht mehr gelten, mit `memory_forget`.
- **Scopes auflisten**, die er sehen kann, mit `memory_scopes` — einschließlich
  Ihres privaten Scopes, den nur Sie erreichen können.

Wo ein neues Gedächtnis landet, wenn Sie keinen Scope angeben, wird durch die
Standard-Schreib-Scope-Richtlinie des Teams bestimmt (`ask` als Standard — der
Assistent schlägt vor und Sie bestätigen). Siehe
[Konfiguration](/de/reference/configuration/).

Ein guter erster Schritt in einem Projekt ist, den Assistenten anzuweisen, zu
Sitzungsbeginn `memory_load_context` aufzurufen, damit er das steuernde Wissen
des Teams anwendet, ohne dass es ihm erneut erklärt werden muss.
