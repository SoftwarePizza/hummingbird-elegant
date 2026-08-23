{**
 * Niewidoczny odnośnik do zakładki „Wysyłka i sposoby płatności” z dołu karty
 * produktu (blok product_tabs). Wkładany do linijek o wysyłce w bloku
 * product_shipping_info — bootstrapowy `.stretched-link` rozciąga go na cały
 * kafelek, więc klikalna jest CAŁA linijka razem z ikoną. Rodzic musi mieć
 * `position: relative` (custom.css, sekcja 41).
 *
 * Sama kotwica niczego nie pokaże — panel zakładki jest `display: none`,
 * dopóki Bootstrap go nie aktywuje. Przełączenie i przewinięcie robi
 * custom.js (moduł product-tab-jump); bez JS-a zostaje nieszkodliwy skok.
 *
 * Szablon wkłada go tylko wtedy, gdy zakładka faktycznie powstaje
 * ($hbHasShippingTab) — strona CMS 1 bywa w niektórych językach pusta.
 *
 * Etykieta stoi na tym samym kluczu, co przycisk zakładki (komplet 16
 * tłumaczeń w ps_translation), żeby czytnik ekranu zapowiedział ten sam napis.
 *}
<a
  class="product__tab-jump stretched-link"
  href="#product-tab-shipping"
  data-hb-product-tab="#product-tab-shipping"
>
  <span class="visually-hidden">{l s='Delivery and payment' d='Shop.Theme.Catalog'}</span>
</a>
