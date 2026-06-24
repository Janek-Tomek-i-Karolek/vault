---
id: 2026-06-24_vault_-_testy
aliases:
  - Vault - testy
  - Testy aplikacji androida na zaliczenie
tags:
  - studies/6/android
author:
  - Jan Kubów
  - Tomasz Gadziński
  - Karol Wołkowski
date: 2026-06-24
subject: Testy
subtitle: Opis testów i metodologii
title: Testy aplikacji Vault
titlepage: true
toc: true
toc-own-page: true
---

# Vault - testy

## Testowanie widgetu

- **Widget**: SingleAssetPageViewer
- **Testowane zachowanie i wygląd**:
  - Test ukrytego panelu _details_ na start
  - Test pojawiąjącego się panelu _details_ na interakcję użytkownika typu
    _drag up_
  - Test poprawnie wyświetlających się metadanych w panelu _details_
- **Mockowane dane**:
  - Nadpisana klasa **Asset**, z przesłoniętą metodą buildImage, która zwraca
    zdjęcie statyczne z assetów apliakacjiNadpisana klasa **Asset**, z
    przesłoniętą metodą buildImage, która zwraca zdjęcie statyczne z assetów
    aplikacji
  - Mock metadanych dla zdjęcia

## Testowanie rozmiaru aplikacji

### Test ogólny

![Rys. 1: Rozmiar aplikacji po zbudowaniu release build](Rozmiar-aplikacji-po-zbudowaniu-release-build-20260624122423.png)

Zbudowana wersja release w paczce `.apk` dla androida waży 53MB. Nie jest to
jednak liczba w 100% reprezentatywna, ponieważ upload do usługi _google play
store_, optymalizuje build, rozbierając paczkę na części pierwsze i dostosowuje
download size do każdego urządzenia.

Natomiast powyższa paczka jest przeznaczona na wszystkie architektury. Po
rozdzieleniu budowania dla każdej architektury osobno, rozmiary prezentują się
następująco:

| Architektura | Rozmiar |
| ------------ | ------- |
| arm          | 17MB    |
| arm64        | 19.4MB  |
| x86          | 20.9MB  |

### Test szczegółowy

> [!NOTE]
>
> Test szczegółowy z rozbiciem na paczki i składowe, został przeprowadzony za
> pomocą narzędzia dostarczonego przez _flutter framework_ - **_size analysis
> tool_**. Do analizy wykorzystany został build na najpopularniejszą
> architekturę procesora na rynku czyli arm64

![Rys. 2: Drzewo struktury projektów przedstawiające rozmiary paczek](Drzewo-struktury-projektów-przedstawiające-rozmiary-paczek-20260624125348.png)

![Rys. 3: TreeMap przedstawiający rozkład rozmiaru dla kodu napisanego przez nas](TreeMap-przedstawiający-rozkład-rozmiaru-dla-kodu-napisanego-przez-nas-20260624125441.png)

**Jak widać na rysunku 2**, największa ilość pamięci zabiera sam framework, oraz
paczki darta wspomagające framework. Paczki dodatkowe które instalowaliśmy w
ramach developmentu, nie są większe od naszego kodu. Widzimy że zależności nie
tłoczą niepotrzebnie pamięci

**Z rysunku 3**, możemy wywnioskować, że największą ilość pamięci zabiera kod do
samego UI

## Testy Jednostkowe

Przeprowadzone zostały testy jednostkowe dla serwisu komunikacji z API Immicha.
Głównym celem testów jest sprawdzenie czy serwis w prawidłowy sposób
przygotowuje żądania i odbiera odpowiedzi.

### Dodanie albumu powinno zwracać Result.ok na statusie odpowiedzi HTTP 201

Co jest sprawdzane:

- wynik powinien zwracać `AlbumResponseDTO` ze statusem wyniku Ok.
- klient API (zamockowany) powinien otrzymać dokładnie 1 zapytanie typu `POST`

_Test zakończony sukcesem_

### Usunięcie albumu powinno zwracać Result.error na statusie odpowiedzi HTTP innym niż 201

Co jest sprawdzane:

- wynik powinien zwracać typ `error` dla statusu odpowiedzi HTTP 500.

_Test zakończony sukcesem_

### Pobranie albumów powinno zwracać listę albumów na statusie odpowiedzi HTTP 200

Co jest sprawdzane:

- wynik powinien zwracać listę `AlbumResponseDTO` ze statusem wyniku Ok.
- klient API (zamockowany) powinien otrzymać dokładnie 1 zapytanie typu `GET`

_Test zakończony sukcesem_

### Podsumowanie

Wszystkie testy jednostkowe zakończyły się sukcesem, przetestowano metody `GET`
oraz `POST`, które poprawnie są wysyłane oraz odbierane przez serwis do
komunikacji z API Immicha. Oznacza to, że jeżeli sam serwer API będzię
_healthy_, to serwis obsłuży powyższe żądania i odpowiedzi prawidłowo.

## Złote testy

Za pomocą testów znanych jako złote testy (ang. *golden tests*) został
przetestowany jeden z głównych ekranów aplikacji: ekran albumów. Testy polegają
na zrobieniu kontrolowanego zrzutu ekranu aplikacji (tzw. złotego pliku), z
którym następnie porównywany jest piksel po pikselu wygląd ekranu przy
uruchomieniu testu.

### Test ekranu albumów

Głównym celem testu jest sprawdzanie, czy ekran albumów wygląda tak jak powinien
(zgodnie ze złotym plikiem) przy uruchomieniu testu. Aby zapewnić stabilne
środowisko testowe wykorzystana została wydmuszka klas umożliwiajacych
komunikację z API Immicha.

#### Tryb jasny

Co jest sprawdzane:

- wygląd ekranu albumów w trybie jasnym aplikacji

_Test zakończony sukcesem_

#### Tryb ciemny

Co jest sprawdzane:

- wygląd ekranu albumów w trybie ciemnym aplikacji

_Test zakończony sukcesem_

### Podusmowanie

Wszystkie złote testy zakończyły się sukcesem. Zapewnią one stabilność wyglądu
ekranu albumów w *potencjalnych* przyszłych wydaniach aplikacji.
