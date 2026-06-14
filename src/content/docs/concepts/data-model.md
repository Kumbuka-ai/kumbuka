---
title: Konzepte
description: Das Domänenmodell von kumbuka — der Gedächtniseintrag, der Scope, in dem er lebt, und der Autor, der ihn geschrieben hat.
---

Das Domänenmodell von kumbuka ist bewusst klein gehalten. Drei Ideen tragen es:
der **Gedächtniseintrag**, der **Scope**, in dem er lebt, und der **Autor**, der
ihn geschrieben hat.

## Gedächtniseintrag

Eine Einheit gemerkten Wissens. Ein Eintrag hat:

| Feld | Bedeutung |
|---|---|
| `id` | Ein stabiler Surrogat-Schlüssel. |
| `scope` | Der Scope, zu dem der Eintrag gehört (siehe unten). |
| `type` | Einer der sechs festen Typen (siehe unten). |
| `key` | Optional, in Kleinbuchstaben, dot/kebab-namespaced — die Adresse, über die der Assistent einen Eintrag nachschlägt, z. B. `db.system-of-record`. |
| `content` | Die Aussage selbst, als reiner Text. |
| `author` | Ein Mensch (dessen authentifizierte Identität) oder der Assistent (`agent`). Serverseitig abgeleitet — siehe [Autorschaft](#authorship). |
| `created_at` / `updated_at` | Zeitstempel. |

Ein Eintrag ist eine einzelne, gut lesbare Aussage — kein Dokument. Beschränke
ihn auf eine Regel, Entscheidung oder Definition.

## Eintrags-Taxonomie (fest, sechs Typen)

Die Taxonomie ist bewusst klein gehalten, damit das Gedächtnis lesbar bleibt. Es
gibt genau sechs Typen, und sie ändern sich nicht:

| Typ | Wofür |
|---|---|
| `decision` | Eine getroffene Entscheidung, auf die sich das Team festgelegt hat. |
| `convention` | Eine geteilte Standardvorgehensweise. |
| `constraint` | Eine harte Grenze, die nicht überschritten werden darf. |
| `open_question` | Etwas Ungeklärtes; braucht einen Verantwortlichen und eine Antwort. |
| `glossary` | Ein Begriff, so definiert, dass alle dasselbe meinen. |
| `status` | Der aktuelle Stand von etwas in Bewegung. |

## Scopes

Ein Scope ist ein Container von Einträgen mit einer Zugriffs-**Art** (kind). Er
hat einen Surrogat-Primärschlüssel, einen eindeutigen und unveränderlichen
**Slug** (die Adresse, die Assistent und UI verwenden), einen Anzeigenamen, eine
Art, eine Beschreibung und ein `archived`-Flag (schreibgeschützt).

| Art | Sichtbarkeit | Hinweise |
|---|---|---|
| `global` | Teamweit | Genau **einer** pro Organisation — die stets aktive Baseline, die der Assistent zuerst liest. Kann nicht erstellt oder entfernt werden. |
| `project` | Team-geteilt | Viele; unterteilen das geteilte Gedächtnis in Räume (z. B. `billing-platform`). Mitglieder lesen/schreiben; Admins verwalten. |
| `private` | Nur Eigentümer | Einer pro Mitglied. Nur durch seinen Eigentümer über die MCP-Oberfläche erreichbar. Erscheint **nie** in der Konsole oder einer admin-/teamseitigen API. |

Der einzelne `global`-Scope ist fest. `project`-Scopes werden erstellt, um das
geteilte Gedächtnis zu organisieren; wer sie erstellen darf, ist eine
Team-Richtlinie (siehe [Konfiguration](/reference/configuration/)). `private`
steht jedem Mitglied jederzeit direkt zur Verfügung und ist nie das
Standard-Schreibziel des Teams.

Der **Slug** eines Scopes ist auch über Umbenennungen hinweg unveränderlich,
sodass die Adresse, die ein Assistent speichert, gültig bleibt.

## Autorschaft {#authorship}

Der Autor eines Eintrags ist entweder ein Mensch oder der Assistent (`agent`),
und die Herkunft wird **serverseitig aus dem Schreibkanal abgeleitet** — niemals
aus einem vom Client gelieferten Flag:

- Schreibvorgänge über die **Konsole** werden dem angemeldeten Menschen
  zugeschrieben.
- Schreibvorgänge über die **MCP-Oberfläche** werden als „über Assistent"
  markiert (`source = mcp`), wobei weiterhin das echte menschliche Subjekt hinter
  der Sitzung erfasst wird.

Es gibt keinen separaten Login für den Assistenten, und kein Client kann einen
anderen Autor angeben als den Kanal, über den er geschrieben hat. Das
„agent"-Abzeichen der Konsole bedeutet einfach, dass der Eintrag über MCP
eingegangen ist.

## Wie der Assistent liest und schreibt

Der Assistent interagiert mit diesen Konzepten über fünf MCP-Tools
(`memory_remember`, `memory_recall`, `memory_forget`, `memory_scopes`,
`memory_load_context`). Wo ein neuer Eintrag landet, wenn kein Scope genannt
wird, regelt die Standard-Schreib-Scope-Richtlinie des Teams. Siehe
[MCP-Tools](/reference/mcp-tools/) und
[Konfiguration](/reference/configuration/).
