/* ------------------------------------------------------------------
   9. Lista życzeń (blockwishlist) — sortowanie jak na listingu

   Stronę /module/blockwishlist/view składa aplikacja Vue modułu, a jej
   przycisk „Sortuj po:" ma data-toggle="dropdown" z Bootstrapa 4 — Bootstrap 5
   z motywu tego nie obsługuje, więc menu nigdy się nie otwierało. Dokładamy
   data-bs-toggle (BS5 nasłuchuje na dokumencie, więc działa też dla
   elementów dodanych później) i klasy przycisku sortowania z listingu.
   Vue nie rusza atrybutów, których sam nie wiąże, ale po zmianie sortowania
   potrafi przebudować nagłówek — stąd obserwator. Pilnuje #wrapper, nie
   samego kontenera: Vue przy montowaniu PODMIENIA serwerowy
   <div class="wishlist-products-container"> na własny element, więc
   uchwyt złapany przed montażem wskazywałby odpięty węzeł.
   Wygląd: sekcja 26 custom.css.
   ------------------------------------------------------------------ */
export function initWishlistSort() {
  var scope = document.getElementById('wrapper') || document.body;
  if (!scope.querySelector('.wishlist-products-container') || scope.dataset.wishlistSortPatched) {
    return;
  }
  scope.dataset.wishlistSortPatched = '1';

  function patch() {
    var root = scope.querySelector('.wishlist-products-container');
    var button = root && root.querySelector('.products-sort-order .select-title');
    if (!button) {
      return;
    }
    if (!button.hasAttribute('data-bs-toggle')) {
      button.setAttribute('data-bs-toggle', 'dropdown');
      button.setAttribute('data-bs-display', 'static');
      button.classList.add('btn', 'btn-outline-tertiary', 'dropdown-toggle', 'products__sort-dropdown-button');
      button.classList.remove('btn-unstyle');
    }
    var menu = root.querySelector('.products-sort-order .dropdown-menu');
    if (menu) {
      menu.classList.add('dropdown-menu-end');
      menu.querySelectorAll('.select-list:not(.dropdown-item)').forEach(function (item) {
        item.classList.add('dropdown-item');
        item.setAttribute('role', 'menuitem');
      });
    }
  }

  patch();
  new MutationObserver(patch).observe(scope, { childList: true, subtree: true });
}
