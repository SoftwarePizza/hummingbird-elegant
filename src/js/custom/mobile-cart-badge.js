/* ------------------------------------------------------------------
   3. MOBILE — licznik koszyka w nagłówku po dodaniu przez ajax

   ps_shoppingcart.js po zdarzeniu 'updateCart' podmienia w nagłówku element
   `.blockcart` — a to jest blok DESKTOPOWY z modułu. Wersja mobilna jest
   wpisana ręcznie w themes/hummingbird/templates/_partials/header.tpl
   (#_mobile_ps_shoppingcart) i tej klasy nie ma, więc jej licznik zostawał
   z liczbą wyrenderowaną przez serwer aż do przeładowania strony. Widać to
   dopiero od 2026-08-17, odkąd koszyk działa ajaxem (PS_BLOCK_CART_AJAX).
   ------------------------------------------------------------------ */
export function initMobileCartBadge() {
  var holder = document.getElementById('_mobile_ps_shoppingcart');
  var ps = window.prestashop;
  if (!holder || !ps || typeof ps.on !== 'function' || holder.dataset.hbeBadgeSynced) {
    return;
  }

  var badge = holder.querySelector('.header-block__badge');
  if (!badge) {
    return;
  }

  holder.dataset.hbeBadgeSynced = '1';

  ps.on('updateCart', function (event) {
    var cart = event && event.resp && event.resp.cart;
    var count = cart && cart.products_count;
    if (count !== undefined && count !== null && count !== '') {
      badge.textContent = count;
    }
  });
}
