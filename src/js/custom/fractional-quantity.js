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

  if (window.prestashop && typeof window.prestashop.on === 'function') {
    window.prestashop.on('updateProduct', function () {
      var input = document.getElementById('quantity_wanted');
      iloscPrzedOdswiezeniem = input ? input.value : null;
    });

    window.prestashop.on('updatedProduct', function (dane) {
      setTimeout(function () {
        przywrocIloscPoZmianieWariantu(dane);
      }, 0);
    });
  }
}

/* ------------------------------------------------------------------
   Zmiana wariantu nie może zerować ilości

   themes/core.js po ajaxowym odświeżeniu karty robi:

     const i = parseInt(e.product_minimal_quantity, 10);
     isNaN(i) || 'updatedProductQuantity' === n || (s.attr('min', i), s.val(i));

   Na tkaninach `product_minimal_quantity` wynosi 0,1 — parseInt ucina je do
   zera, więc po każdej zmianie koloru w polu ilości zostawało „0” (razem
   z min="0"), a klient klikał „Dodaj do koszyka” na zerowej ilości. To ten
   sam parseInt, co w sekcji 5 wyżej, tylko w innym miejscu rdzenia.

   Ilość ma przeżyć zmianę kombinacji: zostaje ta, którą klient miał wpisaną,
   przycięta do minimum i do stanu nowego wariantu. Korekta leci przez
   setTimeout 0, czyli po wszystkich synchronicznych handlerach
   `updatedProduct` — w tym po przepisaniu `max` z odpowiedzi (sekcja 6) —
   więc przycinamy już do stanu nowej kombinacji, nie poprzedniej.
   ------------------------------------------------------------------ */

var iloscPrzedOdswiezeniem = null;

/* Separator dziesiętny sklepu — pole czyta się „0,5”, nie „0.5”. */
function separatorDziesietny() {
  var probka;
  try {
    probka = (1.1).toLocaleString(document.documentElement.lang || 'en');
  } catch (e) {
    probka = '1.1';
  }
  return probka.replace(/\d/g, '') || '.';
}

/* pproperties niesie w data-pp-settings ilość, z jaką karta się otwiera. */
function domyslnaIlosc() {
  var nosnik = document.querySelector('[data-pp-settings]');
  if (!nosnik) {
    return NaN;
  }
  var tekst = nosnik.getAttribute('data-pp-settings');
  if (!tekst) {
    return NaN;
  }
  try {
    var pole = document.createElement('textarea');
    pole.innerHTML = tekst;
    var ustawienia = JSON.parse(pole.value);
    return parseQty(ustawienia.default_quantity);
  } catch (e) {
    return NaN;
  }
}

function przywrocIloscPoZmianieWariantu(dane) {
  var input = document.getElementById('quantity_wanted');
  if (!input) {
    return;
  }

  /* Pola całkowite (sztuki, kupony) rdzeń obsługuje poprawnie — parseInt
     nie ma tam czego uciąć. */
  var krok = parseQty(input.getAttribute('step'));
  if (!isFinite(krok) || krok >= 1) {
    return;
  }

  var min = parseQty(dane && dane.product_minimal_quantity);
  if (isFinite(min) && min > 0) {
    input.setAttribute('min', String(min));
  } else {
    min = parseQty(input.getAttribute('min'));
  }

  /* Wchodzimy TYLKO wtedy, gdy rdzeń faktycznie zepsuł wartość. Odświeżenie
     leci również po każdej zmianie ilości (`updatedProductQuantity`) i tam
     w polu stoi to, co klient wpisał — nadpisanie zapamiętaną wartością
     cofałoby mu „2,5” do „2”. */
  var wPolu = parseQty(input.value);
  if (isFinite(wPolu) && wPolu > 0 && (!isFinite(min) || min <= 0 || wPolu >= min)) {
    return;
  }

  var chciana = parseQty(iloscPrzedOdswiezeniem);
  if (!isFinite(chciana) || chciana <= 0) {
    chciana = domyslnaIlosc();
  }
  if (!isFinite(chciana) || chciana <= 0) {
    chciana = isFinite(min) && min > 0 ? min : 1;
  }

  if (isFinite(min) && min > 0 && chciana < min) {
    chciana = min;
  }

  var max = parseQty(input.getAttribute('max'));
  if (isFinite(max) && max > 0 && chciana > max) {
    chciana = max;
  }

  if (parseQty(input.value) === chciana) {
    return;
  }

  input.value = String(parseFloat(chciana.toFixed(3))).replace('.', separatorDziesietny());

  /* Ten sam sygnał, co klik w „+1” — podgląd kwoty (pproperties) i blok stanu
     przeliczają się na nowej ilości bez pytania serwera. */
  input.dispatchEvent(new CustomEvent('pp:qtychange', {bubbles: true}));
  refreshStockHint();
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
