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

export function initMenuDragScroll() {
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
