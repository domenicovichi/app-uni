# UniApp

App social universitaria per Tor Vergata

## Prerequisiti

Prima di iniziare, assicurati di avere installato:

- [Git](https://git-scm.com/downloads)
- [Flutter](https://flutter.dev/docs/get-started/install)
- Un IDE (consigliato Visual Studio Code o Android Studio)

## Setup del Progetto

1. Clona il repository:
```bash
git clone https://github.com/domenicovichi/app-uni.git
```

2. Entra nella directory del progetto:
```bash
cd app-uni
```

3. Installa le dipendenze:
```bash
flutter pub get
```

4. Avvia l'applicazione:
```bash
flutter run -d chrome
```

## Funzionalità

L'app include le seguenti funzionalità:

- **Spotted**: Pubblica e leggi messaggi anonimi
- **Eventi**: Organizza e partecipa a eventi universitari
- **Libri**: Marketplace per la compravendita di libri universitari
- **Ripetizioni**: Trova o offri ripetizioni per le materie universitarie

## Struttura del Progetto

- `lib/models/`: Contiene i modelli dei dati
- `lib/screens/`: Contiene le schermate dell'applicazione
- `lib/services/`: Contiene i servizi per la gestione dei dati
- `lib/widgets/`: Contiene i widget riutilizzabili

## Note per lo Sviluppo

- L'app utilizza un mock database per la persistenza dei dati
- Per il momento, l'autenticazione è simulata
