# Sheesh: Halloween-Look live einbauen

Anleitung für Claude Code am Laptop. Pia sagt nur "go".

## Was passiert

Im **Live-Theme "Impact"** (ID 194227470673, Shop holdoch.myshopify.com / sheesh.de) werden genau
zwei Dateien angefasst:

1. `sections/halloween-komplett.liquid`: neu. Überschriften, Menü, Buttons, Produkttitel und Footer
   in Creepster und Orange, auf allen Seiten.
2. `sections/header-group.json`: in der vorhandenen Section `halloween_effekte` werden `font`,
   `all_headings` und `pdp_box` auf true gesetzt, und `halloween_komplett` wird angehängt.

Das Theme wird **nicht** ausgetauscht, also bleiben die Übersetzungen erhalten. Templates und Rabatte
werden nicht verändert.

## Ablauf für Claude

1. Prüfen, ob die Shopify CLI installiert ist (`shopify version`). Falls nicht: `npm install -g @shopify/cli`.
2. `cd halloween-sheesh && chmod +x apply.sh rollback.sh && ./apply.sh`
   - Beim ersten `pull` öffnet sich ein Browser-Login für Shopify. Pia meldet sich an.
   - Das Skript zeigt den Diff des Headers. Er darf nur die drei Haken und `halloween_komplett`
     enthalten. Wenn sonst etwas anders ist: abbrechen und Pia fragen.
3. Danach sheesh.de öffnen (Startseite, eine Produktseite, eine Kollektion, Warenkorb) und Pia
   kurz melden, was zu sehen ist.

## Rückbau

`./rollback.sh` nimmt die Haken wieder raus und hängt die Section aus. Die Sicherung des alten
Headers liegt jeweils in `backup/`.

## Hinweise

- Fließtext bleibt bewusst in der normalen Schrift, damit er lesbar ist.
- Der Rabatt "Halloween 2+1 gratis" läuft bis 2.11., 23:59 Uhr. Die Texte im Shop sagen "bis 31.10.".
  Falls verlängert wird, müssen die Texte angepasst werden.
- Ohne CLI gibt es eine Notlösung: Im Customizer bei "Halloween-Effekte" im Header die drei Haken
  setzen und eine "Custom Liquid"-Section mit `customizer-fallback.liquid` einfügen.
