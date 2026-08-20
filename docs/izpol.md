# Gałąź `izpol` — motyw dla izpol.pl

Gałąź `izpol` = `elegant` + wszystko, czym motyw na izpol.pl różni się od
wersji wspólnej. Wdrażana jest **tylko** na izpol.pl; `elegant` zostaje
źródłem dla pozostałych sklepów. Zmiany wspólne robi się na `elegant`
i scala do `izpol` (`git merge elegant`), nigdy odwrotnie.

## Co jest izpolowe

| obszar | pliki |
|---|---|
| nagłówek „katalogowy", mega menu kolumnowe/kaskadowe | `templates/_partials/header.tpl`, `modules/ps_mainmenu/ps_mainmenu.tpl` |
| listing: szuflada filtrów, pływający pasek, większe zdjęcia | `templates/layouts/layout-left-column.tpl`, `templates/catalog/_partials/products-top.tpl`, `templates/catalog/listing/product-list.tpl`, `templates/catalog/_partials/miniatures/*` |
| karta produktu: pproperties (ilości ułamkowe), próbki, nr produktu, termin wysyłki, zakładki | `templates/catalog/product.tpl`, `templates/catalog/_partials/product-*.tpl`, `modules/wksampleproduct/` |
| koszyk i kasa pod pproperties | `templates/checkout/_partials/cart-*-product-line.tpl`, `modules/ps_shoppingcart/*` |
| wyszukiwarka AmbJoliSearch, płatność Revolut | `modules/ambjolisearch/`, `modules/revolutpayment/` |
| style i skrypty sklepu | `src/scss/custom.scss` + `src/scss/custom/`, `src/js/custom.js` + `src/js/custom/` |
| tłumaczenia motywu | `translations/*/ShopThemeGlobal.*.xlf`, `translations/*/ShopThemeCatalog.*.xlf` |

## custom.css i custom.js

Dwa dodatkowe wejścia webpacka (`webpack/webpack.vars.js`, wpis `custom`):

- `src/scss/custom.scss` → `assets/css/custom.css`. Partiale w `src/scss/custom/`
  to zwykły CSS podzielony po sekcjach (numeracja historyczna). Arkusz celowo
  **nie** jest częścią `theme.css`: tamten jest w `@layer`, ten poza warstwami,
  więc wygrywa każdą zwykłą regułę motywu bez podbijania specyficzności.
  Dodatkowe wagi Lory (`_00-fonty-lora.scss`) idą z `@fontsource/lora`, tak jak
  waga 400 w motywie — webpack kopiuje pliki do `assets/fonts` z hashem.
- `src/js/custom.js` → `assets/js/custom.js`. Każdy moduł w `src/js/custom/`
  sam sprawdza, czy na stronie ma co robić. Wejście ma własne
  `library: ThemeCustom`, bo domyślne `window.Theme` nadpisałoby eksporty motywu.

Oba pliki rejestruje rdzeń sklepu (`classes/controller/FrontController.php`,
`setMedia()`, id `theme-custom`, priorytet 1000) — to jedyna modyfikacja poza
motywem, o której trzeba pamiętać przy aktualizacji PrestaShopa.

## Łatki, które muszą przeżyć przebudowę

- `src/js/constants/selectors-map.ts`: `productItemQuantityInput` ma przyrostek
  `-disabled-by-pp` — obsługę ilości w koszyku przejmuje pproperties. Patcher
  modułu (`modules/pproperties/setup/ppsetup.php`) nakładał to samo na zbudowany
  `theme.js`; w źródle nie ginie przy `npm run build`.
- `src/js/theme.ts`: `wrapHeaderIcons()` nie tworzy kontenera ikon, gdy
  `header.tpl` już go wyrenderował (inaczej nagłówek przestawia się po
  `DOMContentLoaded`).

## Build i wdrożenie

```sh
nvm use 20            # package.json: node >= 20
npm ci && npm run build
```

Build jest odtwarzalny (ten sam commit → ten sam `theme.js`). Na sklep idą:
`templates/`, `modules/`, `translations/`, `config/theme.yml`, `assets/css/*.css`,
`assets/js/*.js`, `assets/fonts/` — bez `*.map`, `src/`, `node_modules/`.
Na izpol.pl działa CCC, więc po wdrożeniu trzeba podbić `PS_CCCCSS_VERSION`
i `PS_CCCJS_VERSION` w `ps_configuration` i wyczyścić
`var/cache/prod/{smarty,translations}`.
