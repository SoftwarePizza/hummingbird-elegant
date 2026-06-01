{**
 * For the full copyright and license information, please view the
 * LICENSE.md file that was distributed with this source code.
 *}

{* Desktop: icon only by default, expands to full-width overlay on click *}
<div id="_desktop_ps_searchbar" class="order-2 col-auto d-none d-md-flex align-items-center">
  {* Collapsed: just the icon *}
  <button class="header-block__action-btn btn-search-open border-0 bg-transparent p-0"
          aria-label="{l s='Open search' d='Shop.Theme.Catalog'}"
          aria-expanded="false"
          aria-controls="ps-search-overlay">
    <i class="material-icons header-block__icon" aria-hidden="true">&#xE8B6;</i>
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
        placeholder="{l s='Search products...' d='Shop.Theme.Catalog'}"
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
      <span class="material-icons header-block__icon" aria-hidden="true">&#xE8B6;</span>
    </a>
  </div>

  <div class="ps-searchbar__offcanvas js-search-offcanvas offcanvas offcanvas-top h-auto" tabindex="-1" id="searchCanvas" aria-labelledby="offcanvasTopLabel">
    <div class="offcanvas-header">
      <div id="_mobile_ps_searchbar" class="ps-searchbar__container"></div>
      <button type="button" class="btn btn-link" data-bs-dismiss="offcanvas" aria-label="{l s='Close search' d='Shop.Theme.Global'}">{l s='Cancel' d='Shop.Theme.Global'}</button>
    </div>
  </div>
</div>
