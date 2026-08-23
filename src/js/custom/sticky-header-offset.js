/* ------------------------------------------------------------------
   16. Rezerwa miejsca pod przyklejony nagłówek — liczona z rzeczywistości

   Motyw (src/js/helpers/scrollPadding.ts) ustawia na <html>
   `scroll-padding-top` = wysokość `.js-sticky-header` + 16 px, zakładając,
   że nagłówek jest przyklejony. Na izpolu NIE JEST: hummingbird_editor
   (front.css) daje `#header position: relative` pod overlay wyszukiwarki.
   Efekt: każda kotwica i każde `scrollIntoView` w sklepie zostawiało ~159 px
   pustki nad celem — widać to było po stronicowaniu listingu (rdzeń motywu
   przewija tam `#js-product-list-header`) i przy skoku do zakładek karty
   produktu.

   Poprawiamy SAMĄ właściwość `scroll-padding-top`. Zmienna
   `--scroll-padding-top` zostaje nietknięta, bo służy do czegoś innego —
   `top` przyklejonych podsumowań w koszyku i kasie (_cart.scss, _checkout.scss);
   podmiana ruszyłaby tamten układ przy okazji.

   Korekta jedzie w `requestAnimationFrame`, a nie prosto w uchwycie zdarzenia:
   motyw rejestruje swoje `load`/`resize` dopiero w `DOMContentLoaded`, czyli
   PÓŹNIEJ niż custom.js (ten startuje od razu, na końcu <body>), więc jego
   uchwyt wykonałby się po naszym i przywrócił starą wartość. Wszystkie uchwyty
   jednego zdarzenia lecą w tym samym zadaniu — rAF zaplanowany z któregokolwiek
   z nich wypada po wszystkich.
   ------------------------------------------------------------------ */

var HEADER = '.js-sticky-header';
var GAP = 16;

/* Ile pikseli u góry ekranu naprawdę zasłania nagłówek. Zero, dopóki nie jest
   `sticky`/`fixed` — sprawdzamy wyliczony styl, a nie klasę, bo o przyklejeniu
   decyduje CSS modułu, nie szablon. */
export function stickyHeaderHeight() {
  var header = document.querySelector(HEADER);

  if (!header) {
    return 0;
  }

  var position = window.getComputedStyle(header).position;

  return position === 'sticky' || position === 'fixed' ? header.offsetHeight : 0;
}

export function initScrollPaddingFix() {
  /* boot() z custom.js leci dwa razy (od razu i na DOMContentLoaded) — bez
     tego uchwyty wisiałyby podwójnie. */
  if (!document.querySelector(HEADER) || document.documentElement.dataset.hbScrollPadding) {
    return;
  }

  document.documentElement.dataset.hbScrollPadding = '1';

  function apply() {
    document.documentElement.style.setProperty(
      'scroll-padding-top',
      stickyHeaderHeight() + GAP + 'px',
    );
  }

  function schedule() {
    window.requestAnimationFrame(apply);
  }

  apply();
  window.addEventListener('load', schedule);
  window.addEventListener('resize', schedule);
}
