/**
 * custom.js — izpolowe dodatki do motywu, budowane webpackiem do
 * assets/js/custom.js (wejście `custom` w webpack/webpack.vars.js).
 *
 * Rejestruje go rdzeń — classes/controller/FrontController.php, setMedia(),
 * 'theme-custom', priorytet 1000, position bottom — więc plik ładuje się
 * jako ostatni na KAŻDEJ stronie sklepu. Każdy moduł musi sam sprawdzić,
 * czy ma co robić, i cicho wyjść, jeśli nie ma.
 * Odpowiednik dla stylów: src/scss/custom.scss → assets/css/custom.css.
 *
 * Moduły (src/js/custom/):
 *  banner-reel           nawigacja karuzeli banerów kategorii (#bonbanners)
 *  filters-drawer        filtry listingu w szufladzie z prawej (#PM_ASBlockOutput_*)
 *  mobile-cart-badge     licznik koszyka w nagłówku mobilnym po ajaxie
 *  cascade-menus         mega menu w układzie kaskadowym (.submenu--cascade)
 *  stock-hint            karta produktu — stan magazynowy przy przycisku koszyka
 *  fractional-quantity   ułamkowa ilość na karcie produktu (łata na parseInt w motywie)
 *  menu-drag-scroll      pasek menu przeciągany myszą, gdy nie mieści się w kontenerze
 *  floating-listing-bar  pływający pasek filtrów i sortowania (#js-product-list-top)
 *  back-to-top           strzałka „Wróć na górę" na środku dołu ekranu
 *  wishlist-sort         lista życzeń (blockwishlist) — sortowanie jak na listingu
 *  header-search-toggle  wyszukiwarka pod lupą w nagłówku mobilnym
 *  quantity-max          ilość nie większa niż stan (atrybut max) — karta i koszyk
 *  product-reference-sync  „Nr produktu" nadąża za kolorem multiproduktu
 *  menu-tap-feedback     menu mobilne — pozycja podświetlona do czasu zmiany strony
 *  i18n                  napisy wspólne dla powyższych
 */
import { initBannerReel } from './custom/banner-reel';
import { initFiltersDrawer } from './custom/filters-drawer';
import { initMobileCartBadge } from './custom/mobile-cart-badge';
import { initCascadeMenus } from './custom/cascade-menus';
import { initStockHint } from './custom/stock-hint';
import { initFractionalQuantity } from './custom/fractional-quantity';
import { initMenuDragScroll } from './custom/menu-drag-scroll';
import { initFloatingListingBar } from './custom/floating-listing-bar';
import { initBackToTop } from './custom/back-to-top';
import { initWishlistSort } from './custom/wishlist-sort';
import { initHeaderSearchToggle } from './custom/header-search-toggle';
import { initQuantityMax } from './custom/quantity-max';
import { initProductReferenceSync } from './custom/product-reference-sync';
import { initMenuTapFeedback } from './custom/menu-tap-feedback';

function boot() {
  initBannerReel();
  initFiltersDrawer();
  initMobileCartBadge();
  initCascadeMenus();
  initStockHint();
  initFractionalQuantity();
  initMenuDragScroll();
  initFloatingListingBar();
  initBackToTop();
  initWishlistSort();
  initHeaderSearchToggle();
  initQuantityMax();
  initMenuTapFeedback();
  initProductReferenceSync();
}

/* Plik siedzi na końcu <body>, więc listing i lewa kolumna zwykle już są
   w DOM — ruszamy od razu, żeby przebudowa kolumn zdążyła przed pierwszym
   malowaniem i strona nie mrugnęła układem. DOMContentLoaded zostaje jako
   druga próba, gdyby plik trafił kiedyś wyżej (defer, łączenie assetów);
   wszystkie funkcje same wykrywają, że już zrobiły swoje. */
boot();

if (document.readyState === 'loading') {
  document.addEventListener('DOMContentLoaded', boot);
}
