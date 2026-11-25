# Viikko 5: CI/CD-putki ja itse ylläpidetty LLM-chat

## Linkit

**Chat-sovellus**

- http://195.148.22.121/viikko5/

**GitHub-repositorio**

- https://github.com/TimoTavasti/linux_kurssi_2026/tree/main/viikko_5

---

## Yleiskuvaus

Tässä tehtävässä toteutettiin Flask-pohjainen chat-sovellus, joka käyttää paikallisesti ajettavaa Ollama-kielimallia. Sovellus julkaistaan automaattisesti CSC cPouta -palvelimelle GitHub Actionsin avulla.

Käyttäjä voi keskustella palvelimella ajettavan kielimallin kanssa selaimella. Keskusteluhistoria tallennetaan MariaDB-tietokantaan.

---

## Pyyntöjen kulku

```text
Selain
    |
    v
Nginx (/viikko5/)
    |
    v
Gunicorn
    |
    v
Flask-sovellus
    |-- MariaDB (keskusteluhistoria)
    |
    \-- Ollama (kielimalli)
```

Vain Nginx on julkisesti näkyvissä internetiin. Ollama ja sovelluspalvelin kuuntelevat vain localhost-osoitteessa.

---

## CI/CD-putki

### Pull Request

Jokainen Pull Request suorittaa:

- Ruff-linttauksen
- Pytest-testit
- Shell-skriptien syntaksitarkistuksen

Deployta ei tehdä Pull Requesteille.

### Main-haara

Jokainen push main-haaraan:

1. Ajaa testit
2. Kopioi koodin palvelimelle rsyncillä
3. Päivittää Nginx-konfiguraation
4. Päivittää systemd-palvelun
5. Käynnistää chat-sovelluksen uudelleen
6. Tarkistaa uuden version toiminnan health-endpointilla

Jos jokin testi epäonnistuu, deployta ei tehdä.

---

## Julkaisun varmistaminen

Sovelluksessa on health-endpoint:

```text
/viikko5/health
```

Se palauttaa käytössä olevan Git commit SHA -tunnisteen. Tämän avulla GitHub Actions tarkistaa, että uusi versio on todella käytössä.

---

## Käyttäjät, oikeudet ja salaisuudet

### Linux-käyttäjä

Sovellus toimii omalla palvelukäyttäjällään:

```text
User=chatapp
Group=chatapp
```

Todiste:

```text
systemctl show chatapp -p User -p Group

User=chatapp
Group=chatapp
```

Sovellusta ei ajeta root-käyttäjänä.

### Tietokantakäyttäjä

Tietokanta:

```text
chatapp
```

Tietokantakäyttäjä:

```text
chatapp@localhost
```

Myönnetyt oikeudet:

```sql
GRANT USAGE ON *.* TO `chatapp`@`localhost`
GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, INDEX, ALTER
ON `chatapp`.*
TO `chatapp`@`localhost`
```

Käyttäjällä on oikeudet vain oman sovelluksen tietokantaan.

### Salaisuudet

GitHub Actions käyttää seuraavia salaisuuksia:

```text
CPOUTA_HOST
CPOUTA_USER
CPOUTA_SSH_KEY
CPOUTA_KNOWN_HOSTS
```

Salaisuuksia ei tallenneta Git-repositorioon.

Ympäristömuuttujat sijaitsevat palvelimella tiedostossa:

```text
/etc/chatapp/chatapp.env
```

Tiedoston oikeudet:

```text
-rw-r----- 1 root chatapp chatapp.env
```

Vain root ja palvelukäyttäjä voivat lukea tiedoston.

---

## Nginx-integraatio

Sovellus lisättiin olemassa olevaan Nginx-palveluun ilman aiempien viikkojen sivujen muuttamista.

Server-lohkoon lisättiin:

```nginx
include snippets/chatapp.conf;
```

Deploy päivittää vain tiedoston:

```text
/etc/nginx/snippets/chatapp.conf
```

Näin aiempien viikkojen sivut jatkavat toimintaansa normaalisti.

---

## Mallivalinta

Käytetty kielimalli:

```text
qwen2.5:3b
```

Palvelimen resurssit:

```text
15 GiB RAM
6 vCPU
```

Asennetut mallit:

```text
qwen2.5:3b
```

Muistinkäyttö mallin ollessa käytössä:

```text
Muistia yhteensä: 15 GiB
Käytössä: noin 857 MiB
Vapaana: noin 8.6 GiB
Saatavilla: noin 14 GiB
```

Valittu malli toimii hyvin käytettävissä olevilla resursseilla.

---

## Palvelintodisteet

### Palvelun tila

```text
systemctl status chatapp

Active: active (running)
```

### Sovellushakemisto

```text
ls -l /opt/chatapp

app/
venv/
```

### Ympäristötiedosto

```text
ls -l /etc/chatapp

-rw-r----- 1 root chatapp chatapp.env
```

### Asennettu kielimalli

```text
ollama list

qwen2.5:3b
```

---

## Verkkoliikenne ja tietoturva

Ollama kuuntelee vain localhost-osoitteessa:

```text
127.0.0.1:11434
```

Todiste:

```text
sudo ss -ltnp
```

Näyttää Ollaman olevan sidottu osoitteeseen:

```text
127.0.0.1:11434
```

Internetiin ovat avoinna vain:

```text
22/tcp (SSH)
80/tcp (HTTP)
```

---

## Testitulokset

### Chat-sovellus

- /viikko5/ on julkisesti käytettävissä.
- Paikallinen kielimalli vastaa viesteihin.
- Keskustelut tallentuvat MariaDB:hen.
- Keskusteluhistoria säilyy sivun päivityksen jälkeen.

### Istuntojen erottelu

Yksityisessä selainikkunassa keskustelu alkaa tyhjänä.

### Automaattinen julkaisu

Push main-haaraan käynnistää automaattisesti GitHub Actions -putken, joka testaa ja julkaisee sovelluksen.

### Käynnistyminen uudelleen palvelimen bootin jälkeen

Sovellus toimii systemd-palveluna ja käynnistyy automaattisesti palvelimen käynnistyessä.

---

## Replikointi

Viikon 4 ympäristössä palvelin B toimii vain luku -replikana.

Chat-sovellus sijoitettiin palvelimelle A, koska sovelluksen täytyy kirjoittaa keskusteluhistoria MariaDB-tietokantaan.

---

## Mitä opin

Tämän tehtävän aikana opin rakentamaan kokonaisen CI/CD-putken GitHub Actionsin avulla. Opin myös käyttämään rsynciä, systemd-palveluja, Nginx-reititystä, Ollamaa sekä GitHub Secrets -salaisuuksien hallintaa turvallisesti tuotantoympäristössä.
