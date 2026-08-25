/* ------------------------------------------------------------------
   17. Przycisk ciasteczek tylko u samej góry strony głównej

   Moduł seigicookie trzyma ikonę ciastka (#cookie-change-button)
   przyklejoną do lewego dolnego rogu każdej podstrony. Chowamy ją
   wszędzie poza stroną główną, a na głównej pokazujemy tylko dopóki
   ktoś stoi u samej góry — tak samo zachowuje się plakietka
   Trusted Shops obok. Wygląd i same reguły: sekcja 44 custom.css.

   Tutaj wystarczy przełącznik klasy na <body>: nie szukamy samego
   przycisku, bo moduł wstrzykuje go dopiero po `readystatechange`,
   czyli PÓŹNIEJ niż startuje custom.js. Dzięki temu nie trzeba
   ani obserwatora DOM, ani ponawiania.
   ------------------------------------------------------------------ */

var started = false;

export function initCookieBadge() {
  /* Poza stroną główną CSS chowa przycisk bezwarunkowo, więc nie ma
     czego pilnować — nie zakładamy tam nasłuchu przewijania. */
  if (started || document.body.id !== 'index') {
    return;
  }
  started = true;

  var ticking = false;

  function sync() {
    ticking = false;
    /* Kilka pikseli luzu: przywrócenie pozycji przy powrocie „wstecz"
       i gumowe przewijanie na iOS potrafią dać scrollY rzędu 1-2 px,
       a przycisk nie ma wtedy migać. */
    var scrolled = window.scrollY > 8;
    if (document.body.classList.contains('hbe-scrolled') === scrolled) {
      return;
    }
    document.body.classList.toggle('hbe-scrolled', scrolled);
  }

  function requestSync() {
    if (!ticking) {
      ticking = true;
      window.requestAnimationFrame(sync);
    }
  }

  window.addEventListener('scroll', requestSync, { passive: true });
  sync();
}
