/* ------------------------------------------------------------------
   4. Karta produktu — ile jeszcze zostało i zachęta na końcówkę belki

   Szablon (catalog/_partials/product-add-to-cart.tpl) renderuje pod
   przyciskiem koszyka blok .js-product-stock-hint: stan magazynowy w
   data-stock i komplet tekstów z nietkniętym %quantity%. Tutaj liczymy,
   ile zostanie po zamówieniu, i przy każdym ruchu w polu ilości
   przełączamy wariant komunikatu:

     available — „Na stanie 6,2 m — tyle maksymalnie możesz dodać”
     rest      — zostałaby końcówka krótsza niż próg (data-threshold, 3 m):
                 „Zostanie tylko 1,2 m — weź całość!” + przycisk wpisujący
                 pełny stan w pole ilości
     all       — klient bierze dokładnie tyle, ile mamy
     over      — wpisał więcej, niż jest na stanie

   Liczymy lokalnie, bez pytania serwera — tak samo jak podgląd kwoty
   w pproperties (modules/pproperties/views/js/pproperties-hummingbird.js),
   bo Hummingbird nie odświeża tych bloków po zmianie ilości.

   Trzy rzeczy, przez które ten kod wygląda, jak wygląda:
   1. Pole ilości przyjmuje przecinek (pproperties, ilości ułamkowe), więc
      każde czytanie wartości idzie przez parseQty.
   2. Formatu liczby nie zgadujemy: separator dziesiętny i jednostkę („6,2 m”)
      wyciągamy z tekstu, który policzył serwer w języku sklepu. Dzięki temu
      nie ma tu ani jednego napisu do przetłumaczenia — wszystkie idą z
      ps_translation przez data-msg-*.
   3. Blok żyje też w quickview i wraca świeży po każdym ajaxowym odświeżeniu
      karty, więc zdarzenia są delegowane na document, a element wyszukujemy
      przy każdym przeliczeniu. Podpinamy je bezwarunkowo (kilka porównań
      na zdarzenie), bo quickview wstrzykuje kartę na listingu i na stronie
      głównej, gdzie w chwili startu bloku jeszcze nie ma.
   ------------------------------------------------------------------ */

/* Ilości bywają ułamkowe (0,1 m), więc porównania idą z marginesem na błąd
   binarny — bez tego 6,2 - 6,2 potrafi wyjść ujemne i klient dostaje
   ostrzeżenie „mamy tylko 6,2 m” przy zamówieniu dokładnie na stan. */
var STOCK_EPS = 1e-6;
var stockHintBound = false;

export function parseQty(value) {
  var n = parseFloat(String(value).replace(/[\s\u00a0]/g, '').replace(',', '.'));
  return isFinite(n) ? n : NaN;
}

/* „6,2 m” → separator ',' i jednostka 'm'. Gdy stan jest całkowity („6 m”),
   separatora w tekście nie ma i pyta się o niego Intl przez język strony. */
function stockFormat(box) {
  var text = String(box.getAttribute('data-stock-text') || '');
  var para = text.match(/\d([.,])\d/);
  var separator;

  if (para) {
    separator = para[1];
  } else {
    var probka;
    try {
      probka = (1.1).toLocaleString(document.documentElement.lang || 'en');
    } catch (e) {
      probka = '1.1';
    }
    separator = probka.replace(/\d/g, '') || '.';
  }

  return {
    separator: separator,
    unit: text.replace(/^[\s\u00a0]*[\d\s\u00a0.,]+/, '').trim()
  };
}

/* Sama liczba, w formacie sklepu — tyle i tylko tyle wolno wpisać do pola
   ilości: jednostka doklejona do wartości poszłaby w formularzu jako „6,2 m”
   i koszyk dostałby śmieci zamiast liczby. */
function formatNumber(value, format) {
  /* trzy miejsca to zapas na kroki rzędu 0,05; parseFloat zbija końcowe zera,
     żeby „2” nie wychodziło jako „2,000” */
  return String(parseFloat(value.toFixed(3))).replace('.', format.separator);
}

/* Wersja do czytania — z jednostką, jak w tekście od serwera („6,2 m”). */
function formatQty(value, format) {
  var liczba = formatNumber(value, format);
  return format.unit ? liczba + ' ' + format.unit : liczba;
}

export function refreshStockHint() {
  var box = document.querySelector('.js-product-stock-hint');
  if (!box) {
    return;
  }

  var text = box.querySelector('.js-product-stock-hint-text');
  var stock = parseQty(box.getAttribute('data-stock'));
  if (!text || !isFinite(stock) || stock <= 0) {
    return;
  }

  var input = document.getElementById('quantity_wanted');
  var qty = input ? parseQty(input.value) : NaN;
  if (!isFinite(qty) || qty < 0) {
    qty = 0;
  }

  var prog = parseQty(box.getAttribute('data-threshold'));
  if (!isFinite(prog) || prog <= 0) {
    prog = 3;
  }

  var format = stockFormat(box);
  var stockText = box.getAttribute('data-stock-text') || formatQty(stock, format);
  var left = stock - qty;
  var wariant;
  var wzor;
  var ilosc = stockText;

  /* Rabat za zabranie całości liczy hummingbird_editor na pozycji koszyka.
     Gdy jest wyłączony, data-discount jest puste i lecą warianty bez obietnicy
     zniżki — komplet tekstów przychodzi z szablonu, w języku sklepu. */
  var rabat = box.getAttribute('data-discount') || '';

  function tresc(nazwa) {
    var zRabatem = rabat ? box.getAttribute('data-msg-' + nazwa + '-discount') : '';
    return zRabatem || box.getAttribute('data-msg-' + nazwa) || '';
  }

  if (left < -STOCK_EPS) {
    wariant = 'over';
    wzor = tresc('over');
  } else if (left <= STOCK_EPS) {
    wariant = 'all';
    wzor = tresc('all');
  } else if (left < prog - STOCK_EPS) {
    wariant = 'rest';
    wzor = tresc('rest');
    ilosc = formatQty(left, format);
  } else {
    wariant = 'available';
    wzor = tresc('available');
  }

  text.textContent = String(wzor || '')
    .replace('%quantity%', ilosc)
    .replace('%discount%', rabat);

  ['available', 'rest', 'all', 'over'].forEach(function (nazwa) {
    box.classList.toggle('product__stock-hint--' + nazwa, nazwa === wariant);
  });

  /* Przycisk stoi na karcie od wejścia — zamówienie całej belki ma być na
     jedno kliknięcie, bez wpisywania metrów. Znika w jedynym stanie, w którym
     nie miałby co zrobić: gdy w polu jest już cały stan. */
  var btn = box.querySelector('.js-product-stock-hint-button');
  if (btn) {
    var pokaz = (wariant !== 'all');
    btn.hidden = !pokaz;
    if (pokaz) {
      btn.textContent = String(tresc('button'))
        .replace('%quantity%', stockText)
        .replace('%discount%', rabat);
    }
  }
}

/* PrestaShop po ajaxowym odświeżeniu karty przeszczepia z odpowiedzi tylko
   trzy fragmenty bloku zakupowego: przycisk (.add), #product-availability
   i .product-minimal-quantity (themes/core.js, funkcja podmieniająca
   product_add_to_cart). Nasz blok zostaje więc ze starym data-stock i po
   zmianie wariantu pokazywałby stan poprzedniego koloru. Wyjmujemy go z tej
   samej odpowiedzi sami — HTML jest z naszego szablonu i z tego samego
   serwera, więc innerHTML nic nie wnosi ponad to, co PS wstawia obok. */
function syncStockHint(dane) {
  if (!dane || !dane.product_add_to_cart) {
    return;
  }

  var pojemnik = document.createElement('div');
  pojemnik.innerHTML = dane.product_add_to_cart;
  var nowy = pojemnik.querySelector('.js-product-stock-hint');
  var stary = document.querySelector('.js-product-stock-hint');

  if (nowy && stary) {
    stary.parentNode.replaceChild(nowy, stary);
  } else if (nowy) {
    /* wariant, który wcześniej nie miał czego pokazywać (stan zerowy,
       sprzedaż ponad stan) — blok wraca na swoje miejsce, za pole ilości */
    var gniazdo = document.querySelector('.js-product-add-to-cart .product__actions-qty-add');
    if (gniazdo && gniazdo.parentNode) {
      gniazdo.parentNode.insertBefore(nowy, gniazdo.nextSibling);
    }
  } else if (stary) {
    stary.parentNode.removeChild(stary);
  }
}

function takeWholeStock() {
  var box = document.querySelector('.js-product-stock-hint');
  var input = document.getElementById('quantity_wanted');
  if (!box || !input) {
    return;
  }

  var stock = parseQty(box.getAttribute('data-stock'));
  if (!isFinite(stock) || stock <= 0) {
    return;
  }

  input.value = formatNumber(stock, stockFormat(box));

  /* Motyw i pproperties słuchają na polu, nie na naszym przycisku — bez tych
     dwóch zdarzeń w formularzu zostałaby stara ilość, a obok stara kwota. */
  ['input', 'change'].forEach(function (nazwa) {
    input.dispatchEvent(new Event(nazwa, {bubbles: true}));
  });

  refreshStockHint();
}

export function initStockHint() {
  if (stockHintBound) {
    refreshStockHint();
    return;
  }
  stockHintBound = true;

  ['input', 'change', 'keyup', 'blur', 'pp:qtychange'].forEach(function (nazwa) {
    document.addEventListener(nazwa, function (e) {
      if (e.target && e.target.id === 'quantity_wanted') {
        window.setTimeout(refreshStockHint, 0);
      }
    }, true);
  });

  document.addEventListener('click', function (e) {
    if (!e.target || !e.target.closest) {
      return;
    }
    if (e.target.closest('.js-product-stock-hint-button')) {
      e.preventDefault();
      takeWholeStock();
      return;
    }
    /* Strzałki +/- ustawiają wartość programowo, a to nie wyzwala „input” —
       przeliczamy po oddaniu sterowania obsłudze motywu. */
    if (e.target.closest('.js-quantity-button, .quantity-button')) {
      window.setTimeout(refreshStockHint, 0);
    }
  }, true);

  /* Po ajaxowym odświeżeniu karty (zmiana wariantu, przeliczenie ilości)
     i po otwarciu quickview blok jest nowy i pokazuje wariant serwerowy. */
  if (window.prestashop && window.prestashop.on) {
    var ev = (window.Theme && window.Theme.events) || {};
    ['updatedProduct', 'quickviewOpened'].forEach(function (nazwa) {
      try {
        window.prestashop.on(ev[nazwa] || nazwa, function (dane) {
          syncStockHint(dane);
          window.setTimeout(refreshStockHint, 0);
        });
      } catch (err) {
        /* zdarzenie nieobsługiwane w tej wersji motywu */
      }
    });
  }

  refreshStockHint();
}
