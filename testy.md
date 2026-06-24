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
