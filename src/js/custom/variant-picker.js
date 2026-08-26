/* ------------------------------------------------------------------
   Zwijany wybór koloru multiproduktu (wzór: chanel.com)

   Szablon product-variants.tpl renderuje grupę kolorów jako <details
   class="js-variant-picker"> — zwinięty wiersz z wybranym kolorem,
   rozwijana lista wszystkich. <details> działa bez tego pliku; tu jest
   tylko wygoda:

   - zamknięcie po wyborze koloru (rdzeń i tak zaraz przeszczepi cały
     blok fragmentem `product_variants`, ale domknięcie od razu skraca
     moment „lista wisi, a karta się przeładowuje"),
   - przycisk X, klik obok panelu i Escape zamykają,
   - przełącznik widoku lista/siatka; wybór trzymamy w localStorage
     i nakładamy przy każdym otwarciu, bo po ajaxie blok jest świeży,
   - po otwarciu przewijamy listę do zaznaczonego koloru,
   - podpisy przełącznika widoku (aria-label/title) — z i18n, bo w
     katalogach PrestaShopa nie ma gotowych fraz „lista"/„siatka".

   Wszystko na delegacji z document — blok wymienia się przy każdej
   zmianie kombinacji, więc nasłuchy na samych elementach by przepadały.
   ------------------------------------------------------------------ */
import { labels } from './i18n';

var VIEW_KEY = 'izpVariantPickerView';

function storedView() {
  try {
    return window.localStorage.getItem(VIEW_KEY) === 'grid' ? 'grid' : 'list';
  } catch (e) {
    return 'list';
  }
}

function rememberView(view) {
  try {
    window.localStorage.setItem(VIEW_KEY, view);
  } catch (e) {
    /* prywatne okno — trudno, widok nie przetrwa przeładowania */
  }
}

function applyView(picker, view) {
  picker.classList.toggle('variant-picker--grid', view === 'grid');
  picker.querySelectorAll('.js-variant-view').forEach(function (btn) {
    btn.setAttribute('aria-pressed', String(btn.dataset.view === view));
  });
}

function labelViewButtons(picker) {
  var t = labels();
  picker.querySelectorAll('.js-variant-view').forEach(function (btn) {
    var text = btn.dataset.view === 'grid' ? t.viewGrid : t.viewList;
    if (text && !btn.getAttribute('aria-label')) {
      btn.setAttribute('aria-label', text);
      btn.setAttribute('title', text);
    }
  });
}

export function initVariantPicker() {
  if (document.__izpVariantPicker) {
    return;
  }
  document.__izpVariantPicker = true;

  /* Otwarcie: nałóż zapamiętany widok, podpisz przyciski, przewiń do
     zaznaczonego. `toggle` nie bąbelkuje — łapiemy w fazie capture. */
  document.addEventListener('toggle', function (event) {
    var picker = event.target;
    if (!picker.classList || !picker.classList.contains('js-variant-picker') || !picker.open) {
      return;
    }
    applyView(picker, storedView());
    labelViewButtons(picker);

    var active = picker.querySelector('.variant-picker__row--active');
    if (active && typeof active.scrollIntoView === 'function') {
      active.scrollIntoView({ block: 'nearest' });
    }
  }, true);

  document.addEventListener('click', function (event) {
    var target = event.target;

    /* Przełącznik lista/siatka. */
    var viewBtn = target.closest ? target.closest('.js-variant-view') : null;
    if (viewBtn) {
      var picker = viewBtn.closest('.js-variant-picker');
      if (picker) {
        rememberView(viewBtn.dataset.view);
        applyView(picker, viewBtn.dataset.view);
      }
      return;
    }

    /* Przycisk X. */
    var closeBtn = target.closest ? target.closest('.js-variant-close') : null;
    if (closeBtn) {
      var owner = closeBtn.closest('.js-variant-picker');
      if (owner) {
        owner.open = false;
      }
      return;
    }

    /* Klik poza otwartym panelem zamyka. */
    document.querySelectorAll('.js-variant-picker[open]').forEach(function (open) {
      if (!open.contains(target)) {
        open.open = false;
      }
    });
  });

  /* Wybór koloru: domknij panel, zanim przyjedzie odświeżony fragment. */
  document.addEventListener('change', function (event) {
    var input = event.target;
    if (input.matches && input.matches('.js-variant-picker input[type="radio"]')) {
      var picker = input.closest('.js-variant-picker');
      if (picker) {
        picker.open = false;
      }
    }
  });

  document.addEventListener('keydown', function (event) {
    if (event.key !== 'Escape') {
      return;
    }
    document.querySelectorAll('.js-variant-picker[open]').forEach(function (open) {
      open.open = false;
      var toggle = open.querySelector('.variant-picker__toggle');
      if (toggle) {
        toggle.focus();
      }
    });
  });
}
