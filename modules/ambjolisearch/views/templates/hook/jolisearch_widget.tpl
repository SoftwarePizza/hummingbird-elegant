{**
 * AmbJoliSearch — pole wyszukiwania nagłówka (układ „katalogowy")
 *
 * Nadpisanie modules/ambjolisearch/views/templates/hook/jolisearch_widget.tpl
 * Pole jest widoczne stale, w rzędzie z logo; podpowiedzi liczy silnik modułu.
 *
 * Pułapki, które trzymają ten szablon w ryzach:
 *
 *  - id NIE brzmi _desktop_ps_searchbar. wrapHeaderIcons() z assets/js/theme.js
 *    wciąga elementy o tym id do wspólnego kubełka z ikonami konta i koszyka —
 *    pole przestałoby być szerokie.
 *  - brak klasy js-search-widget: komponent wyszukiwarki motywu odpaliłby po niej
 *    drugi, konkurencyjny autocomplete pod data-search-controller-url.
 *  - brak klasy jolisearch: ambjolisearch.js szuka pola w kolejności
 *    $('.jolisearch').find('input') → input[name=s] → input[name=search_query].
 *    Z tą klasą złapałby też ukryty input[name=controller]; bez niej wpada
 *    dokładnie w nasze pole.
 *  - search-overlay.js z hummingbird_editor nie znajdzie .btn-search-open ani
 *    #ps-search-overlay i wyjdzie bez efektu (ma wczesny return) — nakładka
 *    nie jest już potrzebna.
 *
 * Wygląd listy podpowiedzi:
 *   modules/ambjolisearch/views/css/themes/hummingbird-1.7.css
 *}

{* Moduł spimagesearch (wyszukiwarka tekst+zdjęcie) przejmuje wysyłkę formularza;
   bez niego pole działa jak dawniej (kontroler search). Autocomplete AmbJoliSearch
   nadal liczy podpowiedzi z pola `s`. *}
{assign var=spis_on value=Module::isEnabled('spimagesearch')}
<div id="_desktop_jolisearch" class="ps-searchbar-slot col-12 col-md order-3 order-md-2">
  <div id="ps_searchbar" class="ps-searchbar w-100" data-search-controller-url="{$search_controller_url}">
    <form class="ps-searchbar__form" method="get" action="{if $spis_on}{$link->getModuleLink('spimagesearch', 'search', [], true)}{else}{$search_controller_url}{/if}" role="search">
      {if !$spis_on}<input type="hidden" name="controller" value="search">{/if}

      <label for="ps_searchbar_input" class="visually-hidden">{l s='Search' d='Shop.Theme.Catalog'}</label>

      <span class="ps-searchbar__icon" aria-hidden="true">
        <svg width="16" height="16" viewBox="0 0 17 17" fill="none" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round"><path d="M12.5974 12.5976L16.4998 16.5M7.57984 0.5C9.53504 0.5 11.3054 1.292 12.5862 2.5736C13.7445 3.73182 14.4653 5.25581 14.6259 6.88591C14.7865 8.51602 14.3769 10.1514 13.4669 11.5133C12.5569 12.8753 11.2028 13.8796 9.63536 14.3551C8.0679 14.8306 6.38407 14.7479 4.87074 14.1211C3.35742 13.4943 2.10825 12.3622 1.33608 10.9176C0.563904 9.47306 0.3165 7.80544 0.636021 6.19891C0.955542 4.59239 1.82222 3.14635 3.08838 2.10719C4.35454 1.06803 5.94185 0.500039 7.57984 0.5Z"/></svg>
      </span>

      <input
        class="js-search-input form-control ps-searchbar__input"
        type="text"
        name="s"
        value="{if isset($search_string)}{$search_string}{/if}"
        placeholder="{l s='Search our catalog' d='Shop.Theme.Catalog'}"
        id="ps_searchbar_input"
        aria-label="{l s='Search' d='Shop.Theme.Catalog'}"
        autocomplete="off"
        data-position='{literal}{"my":"left top","at":"left bottom","collision":"none"}{/literal}'
      >

      {if $spis_on}{hook h='displayImageSearchButton'}{/if}

      <button type="submit" class="ps-searchbar__submit">
        <span class="ps-searchbar__submit-label">{l s='Search' d='Shop.Theme.Catalog'}</span>
      </button>
    </form>
  </div>
</div>
{* Lista podpowiedzi AmbJoliSearch doczepiana do formularza pola (position:relative),
   pozycja stała z CSS (modules/ambjolisearch/views/css/themes/hummingbird-1.7.css) –
   bez tego jQuery UI wiesza ją na <body> i przy `left:auto` ląduje przy lewym brzegu. *}
<script>window.jolisearch = window.jolisearch || {}; window.jolisearch.autocomplete_target = '#ps_searchbar .ps-searchbar__form';</script>
