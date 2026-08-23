import { behavior } from './i18n';

/* ------------------------------------------------------------------
   15. Karta produktu — linijki o wysyłce prowadzą do zakładki

   Blok pod przyciskiem koszyka („Zamów dzisiaj…” i „Darmowa dostawa od…”)
   ma w środku rozciągnięty odnośnik `[data-hb-product-tab]` wskazujący panel
   zakładki na dole karty. Kliknięcie przełącza tę zakładkę i przewija do
   niej — sama kotwica by nie wystarczyła, bo panel jest `display: none`,
   dopóki Bootstrap go nie pokaże.

   Zakładkę pokazujemy KLIKAJĄC jej przycisk, a nie tworząc `bootstrap.Tab`:
   motyw nie wystawia Bootstrapa w `window`, ale jego delegowany handler
   `[data-bs-toggle="tab"]` siedzi w theme.js i łapie zwykły click.

   Wygląd: custom.css sekcja 41.
   ------------------------------------------------------------------ */
export function initProductTabJump() {
  var links = document.querySelectorAll('[data-hb-product-tab]');

  if (!links.length) {
    return;
  }

  Array.prototype.forEach.call(links, function (link) {
    if (link.dataset.hbTabBound) {
      return;
    }

    var target = link.getAttribute('data-hb-product-tab');
    var tab = target
      ? document.querySelector('[data-bs-toggle="tab"][data-bs-target="' + target + '"]')
      : null;

    /* Zakładki nie ma (pusta strona CMS w tym języku) — nie podpinamy się,
       niech kotwica zostanie zwykłą kotwicą. Szablon i tak w tej sytuacji
       odnośnika nie renderuje; to zapas na wypadek nadpisania szablonu. */
    if (!tab) {
      return;
    }

    link.dataset.hbTabBound = '1';

    /* Przewijamy do PASKA zakładek, nie do panelu: pasek jest tuż nad treścią,
       więc po zatrzymaniu widać i wybraną zakładkę, i początek tekstu.

       Cel liczymy sami, zamiast wołać scrollIntoView. Motyw ustawia
       `scroll-padding-top` na wysokość nagłówka (helpers/scrollPadding.ts),
       a nagłówek izpola nie jest przyklejony (`.js-sticky-header` ma
       `position: relative`) — pasek lądowałby wtedy 175 px od góry, za
       ścianą pustego miejsca. Rezerwę bierzemy z rzeczywistego stanu
       nagłówka: 0, dopóki nie jest sticky/fixed. */
    function jump() {
      var nav = tab.closest('.nav') || tab;
      var header = document.querySelector('.js-sticky-header');
      var position = header ? window.getComputedStyle(header).position : '';
      var reserved = position === 'sticky' || position === 'fixed' ? header.offsetHeight : 0;
      var top = nav.getBoundingClientRect().top + window.scrollY - reserved - 16;

      window.scrollTo({ top: Math.max(top, 0), behavior: behavior() });

      /* Fokus na przycisku zakładki — klawiatura i czytnik ekranu lądują tam,
         gdzie treść, a nie zostają przy bloku zakupowym. preventScroll, żeby
         nie przerwać płynnego przewijania powyżej. */
      tab.focus({ preventScroll: true });
    }

    link.addEventListener('click', function (event) {
      event.preventDefault();

      if (tab.classList.contains('active')) {
        jump();

        return;
      }

      /* Przewijanie MUSI poczekać na `shown.bs.tab`. Bootstrap przełącza panele
         przez 150 ms przenikania i w połowie tej animacji żaden nie jest
         `active` — dokument kurczy się wtedy o całą wysokość opisu, przeglądarka
         przycina płynne przewijanie do nowego maksimum i już go nie wznawia.
         Bez tego pasek zatrzymywał się 175 px od góry zamiast 16 px.
         Zapasowy timer na wypadek, gdyby zdarzenie nie doszło (inna wersja
         Bootstrapa, wyłączone przejścia). */
      var done = false;

      function once() {
        if (done) {
          return;
        }
        done = true;
        jump();
      }

      tab.addEventListener('shown.bs.tab', once, { once: true });
      window.setTimeout(once, 400);
      tab.click();
    });
  });
}
