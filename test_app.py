import pytest

from app import app as flask_app


@pytest.fixture
def client():
    flask_app.config["TESTING"] = True
    with flask_app.test_client() as client:
        yield client


def test_index_returns_message(client):
    response = client.get("/")
    assert response.status_code == 200
    body = response.get_json()
    assert body["message"] == "Hello from the CI/CD sample app"
    assert "version" in body


def test_health_returns_ok(client):
    response = client.get("/health")
    assert response.status_code == 200
    assert response.get_json() == {"status": "ok"}


def test_unknown_route_returns_404(client):
    response = client.get("/does-not-exist")
    assert response.status_code == 404
