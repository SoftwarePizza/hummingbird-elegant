/* ------------------------------------------------------------------
   11. Menu mobilne — pozycja podświetlona do czasu zmiany strony

   Samo `:active` gaśnie w chwili puszczenia palca, a na wejście nowej
   strony czeka się na telefonie ułamek sekundy do kilku sekund. Klient
   przez ten czas patrzył na menu bez śladu po swoim tapnięciu i tapał
   drugi raz. Tutaj po kliknięciu linku, który faktycznie prowadzi na
   inną stronę, zostaje na nim `data-ps-state="loading"` — tło i kręcące
   się kółko przy etykiecie (custom.css, sekcja 35) — aż przeglądarka
   zacznie rysować nową stronę.

   Trzy rzeczy, o które trzeba tu zadbać:

   - „Kliknięcie" to nie zawsze nawigacja. Pomijamy linki otwierane
     w nowej karcie, kotwice (`#`), `tel:`/`mailto:`, kliknięcia
     z Ctrl/Cmd/Shift/środkowym przyciskiem i takie, którym coś wcześniej
     zdążyło zabrać domyślne działanie (`defaultPrevented`) — inaczej
     podświetlenie zostawałoby na pozycji, po której nic się nie dzieje.
     Przycisk rozwijania podmenu to `<button>`, więc sam z siebie tu nie
     wpada; jego reakcja to samo `:active`.

   - Powrót „wstecz" wyjmuje stronę z bfcache w stanie, w jakim ją
     zostawiliśmy — z podświetloną pozycją i kręcącym się kółkiem.
     Dlatego sprzątamy w `pageshow` (`persisted`) i przy zamknięciu
     szuflady.

   - Gdyby nawigacja nie ruszyła (brak sieci, przerwane żądanie),
     podświetlenie znika samo po WATCHDOG_MS, żeby nie zostawiać menu
     w stanie wiecznego ładowania.

   Wiązanie idzie przez delegację na szufladzie i po semantyce HTML
   (`a[href]`), nie po klasach stylowych — panele podmenu są w DOM-ie od
   początku, a moduł nie musi wiedzieć, ile ich jest.
   ------------------------------------------------------------------ */

var MENU_CANVAS_SELECTOR = '#mobileMenu';
var LOADING_ATTR = 'data-ps-state';
var LOADING_VALUE = 'loading';
var WATCHDOG_MS = 8000;

var watchdogTimer = null;

/** Zdejmuje podświetlenie ze wszystkiego, co je jeszcze ma. */
function clearLoading(canvas) {
  var marked = canvas.querySelectorAll('[' + LOADING_ATTR + '="' + LOADING_VALUE + '"]');

  for (var i = 0; i < marked.length; i += 1) {
    marked[i].removeAttribute(LOADING_ATTR);
  }

  if (watchdogTimer) {
    window.clearTimeout(watchdogTimer);
    watchdogTimer = null;
  }
}

/**
 * Czy to kliknięcie faktycznie zabiera klienta na inną stronę?
 * Wszystkie „nie" oznaczają, że podświetlenia nie zapalamy wcale.
 */
function isNavigatingClick(event, link) {
  if (event.defaultPrevented || event.button !== 0) {
    return false;
  }

  if (event.ctrlKey || event.metaKey || event.shiftKey || event.altKey) {
    return false;
  }

  if (link.target && link.target !== '_self') {
    return false;
  }

  var href = link.getAttribute('href');

  if (!href || href.charAt(0) === '#') {
    return false;
  }

  // tel: i mailto: przekazują sprawę innej aplikacji — strona zostaje ta sama.
  if (/^(?:tel|mailto|sms|javascript):/i.test(href)) {
    return false;
  }

  // Kotwica w obrębie tej samej strony (pełny adres z #) też nie nawiguje.
  if (link.hash && link.pathname === window.location.pathname && link.search === window.location.search) {
    return false;
  }

  return true;
}

export function initMenuTapFeedback() {
  var canvas = document.querySelector(MENU_CANVAS_SELECTOR);

  if (!canvas || canvas.dataset.tapFeedbackReady === '1') {
    return;
  }

  canvas.dataset.tapFeedbackReady = '1';

  canvas.addEventListener('click', function (event) {
    var link = event.target.closest ? event.target.closest('a[href]') : null;

    if (!link || !canvas.contains(link) || !isNavigatingClick(event, link)) {
      return;
    }

    clearLoading(canvas);
    link.setAttribute(LOADING_ATTR, LOADING_VALUE);

    watchdogTimer = window.setTimeout(function () {
      clearLoading(canvas);
    }, WATCHDOG_MS);
  });

  // Powrót z bfcache: strona wraca dokładnie taka, jaką ją zostawiliśmy.
  window.addEventListener('pageshow', function (event) {
    if (event.persisted) {
      clearLoading(canvas);
    }
  });

  // Zamknięcie szuflady bez przechodzenia dalej (krzyżyk, tło, Esc).
  canvas.addEventListener('hidden.bs.offcanvas', function () {
    clearLoading(canvas);
  });
}
