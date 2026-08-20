{**
 * For the full copyright and license information, please view the
 * LICENSE.md file that was distributed with this source code.
 *}
{* Klasa listing-bar to pływający pasek z custom.css (sekcja 24) — dotąd
   dokładał ją custom.js, a pasek rósł o swój padding dopiero po załadowaniu
   skryptu. Na motywie bez tych styli klasa nic nie robi. *}
<div id="js-product-list-top" class="listing-bar">
  <div class="products__selection">
    {* Przycisk szuflady filtrów — patrz layouts/layout-left-column.tpl. Renderowany
       z serwera, żeby nie wskakiwał dopiero z JS-em; do tego czasu stoi schowany
       inline, a custom.css pokazuje go razem z klasą `has-filters-drawer`.
       Skrypt przejmuje ten węzeł (zdejmuje styl, podpina stan). Przy odświeżeniu
       listingu ajaxem ten szablon leci bez layoutu, więc $spFiltersDrawer nie ma
       i przycisku nie ma — skrypt wstawia wtedy swój węzeł z powrotem. *}
    {if !empty($spFiltersDrawer)}
      <button type="button" class="filters-toggle btn btn-outline-tertiary" style="display:none" data-bs-toggle="offcanvas" data-bs-target="#filtersDrawer" aria-controls="filtersDrawer">
        <i class="material-icons" aria-hidden="true">&#xE152;</i>
        <span>{l s='Filters' d='Shop.Theme.Catalog'}</span>
      </button>
    {/if}
    <div class="products__count">
      {if $listing.pagination.total_items> 1}
        <span>{l s='There are %product_count% products.' d='Shop.Theme.Catalog' sprintf=['%product_count%' => $listing.pagination.total_items]}</span>
      {elseif $listing.pagination.total_items> 0}
        <span>{l s='There is 1 product.' d='Shop.Theme.Catalog'}</span>
      {/if}
    </div>

    <div class="products__sort">
      {block name='sort_by'}
        {include file='catalog/_partials/sort-orders.tpl' sort_orders=$listing.sort_orders}
      {/block}

      {if !empty($listing.rendered_facets) && !isset($page.body_classes['layout-full-width'])}
        <button id="search_filter_toggler" class="products__filter-button btn btn-outline-primary js-search-toggler" data-bs-toggle="offcanvas" data-bs-target="#offcanvas-faceted">
          <i class="material-icons" aria-hidden="true">&#xE152;</i>
          {l s='Filter' d='Shop.Theme.Actions'}
        </button>
      {/if}
    </div>
  </div>
</div>
