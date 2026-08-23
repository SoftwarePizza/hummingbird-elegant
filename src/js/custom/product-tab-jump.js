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

    link.addEventListener('click', function (event) {
      event.preventDefault();

      if (!tab.classList.contains('active')) {
        tab.click();
      }

      /* Przewijamy do PASKA zakładek, nie do panelu: pasek jest tuż nad
         treścią, więc po zatrzymaniu widać i wybraną zakładkę, i początek
         tekstu. Odstęp od górnej krawędzi daje scroll-margin w custom.css. */
      var nav = tab.closest('.nav') || tab;
      nav.scrollIntoView({ behavior: behavior(), block: 'start' });

      /* Fokus na przycisku zakładki — klawiatura i czytnik ekranu lądują
         tam, gdzie treść, a nie zostają przy bloku zakupowym. preventScroll,
         żeby nie przerwać płynnego przewijania powyżej. */
      tab.focus({ preventScroll: true });
    });
  });
}
