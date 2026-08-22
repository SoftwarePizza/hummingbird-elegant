{**
 * AmbJoliSearch — Hummingbird autocomplete dropdown
 *
 * Theme override of modules/ambjolisearch/views/templates/front/dropdown-list.tpl
 * (rendered server-side by the "finder" jolisearch theme and injected into the
 * jQuery-UI menu as a single item).
 *
 * It reuses the theme's own ps_searchbar classes — .ps-searchbar__results,
 * .ps-searchbar__result-link, .ps-searchbar__result-image,
 * .ps-searchbar__result-name — so the result strip inherits the native
 * Hummingbird look. Only the extras (categories / brands / more results) carry
 * .ps-jolisearch__* classes, styled in
 * modules/ambjolisearch/views/css/themes/hummingbird-1.7.css
 *
 * The class names product-name / product-category / product-manufacturer /
 * category-name / manufacturer-name must stay: ambjolisearch.js uses them to
 * bold the matched search term.
 *}
<div class="jolisearch-body ps-jolisearch">

  {if (isset($categories) && count($categories) > 0) || (isset($manufacturers) && count($manufacturers) > 0)}
    <div class="ps-jolisearch__facets">
      {if isset($categories) && count($categories) > 0}
        <span class="ps-jolisearch__facet-label">{l s='Categories' mod='ambjolisearch'}</span>
        {foreach from=$categories item=category}
          <a href="{$category.link}"
             class="ps-jolisearch__chip category-name"
             data-category-id="{$category.cat_id}"
             data-parameter-name="ajs_cat">{$category.cat_name}<span class="ps-jolisearch__chip-count">{$category.results}</span></a>
        {/foreach}
      {/if}

      {if isset($manufacturers) && count($manufacturers) > 0}
        <span class="ps-jolisearch__facet-label">{l s='Manufacturers' mod='ambjolisearch'}</span>
        {foreach from=$manufacturers item=manufacturer}
          <a href="{$manufacturer.link}"
             class="ps-jolisearch__chip manufacturer-name"
             data-manufacturer-id="{$manufacturer.man_id}"
             data-parameter-name="ajs_man">{$manufacturer.man_name}<span class="ps-jolisearch__chip-count">{$manufacturer.results}</span></a>
        {/foreach}
      {/if}
    </div>
  {/if}

  {if isset($products) && count($products) > 0}
    <p class="ps-jolisearch__title">
      {l s='Products' mod='ambjolisearch'}
      {if isset($products_count)}<span class="ps-jolisearch__title-count">{$products_count}</span>{/if}
    </p>

    <div class="ps-searchbar__results ps-jolisearch__results">
      {foreach from=$products item=product}
        <a class="ps-searchbar__result-link ps-jolisearch__result" href="{$product.link}">
          <img class="ps-searchbar__result-image" src="{$product.img}" alt="{$product.pname}" loading="lazy">
          <p class="ps-searchbar__result-name product-name">{$product.pname}</p>
          {if isset($product.mname) && !empty($product.mname) && isset($settings.display_manufacturer) && $settings.display_manufacturer}
            <span class="ps-jolisearch__meta product-manufacturer">{$product.mname}</span>
          {elseif isset($product.cname) && !empty($product.cname) && isset($settings.display_category) && $settings.display_category}
            <span class="ps-jolisearch__meta product-category">{$product.cname}</span>
          {/if}
          {if isset($product.price) && !empty($product.price)}
            <span class="ps-jolisearch__price product-price">{$product.price}</span>
          {/if}
        </a>
      {/foreach}
    </div>
  {/if}

  {if isset($more_results) && count($more_results) > 0}
    {* „Więcej wyników” → nowa wyszukiwarka (spimagesearch): ta sama ścieżka, inny slug;
       kontroler spimagesearch przyjmuje `s` jak jolisearch. Bez wywołań PHP w szablonie –
       Module::isEnabled()/$link w tym kontekście ajax dawały 500. *}
    <a class="ps-jolisearch__more" href="{$more_results.0.link|replace:'/jolisearch':'/wyszukiwarka'}" title="{$settings.l_more_results}">{$settings.l_more_results}</a>
  {/if}
</div>
