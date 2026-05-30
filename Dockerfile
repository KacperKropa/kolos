FROM python:3.12-slim

# Dobre praktyki dla Pythona
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*


# Tworzymy użytkownika i folder na bazę danych z odpowiednimi uprawnieniami
RUN useradd -m appuser && \
    mkdir -p /data && \
    chown appuser:appuser /data

WORKDIR /app

# Najpierw instalujemy zależności (optymalizacja cache)
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Kopiujemy kod aplikacji
COPY --chown=appuser:appuser . .

# Przełączamy na bezpiecznego użytkownika
USER appuser

# Zgodnie z poleceniem aplikacja słucha na 8000
EXPOSE 8000

# Komenda uruchamiająca serwer z pliku README
CMD ["gunicorn", "-b", "0.0.0.0:8000", "app.main:app"]