import { labels, behavior } from './i18n';

/* ------------------------------------------------------------------
   8. Strzałka „Wróć na górę" na środku dołu ekranu

   Na każdej stronie poza kasą (tam dół ekranu należy do podsumowania
   i przycisków kroków). Pojawia się po przewinięciu o wysokość jednego
   ekranu, znika przy górze. Wygląd: sekcja 25 custom.css.
   ------------------------------------------------------------------ */
export function initBackToTop() {
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
