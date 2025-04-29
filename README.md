# n8n-Automation

Dieses Repository enthält eine komplette Umgebung, um automatisierte Workflows mit n8n zu betreiben. Es besteht aus den folgenden Komponenten:

- **n8n**: Workflow-Automatisierungsplattform
- **crawl4ai**: Dienst zum Crawlen und Verarbeiten von Webseiten für KI-Workflows
- **SearxNG**: Meta-Suchmaschine für private und skalierbare Suche

## Voraussetzungen

- Docker & Docker Compose
- Ein API-Key für euer bevorzugtes LLM (z.B. Gemini) in der Datei `n8n-automation/crawl4ai/.llm.env` 
- Git

## Installation & Start (Docker)

1. **Repository klonen**
   ```bash
   git clone https://github.com/kevinboehmisch/n8n-automation.git
   cd n8n-automation/n8n
   ```

2. **API-Key hinterlegen**
   Lege in `crawl4ai/.llm.env` deinen API-Key ab:
   ```text
   # Beispiel .llm.env
   GEMINI_API_KEY=dein_api_key_hier
   ```

3. **Container starten**
   ```bash
   docker compose up -d
   ```
   > Die Docker-Compose-Datei startet automatisch die Container für:
   > - **crawl4ai** (Crawling-Service für AI-gestützte Workflows)
   > - **searxng** (private Suchmaschine)
   > - **n8n** (Workflow-Editor und -Runner)

4. **Workflow importieren**
   - Öffne das n8n-Frontend unter `http://localhost:5678` (Standardport).
   - Klicke oben links auf **Import** und lade `templates/search_workflow_docker.json` hoch.
   - Aktiviere den Workflow, um ihn regelmäßig oder manuell auszuführen.

## Alternative: Lokaler Betrieb ohne Docker

Falls ihr n8n & Co. bereits lokal installiert habt, könnt ihr nur den Workflow importieren:

1. Repository klonen und in das n8n-Verzeichnis wechseln (siehe oben).
2. Starte euer lokales n8n (z.B. via `npx n8n`).
3. Importiere `templates/search_workflow_local.json` über die n8n-UI.
4. in den searxng-docker und crawl4ai ordner navigieren und jeweils beide in einem separaten Terminal mit `docker compose up -d starten`

## Workflow-Details

- **search_workflow_docker.json**: Konfiguriert für die Kommunikation zwischen n8n, crawl4ai und SearxNG über Docker-Netzwerk.
- **search_workflow_local.json**: Nutzt lokale Endpunkte (z.B. `http://localhost:3000`) für dieselben Dienste.

## Stoppen der Umgebung

```bash
docker compose down
```

Dadurch werden alle gestarteten Container sauber heruntergefahren.

## Weiterführende Links

- [n8n Dokumentation](https://docs.n8n.io)
- [crawl4ai GitHub](https://github.com/kevinboehmisch/crawl4ai)
- [SearxNG Dokumentation](https://searxng.github.io/searxng)

---



