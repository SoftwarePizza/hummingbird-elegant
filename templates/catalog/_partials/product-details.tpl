{**
 * For the full copyright and license information, please view the
 * LICENSE.md file that was distributed with this source code.
 *}
{* One "Dane techniczne" list: product features, dimensions, then the
   productinformation module rows (dishwasher/microwave with enriched content,
   rendered as bare <li> by the theme override of the module view), then the
   remaining data sheet entries. Repeated feature values are collapsed — BO
   data carries the same value attached twice (e.g. "Tak\nTak"). *}
{capture name='productInformationHook'}{hook h='displayProductInformation'}{/capture}
{$productInformationHtml = $smarty.capture.productInformationHook}
{$hasProductInformation = ($productInformationHtml|strip_tags|trim) !== ''}


<div
  class="js-product-details product-specs"
  data-product="{$product.embedded_attributes|json_encode}"
  data-ps-ref="product-specs"
>
  <div class="product-specs__tabs">
    <span class="product-specs__tab product-specs__tab--active">{l s='Dane techniczne' d='Shop.Theme.Catalog'}</span>
  </div>

  <div class="product-specs__panel">
    <ul class="product-specs__list">
      {block name='product_features'}
        {if $product.grouped_features}
          {foreach from=$product.grouped_features item=feature}
            {* Features rendered by the module hook (data-general-parameter
               markers in the captured hook output) are skipped here so the
               same row never shows twice. *}
            {$generalParameterMarker = 'data-general-parameter="'|cat:($feature.name|trim|escape:'html')|cat:'"'}
            {if !$hasProductInformation || strpos($productInformationHtml, $generalParameterMarker) === false}
              {$featureValues = []}
              {foreach from="\n"|explode:$feature.value item=rawValue}
                {$value = $rawValue|trim}
                {if $value !== '' && !($value|in_array:$featureValues)}
                  {$featureValues[] = $value}
                {/if}
              {/foreach}
              <li class="product-specs__row">
                <span class="product-specs__label">{$feature.name}</span>
                <span class="product-specs__value">{foreach from=$featureValues item=featureValue name=featureValues}{if !$smarty.foreach.featureValues.first}<br>{/if}{$featureValue|escape:'html':'UTF-8'}{/foreach}</span>
              </li>
            {/if}
          {/foreach}
        {/if}
      {/block}

      {block name='product_dimensions'}
        {* Wymiary i waga pochodzą z dedykowanych pól produktu, a nie z cech, więc ta
           sama informacja nie jest utrzymywana w dwóch miejscach. Jednostka długości
           jest literałem: core nie wstrzykuje PS_DIMENSION_UNIT do szablonu, a sięganie
           po konfigurację z motywu łamałoby granicę prezentacji. *}
        {if $product.width > 0}
          <li class="product-specs__row">
            <span class="product-specs__label">{l s='Szerokość' d='Shop.Theme.Catalog'}</span>
            <span class="product-specs__value">{$product.width|string_format:"%g"|replace:'.':','|escape:'html':'UTF-8'} {l s='cm' d='Shop.Theme.Catalog'}</span>
          </li>
        {/if}
        {if $product.height > 0}
          <li class="product-specs__row">
            <span class="product-specs__label">{l s='Wysokość' d='Shop.Theme.Catalog'}</span>
            <span class="product-specs__value">{$product.height|string_format:"%g"|replace:'.':','|escape:'html':'UTF-8'} {l s='cm' d='Shop.Theme.Catalog'}</span>
          </li>
        {/if}
        {if $product.depth > 0}
          <li class="product-specs__row">
            <span class="product-specs__label">{l s='Długość' d='Shop.Theme.Catalog'}</span>
            <span class="product-specs__value">{$product.depth|string_format:"%g"|replace:'.':','|escape:'html':'UTF-8'} {l s='cm' d='Shop.Theme.Catalog'}</span>
          </li>
        {/if}
        {if $product.weight > 0}
          <li class="product-specs__row">
            <span class="product-specs__label">{l s='Waga' d='Shop.Theme.Catalog'}</span>
            <span class="product-specs__value">{$product.weight|string_format:"%g"|replace:'.':','|escape:'html':'UTF-8'} {$product.weight_unit|escape:'html':'UTF-8'}</span>
          </li>
        {/if}
      {/block}

      {block name='product_information'}
        {if $hasProductInformation}
          {$productInformationHtml nofilter}
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
