{**
 * For the full copyright and license information, please view the
 * LICENSE.md file that was distributed with this source code.
 *}

{* Desktop: icon only by default, expands to full-width overlay on click *}
<div id="_desktop_ps_searchbar" class="order-2 col-auto d-none d-md-flex align-items-center">
  {* Collapsed: just the icon *}
  <button class="header-block__action-btn btn-search-open border-0 bg-transparent p-0 d-inline-flex align-items-center"
          aria-label="{l s='Open search' d='Shop.Theme.Catalog'}"
          aria-expanded="false"
          aria-controls="ps-search-overlay">
    <svg class="header-block__icon header-block__icon--outline" width="16" height="16" viewBox="0 0 17 17" fill="none" stroke="rgba(36,36,36,1)" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M12.5974 12.5976L16.4998 16.5M7.57984 0.5C9.53504 0.5 11.3054 1.292 12.5862 2.5736C13.7445 3.73182 14.4653 5.25581 14.6259 6.88591C14.7865 8.51602 14.3769 10.1514 13.4669 11.5133C12.5569 12.8753 11.2028 13.8796 9.63536 14.3551C8.0679 14.8306 6.38407 14.7479 4.87074 14.1211C3.35742 13.4943 2.10825 12.3622 1.33608 10.9176C0.563904 9.47306 0.3165 7.80544 0.636021 6.19891C0.955542 4.59239 1.82222 3.14635 3.08838 2.10719C4.35454 1.06803 5.94185 0.500039 7.57984 0.5Z"/></svg>
    <span class="header-block__label">{l s='Search' d='Shop.Theme.Catalog'}</span>
  </button>
</div>

{* Full-width search overlay — rendered inside header, hidden by default *}
<div id="ps-search-overlay" class="ps-search-overlay" role="search" aria-hidden="true" style="display:none">
  <div id="ps_searchbar" class="ps-searchbar js-search-widget w-100" data-search-controller-url="{$search_controller_url}">
    <form class="ps-searchbar__form ps-search-overlay__form" method="get" action="{$search_controller_url}">
      <input type="hidden" name="controller" value="search">
      <label for="ps_searchbar_input" class="visually-hidden">{l s='Search' d='Shop.Theme.Catalog'}</label>
      <input
        class="js-search-input form-control ps-searchbar__input ps-search-overlay__input"
        type="text"
        name="s"
        value="{$search_string}"
        placeholder="{l s='Search our catalog' d='Shop.Theme.Catalog'}"
        id="ps_searchbar_input"
        autocomplete="off"
        role="combobox"
        aria-haspopup="listbox"
        aria-autocomplete="list"
        aria-controls="ps_searchbar_results"
        aria-expanded="false"
      >
      <button type="button" class="btn-search-close border-0 bg-transparent" aria-label="{l s='Close search' d='Shop.Theme.Catalog'}">
        <i class="material-icons" aria-hidden="true">&#xE5CD;</i>
      </button>
    </form>
    <div class="ps-searchbar__dropdown js-search-dropdown d-none" id="ps_searchbar_dropdown" aria-label="{l s='Search results' d='Shop.Theme.Catalog'}" tabindex="-1">
      <div class="ps-searchbar__results js-search-results" id="ps_searchbar_results" role="listbox" tabindex="-1"></div>
    </div>
  </div>
</div>

<template id="ps_searchbar_result" class="js-search-template">
  <a data-ps-ref="searchbar-result-link" class="ps-searchbar__result-link" id="" href="">
    <img src="" alt="" class="ps-searchbar__result-image">
    <p class="ps-searchbar__result-name"></p>
  </a>
</template>

{* MOBILE SEARCH BAR — unchanged *}
<div class="ps-searchbar--mobile d-md-none d-flex col-auto">
  <div class="header-block d-flex align-items-center">
    <a class="header-block__action-btn" href="#" role="button" data-bs-toggle="offcanvas" data-bs-target="#searchCanvas" aria-controls="searchCanvas" aria-label="{l s='Show search bar' d='Shop.Theme.Global'}">
      <svg class="header-block__icon header-block__icon--outline" width="16" height="16" viewBox="0 0 17 17" fill="none" stroke="rgba(36,36,36,1)" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M12.5974 12.5976L16.4998 16.5M7.57984 0.5C9.53504 0.5 11.3054 1.292 12.5862 2.5736C13.7445 3.73182 14.4653 5.25581 14.6259 6.88591C14.7865 8.51602 14.3769 10.1514 13.4669 11.5133C12.5569 12.8753 11.2028 13.8796 9.63536 14.3551C8.0679 14.8306 6.38407 14.7479 4.87074 14.1211C3.35742 13.4943 2.10825 12.3622 1.33608 10.9176C0.563904 9.47306 0.3165 7.80544 0.636021 6.19891C0.955542 4.59239 1.82222 3.14635 3.08838 2.10719C4.35454 1.06803 5.94185 0.500039 7.57984 0.5Z"/></svg>
    </a>
  </div>

  <div class="ps-searchbar__offcanvas js-search-offcanvas offcanvas offcanvas-top h-auto" tabindex="-1" id="searchCanvas" aria-labelledby="offcanvasTopLabel">
    <div class="offcanvas-header">
      <div id="_mobile_ps_searchbar" class="ps-searchbar__container"></div>
      <button type="button" class="btn btn-link" data-bs-dismiss="offcanvas" aria-label="{l s='Close search' d='Shop.Theme.Global'}">{l s='Cancel' d='Shop.Theme.Global'}</button>
    </div>
  </div>
</div>
