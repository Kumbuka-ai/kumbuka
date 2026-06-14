---
title: MCP-Tools
description: Die fünf MCP-Tools, die ein KI-Assistent aufruft, um das steuernde Wissen eines Teams zu speichern, abzurufen und zu vergessen — bereitgestellt über einen Remote-Server.
---

kumbuka stellt einen Remote-**MCP-Server über Streamable HTTP** unter `/mcp`
bereit, der auf den authentifizierten Benutzer beschränkt ist. Fünf Tools bilden
die Oberfläche. Die Namen sind bewusst funktional statt markenpräfigiert gehalten —
das Modell liest sie, und Klarheit schlägt Markengeräusch.

Tool-Rückgaben sind **strukturiertes JSON** (MCP `structuredContent`), damit das
Modell Felder zuverlässig lesen kann, anstatt Prosa erneut zu parsen.

Es gibt außerdem eine MCP-**Ressource** `memory://{scope}`, die den Inhalt eines
Scopes auflistet.

Zu den zugrunde liegenden Konzepten (Scopes, Typen, Schlüssel, Autorschaft) siehe
[Konzepte](/concepts/data-model/).

---

## `memory_remember`

Schreibt einen neuen Eintrag oder führt einen Upsert eines bestehenden Eintrags
durch, wenn ein `key` angegeben wird.

| Parameter | Erforderlich | Beschreibung |
|---|---|---|
| `content` | ja | Die zu merkende Aussage (Klartext). |
| `type` | ja | Einer von `decision`, `convention`, `constraint`, `open_question`, `glossary`, `status`. |
| `scope` | nein | Ziel-Scope-Slug. Wird er weggelassen, entscheidet die **Standard-Schreib-Scope-Richtlinie** des Teams (`ask` / `project` / `global` — siehe [Konfiguration](/reference/configuration/)). |
| `key` | nein | Kleingeschriebene, mit Punkt/Kebab namensräumlich gegliederte Adresse (z. B. `db.system-of-record`). Wenn angegeben, wird ein passender Eintrag an Ort und Stelle aktualisiert statt dupliziert. |

Die Autorschaft wird automatisch aus dem Schreibkanal erfasst; ein Client kann sie
nicht setzen.

## `memory_recall`

Liest Einträge mit Filtern. Alle Parameter sind optional; ohne Angabe liefert es
zurück, was der Aufrufer im Kontext sehen darf.

| Parameter | Beschreibung |
|---|---|
| `scope` | Auf einen Scope-Slug beschränken. |
| `type` | Auf einen Eintragstyp beschränken. |
| `query` | Teilstring-Treffer über den Inhalt. |
| `include_global` | Ob die `global`-Baseline neben dem ausgewählten Scope eingebunden wird. |

`memory_recall` liefert immer nur Einträge zurück, die der aufrufende Benutzer
sehen darf.

## `memory_forget`

Entfernt einen Eintrag.

| Parameter | Beschreibung |
|---|---|
| `scope` | Der Scope, in dem der Eintrag liegt. |
| `key` *oder* `id` | Identifiziert den Eintrag über seinen `key` innerhalb des Scopes oder über seine `id`. |

Private Einträge werden durch die Eigentümerprüfung geschützt — nur der Eigentümer
kann über seine eigene Sitzung seine privaten Einträge vergessen.

## `memory_scopes`

Listet die Scopes auf, die der Aufrufer sehen darf — seinen eigenen
`private`-Scope sowie jeden geteilten Scope (`global` und die `project`-Scopes, auf
die er Zugriff hat). Keine Parameter.

## `memory_load_context`

Liefert einen typisierten, sofort einfügbaren **Digest** der relevanten Regeln,
gruppiert nach Typ (decision / convention / constraint / open_question / glossary /
status) und pro Gruppe begrenzt. Dies ist das Tool, das zu Beginn einer Sitzung
aufgerufen werden sollte, damit der Assistent das steuernde Wissen des Teams vom
ersten Zug an mitführt.

| Parameter | Beschreibung |
|---|---|
| `scope` | Optionaler Scope, auf den der Digest fokussiert wird; andernfalls wird die relevante Baseline verwendet. |

---

## Notes

- **Beschränkung auf den Benutzer.** Jeder Aufruf läuft als der authentifizierte
  Benutzer. Deshalb kann derselbe Endpunkt den privaten Scope eines Mitglieds
  neben den geteilten bedienen, ohne jemals das private Gedächtnis eines Benutzers
  einem anderen offenzulegen — siehe [Sicherheit & Datenschutz](/operations/security/).
- **Streamable HTTP.** kumbuka verwendet den modernen MCP-Transport (Streamable
  HTTP), nicht den älteren SSE-Transport.
