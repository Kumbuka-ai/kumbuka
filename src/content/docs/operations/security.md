---
title: Sicherheit & Datenschutz
description: Die Garantie des privaten Gedächtnisses und wie sie strukturell durchgesetzt wird, Deaktivierung vs. Löschung, die release-blockierenden Invarianten und die Netzwerk-Quelltextpflicht nach AGPL §13.
---

Diese Seite beschreibt das Sicherheitsmodell der Community Edition: die Garantie
des privaten Gedächtnisses und wie sie *strukturell* durchgesetzt wird, was das
Deaktivieren gegenüber dem Löschen eines Mitglieds für dessen Gedächtnis
bedeutet, und die Invarianten, die kumbuka als release-blockierend behandelt.

Um eine **Schwachstelle zu melden**, siehe [SECURITY.md](https://github.com/kumbuka-ai/kumbuka/blob/main/SECURITY.md). Bitte
eröffnen Sie für Sicherheitsprobleme kein öffentliches Issue.

## Die Garantie des privaten Gedächtnisses

Der **private** Scope eines Mitglieds gehört diesem und ist **nur** für dieses
erreichbar, **nur** über die MCP-Oberfläche unter dessen eigener
authentifizierter Sitzung.

- **Kein** Admin, **keine** Konsolenansicht und **keine** teamseitige API kann ihn
  lesen.
- Er wird auf der **Datenzugriffsschicht** durchgesetzt — die privilegierten
  (Admin-/Konsolen-)Codepfade haben **keine Route**, die private Zeilen
  zurückgeben kann.
- Es handelt sich **nicht** um einen Konfigurationsschalter, der umgelegt werden
  könnte, und nicht um einen Filter auf UI-Ebene, den eine fehlende Prüfung
  umgehen könnte.

### Wie sie strukturell durchgesetzt wird

Die Garantie hängt nicht davon ab, dass jeder Aufrufer daran denkt, eine
`WHERE`-Klausel hinzuzufügen. Die Admin-/Konsolen-Lesepfade werden von Code
bedient, der überhaupt keine Methode besitzt, die eine private Zeile zurückgeben
könnte — die privilegierte Oberfläche kann die Abfrage schlicht nicht
ausdrücken. Der private Scope ist nur über den nutzerspezifischen MCP-Pfad
erreichbar, der stets als der besitzende, authentifizierte Nutzer ausgeführt
wird.

Die Konsole macht dieses Versprechen an mehreren Stellen sichtbar (der
Scope-Browser, das Dashboard, die Einstellungen, die Kontoansicht und der
Einladungsablauf), sodass es als bewusste Garantie und nicht als Auslassung
gelesen wird.

> Entwurfsregel: Wenn die private Garantie und die Bequemlichkeit in Konflikt
> geraten, gewinnt die Garantie.

## Deaktivierung vs. Löschung

Dies sind zwei verschiedene Vorgänge mit zwei verschiedenen Auswirkungen auf das
Gedächtnis eines Mitglieds.

- **Deaktivierung** *(ratifiziertes Verhalten)* — das Deaktivieren eines Nutzers
  **setzt dessen Konto aus**: Er kann sich nicht mehr anmelden oder die
  MCP-Oberfläche erreichen. Sein **privates Gedächtnis bleibt unangetastet und
  bleibt sein Eigentum**. Eine erneute Aktivierung stellt den Zugriff darauf
  wieder her. Die Deaktivierung ist umkehrbar und zerstört nichts.

- **Löschung** *(ratifiziertes Verhalten)* — das bewusste Gegenteil der
  Deaktivierung: das Konto des Mitglieds **und dessen gesamter privater Scope**
  werden entfernt, sodass der private Inhalt **weg ist, nicht bloß ausgesetzt**.
  Dies ist das Verhalten für eine Kontolöschung / Anfrage auf Recht auf Löschung.

Wie die Löschung mit dem umgeht, was das Mitglied berührt hat:

- **Privates Gedächtnis** — vollständig gelöscht. Nichts vom privaten Scope des
  Mitglieds überlebt die Löschung.
- **Geteilte Einträge, die es verfasst hat** (in `global` / `project` Scopes) —
  **beibehalten**, sodass Teamwissen, auf das sich die Gruppe verlässt, nicht
  verloren geht, wenn eine Person geht. Die **Autorschaft wird anonymisiert** zu
  einer Tombstone-Identität (z. B. *ehemaliges Mitglied*). Dies ist ein
  serverseitiges Löschereignis, konsistent mit der
  [Invariante der serverseitig abgeleiteten Autorschaft](#release-blocking-invariants) —
  die Autorschaft wird vom Server neu zugewiesen, niemals durch ein Client-Flag.
- **Kulanzfenster** — die Löschung ist **für einen kurzen, konfigurierbaren
  Aufbewahrungszeitraum umkehrbar (Standard 30 Tage)**; nach dessen Ablauf ist
  die Löschung dauerhaft.

## Release-blockierende Invarianten {#release-blocking-invariants}

kumbuka behandelt die folgenden Punkte als sperrend — ein Build, der einen von
ihnen verletzt, ist nicht auslieferbar:

1. **Privates leckt niemals.** Kein Admin-, Konsolen- oder teamseitiger API-Pfad
   kann die privaten Zeilen eines Mitglieds zurückgeben.
2. **Mandantentrennung.** Keine Bereitstellungsgrenze lässt die Daten eines
   Mandanten an einen anderen gelangen. *(In der einmandantenfähigen Community
   Edition gibt es einen Mandanten; die Isolationsnaht existiert zur
   Vorwärtskompatibilität und ist im kommerziellen mehrmandantenfähigen Pfad
   tragend.)*
3. **Der Betreiber sieht keinen privaten Inhalt.** Das Ausführen oder
   Administrieren des Dienstes gewährt keinen Pfad zum privaten Gedächtnis der
   Mitglieder.
4. **Serverseitig abgeleitete Autorschaft.** Der Autor eines Eintrags wird durch
   den Schreibkanal auf dem Server bestimmt, niemals durch ein
   client-geliefertes Flag.

## Netzwerk-Quelltextpflicht (AGPL §13) {#network-source-obligation-agpl-13}

kumbuka ist unter **AGPL-3.0** lizenziert und wird normalerweise als
netzwerkzugänglicher Dienst bereitgestellt. Nach AGPL **§13** müssen Sie, wenn
Sie eine **modifizierte** Version betreiben und Nutzer über ein Netzwerk mit ihr
interagieren lassen, diesen Nutzern den **entsprechenden Quelltext** Ihrer
modifizierten Version anbieten. Der Betrieb eines unveränderten Release begründet
keine neuen Pflichten über die Bedingungen der AGPL hinaus; das Modifizieren und
das Bereitstellen über ein Netzwerk dagegen schon. Siehe [Editionen](/concepts/editions/)
und die [LICENSE](https://github.com/kumbuka-ai/kumbuka/blob/main/LICENSE).

## Meldung

Sicherheitsmeldungen gehen an den Kontakt in [SECURITY.md](https://github.com/kumbuka-ai/kumbuka/blob/main/SECURITY.md).
Wir bitten um koordinierte Offenlegung und arbeiten mit Ihnen an einer Behebung
und einem Zeitplan.
