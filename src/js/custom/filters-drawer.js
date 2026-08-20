import { labels } from './i18n';

/* ------------------------------------------------------------------
   2. Filtry listingu w szufladzie z prawej

   Blok filtrów pm_advancedsearch4 razem z resztą lewej kolumny jedzie do
   offcanvasu Bootstrapa doklejonego do <body>, a nad listingiem zostaje
   przycisk „Filtry". Listing przejmuje całą szerokość — klasa
   `has-filters-drawer` na <body> włącza układ z sekcji 6 i 7 custom.css.
   Bez JS-a nic się nie dzieje i strona zostaje z klasyczną lewą kolumną,
   więc filtry są osiągalne zawsze.

   Trzy rzeczy, o które trzeba tu dbać:
   - motyw po każdym filtrowaniu podmienia #js-product-list-top na świeży
     HTML z ajaxa i zabiera ze sobą przycisk — dlatego obserwator wstawia
     ten sam węzeł z powrotem;
   - moduł filtrów podmienia swój własny blok (`replaceWith`), więc nic,
     co ma przetrwać filtrowanie, nie może na nim wisieć;
   - to moduł, a nie szuflada, decyduje, kiedy listing się zmienia:
     przy search_method 2/4 dopiero jego przycisk „Szukaj" wysyła formularz
     z produktami, więc stopka szuflady klika ten właśnie przycisk.
   ------------------------------------------------------------------ */
export function initFiltersDrawer() {
  if (document.getElementById('filtersDrawer')) {
    return;
  }

  var left = document.getElementById('left-column');
  var block = left && left.querySelector('.PM_ASBlockOutput');
  var listTop = document.getElementById('js-product-list-top');
  if (!left || !block || !listTop) {
    /* Klasę mógł już nadać serwer (layouts/layout-left-column.tpl), żeby
       układ nie mrugał przed tym skryptem. Bez szuflady musi zniknąć,
       inaczej lewa kolumna zostałaby schowana bez zastępstwa. */
    document.body.classList.remove('has-filters-drawer');
    return;
  }

  var t = labels();
  var filtersLabel = t.filters;

  /* Przycisk „Filtry" renderuje już szablon (products-top.tpl). Przejmujemy
     ten węzeł zamiast tworzyć drugi — a jego napis jest tłumaczeniem
     z motywu, więc tytuł szuflady bierze ten sam tekst. (style.display
     czyścimy na wypadek starszego szablonu, który chował go inline.) */
  var button = listTop.querySelector('.filters-toggle');
  if (button) {
    button.style.display = '';
    var served = button.querySelector('span');
    if (served && served.textContent.trim()) {
      filtersLabel = served.textContent.trim();
    }
  }

  function el(tag, className) {
    var node = document.createElement(tag);
    if (className) {
      node.className = className;
    }
    return node;
  }

  var drawer = el('div', 'offcanvas offcanvas-end filters-drawer');
  drawer.id = 'filtersDrawer';
  drawer.tabIndex = -1;
  drawer.setAttribute('aria-labelledby', 'filtersDrawerTitle');

  var head = el('div', 'offcanvas-header');
  var title = el('span', 'offcanvas-title h5');
  title.id = 'filtersDrawerTitle';
  title.textContent = filtersLabel;
  /* Ten sam przycisk zamykania co w offcanvasie menu mobilnego motywu. */
  var close = el('button', 'btn-close btn text-reset');
  close.type = 'button';
  close.setAttribute('data-bs-dismiss', 'offcanvas');
  close.setAttribute('aria-label', t.close);
  head.appendChild(title);
  head.appendChild(close);

  var body = el('div', 'offcanvas-body');

  var foot = el('div', 'filters-drawer__foot');
  var done = el('button', 'btn btn-primary w-100');
  done.type = 'button';
  foot.appendChild(done);

  /* Moduł jest ustawiony na „szukanie po kliknięciu przycisku" (search_method
     4): zaznaczenie kryterium odświeża sam blok filtrów, a listing zmienia
     się dopiero po modułowym „Szukaj" — i to przeładowaniem strony pod adres
     wyników. Stopka szuflady musi więc BYĆ tym przyciskiem; zwykłe „zamknij"
     wypuszczało użytkownika z filtrami, których nikt nie zastosował.

     Klikamy oryginał zamiast przenosić go do stopki, bo moduł ma na nim
     delegowany handler (`$(document).on('click', '.PM_ASSubmitSearch')`
     w as4_plugin-17.js), który wysyła `$(this).parents('form')` — poza
     formularzem przycisk przestałby cokolwiek robić. Szukamy go dopiero
     w chwili kliknięcia, bo moduł po każdej zmianie kryterium podmienia cały
     blok na nowy węzeł. Sam oryginał chowa CSS (sekcja 7). */
  function moduleSubmit() {
    return body.querySelector('.PM_ASSubmitSearch');
  }

  function syncSubmit() {
    var submit = moduleSubmit();
    var caption = submit && (submit.value || submit.textContent || '').trim();
    /* Napis bierzemy z modułu, żeby stopka mówiła to samo co przycisk, który
       naprawdę odpala wyszukiwanie — z jego tłumaczeniem włącznie. */
    done.textContent = caption || t.showProducts;
    /* Konfiguracja „szukaj od razu po zaznaczeniu" nie renderuje przycisku
       w ogóle — wtedy stopka zostaje zwykłym „zamknij". */
    if (submit) {
      done.removeAttribute('data-bs-dismiss');
    } else {
      done.setAttribute('data-bs-dismiss', 'offcanvas');
    }
  }

  function busy(state) {
    done.disabled = state;
    done.classList.toggle('is-busy', state);
  }

  done.addEventListener('click', function () {
    var submit = moduleSubmit();
    if (!submit) {
      return; // data-bs-dismiss zamyka szufladę
    }
    /* Wyszukiwanie potrafi trwać kilka sekund i kończy się przeładowaniem
       strony — bez blokady przycisk wygląda na martwy i łapie drugi klik.
       Timer jest bezpiecznikiem na wypadek, gdyby ajax nie wrócił; przy
       udanym wyszukiwaniu ginie razem ze stroną. Zdarzenie pageshow łapie
       powrót „wstecz" z bfcache, gdzie wróciłby zablokowany przycisk. */
    busy(true);
    window.setTimeout(function () {
      busy(false);
    }, 15000);
    submit.click();
  });

  window.addEventListener('pageshow', function () {
    busy(false);
  });

  drawer.appendChild(head);
  drawer.appendChild(body);
  drawer.appendChild(foot);
  document.body.appendChild(drawer);

  /* Filtry na górę, reszta lewej kolumny (drzewo kategorii, blok ulubionych)
     pod nimi — nic nie znika, a listing dostaje pełną szerokość. */
  body.appendChild(block);
  while (left.firstElementChild) {
    body.appendChild(left.firstElementChild);
  }

  syncSubmit();

  if (!button) {
    button = el('button', 'filters-toggle btn btn-outline-tertiary');
    button.type = 'button';
    button.setAttribute('data-bs-toggle', 'offcanvas');
    button.setAttribute('data-bs-target', '#filtersDrawer');
    button.setAttribute('aria-controls', 'filtersDrawer');
    var icon = el('i', 'material-icons');
    icon.setAttribute('aria-hidden', 'true');
    icon.textContent = '\uE152'; // filter_list
    var caption = el('span');
    caption.textContent = filtersLabel;
    button.appendChild(icon);
    button.appendChild(caption);
  }

  function place() {
    var host =
      document.querySelector('#js-product-list-top .products__selection') ||
      document.getElementById('js-product-list-top');
    if (!host) {
      return;
    }
    /* Po filtrowaniu motyw wstawia świeży pasek z ajaxa. Zwykle bez
       przycisku (szablon renderuje go tylko pod layoutem), ale gdyby jakiś
       był — podmieniamy go na nasz, żeby stan i zdarzenia nie przepadły. */
    var current = host.querySelector('.filters-toggle');
    if (current === button) {
      return;
    }
    if (current) {
      host.replaceChild(button, current);
    } else {
      host.insertBefore(button, host.firstChild);
    }
  }

  place();

  var products = document.getElementById('products') || listTop.parentElement;
  if (products && window.MutationObserver) {
    new window.MutationObserver(place).observe(products, {
      childList: true,
      subtree: true
    });
  }

  /* Sygnał „masz włączone filtry" — bez liczby, bo na stronie kategorii moduł
     trzyma jedno kryterium (samą kategorię) od wejścia i licznik pokazywałby
     1 przy nietkniętych filtrach. Modułowe „Usuń filtry" jest schowane,
     dopóki użytkownik czegoś nie zaznaczy, więc bierzemy je za wskaźnik. */
  function syncActive() {
    var reset = drawer.querySelector('.PM_ASResetSearch');
    button.classList.toggle(
      'filters-toggle--active',
      !!reset && reset.style.display !== 'none'
    );
  }

  function syncDrawer() {
    syncActive();
    /* Po podmianie bloku przycisk „Szukaj" to inny węzeł — napis w stopce
       trzeba przeliczyć, bo mógł też zniknąć albo się pojawić. */
    syncSubmit();
  }

  syncActive();

  if (window.MutationObserver) {
    new window.MutationObserver(syncDrawer).observe(body, {
      childList: true,
      subtree: true,
      attributes: true,
      attributeFilter: ['style']
    });
  }

  document.body.classList.add('has-filters-drawer');
}
