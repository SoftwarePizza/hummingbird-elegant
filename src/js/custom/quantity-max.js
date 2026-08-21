/* ------------------------------------------------------------------
   10. Ilość nie większa niż stan — karta produktu i koszyk

   Koszyk przyjmował 50 m przy 6,2 m na belce: rdzeń zapisuje ilość, a o
   braku mówi dopiero w kasie. Teraz pole ilości niesie atrybut `max`
   (szablony catalog/_partials/product-add-to-cart.tpl i
   checkout/_partials/cart-detailed-product-line.tpl renderują go, gdy
   produkt nie może iść ponad stan) i wszystko, co przekracza `max`, od
   razu wraca na `max` — wpis z klawiatury, strzałki, przyciski +/- i +1.
   Klient widzi dymek nad polem z tekstem z data-max-message („Mamy na
   stanie tylko 6,2 m" — ten sam klucz tłumaczenia, co wariant „over"
   bloku stanu ze stock-hint) i przyciski „+" przygaszone na maksimum.

   Druga warstwa jest na serwerze: override/controllers/front/
   CartController.php przycina żądanie niezależnie od tego JS-a i zwraca
   w JSON-ie `quantity_clamped` — gdy stan zmienił się po załadowaniu
   strony, dymek pokazujemy z tekstu, który przyszedł z serwera.

   Jak to gra z resztą pola:
   - motyw (pola całkowite) i pproperties-hummingbird.js (ułamkowe)
     ustawiają wartość w swoich handlerach; my liczymy PO nich
     (setTimeout 0), więc nie zależymy od kolejności rejestracji;
   - po przycięciu puszczamy na polu „input" i „change" — tak samo jak
     przycisk „Weź całość": od tego zależy przeliczenie ceny na karcie,
     blok stanu i (w koszyku) zaplanowana aktualizacja pozycji;
   - „+" z pproperties wysyła własne zdarzenie pp:qtychange, bo zmiana
     wartości skryptem nie wyzwala „input";
   - po ajaxowym odświeżeniu koszyka (core.js podmienia cały .cart-overview)
     pola są nowe — stan „na maksimum" i ewentualny dymek odtwarzamy
     w „updatedCart"; po zmianie wariantu na karcie (`updatedProduct`)
     przepisujemy `max` z HTML-a odpowiedzi, bo rdzeń tego pola nie podmienia.

   Moduł jest samowystarczalny (własne parseQty/formatNumber/STOCK_EPS),
   żeby nie wiązać go ze stock-hint — limit do stanu działa też tam, gdzie
   bloku stanu nie ma (np. koszyk).
   ------------------------------------------------------------------ */

var STOCK_EPS = 1e-6;
var QTY_MAX_SELECTOR = '#quantity_wanted, .js-cart-line-product-quantity';
var QTY_BUBBLE_MS = 5000;
var qtyMaxBound = false;
var serverClamp = null;        /* {id_cart_product, id_product, message, until} */
var autoFixedIcp = {};         /* pozycje koszyka poprawione przy wejściu */

function parseQty(value) {
  var n = parseFloat(String(value).replace(/[\s ]/g, '').replace(',', '.'));
  return isFinite(n) ? n : NaN;
}

/* Sama liczba w formacie sklepu — jednostka doklejona do wartości pola
   poszłaby w formularzu jako „6,2 m". Trzy miejsca to zapas na kroki rzędu
   0,05; parseFloat zbija końcowe zera. */
function formatNumber(value, separator) {
  return String(parseFloat(value.toFixed(3))).replace('.', separator || '.');
}

function qtyMaxInput(el) {
  return el && el.matches && el.matches(QTY_MAX_SELECTOR) ? el : null;
}

function qtyMaxOf(input) {
  var m = parseQty(input.getAttribute('max'));
  return isFinite(m) && m > 0 ? m : NaN;
}

function qtyGroupOf(input) {
  return input.closest('.quantity-button__group') || input.parentNode;
}

function qtyWrapperOf(input) {
  return input.closest('.js-quantity-button, .quantity-button') || qtyGroupOf(input);
}

/* Separator dziesiętny do WPISANIA w pole: z tekstu komunikatu („6,2 m"),
   a gdy stan jest całkowity — z języka strony. */
function qtySeparator(input) {
  var para = String(input.getAttribute('data-max-message') || '').match(/\d([.,])\d/);
  if (para) {
    return para[1];
  }
  try {
    return (1.1).toLocaleString(document.documentElement.lang || 'en').replace(/\d/g, '') || '.';
  } catch (e) {
    return '.';
  }
}

function qtyIsFractional(input) {
  var krok = parseQty(input.getAttribute('step'));
  return isFinite(krok) && krok > 0 && krok < 1;
}

function syncQtyMaxState(input) {
  var group = qtyGroupOf(input);
  if (!group) {
    return;
  }
  var max = qtyMaxOf(input);
  var v = parseQty(input.value);
  var atMax = isFinite(max) && isFinite(v) && v >= max - STOCK_EPS;
  group.classList.toggle('is-at-max', atMax);
  var plusy = group.querySelectorAll('.js-increment-button, [data-action="increment"]');
  Array.prototype.forEach.call(plusy, function (btn) {
    if (atMax) {
      btn.setAttribute('aria-disabled', 'true');
    } else {
      btn.removeAttribute('aria-disabled');
    }
  });
}

function showQtyBubble(input, message, ms) {
  var wrapper = qtyWrapperOf(input);
  if (!wrapper || !message) {
    return;
  }
  var bubble = wrapper.querySelector('.qty-max-bubble');
  if (!bubble) {
    bubble = document.createElement('div');
    bubble.className = 'qty-max-bubble';
    bubble.setAttribute('role', 'status');
    bubble.setAttribute('aria-live', 'polite');
    bubble.innerHTML = '<i class="material-icons qty-max-bubble__icon" aria-hidden="true">&#xE88E;</i><span class="qty-max-bubble__text"></span>';
    wrapper.appendChild(bubble);
  }
  bubble.querySelector('.qty-max-bubble__text').textContent = message;
  if (bubble._timer) {
    window.clearTimeout(bubble._timer);
  }
  /* ponowne pokazanie przy tym samym tekście ma mrugnąć — reflow resetuje animację */
  bubble.classList.remove('is-visible');
  void bubble.offsetWidth;
  bubble.classList.add('is-visible');
  bubble._timer = window.setTimeout(function () {
    bubble.classList.remove('is-visible');
  }, ms || QTY_BUBBLE_MS);
}

/* Zwraca true, gdy wartość trzeba było przyciąć. */
function clampQtyToMax(input, opts) {
  opts = opts || {};
  var max = qtyMaxOf(input);
  var v = parseQty(input.value);
  if (!isFinite(max) || !isFinite(v) || v <= max + STOCK_EPS) {
    syncQtyMaxState(input);
    return false;
  }

  input.value = formatNumber(max, qtySeparator(input));
  syncQtyMaxState(input);

  if (opts.silent !== true) {
    showQtyBubble(input, input.getAttribute('data-max-message'), QTY_BUBBLE_MS);
  }
  if (opts.notify !== false) {
    ['input', 'change'].forEach(function (nazwa) {
      input.dispatchEvent(new Event(nazwa, { bubbles: true }));
    });
  }
  return true;
}

/* Pozycja koszyka wczytana już z nadmiarem (stan spadł, gdy koszyk leżał):
   poprawiamy ją i wysyłamy aktualizację tak, jak zrobiłby to klient —
   pole ułamkowe aktualizuje pproperties po „blur", całkowite motyw po
   Enterze. Raz na pozycję, żeby odświeżenie koszyka nie zapętliło. */
function autoFixCartLine(input) {
  var line = input.closest('[data-icp]');
  var icp = line ? line.getAttribute('data-icp') : input.getAttribute('data-product-id');
  if (!icp || autoFixedIcp[icp]) {
    return;
  }
  if (!clampQtyToMax(input, { notify: false })) {
    return;
  }
  autoFixedIcp[icp] = true;
  if (qtyIsFractional(input)) {
    input.dispatchEvent(new Event('blur', { bubbles: false }));
  } else {
    input.dispatchEvent(new KeyboardEvent('keyup', { key: 'Enter', bubbles: true }));
  }
}

function syncAllQtyMax(autoFix) {
  var pola = document.querySelectorAll(QTY_MAX_SELECTOR);
  Array.prototype.forEach.call(pola, function (input) {
    if (autoFix && input.hasAttribute('data-update-url')) {
      autoFixCartLine(input);
    } else if (input.id === 'quantity_wanted') {
      clampQtyToMax(input);
    }
    syncQtyMaxState(input);
  });
}

/* Po zmianie wariantu rdzeń podmienia tylko .add, #product-availability
   i .product-minimal-quantity — `max` zostałby ze starego koloru. */
function syncQtyMaxFromProductRefresh(dane) {
  if (!dane || !dane.product_add_to_cart) {
    return;
  }
  var input = document.getElementById('quantity_wanted');
  if (!input) {
    return;
  }
  var pojemnik = document.createElement('div');
  pojemnik.innerHTML = dane.product_add_to_cart;
  var nowy = pojemnik.querySelector('#quantity_wanted');
  if (!nowy) {
    return;
  }
  ['max', 'data-max-message'].forEach(function (attr) {
    if (nowy.hasAttribute(attr)) {
      input.setAttribute(attr, nowy.getAttribute(attr));
    } else {
      input.removeAttribute(attr);
    }
  });
  clampQtyToMax(input);
}

function findClampedInput(info) {
  if (!info) {
    return null;
  }
  var input = null;
  if (info.id_cart_product) {
    var line = document.querySelector('[data-icp="' + info.id_cart_product + '"]');
    input = line ? line.querySelector('.js-cart-line-product-quantity') : null;
  }
  if (!input) {
    /* karta produktu (dodanie do koszyka przycięte po stronie serwera) */
    input = document.getElementById('quantity_wanted');
    var idNaKarcie = document.getElementById('product_page_product_id');
    if (input && info.id_product && idNaKarcie && String(idNaKarcie.value) !== String(info.id_product)) {
      input = null;
    }
  }
  return input;
}

function showServerClamp() {
  if (!serverClamp || Date.now() > serverClamp.until) {
    serverClamp = null;
    return;
  }
  var input = findClampedInput(serverClamp);
  if (input) {
    showQtyBubble(input, serverClamp.message, QTY_BUBBLE_MS + 1000);
    syncQtyMaxState(input);
  }
}

export function initQuantityMax() {
  if (qtyMaxBound) {
    syncAllQtyMax(true);
    return;
  }
  qtyMaxBound = true;

  ['input', 'change', 'blur', 'pp:qtychange'].forEach(function (nazwa) {
    document.addEventListener(nazwa, function (e) {
      var input = qtyMaxInput(e.target);
      if (input) {
        window.setTimeout(function () { clampQtyToMax(input); }, 0);
      }
    }, true);
  });

  /* Strzałki i przyciski ustawiają wartość skryptem — bez „input". */
  document.addEventListener('keydown', function (e) {
    var input = qtyMaxInput(e.target);
    if (input && (e.key === 'ArrowUp' || e.key === 'ArrowDown')) {
      window.setTimeout(function () { clampQtyToMax(input); }, 0);
    }
  }, true);

  document.addEventListener('click', function (e) {
    var btn = e.target && e.target.closest ? e.target.closest('.quantity-button__group button') : null;
    if (!btn) {
      return;
    }
    var input = btn.closest('.quantity-button__group').querySelector('input');
    if (qtyMaxInput(input)) {
      window.setTimeout(function () { clampQtyToMax(input); }, 0);
    }
  }, true);

  if (window.prestashop && window.prestashop.on) {
    var ev = (window.Theme && window.Theme.events) || {};
    try {
      window.prestashop.on(ev.updateCart || 'updateCart', function (dane) {
        var info = dane && dane.resp && dane.resp.quantity_clamped;
        if (info && info.message) {
          serverClamp = {
            id_cart_product: info.id_cart_product,
            id_product: info.id_product,
            message: info.message,
            until: Date.now() + 15000
          };
          showServerClamp();
        }
      });
      window.prestashop.on(ev.updatedCart || 'updatedCart', function () {
        syncAllQtyMax(true);
        showServerClamp();
      });
      ['updatedProduct', 'quickviewOpened'].forEach(function (nazwa) {
        window.prestashop.on(ev[nazwa] || nazwa, function (dane) {
          syncQtyMaxFromProductRefresh(dane);
          window.setTimeout(function () { syncAllQtyMax(false); }, 0);
        });
      });
    } catch (err) {
      /* starsza wersja rdzenia bez tych zdarzeń */
    }
  }

  syncAllQtyMax(true);
}
