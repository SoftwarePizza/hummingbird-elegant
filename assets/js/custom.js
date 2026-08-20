/**
 * themes/hummingbird/assets/js/custom.js
 *
 * Rejestruje go zhakowany rdzeń — classes/controller/FrontController.php,
 * setMedia(), 'theme-custom', priorytet 1000, position bottom — więc plik
 * ładuje się jako ostatni na KAŻDEJ stronie sklepu. Każdy blok musi sam
 * sprawdzić, czy ma co robić, i cicho wyjść, jeśli nie ma.
 * Odpowiednik dla stylów: themes/hummingbird/assets/css/custom.css.
 *
 * 1. Nawigacja karuzeli banerów kategorii (#bonbanners)
 * 2. Filtry listingu w szufladzie z prawej (#PM_ASBlockOutput_*)
 * 3. Mega menu w układzie kaskadowym (.submenu--cascade)
 * 4. Karta produktu — stan magazynowy przy przycisku koszyka
 * 5. Ułamkowa ilość na karcie produktu (łata na parseInt w motywie)
 * 6. Pasek menu przeciągany myszą, gdy nie mieści się w kontenerze
 * 7. Pływający pasek filtrów i sortowania na listingu (#js-product-list-top)
 * 8. Strzałka „Wróć na górę" na środku dołu ekranu
 * 9. Lista życzeń (blockwishlist) — sortowanie jak na listingu
 */
(function () {
  'use strict';

  /* ------------------------------------------------------------------
     1. Nawigacja karuzeli banerów kategorii

     Sam pas przewijany palcem robi CSS (sekcja 5 w custom.css, scroll-snap).
     Tutaj dochodzi to, czego CSS nie umie: strzałki, kropki z aktywnym kaflem,
     przeciąganie myszą na desktopie i klasa .bb-current pod animację podpisu.

     Przeciąganie idzie tą samą konwencją co karuzele produktowe
     (modules/hummingbird_editor/views/js/carousel-drag.js): klasa is-dragging,
     próg 4 px i blokada kliknięcia, żeby przeciągnięcie nie otwierało
     kategorii. Strzałki noszą klasę .hbe-carousel-nav__btn z motywu, więc
     wyglądają jak te w karuzelach produktowych niżej.
     ------------------------------------------------------------------ */

  var LABELS = {
    pl: {
      prev: 'Poprzedni baner', next: 'Następny baner', dot: 'Baner ',
      /* showProducts to tylko zapas: napis na stopce szuflady bierzemy
         z przycisku „Szukaj" modułu filtrów, gdy ten w ogóle istnieje. */
      filters: 'Filtry', close: 'Zamknij', showProducts: 'Pokaż produkty',
      backToTop: 'Wróć na górę'
    },
    da: {
      prev: 'Forrige banner', next: 'Næste banner', dot: 'Banner ',
      filters: 'Filtre', close: 'Luk', showProducts: 'Vis produkter',
      backToTop: 'Tilbage til toppen'
    },
    de: {
      prev: 'Vorheriges Banner', next: 'Nächstes Banner', dot: 'Banner ',
      filters: 'Filter', close: 'Schließen', showProducts: 'Produkte anzeigen',
      backToTop: 'Nach oben'
    },
    en: {
      prev: 'Previous banner', next: 'Next banner', dot: 'Banner ',
      filters: 'Filters', close: 'Close', showProducts: 'Show products',
      backToTop: 'Back to top'
    }
  };

  function labels() {
    var lang = (document.documentElement.lang || 'en').slice(0, 2).toLowerCase();
    return LABELS[lang] || LABELS.en;
  }

  function behavior() {
    return window.matchMedia('(prefers-reduced-motion: reduce)').matches
      ? 'auto'
      : 'smooth';
  }

  function initBannerReel() {
    var section = document.getElementById('bonbanners');
    if (!section) {
      return;
    }

    /* boot() może pójść dwa razy (patrz koniec pliku) — klasa .bb-ready jest
       jednocześnie znacznikiem „już zrobione". */
    if (section.classList.contains('bb-ready')) {
      return;
    }

    var track = section.querySelector('ul.row');
    if (!track) {
      return;
    }

    var items = Array.prototype.slice.call(track.querySelectorAll(':scope > li'));
    if (items.length < 2) {
      return;
    }

    var t = labels();

    /* Pozycja scrolla, na której dany kafel jest „ten aktywny". Różnica
       offsetLeft-ów znosi offsetParent, więc działa niezależnie od tego,
       jak szerokie są kafle i ile jest paddingu na pasie. */
    function offsetOf(i) {
      return items[i].offsetLeft - items[0].offsetLeft;
    }

    function currentIndex() {
      var x = track.scrollLeft;
      var best = 0;
      var bestDist = Infinity;

      for (var i = 0; i < items.length; i++) {
        var dist = Math.abs(offsetOf(i) - x);
        if (dist < bestDist) {
          bestDist = dist;
          best = i;
        }
      }

      return best;
    }

    function goTo(i) {
      var last = items.length - 1;
      var target = i < 0 ? 0 : i > last ? last : i;
      track.scrollTo({ left: offsetOf(target), behavior: behavior() });
    }

    function navButton(dir) {
      var isPrev = dir < 0;
      var button = document.createElement('button');
      button.type = 'button';
      /* hbe-carousel-nav__btn = wygląd przycisku z karuzel produktowych. */
      button.className =
        'bb-nav hbe-carousel-nav__btn bb-nav--' + (isPrev ? 'prev' : 'next');
      button.setAttribute('aria-label', isPrev ? t.prev : t.next);

      var icon = document.createElement('i');
      icon.className = 'material-icons';
      icon.setAttribute('aria-hidden', 'true');
      /* chevron_left / chevron_right — te same kodpunkty co w products.tpl
         (&#xE314; / &#xE315;), zapisane escape'em: to znaki z prywatnego
         obszaru Unicode, więc lepiej, żeby plik został czystym ASCII. */
      icon.textContent = isPrev ? '\uE314' : '\uE315';
      button.appendChild(icon);

      button.addEventListener('click', function () {
        goTo(currentIndex() + dir);
      });

      return button;
    }

    var prev = navButton(-1);
    var next = navButton(1);

    var dotsWrap = document.createElement('div');
    dotsWrap.className = 'bb-dots';

    var dots = items.map(function (item, i) {
      var dot = document.createElement('button');
      dot.type = 'button';
      dot.className = 'bb-dot';
      dot.setAttribute('aria-label', t.dot + (i + 1));
      dot.addEventListener('click', function () {
        goTo(i);
      });
      dotsWrap.appendChild(dot);
      return dot;
    });

    section.appendChild(prev);
    section.appendChild(next);
    section.appendChild(dotsWrap);

    var shown = -1;

    function update() {
      /* Po scrollu, nie po indeksie: przy kilku kaflach na ekran ostatni kafel
         nigdy nie dojeżdża do lewej krawędzi, więc indeks nie dobiłby do końca
         listy i strzałka „dalej" zostałaby aktywna bez efektu. */
      prev.disabled = track.scrollLeft <= 1;
      next.disabled =
        track.scrollLeft + track.clientWidth >= track.scrollWidth - 1;

      var i = currentIndex();
      if (i === shown) {
        return;
      }

      if (shown > -1) {
        items[shown].classList.remove('bb-current');
        dots[shown].classList.remove('bb-dot--active');
        dots[shown].removeAttribute('aria-current');
      }

      items[i].classList.add('bb-current');
      dots[i].classList.add('bb-dot--active');
      dots[i].setAttribute('aria-current', 'true');
      shown = i;
    }

    /* scroll leci kilkadziesiąt razy na sekundę, a currentIndex() czyta
       offsetLeft-y — jedno przeliczenie na klatkę wystarczy. */
    var frame = 0;

    function schedule() {
      if (frame) {
        return;
      }
      frame = window.requestAnimationFrame(function () {
        frame = 0;
        update();
      });
    }

    track.addEventListener('scroll', schedule, { passive: true });
    window.addEventListener('resize', schedule);

    /* -------- przeciąganie myszą (desktop) -------- */

    var down = false;
    var startX = 0;
    var startScroll = 0;
    var moved = false;
    var release = 0;

    /* Złapanie zdjęcia albo linku odpaliłoby natywne przeciąganie obrazka,
       które zjada mousemove i blokuje przewijanie. */
    track.addEventListener('dragstart', function (e) {
      e.preventDefault();
    });

    track.addEventListener('mousedown', function (e) {
      if (e.button !== 0) {
        return;
      }
      down = true;
      moved = false;
      startX = e.pageX;
      startScroll = track.scrollLeft;
      window.clearTimeout(release);
      /* CSS na tej klasie zdejmuje scroll-snap — bez tego snap ściągałby pas
         z powrotem przy każdym ruchu myszy. */
      track.classList.add('is-dragging');
      e.preventDefault();
    });

    /* Na window, nie na pasie: kursor może zjechać nad/pod pas, a puszczenie
       przycisku gdziekolwiek musi kończyć przeciąganie. */
    window.addEventListener('mousemove', function (e) {
      if (!down) {
        return;
      }
      var walk = e.pageX - startX;
      if (Math.abs(walk) > 4) {
        moved = true;
      }
      track.scrollLeft = startScroll - walk;
      e.preventDefault();
    });

    window.addEventListener('mouseup', function () {
      if (!down) {
        return;
      }
      down = false;
      /* Dociągnięcie do najbliższego kafla własnym scrollem, a snap wraca
         dopiero po nim — inaczej włączenie snapu szarpnęłoby pasem. */
      goTo(currentIndex());
      release = window.setTimeout(function () {
        track.classList.remove('is-dragging');
      }, 450);
    });

    track.addEventListener(
      'click',
      function (e) {
        if (moved) {
          e.preventDefault();
          e.stopPropagation();
          moved = false;
        }
      },
      true
    );

    /* Klasa dopiero teraz: dopóki jej nie ma, podpisy są normalnie widoczne,
       więc wywalony JS nie zostawia kafli bez nazw kategorii. */
    section.classList.add('bb-ready');
    update();
  }

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
  function initFiltersDrawer() {
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

  /* ------------------------------------------------------------------
     3. MOBILE — licznik koszyka w nagłówku po dodaniu przez ajax

     ps_shoppingcart.js po zdarzeniu 'updateCart' podmienia w nagłówku element
     `.blockcart` — a to jest blok DESKTOPOWY z modułu. Wersja mobilna jest
     wpisana ręcznie w themes/hummingbird/templates/_partials/header.tpl
     (#_mobile_ps_shoppingcart) i tej klasy nie ma, więc jej licznik zostawał
     z liczbą wyrenderowaną przez serwer aż do przeładowania strony. Widać to
     dopiero od 2026-08-17, odkąd koszyk działa ajaxem (PS_BLOCK_CART_AJAX).
     ------------------------------------------------------------------ */
  function initMobileCartBadge() {
    var holder = document.getElementById('_mobile_ps_shoppingcart');
    var ps = window.prestashop;
    if (!holder || !ps || typeof ps.on !== 'function' || holder.dataset.hbeBadgeSynced) {
      return;
    }

    var badge = holder.querySelector('.header-block__badge');
    if (!badge) {
      return;
    }

    holder.dataset.hbeBadgeSynced = '1';

    ps.on('updateCart', function (event) {
      var cart = event && event.resp && event.resp.cart;
      var count = cart && cart.products_count;
      if (count !== undefined && count !== null && count !== '') {
        badge.textContent = count;
      }
    });
  }


  /* ------------------------------------------------------------------
     3. Mega menu w układzie kaskadowym

     Szablon (ps_mainmenu.tpl, funkcja cascadePanes) wypluwa WSZYSTKIE poziomy
     drzewa naraz, jako rodzeństwo w jednym rzędzie flex: .cascade__pane
     z atrybutem data-level. Widoczny jest tylko łańcuch od korzenia do
     najechanej pozycji. Tutaj sterujemy tą widocznością.

     Dlaczego nie na samym CSS-ie (:hover + ~): panele są rodzeństwem, ale
     panel wnuka nie jest sąsiadem panelu dziecka — między nimi bywają panele
     innych gałęzi. Selektor rodzeństwa tego nie wyrazi.

     Zasada jest jedna i wynika wprost z zagnieżdżenia: najechanie pozycji
     na poziomie N zamyka wszystko głębsze niż N, a potem otwiera panel tej
     pozycji (o ile jakiś ma). Pozycja bez dzieci po prostu domyka głębsze
     panele. Nic tu nie wie, ile poziomów ma drzewo.
     ------------------------------------------------------------------ */

  function initCascadeMenus() {
    var menus = document.querySelectorAll('.submenu--cascade .cascade');
    if (!menus.length) return;

    Array.prototype.forEach.call(menus, function (root) {
      if (root.dataset.cascadeReady === '1') return;
      root.dataset.cascadeReady = '1';

      var panes = root.querySelectorAll('.cascade__pane');

      function closeDeeperThan(level) {
        Array.prototype.forEach.call(panes, function (pane) {
          if (pane.dataset.cascadeStatic === '1') return;
          if (parseInt(pane.dataset.level, 10) > level) {
            pane.classList.remove('is-open');
            /* Pozycje w zamykanym panelu tracą podświetlenie, inaczej po
               powrocie w tę gałąź świeciłyby dwie naraz. */
            var act = pane.querySelectorAll('.cascade__item.is-active');
            Array.prototype.forEach.call(act, function (a) {
              a.classList.remove('is-active');
              if (a.hasAttribute('aria-expanded')) a.setAttribute('aria-expanded', 'false');
            });
          }
        });
      }

      function activate(item) {
        var pane = item.closest('.cascade__pane');
        if (!pane) return;
        /* Kolumna z pojedynczymi kategoriami jest tylko do czytania — kursor
           jedzie przez nią do panelu potomka i nie wolno, żeby po drodze
           cokolwiek zamknęła. */
        if (pane.dataset.cascadeStatic === '1') return;
        var level = parseInt(pane.dataset.level, 10);

        closeDeeperThan(level);

        var siblings = pane.querySelectorAll('.cascade__item.is-active');
        Array.prototype.forEach.call(siblings, function (a) {
          a.classList.remove('is-active');
          if (a.hasAttribute('aria-expanded')) a.setAttribute('aria-expanded', 'false');
        });

        var targetId = item.getAttribute('data-cascade-open');
        if (!targetId) return;

        var target = root.querySelector('#' + CSS.escape(targetId));
        if (!target) return;

        target.classList.add('is-open');
        item.classList.add('is-active');
        item.setAttribute('aria-expanded', 'true');
        position();
      }

      /* Tolerancja na przejazd kursorem.

         Droga z pozycji do jej panelu wiedzie w prawo, a po drodze kursor
         zahacza o sąsiednie pozycje — w pionowej liście wystarczy ruch pod
         lekkim skosem. Bez opóźnienia każde takie muśnięcie zamykało panel,
         do którego użytkownik właśnie zmierzał. Dlatego przełączenie na INNĄ
         gałąź czeka chwilę i daje się odwołać; jeśli w tym czasie kursor
         wejdzie w panel głębszy niż ten, z którego wyszedł, zamiar jest
         oczywisty i przełączenie odwołujemy.

         Zwłoka dotyczy tylko sytuacji, w której jest co zamykać. Pierwsze
         najechanie, gdy nic głębszego nie stoi otworem, działa natychmiast —
         inaczej całe menu sprawiałoby wrażenie ociężałego. */
      var switchTimer = null;
      var pendingLevel = null;

      function cancelPending() {
        if (switchTimer) clearTimeout(switchTimer);
        switchTimer = null;
        pendingLevel = null;
      }

      function scheduleActivate(item) {
        var pane = item.closest('.cascade__pane');
        if (!pane || pane.dataset.cascadeStatic === '1') return;
        var level = parseInt(pane.dataset.level, 10);
        var deeperOpen = root.querySelector('.cascade__pane.is-open[data-level="' + (level + 1) + '"]');

        cancelPending();

        if (!deeperOpen || item.classList.contains('is-active')) {
          activate(item);
          return;
        }

        pendingLevel = level;
        switchTimer = setTimeout(function () {
          cancelPending();
          activate(item);
        }, 160);
      }

      /* Delegacja: `mouseover` bąbelkuje (mouseenter nie), więc jeden
         nasłuch obsługuje wszystkie poziomy, także te dorysowane później. */
      root.addEventListener('mouseover', function (e) {
        var pane = e.target.closest('.cascade__pane');
        if (pane && pane.dataset.cascadeStatic !== '1'
            && pendingLevel !== null && parseInt(pane.dataset.level, 10) > pendingLevel) {
          cancelPending();
          return;
        }

        var item = e.target.closest('.cascade__item');
        if (item && root.contains(item)) scheduleActivate(item);
      });

      /* Klawiatura: tabowanie po liście ma otwierać to samo, co kursor. */
      root.addEventListener('focusin', function (e) {
        var item = e.target.closest('.cascade__item');
        if (item && root.contains(item)) { cancelPending(); activate(item); }
      });

      /* Pierwsza gałąź otwarta od razu — inaczej po najechaniu na pozycję menu
         karta pokazuje jedną kolumnę i morze pustego miejsca obok. Szablon
         układa pozycje z podkategoriami na początku listy, więc „pierwsza
         z dzieckiem" to po prostu pierwsza pozycja. */
      function openDefaultBranch() {
        cancelPending();
        closeDeeperThan(1);
        var first = root.querySelector('.cascade__pane[data-level="1"]:not([data-cascade-static]) .cascade__item[data-cascade-open]');
        if (first) activate(first);
        position();
      }

      /* Karta ma szerokość treści (custom.css, sekcja 15), więc sama nie wie,
         gdzie stanąć. Ustawiamy ją pod pozycją menu, którą rozwija, i dociskamy
         do kontenera, żeby przy skrajnie prawej pozycji nie wyjechała za
         krawędź strony. Liczone przy każdym otwarciu panelu, bo szerokość
         karty rośnie i maleje razem z otwartym łańcuchem. */
      var submenu = root.closest('.submenu');
      var parentLi = submenu ? submenu.closest('li') : null;
      var pageContainer = document.querySelector('.header-nav-full-width__container');

      function position() {
        if (!submenu || !parentLi || !pageContainer) return;
        /* Panel schowany nie ma ani szerokości, ani offsetParent — pomiar nie
           ma wtedy sensu i `bar` wyszedłby null. Stąd odczyt przy każdym
           wywołaniu, a nie raz przy starcie. */
        if (!submenu.offsetWidth) return;
        var bar = submenu.offsetParent;
        if (!bar) return;

        var barRect = bar.getBoundingClientRect();
        var contRect = pageContainer.getBoundingClientRect();
        /* Mierzymy ETYKIETĘ, nie <li>: od sekcji 14 pozycje są rozciągane
           flexem, więc krawędź <li> stoi gdzieś w połowie odstępu i panel
           wychodziłby wyraźnie na lewo od napisu, który go otwiera. */
        var label = parentLi.querySelector('.ps-mainmenu__tree-label');
        var itemRect = (label || parentLi).getBoundingClientRect();

        /* Wcięcie wewnętrznego .container odjęte, żeby pierwsza kolumna panelu
           stanęła w jednej osi z etykietą pozycji, a nie 12 px dalej. */
        var inner = submenu.querySelector('.container');
        var gutter = inner ? parseFloat(getComputedStyle(inner).paddingLeft) || 0 : 0;

        /* Pozycje mają rowek na znacznik „najczęściej szukane" (custom.css,
           sekcja 19). Doliczamy go, żeby pierwsza kolumna panelu dalej stała
           w osi etykiety na pasku, a nie o ten rowek dalej. */
        var probe = root.querySelector('.cascade__item');
        if (probe) gutter += parseFloat(getComputedStyle(probe).paddingLeft) || 0;

        var minLeft = contRect.left - barRect.left;
        var maxLeft = contRect.right - barRect.left - submenu.offsetWidth;
        var left = itemRect.left - barRect.left - gutter;

        if (maxLeft < minLeft) maxLeft = minLeft;
        submenu.style.left = Math.max(minLeft, Math.min(left, maxLeft)) + 'px';
      }

      if (parentLi) {
        parentLi.addEventListener('mouseenter', function () {
          /* Motyw zdejmuje `display:none` dopiero po tym zdarzeniu, więc pomiar
             musi poczekać na kolejną klatkę. */
          requestAnimationFrame(openDefaultBranch);
        });
      }

      /* Po zamknięciu całego mega menu wracamy do stanu wyjściowego, żeby
         następne otwarcie nie zaczynało się od przypadkowej gałęzi. */
      if (submenu) {
        submenu.addEventListener('mouseleave', openDefaultBranch);
      }
    });
  }

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

  function parseQty(value) {
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

  function refreshStockHint() {
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

  function initStockHint() {
    if (stockHintBound) {
      refreshStockHint();
      return;
    }
    stockHintBound = true;

    ['input', 'change', 'keyup', 'blur'].forEach(function (nazwa) {
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

  function initFractionalQuantity() {
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


  /* ------------------------------------------------------------------
     6. Pasek menu przeciągany myszą

     Pasek przewija się w bok, gdy pozycje nie mieszczą się w kontenerze
     (custom.css, sekcja 14 — dzieje się to np. po niemiecku). Kółkiem myszy
     przewija się w poziomie tylko z shiftem, a cienki pasek przewijania pod
     spodem to mały cel. Stąd chwyt i przeciągnięcie, jak po mapie.

     Cztery rzeczy, na które trzeba uważać:

     - Włączamy się TYLKO wtedy, gdy jest co przewijać. Przy polskich nazwach
       pasek mieści się w całości i nie ma powodu, żeby zmieniać kursor ani
       przechwytywać kliknięcia. Stan przeliczamy przy zmianie rozmiaru okna.
     - Rozwinięty panel mega menu jest DZIECKIEM <li>, więc wciśnięcie myszy
       w środku panelu bąbelkuje do listy. Bez wyjątku na `.submenu`
       przeciąganie linku w panelu przewijałoby pasek nad nim.
     - Po prawdziwym przeciągnięciu trzeba zjeść kliknięcie, inaczej puszczenie
       myszy nad pozycją menu nawiguje do kategorii. Nasłuch w fazie
       przechwytywania, z progiem — drgnięcie ręki przy zwykłym kliknięciu nie
       może go blokować.
     - `mousemove`/`mouseup` wiszą na oknie, nie na pasku: kursor wyjeżdża poza
       pasek w trakcie przeciągania i inaczej gest zostawałby „wciśnięty".
     ------------------------------------------------------------------ */

  function initMenuDragScroll() {
    var tree = document.querySelector('.ps-mainmenu--desktop .ps-mainmenu__tree');
    if (!tree || tree.dataset.dragReady === '1') return;
    tree.dataset.dragReady = '1';

    var PROG = 6; // px, powyżej których ruch liczy się jako przeciąganie
    var ciagnie = false;
    var startX = 0;
    var startScroll = 0;
    var przesuniecie = 0;

    function odswiezStan() {
      tree.classList.toggle('is-draggable', tree.scrollWidth > tree.clientWidth + 2);
    }

    odswiezStan();
    window.addEventListener('resize', odswiezStan);

    tree.addEventListener('mousedown', function (e) {
      if (e.button !== 0) return;
      if (e.target.closest('.submenu')) return;
      if (tree.scrollWidth <= tree.clientWidth + 2) return;

      ciagnie = true;
      przesuniecie = 0;
      startX = e.clientX;
      startScroll = tree.scrollLeft;
      tree.classList.add('is-dragging');
      /* Bez tego przeciąganie zaznacza etykiety zamiast przewijać. */
      e.preventDefault();
    });

    window.addEventListener('mousemove', function (e) {
      if (!ciagnie) return;
      var delta = e.clientX - startX;
      przesuniecie = Math.max(przesuniecie, Math.abs(delta));
      tree.scrollLeft = startScroll - delta;
    });

    window.addEventListener('mouseup', function () {
      if (!ciagnie) return;
      ciagnie = false;
      tree.classList.remove('is-dragging');
    });

    tree.addEventListener('click', function (e) {
      if (przesuniecie > PROG) {
        e.preventDefault();
        e.stopPropagation();
        przesuniecie = 0;
      }
    }, true);
  }

  /* ------------------------------------------------------------------
     7. Pływający pasek filtrów i sortowania na listingu

     Samo przyklejenie robi CSS (sekcja 24 custom.css, position: sticky
     na #js-product-list-top.listing-bar). Tu dochodzi to, czego CSS nie
     umie:
     - klasa .is-stuck, gdy pasek naprawdę wisi (biała karta z cieniem
       zamiast przezroczystego wiersza) — sprawdzana na scroll/resize
       przez requestAnimationFrame;
     - kopia licznika („Jest 136 produktów.") nad paskiem jako
       .listing-count, bo na telefonie pasek ma być jednowierszowy,
       a licznik w nim chowa CSS;
     - odtworzenie obu rzeczy po ajaxowym sortowaniu/stronicowaniu —
       motyw podmienia wtedy cały węzeł #js-product-list-top
       (core/listing: replaceWith), więc klasa i stan giną razem z nim.

     Pasek szukamy zawsze świeżo po id, nigdy nie trzymamy referencji —
     z tego samego powodu.
     ------------------------------------------------------------------ */
  function initFloatingListingBar() {
    var products = document.getElementById('products');
    if (!products || !document.getElementById('js-product-list-top')) {
      return;
    }
    if (products.dataset.listingBar) {
      return;
    }
    products.dataset.listingBar = '1';

    function bar() {
      return document.getElementById('js-product-list-top');
    }

    /* Kopia licznika nad paskiem. Tekst jest kopiowany, nie przenoszony —
       oryginał zostaje w pasku dla desktopu, a który z nich widać, decyduje
       CSS po szerokości ekranu. */
    function syncCount(el) {
      var source = el.querySelector('.products__count');
      var copy = el.previousElementSibling;
      if (!copy || !copy.classList.contains('listing-count')) {
        copy = document.createElement('p');
        copy.className = 'listing-count';
        el.parentNode.insertBefore(copy, el);
      }
      var text = source ? source.textContent.replace(/\s+/g, ' ').trim() : '';
      if (copy.textContent.replace(/\s+/g, ' ').trim() !== text) {
        copy.textContent = text;
      }
      /* Kopię z szablonu (product-list.tpl) chowa styl inline — od tej
         chwili o widoczności decyduje CSS po szerokości ekranu. */
      copy.style.display = '';
      copy.hidden = !text;
    }

    var ticking = false;

    function syncStuck() {
      ticking = false;
      var el = bar();
      if (!el) {
        return;
      }
      /* Próg = wartość `top` ze stylu (0.5rem), żeby nie dublować liczby
         z CSS-a. Warunek na scrollY odróżnia „przyklejony u góry" od
         „strona jeszcze nieprzewinięta, a pasek akurat stoi wysoko". */
      var top = parseFloat(window.getComputedStyle(el).top) || 0;
      var stuck =
        window.scrollY > 0 && el.getBoundingClientRect().top <= top + 1;
      el.classList.toggle('is-stuck', stuck);
    }

    function requestSync() {
      if (!ticking) {
        ticking = true;
        window.requestAnimationFrame(syncStuck);
      }
    }

    function setup() {
      var el = bar();
      if (!el) {
        return;
      }
      el.classList.add('listing-bar');
      syncCount(el);
      requestSync();
    }

    setup();

    window.addEventListener('scroll', requestSync, { passive: true });
    window.addEventListener('resize', requestSync);

    if (window.MutationObserver) {
      new window.MutationObserver(setup).observe(products, {
        childList: true,
        subtree: true
      });
    }
  }

  /* ------------------------------------------------------------------
     8. Strzałka „Wróć na górę" na środku dołu ekranu

     Na każdej stronie poza kasą (tam dół ekranu należy do podsumowania
     i przycisków kroków). Pojawia się po przewinięciu o wysokość jednego
     ekranu, znika przy górze. Wygląd: sekcja 25 custom.css.
     ------------------------------------------------------------------ */
  function initBackToTop() {
    if (document.getElementById('backToTop') || document.body.id === 'checkout') {
      return;
    }

    var t = labels();
    var button = document.createElement('button');
    button.type = 'button';
    button.id = 'backToTop';
    button.className = 'back-to-top';
    button.setAttribute('aria-label', t.backToTop);
    button.setAttribute('aria-hidden', 'true');
    button.tabIndex = -1;
    var icon = document.createElement('i');
    icon.className = 'material-icons';
    icon.setAttribute('aria-hidden', 'true');
    icon.textContent = ''; // expand_less
    button.appendChild(icon);
    document.body.appendChild(button);

    button.addEventListener('click', function () {
      window.scrollTo({ top: 0, behavior: behavior() });
      /* Fokus wraca na początek dokumentu, żeby czytnik ekranu i klawiatura
         też „wróciły na górę", a nie zostały na niewidocznym już przycisku. */
      var target = document.querySelector('#header a, #header button, #header input');
      if (target) {
        target.focus({ preventScroll: true });
      }
    });

    var ticking = false;

    function sync() {
      ticking = false;
      var visible = window.scrollY > window.innerHeight;
      if (button.classList.contains('is-visible') === visible) {
        return;
      }
      button.classList.toggle('is-visible', visible);
      button.setAttribute('aria-hidden', visible ? 'false' : 'true');
      button.tabIndex = visible ? 0 : -1;
    }

    function requestSync() {
      if (!ticking) {
        ticking = true;
        window.requestAnimationFrame(sync);
      }
    }

    window.addEventListener('scroll', requestSync, { passive: true });
    window.addEventListener('resize', requestSync);
    sync();
  }

  /* ------------------------------------------------------------------
     9. Lista życzeń (blockwishlist) — sortowanie jak na listingu

     Stronę /module/blockwishlist/view składa aplikacja Vue modułu, a jej
     przycisk „Sortuj po:" ma data-toggle="dropdown" z Bootstrapa 4 — Bootstrap 5
     z motywu tego nie obsługuje, więc menu nigdy się nie otwierało. Dokładamy
     data-bs-toggle (BS5 nasłuchuje na dokumencie, więc działa też dla
     elementów dodanych później) i klasy przycisku sortowania z listingu.
     Vue nie rusza atrybutów, których sam nie wiąże, ale po zmianie sortowania
     potrafi przebudować nagłówek — stąd obserwator. Pilnuje #wrapper, nie
     samego kontenera: Vue przy montowaniu PODMIENIA serwerowy
     <div class="wishlist-products-container"> na własny element, więc
     uchwyt złapany przed montażem wskazywałby odpięty węzeł.
     Wygląd: sekcja 26 custom.css.
     ------------------------------------------------------------------ */
  function initWishlistSort() {
    var scope = document.getElementById('wrapper') || document.body;
    if (!scope.querySelector('.wishlist-products-container') || scope.dataset.wishlistSortPatched) {
      return;
    }
    scope.dataset.wishlistSortPatched = '1';

    function patch() {
      var root = scope.querySelector('.wishlist-products-container');
      var button = root && root.querySelector('.products-sort-order .select-title');
      if (!button) {
        return;
      }
      if (!button.hasAttribute('data-bs-toggle')) {
        button.setAttribute('data-bs-toggle', 'dropdown');
        button.setAttribute('data-bs-display', 'static');
        button.classList.add('btn', 'btn-outline-tertiary', 'dropdown-toggle', 'products__sort-dropdown-button');
        button.classList.remove('btn-unstyle');
      }
      var menu = root.querySelector('.products-sort-order .dropdown-menu');
      if (menu) {
        menu.classList.add('dropdown-menu-end');
        menu.querySelectorAll('.select-list:not(.dropdown-item)').forEach(function (item) {
          item.classList.add('dropdown-item');
          item.setAttribute('role', 'menuitem');
        });
      }
    }

    patch();
    new MutationObserver(patch).observe(scope, { childList: true, subtree: true });
  }


  /* ------------------------------------------------------------------
     7. Wyszukiwarka pod lupą w nagłówku mobilnym

     Pole nie zajmuje już stałego rzędu (custom.css, sekcja 23) — wyjeżdża
     dopiero po dotknięciu lupy. Przełączamy klasę na `.header-bottom`, a nie
     na samym polu, bo to nagłówek decyduje o układzie rzędów.

     Świadomie NIE przenosimy węzła `#ps_searchbar` nigdzie indziej: to ten sam
     widget, który obsługuje AmbJoliSearch, i każde `innerHTML` czy przeniesienie
     zrywa jego podpięte zdarzenia. Odsłaniamy go w miejscu, w którym stoi.
     ------------------------------------------------------------------ */

  function initHeaderSearchToggle() {
    var btn = document.querySelector('.js-header-search-toggle');
    if (!btn || btn.dataset.searchReady === '1') return;
    btn.dataset.searchReady = '1';

    var header = btn.closest('.header-bottom');
    if (!header) return;

    var input = header.querySelector('.ps-searchbar-slot input[type="text"], .ps-searchbar-slot .js-search-input');

    function otwarte() {
      return header.classList.contains('is-search-open');
    }

    function ustaw(stan) {
      header.classList.toggle('is-search-open', stan);
      btn.setAttribute('aria-expanded', stan ? 'true' : 'false');
      /* Focus dopiero po odsłonięciu — na ukrytym polu przeglądarka go zignoruje. */
      if (stan && input) {
        requestAnimationFrame(function () { input.focus(); });
      }
    }

    btn.addEventListener('click', function () {
      ustaw(!otwarte());
    });

    document.addEventListener('keydown', function (e) {
      if (e.key === 'Escape' && otwarte()) {
        ustaw(false);
        btn.focus();
      }
    });

    /* Dotknięcie poza nagłówkiem zamyka pole, ale tylko puste — z wpisaną
       frazą użytkownik zwykle celuje w podpowiedź, która wisi POD nagłówkiem
       i technicznie jest kliknięciem „na zewnątrz". */
    document.addEventListener('click', function (e) {
      if (!otwarte()) return;
      if (header.contains(e.target)) return;
      if (e.target.closest('.ps-searchbar__dropdown, .ui-menu, .jolisearch')) return;
      if (input && input.value.trim() !== '') return;
      ustaw(false);
    });
  }

  function boot() {
    initBannerReel();
    initFiltersDrawer();
    initMobileCartBadge();
    initCascadeMenus();
    initStockHint();
    initFractionalQuantity();
    initMenuDragScroll();
    initFloatingListingBar();
    initBackToTop();
    initWishlistSort();
    initHeaderSearchToggle();
  }

  /* Plik siedzi na końcu <body>, więc listing i lewa kolumna zwykle już są
     w DOM — ruszamy od razu, żeby przebudowa kolumn zdążyła przed pierwszym
     malowaniem i strona nie mrugnęła układem. DOMContentLoaded zostaje jako
     druga próba, gdyby plik trafił kiedyś wyżej (defer, łączenie assetów);
     obie funkcje same wykrywają, że już zrobiły swoje. */
  boot();

  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', boot);
  }
})();
