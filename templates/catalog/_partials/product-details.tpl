{**
 * For the full copyright and license information, please view the
 * LICENSE.md file that was distributed with this source code.
 *}
<div
  class="js-product-details product-specs"
  data-product="{$product.embedded_attributes|json_encode}"
>
  <div class="product-specs__tabs">
    <span class="product-specs__tab product-specs__tab--active">{l s='Ogólne parametry' d='Shop.Theme.Catalog'}</span>
  </div>

  <ul class="product-specs__list details__list">
    {block name='product_features'}
      {if $product.grouped_features}
        {foreach from=$product.grouped_features item=feature}
          <li class="product-specs__row details__item details__item--feature">
            <span class="product-specs__label">{$feature.name}</span>
            <span class="product-specs__value">{$feature.value|escape:'htmlall'|nl2br nofilter}</span>
          </li>
        {/foreach}
      {/if}
    {/block}

    {block name='product_manufacturer'}
      {if isset($product_manufacturer->id)}
        <li class="product-specs__row details__item details__item--manufacturer">
          <span class="product-specs__label">{l s='Brand' d='Shop.Theme.Catalog'}</span>
          <span class="product-specs__value">
            <a href="{$product_manufacturer->url}">{$product_manufacturer->name}</a>
          </span>
        </li>
      {/if}
    {/block}

    {block name='product_reference'}
      {if !empty($product.reference_to_display)}
        <li class="product-specs__row details__item details__item--reference">
          <span class="product-specs__label">{l s='Reference' d='Shop.Theme.Catalog'}</span>
          <span class="product-specs__value">{$product.reference_to_display}</span>
        </li>
      {/if}
    {/block}

    {block name='product_quantities'}
      {if $product.show_quantities}
        <li class="product-specs__row details__item details__item--quantities">
          <span class="product-specs__label">{l s='In stock' d='Shop.Theme.Catalog'}</span>
          <span class="product-specs__value" data-stock="{$product.quantity}" data-allow-oosp="{$product.allow_oosp}">{$product.quantity} {$product.quantity_label}</span>
        </li>
      {/if}
    {/block}

    {block name='product_availability_date'}
      {if $product.availability_date}
        <li class="product-specs__row details__item details__item--availability-date">
          <span class="product-specs__label">{l s='Availability date' d='Shop.Theme.Catalog'}</span>
          <span class="product-specs__value">{$product.availability_date}</span>
        </li>
      {/if}
    {/block}

    {block name='product_condition'}
      {if $product.condition}
        <li class="product-specs__row details__item details__item--condition">
          <span class="product-specs__label">{l s='Condition' d='Shop.Theme.Catalog'}</span>
          <span class="product-specs__value">{$product.condition.label}</span>
        </li>
      {/if}
    {/block}

    {block name='product_specific_references'}
      {if !empty($product.specific_references)}
        {foreach from=$product.specific_references item=reference key=key}
          <li class="product-specs__row details__item details__item--{$key|classname}">
            <span class="product-specs__label">{$key}</span>
            <span class="product-specs__value">{$reference}</span>
          </li>
        {/foreach}
      {/if}
    {/block}
  </ul>
</div>
