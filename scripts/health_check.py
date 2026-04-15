#!/usr/bin/env python3
"""
health_check.py - Verificacao de saude dos servicos em producao
Monitora endpoints criticos e envia alertas via Telegram se algum servico cair.
"""

import requests
import sys
import json
from datetime import datetime


SERVICES = {
    "api": "/api/health",
    "auth": "/api/auth/status",
    "database": "/api/health/db",
}

TELEGRAM_BOT_TOKEN = None  # Configurar via variavel de ambiente
TELEGRAM_CHAT_ID = None


def check_endpoint(base_url, path, timeout=10):
    """Verifica se um endpoint responde com status 200."""
    url = f"{base_url}{path}"
    try:
        response = requests.get(url, timeout=timeout)
        return {
            "url": url,
            "status": response.status_code,
            "healthy": response.status_code == 200,
            "response_time_ms": int(response.elapsed.total_seconds() * 1000),
            "timestamp": datetime.utcnow().isoformat(),
        }
    except requests.exceptions.Timeout:
        return {"url": url, "status": 0, "healthy": False, "error": "timeout"}
    except requests.exceptions.ConnectionError:
        return {"url": url, "status": 0, "healthy": False, "error": "connection_refused"}
    except Exception as e:
        return {"url": url, "status": 0, "healthy": False, "error": str(e)}


def send_telegram_alert(message):
    """Envia alerta via Telegram bot."""
    if not TELEGRAM_BOT_TOKEN or not TELEGRAM_CHAT_ID:
        return
    url = f"https://api.telegram.org/bot{TELEGRAM_BOT_TOKEN}/sendMessage"
    requests.post(url, json={"chat_id": TELEGRAM_CHAT_ID, "text": message, "parse_mode": "HTML"})


def run_health_check(base_url):
    """Executa health check em todos os servicos configurados."""
    print(f"\n[{datetime.utcnow().isoformat()}] Health Check - {base_url}")
    print("-" * 60)

    all_healthy = True
    results = []

    for service_name, path in SERVICES.items():
        result = check_endpoint(base_url, path)
        results.append(result)

        status_icon = "OK" if result["healthy"] else "FAIL"
        response_time = result.get("response_time_ms", "N/A")
        print(f"  [{status_icon}] {service_name}: {result['status']} ({response_time}ms)")

        if not result["healthy"]:
            all_healthy = False
            send_telegram_alert(
                f"<b>ALERT</b> - {service_name} is DOWN\n"
                f"URL: {result['url']}\n"
                f"Error: {result.get('error', f'HTTP {result['status']}')}"
            )

    print("-" * 60)
    print(f"  Result: {'ALL HEALTHY' if all_healthy else 'ISSUES DETECTED'}")

    return all_healthy, results


if __name__ == "__main__":
    base_url = sys.argv[1] if len(sys.argv) > 1 else "https://app.horaamiga.pt"
    healthy, _ = run_health_check(base_url)
    sys.exit(0 if healthy else 1)
