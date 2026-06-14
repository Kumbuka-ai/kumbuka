---
title: Überblick
description: Was kumbuka ist, die persönliche/geteilte Grenze, die es definiert, und wo es läuft.
---

kumbuka ist ein quelloffenes **Team-Gedächtnis-System für KI-Assistenten**. Es
gibt einem Team einen dauerhaften, geteilten Ort für das Wissen, das ein
Assistent über Konversationen hinweg mitführen sollte, und stellt dieses Wissen
MCP-fähigen KI-Clients über einen Remote-Server bereit. Eine Web-Admin-Konsole
ermöglicht es dem Team, es zu kuratieren.

Diese Seite gibt dir Orientierung. Das genaue Domänenmodell findest du unter
[Konzepte](/concepts/data-model/); wie ein Assistent es aufruft, zeigen die
[MCP-Tools](/reference/mcp-tools/).

## Wofür es da ist

Teams, die KI-Assistenten nutzen, erklären in jeder Sitzung dasselbe steuernde
Wissen erneut — die Entscheidungen, Konventionen und Einschränkungen, die prägen
sollten, wie der Assistent arbeitet. kumbuka macht daraus ein erstklassiges,
teameigenes Gut, sodass es angewendet wird, ohne erneut erzählt zu werden.

Es erfasst **arbeitssteuerndes Wissen**, bewusst klein und typisiert:

- die Regeln und Definitionen, die leiten, wie der Assistent arbeitet, **nicht**
  eine Kopie der Dokumente oder Quellen des Teams (diese verbleiben in ihren
  eigenen Systemen);
- geteilt und kuratierbar, sodass das Team sieht und bearbeitet, worauf sich der
  Assistent stützt, statt dass jede Person einen undurchsichtigen, divergierenden
  Kontext ansammelt;
- portabel, sodass jeder MCP-fähige Assistent es über einen Endpunkt liest und
  schreibt.

## Die persönliche / geteilte Grenze

kumbuka hat zwei Hälften, und die Linie zwischen ihnen ist das definierende
Prinzip des Produkts.

- **Geteiltes Gedächtnis** ist das, was das Team gemeinsam kuratiert — die
  `global`-Basis und beliebig viele `project`-Scopes. Es ist in der Konsole
  sichtbar und vom Team gemäß Rolle bearbeitbar.
- **Privates Gedächtnis** ist der eigene Arbeitsbereich jedes Mitglieds. Es ist
  **nur** durch dieses Mitglied erreichbar, **nur** über dessen eigene
  authentifizierte MCP-Sitzung. Kein Administrator, keine Konsolenansicht und
  keine teamseitige API kann es lesen. Dies wird strukturell durchgesetzt, nicht
  durch eine Einstellung (siehe [Sicherheit & Datenschutz](/operations/security/)).

Wenn die beiden jemals in Konflikt zu geraten scheinen, gewinnt die Garantie des
privaten Gedächtnisses über die Bequemlichkeit.

## Wo es läuft

kumbuka ist ein einziger Docker-Compose-Stack: ein Quarkus-Backend, PostgreSQL,
Keycloak (der Identitätsanbieter) und ein Caddy-Edge, mit der Next.js-Admin-Konsole.
Der bereitstellbare Stack lebt in
[`kumbuka-server`](https://github.com/kumbuka-ai/kumbuka-server). Siehe den
[Schnellstart](/get-started/quickstart/), um ihn selbst zu hosten, und die
[Architektur](/operations/architecture/) für die Topologie.

## Editionen

Die hier dokumentierte **Community Edition** ist der kostenlose, selbst gehostete,
Single-Tenant-Gedächtniskern. Ein kommerzieller Weg (Mandantenfähigkeit, die
Context-Documents-Erweiterung, ein Moderations-Add-on und gehostetes SaaS) ist
geplant, aber pre-beta — siehe [Editionen](/concepts/editions/). Er wird
ehrlich beschrieben: keine Übertreibungen, keine Preise, keine Daten.
