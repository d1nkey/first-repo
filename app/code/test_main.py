from unittest.mock import AsyncMock, patch
import pytest
from fastapi.testclient import TestClient
from main import app

client = TestClient(app)


@pytest.fixture
def mock_db():
    mock_pool = AsyncMock()
    mock_conn = AsyncMock()
    mock_pool.acquire.return_value.__aenter__.return_value = mock_conn
    return mock_pool, mock_conn


def test_get_visitor(mock_db):
    mock_pool, mock_conn = mock_db
    mock_conn.fetchval.return_value = 10

    with patch("main.db_pool", mock_pool):
        response = client.get("/")
        assert response.status_code == 200
        assert response.json() == {"message": "Hello! You are visitor number 10"}


def test_health_check_success(mock_db):
    mock_pool, mock_conn = mock_db
    mock_conn.fetchval.return_value = 1

    with patch("main.db_pool", mock_pool):
        response = client.get("/health")
        assert response.status_code == 200
        assert response.json() == {"status": "ok", "db": "connected"}


def test_health_check_failure(mock_db):
    mock_pool, mock_conn = mock_db
    mock_conn.fetchval.side_effect = Exception("DB Connection Error")

    with patch("main.db_pool", mock_pool):
        response = client.get("/health")
        assert response.status_code == 500
        assert response.json() == {"detail": {"status": "error", "db": "disconnected"}}