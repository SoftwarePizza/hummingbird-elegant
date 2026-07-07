{**
 * For the full copyright and license information, please view the
 * LICENSE.md file that was distributed with this source code.
 *}
{* Figma: two tabs — "Ogólne parametry" (productinformation module) and the
   default PrestaShop data sheet. The module tab only appears when the module
   matched at least one feature of the current product. *}
{capture name='productInformationHook'}{hook h='displayProductInformation'}{/capture}
{$productInformationHtml = $smarty.capture.productInformationHook}
{$hasProductInformation = ($productInformationHtml|strip_tags|trim) !== ''}


<div
  class="js-product-details product-specs"
  data-product="{$product.embedded_attributes|json_encode}"
  data-ps-ref="product-specs"
>
  {if $hasProductInformation}
    <div class="product-specs__tabs" role="tablist" aria-label="{l s='Szczegóły produktu' d='Shop.Theme.Catalog'}">
      <button
        type="button"
        class="product-specs__tab product-specs__tab--active"
        id="product-specs-tab-information"
        role="tab"
        aria-selected="true"
        aria-controls="product-specs-panel-information"
        data-ps-action="switch-product-specs-tab"
      >{l s='Ogólne parametry' d='Shop.Theme.Catalog'}</button>
      <button
        type="button"
        class="product-specs__tab"
        id="product-specs-tab-datasheet"
        role="tab"
        aria-selected="false"
        aria-controls="product-specs-panel-datasheet"
        tabindex="-1"
        data-ps-action="switch-product-specs-tab"
      >{l s='Dane techniczne' d='Shop.Theme.Catalog'}</button>
    </div>

    <div
      class="product-specs__panel"
      id="product-specs-panel-information"
      role="tabpanel"
      aria-labelledby="product-specs-tab-information"
    >
      {$productInformationHtml nofilter}
    </div>
  {else}
    <div class="product-specs__tabs">
      <span class="product-specs__tab product-specs__tab--active">{l s='Ogólne parametry' d='Shop.Theme.Catalog'}</span>
    </div>
  {/if}

  <div
    class="product-specs__panel"
    {if $hasProductInformation}
      id="product-specs-panel-datasheet"
      role="tabpanel"
      aria-labelledby="product-specs-tab-datasheet"
      hidden
    {/if}
  >
    <ul class="product-specs__list">
      {block name='product_features'}
        {if $product.grouped_features}
          {foreach from=$product.grouped_features item=feature}
            {* Features claimed by the module tab (data-general-parameter
               markers in the captured hook output) are skipped here so the
               same row never shows in both tabs. *}
            {$generalParameterMarker = 'data-general-parameter="'|cat:($feature.name|trim|escape:'html')|cat:'"'}
            {if !$hasProductInformation || strpos($productInformationHtml, $generalParameterMarker) === false}
              <li class="product-specs__row">
                <span class="product-specs__label">{$feature.name}</span>
                <span class="product-specs__value">{$feature.value|escape:'htmlall'|nl2br nofilter}</span>
              </li>
            {/if}
          {/foreach}
        {/if}
      {/block}

      {block name='product_manufacturer'}
        {if isset($product_manufacturer->id)}
          <li class="product-specs__row">
            <span class="product-specs__label">{l s='Brand' d='Shop.Theme.Catalog'}</span>
            <span class="product-specs__value">
              <a href="{$product_manufacturer->url}">{$product_manufacturer->name}</a>
            </span>
          </li>
        {/if}
      {/block}

      {block name='product_reference'}
        {if !empty($product.reference_to_display)}
          <li class="product-specs__row">
            <span class="product-specs__label">{l s='Reference' d='Shop.Theme.Catalog'}</span>
            <span class="product-specs__value">{$product.reference_to_display}</span>
          </li>
        {/if}
      {/block}

      {block name='product_quantities'}
        {if $product.show_quantities}
          <li class="product-specs__row">
            <span class="product-specs__label">{l s='In stock' d='Shop.Theme.Catalog'}</span>
            <span class="product-specs__value" data-stock="{$product.quantity}" data-allow-oosp="{$product.allow_oosp}">{$product.quantity} {$product.quantity_label}</span>
          </li>
        {/if}
      {/block}

      {block name='product_availability_date'}
        {if $product.availability_date}
          <li class="product-specs__row">
            <span class="product-specs__label">{l s='Availability date' d='Shop.Theme.Catalog'}</span>
            <span class="product-specs__value">{$product.availability_date}</span>
          </li>
        {/if}
      {/block}

      {block name='product_condition'}
        {if $product.condition}
          <li class="product-specs__row">
            <span class="product-specs__label">{l s='Condition' d='Shop.Theme.Catalog'}</span>
            <span class="product-specs__value">{$product.condition.label}</span>
          </li>
        {/if}
      {/block}

      {block name='product_specific_references'}
        {if !empty($product.specific_references)}
          {foreach from=$product.specific_references item=reference key=key}
            <li class="product-specs__row">
              <span class="product-specs__label">{$key}</span>
              <span class="product-specs__value">{$reference}</span>
            </li>
          {/foreach}
        {/if}
      {/block}
    </ul>
  </div>
</div>
