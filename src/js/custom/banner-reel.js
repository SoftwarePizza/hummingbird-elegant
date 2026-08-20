import { labels, behavior } from './i18n';

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

export function initBannerReel() {
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
