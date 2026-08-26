/* Napisy wstrzykiwane przez skrypty (karuzela banerów, szuflada filtrów,
   „Wróć na górę"). Język bierzemy z <html lang>; dla języków spoza listy
   zapas po angielsku. Wszystko, co da się wyrenderować z szablonu i {l},
   jest tam — tu zostaje tylko to, co powstaje dopiero w przeglądarce. */

var LABELS = {
  pl: {
    prev: 'Poprzedni baner', next: 'Następny baner', dot: 'Baner ',
    /* showProducts to tylko zapas: napis na stopce szuflady bierzemy
       z przycisku „Szukaj" modułu filtrów, gdy ten w ogóle istnieje. */
    filters: 'Filtry', close: 'Zamknij', showProducts: 'Pokaż produkty',
    backToTop: 'Wróć na górę',
    viewList: 'Widok listy', viewGrid: 'Widok siatki'
  },
  da: {
    prev: 'Forrige banner', next: 'Næste banner', dot: 'Banner ',
    filters: 'Filtre', close: 'Luk', showProducts: 'Vis produkter',
    backToTop: 'Tilbage til toppen',
    viewList: 'Listevisning', viewGrid: 'Gittervisning'
  },
  de: {
    prev: 'Vorheriges Banner', next: 'Nächstes Banner', dot: 'Banner ',
    filters: 'Filter', close: 'Schließen', showProducts: 'Produkte anzeigen',
    backToTop: 'Nach oben',
    viewList: 'Listenansicht', viewGrid: 'Rasteransicht'
  },
  en: {
    prev: 'Previous banner', next: 'Next banner', dot: 'Banner ',
    filters: 'Filters', close: 'Close', showProducts: 'Show products',
    backToTop: 'Back to top',
    viewList: 'List view', viewGrid: 'Grid view'
  }
};

export function labels() {
  var lang = (document.documentElement.lang || 'en').slice(0, 2).toLowerCase();
  return LABELS[lang] || LABELS.en;
}

export function behavior() {
  return window.matchMedia('(prefers-reduced-motion: reduce)').matches
    ? 'auto'
    : 'smooth';
}
