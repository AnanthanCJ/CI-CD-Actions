# CI/CD Sample App

A small Flask app used to learn GitHub Actions and deploy to AWS EC2.

## Endpoints

- `GET /` returns a JSON message with the app version, hostname, and time.
- `GET /health` returns `{"status": "ok"}`.

## Run locally

```bash
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt

# Development server
python app.py

# Production-style server
gunicorn --bind 0.0.0.0:5000 app:app
```

## Run tests

```bash
pytest
```
