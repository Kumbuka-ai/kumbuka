---
title: Editionen
description: Die Open-Core-Grenze — was die kostenlose, selbst gehostete Community Edition heute ist und was der geplante kommerzielle Weg ergänzt, ehrlich dargestellt.
---

kumbuka folgt einem **Open-Core**-Modell: ein vollständiger, kostenloser,
quelloffener Kern mit einem geplanten kommerziellen Weg für Organisationen, die
mehr benötigen. Diese Seite stellt die Grenze ehrlich dar — was die Community
Edition heute ist und was der kommerzielle Weg ergänzt — ohne zu übertreiben.

> **Das Produkt ist pre-beta.** Der kommerzielle Weg unten beschreibt die
> beabsichtigte Richtung. Er ist **nicht allgemein verfügbar**, und diese Seite
> nennt **keine Preise und keine Termine**.

## Community Edition (Gegenstand dieses Repositorys)

Die Community Edition ist der **quelloffene, selbst gehostete, Single-Tenant,
atomare Gedächtniskern** — und sie ist kostenlos.

- **Selbst gehostet** — Sie betreiben den Docker-Compose-Stack auf Ihrer eigenen
  Infrastruktur ([Schnellstart](/get-started/quickstart/)).
- **Single-Tenant** — ein Team pro Deployment.
- **Der atomare Gedächtniskern** — das vollständige Gedächtnismodell: die
  Sechs-Typen-Taxonomie der Einträge, die Bereiche `global` / `project` /
  `private`, die fünf `memory_*` MCP-Tools, die Admin-Konsole und die **Garantie
  des privaten Gedächtnisses**, die auf der Datenzugriffsebene durchgesetzt wird.
- **Lizenziert unter AGPL-3.0** — siehe [Lizenzierung](#licensing).

Die Garantie des privaten Gedächtnisses ist **kein** an die Edition gebundenes
Feature. Sie ist Teil des Kerns und in der Community Edition genau so vorhanden,
wie es unter [Sicherheit & Datenschutz](/operations/security/) beschrieben ist.

## Kommerzieller Weg (geplant)

Für Organisationen, die Fähigkeiten über ein einzelnes, selbst gehostetes Team
hinaus benötigen, ist ein kommerzieller Weg geplant. Schlicht dargestellt, ohne
Verfügbarkeitsaussagen:

| Capability | What it is |
|---|---|
| **Mehrmandantenfähigkeit (Multi-Tenancy)** | Viele isolierte Teams auf einem Deployment. Der Single-Tenant-Kern trägt bereits die Isolationsnaht für die Vorwärtskompatibilität. |
| **Context Documents** | Eine Erweiterung über die atomaren Gedächtniseinträge hinaus — reichhaltigerer, dokumentförmiger Kontext. |
| **Moderation** | Ein Add-on zum Überprüfen und Steuern des geteilten Gedächtnisses im großen Maßstab. |
| **Gehostetes SaaS** | Ein verwaltetes Angebot, sodass Sie nicht selbst hosten müssen. |

Dies sind die kommerziellen Ergänzungen; die Community Edition enthält sie nicht.
Wir werden nicht andeuten, dass sie ausgeliefert oder ausgehärtet sind, solange
das Produkt pre-beta ist.

## Lizenzierung {#licensing}

Die Community Edition ist unter der **GNU Affero General Public License v3.0**
([AGPL-3.0](https://github.com/kumbuka-ai/kumbuka/blob/main/LICENSE), ratifiziert)
lizenziert. Da kumbuka als Netzwerkdienst bereitgestellt wird, gilt AGPL
**§13** — der Betrieb einer modifizierten Version, mit der Nutzer über ein
Netzwerk interagieren, verpflichtet Sie, ihnen den zugehörigen Quellcode
anzubieten (siehe [Sicherheit & Datenschutz](/operations/security/#network-source-obligation-agpl-13)).

Ein kommerzieller **Dual-License**-Weg ist für Organisationen geplant, die nicht
unter der AGPL operieren können oder die die Features der kommerziellen Edition
wünschen. Details, Bedingungen und Verfügbarkeit sind noch nicht veröffentlicht.
`[founder input]`

Wie diese Lizenzierung mit Beiträgen zusammenwirkt, erfahren Sie in
[CONTRIBUTING.md](https://github.com/kumbuka-ai/kumbuka/blob/main/CONTRIBUTING.md).
