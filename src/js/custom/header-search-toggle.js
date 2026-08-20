/* ------------------------------------------------------------------
   7. Wyszukiwarka pod lupą w nagłówku mobilnym

   Pole nie zajmuje już stałego rzędu (custom.css, sekcja 23) — wyjeżdża
   dopiero po dotknięciu lupy. Przełączamy klasę na `.header-bottom`, a nie
   na samym polu, bo to nagłówek decyduje o układzie rzędów.

   Świadomie NIE przenosimy węzła `#ps_searchbar` nigdzie indziej: to ten sam
   widget, który obsługuje AmbJoliSearch, i każde `innerHTML` czy przeniesienie
   zrywa jego podpięte zdarzenia. Odsłaniamy go w miejscu, w którym stoi.
   ------------------------------------------------------------------ */

export function initHeaderSearchToggle() {
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
