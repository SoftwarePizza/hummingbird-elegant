/* ------------------------------------------------------------------
   7. Pływający pasek filtrów i sortowania na listingu

   Samo przyklejenie robi CSS (sekcja 24 custom.css, position: sticky
   na #js-product-list-top.listing-bar). Tu dochodzi to, czego CSS nie
   umie:
   - klasa .is-stuck, gdy pasek naprawdę wisi (biała karta z cieniem
     zamiast przezroczystego wiersza) — sprawdzana na scroll/resize
     przez requestAnimationFrame;
   - kopia licznika („Jest 136 produktów.") nad paskiem jako
     .listing-count, bo na telefonie pasek ma być jednowierszowy,
     a licznik w nim chowa CSS;
   - odtworzenie obu rzeczy po ajaxowym sortowaniu/stronicowaniu —
     motyw podmienia wtedy cały węzeł #js-product-list-top
     (core/listing: replaceWith), więc klasa i stan giną razem z nim.

   Pasek szukamy zawsze świeżo po id, nigdy nie trzymamy referencji —
   z tego samego powodu.
   ------------------------------------------------------------------ */
export function initFloatingListingBar() {
  var products = document.getElementById('products');
  if (!products || !document.getElementById('js-product-list-top')) {
    return;
  }
  if (products.dataset.listingBar) {
    return;
  }
  products.dataset.listingBar = '1';

  function bar() {
    return document.getElementById('js-product-list-top');
  }

  /* Kopia licznika nad paskiem. Tekst jest kopiowany, nie przenoszony —
     oryginał zostaje w pasku dla desktopu, a który z nich widać, decyduje
     CSS po szerokości ekranu. */
  function syncCount(el) {
    var source = el.querySelector('.products__count');
    var copy = el.previousElementSibling;
    if (!copy || !copy.classList.contains('listing-count')) {
      copy = document.createElement('p');
      copy.className = 'listing-count';
      el.parentNode.insertBefore(copy, el);
    }
    var text = source ? source.textContent.replace(/\s+/g, ' ').trim() : '';
    if (copy.textContent.replace(/\s+/g, ' ').trim() !== text) {
      copy.textContent = text;
    }
    /* Kopię z szablonu (product-list.tpl) chowa styl inline — od tej
       chwili o widoczności decyduje CSS po szerokości ekranu. */
    copy.style.display = '';
    copy.hidden = !text;
  }

  var ticking = false;

  function syncStuck() {
    ticking = false;
    var el = bar();
    if (!el) {
      return;
    }
    /* Próg = wartość `top` ze stylu (0.5rem), żeby nie dublować liczby
       z CSS-a. Warunek na scrollY odróżnia „przyklejony u góry" od
       „strona jeszcze nieprzewinięta, a pasek akurat stoi wysoko". */
    var top = parseFloat(window.getComputedStyle(el).top) || 0;
    var stuck =
      window.scrollY > 0 && el.getBoundingClientRect().top <= top + 1;
    el.classList.toggle('is-stuck', stuck);
  }

  function requestSync() {
    if (!ticking) {
      ticking = true;
      window.requestAnimationFrame(syncStuck);
    }
  }

  function setup() {
    var el = bar();
    if (!el) {
      return;
    }
    el.classList.add('listing-bar');
    syncCount(el);
    requestSync();
  }

  setup();

  window.addEventListener('scroll', requestSync, { passive: true });
  window.addEventListener('resize', requestSync);

  if (window.MutationObserver) {
    new window.MutationObserver(setup).observe(products, {
      childList: true,
      subtree: true
    });
  }
}
