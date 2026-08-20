import { parseQty, refreshStockHint } from './stock-hint';

/* ------------------------------------------------------------------
   5. Ułamkowa ilość na karcie produktu przeżywa zdarzenie „change”

   Hummingbird ma na polu ilości własny handler:

     change -> const _ = parseInt(d.value, 10) ... d.value = _.toString()

   (assets/js/theme.js, zminifikowane). parseInt ucina część ułamkową, więc
   klient hurtowni tkanin wpisywał „4,5”, klikał obok — i zostawało 4, razem
   z ceną przeliczoną na 4 m. Bez ostrzeżenia, bez śladu. Ułamki same w sobie
   działają: strzałki +/- (obsługa pproperties) chodzą po 0,1 i koszyk
   przyjmuje 2,5 m bez zarzutu — psuje je wyłącznie ta jedna linijka.

   Nie blokujemy handlera motywu (stopPropagation w fazie przechwytywania
   zabrałoby „change” także modułom, które słuchają go przez jQuery na
   document). Zamiast tego pamiętamy wartość sprzed zmiany i po handlerze
   wpisujemy ją z powrotem. Rdzeń czyta pole dopiero po 750 ms debounce'u
   (themes/core.js, updatedProductQuantity), więc do serwera i tak idzie już
   wartość poprawiona.

   Naprawa dotyczy tylko pól, które w ogóle dopuszczają ułamki — o krok pyta
   atrybut step, wystawiany przez pproperties (0,1 dla metrów, 1 dla sztuk).
   Na produktach sprzedawanych na sztuki zachowanie motywu zostaje.
   ------------------------------------------------------------------ */

var fractionalBound = false;

export function initFractionalQuantity() {
  /* boot() leci dwa razy (od razu i na DOMContentLoaded) — listenery
     rejestrujemy raz, jak w sekcji 4. */
  if (fractionalBound) {
    return;
  }
  fractionalBound = true;

  var przedZmiana = null;

  document.addEventListener('change', function (e) {
    if (e.target && e.target.id === 'quantity_wanted') {
      przedZmiana = e.target.value;
    }
  }, true);

  document.addEventListener('change', function (e) {
    var input = e.target;
    if (!input || input.id !== 'quantity_wanted') {
      return;
    }

    var chciana = parseQty(przedZmiana);
    var teraz = parseQty(input.value);
    przedZmiana = null;

    var krok = parseQty(input.getAttribute('step'));
    if (!isFinite(krok) || krok >= 1) {
      return;
    }

    /* Wchodzimy tylko w jeden, rozpoznawalny przypadek: wpisana wartość była
       ułamkiem, a w polu została dokładnie jej część całkowita. Wszystko inne
       (dociągnięcie do minimum, pusty wpis, zmiana przez strzałki) to
       działanie motywu albo pproperties i nie ruszamy go. */
    if (!isFinite(chciana) || !isFinite(teraz) || chciana === teraz) {
      return;
    }
    if (chciana === Math.floor(chciana) || Math.floor(chciana) !== teraz) {
      return;
    }

    var min = parseQty(input.getAttribute('min'));
    if (isFinite(min) && chciana < min) {
      return;
    }

    input.value = String(chciana);
    refreshStockHint();
  }, false);

  /* Druga strona tej samej monety: pola CAŁKOWITE (step >= 1, produkty na
     sztuki). Motyw przepuszcza je przez parser, który separator wyrzuca,
     a cyfry SKLEJA — „2,5" robiło się 25 sztuk i ceną razy dziesięć. Na
     sklepie, gdzie obok kuponów leżą tkaniny zamawiane z przecinkiem, to
     pomyłka na wyciągnięcie ręki.

     W trakcie pisania zostawiamy przecinek w polu (zatrzymujemy zdarzenie
     przed handlerami motywu; inne listenery na document — pproperties
     i sekcja 4 — dostają je normalnie, bo to stopPropagation, nie
     stopImmediatePropagation), a po wyjściu z pola ucinamy część ułamkową.
     W dół, nie do najbliższej: przy „2,5 szt” klient chce raczej 2 niż 3. */
  document.addEventListener('input', function (e) {
    var input = e.target;
    if (!input || input.id !== 'quantity_wanted' || !maUlamekWPolu(input)) {
      return;
    }
    e.stopPropagation();
  }, true);

  ['change', 'blur'].forEach(function (nazwa) {
    document.addEventListener(nazwa, function (e) {
      if (e.target && e.target.id === 'quantity_wanted') {
        utnijUlamekWPoluCalkowitym(e.target);
      }
    }, true);
  });
}

/* Osobno, bo pyta o to i listener „input”, i sprzątanie na wyjściu z pola. */
function maUlamekWPolu(input) {
  var krok = parseQty(input.getAttribute('step'));
  if (!isFinite(krok) || krok < 1) {
    return false;
  }
  return /[.,]/.test(String(input.value));
}

function utnijUlamekWPoluCalkowitym(input) {
  if (!maUlamekWPolu(input)) {
    return;
  }

  var min = parseQty(input.getAttribute('min'));
  var wartosc = parseQty(input.value);
  if (!isFinite(wartosc)) {
    wartosc = isFinite(min) ? min : 1;
  }
  wartosc = Math.floor(wartosc);
  if (isFinite(min) && wartosc < min) {
    wartosc = min;
  }

  input.value = String(wartosc);

  /* Handler „input” motywu tej wartości nie widział, więc cena i blok stanu
     stoją na poprzedniej. Rdzeń i tak scali żądania (debounce 750 ms
     z abortem poprzedniego), więc dodatkowe wywołanie nic nie kosztuje. */
  if (window.prestashop && window.prestashop.emit) {
    try {
      window.prestashop.emit('updateProduct', {eventType: 'updatedProductQuantity'});
    } catch (err) {
      /* starsza wersja rdzenia bez tego zdarzenia */
    }
  }
  refreshStockHint();
}
