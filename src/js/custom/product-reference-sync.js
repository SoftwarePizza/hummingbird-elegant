/* ------------------------------------------------------------------
   Numer produktu ("Nr produktu") a multiprodukty (zintegrowane produkty)

   Górny blok referencji (.product__reference--top) siedzi w product.tpl, poza
   fragmentami, które rdzeń przeszczepia po ajaxowym odświeżeniu karty
   (product_prices/product_add_to_cart/…). Przy zwykłej kombinacji to bez
   znaczenia — numer się nie zmienia. Ale w multiproduktach każdy kolor to
   OSOBNY produkt z własną referencją, więc po wyborze koloru numer zostawał
   stary (zgłoszenie klienta).

   Odświeżony `product_details` NIESIE nowy numer (`.js-product-reference-src`).
   Po każdym `updatedProduct` wyjmujemy go stamtąd i wpisujemy do górnego bloku
   (`.js-product-reference-top`); gdy nowy wariant nie ma numeru — chowamy blok.
   ------------------------------------------------------------------ */
export function initProductReferenceSync() {
  if (!window.prestashop || typeof window.prestashop.on !== 'function') {
    return;
  }
  var ev = (window.Theme && window.Theme.events) || {};

  function sync(dane) {
    var block = document.querySelector('.js-product-reference-block');
    if (!block || !dane || !dane.product_details) {
      return;
    }
    var box = document.createElement('div');
    box.innerHTML = dane.product_details;
    var src = box.querySelector('.js-product-reference-src');
    var ref = src ? src.textContent.trim() : '';
    var top = block.querySelector('.js-product-reference-top');

    if (ref) {
      if (top) {
        top.textContent = ref;
      }
      block.hidden = false;
    } else {
      block.hidden = true;
    }
  }

  try {
    window.prestashop.on(ev.updatedProduct || 'updatedProduct', sync);
  } catch (e) {
    /* starsza wersja rdzenia bez tego zdarzenia */
  }
}
