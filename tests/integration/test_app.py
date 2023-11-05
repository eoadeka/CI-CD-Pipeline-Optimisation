import pytest
from my_app.app import app

def test_home_route():
    response = app.test_client().get('/')
    assert response.status_code == 200
    print()

test_home_route()