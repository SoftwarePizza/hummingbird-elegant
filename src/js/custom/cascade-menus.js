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

export function initCascadeMenus() {
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
