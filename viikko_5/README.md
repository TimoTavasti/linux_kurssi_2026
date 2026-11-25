# Viikko 5 - LLM Chat

Linux-kurssin viikko 5 harjoitustyö.

## Tavoite

Rakentaa Flask-pohjainen chat-sovellus, joka:

- käyttää paikallista Ollama-mallia
- tallentaa keskustelut MariaDB:hen
- toimii osoitteessa /viikko5/
- deployataan automaattisesti GitHub Actionsilla

## Projektin rakenne

- app.py - Flask-sovellus
- templates/ - HTML-sivut
- tests/ - automaattiset testit
- nginx/ - Nginx-konfiguraatiot
- systemd/ - palvelutiedostot
- deploy/ - deploy-skriptit
