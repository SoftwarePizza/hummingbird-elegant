{**
 * For the full copyright and license information, please view the
 * LICENSE.md file that was distributed with this source code.
 *}
{if $product.show_price}
  <div class="product__prices js-product-prices">
    {block name='product_price'}
      <div class="product__prices-block">
        {* Figma: current price + tax label + (when discounted) struck regular
           price and a "-XX%" pill, all on one line. *}
        <div class="product__prices-inline product__prices-inline--small-gap">
          <div class="product__price">
            {capture name='custom_price'}{hook h='displayProductPriceBlock' product=$product type='custom_price' hook_origin='product_sheet'}{/capture}
            {if !empty($smarty.capture.custom_price)}
              {$smarty.capture.custom_price nofilter}
            {else}
              <span class="visually-hidden">{l s='Price: ' d='Shop.Theme.Catalog'}</span>
              {if isset($product.price_to_display)}{$product.price_to_display nofilter}{else}{$product.price}{/if}
            {/if}
          </div>

          <span class="product__tax-label">
            {if !$configuration.taxes_enabled}
              {l s='No tax' d='Shop.Theme.Catalog'}
            {elseif $configuration.display_taxes_label}
              {$product.labels.tax_long}
            {/if}

            {hook h='displayProductPriceBlock' product=$product type="price"}
            {hook h='displayProductPriceBlock' product=$product type="after_price"}
          </span>

          {block name='product_unit_price'}
            {if $displayUnitPrice}
              <span class="product__unit-price">
                {l s='(%unit_price%)' sprintf=['%unit_price%' => $product.unit_price_full] d='Shop.Theme.Catalog'}
              </span>
            {/if}
          {/block}

          {if $product.has_discount}
            {hook h='displayProductPriceBlock' product=$product type="old_price"}

            <span class="product__regular-price">
              <span class="visually-hidden">{l s='Regular price: ' d='Shop.Theme.Catalog'}</span>
              {if isset($product.regular_price_to_display)}{$product.regular_price_to_display nofilter}{else}{$product.regular_price}{/if}
            </span>

            {if $product.discount_type === 'percentage'}
              <span class="product__discount-badge">-{$product.discount_percentage_absolute}</span>
            {else}
              <span class="product__discount-badge">-{$product.discount_to_display}</span>
            {/if}
          {/if}
        </div>

        {* Omnibus (EU): lowest price in the last 30 days, shown when discounted.
           Uses the regular price as the reference; when the Core "Display the
           lowest price" setting is enabled it exposes the real 30-day figure via
           displayProductPriceBlock, which will render inside this block. *}
        {if $product.has_discount}
          <div class="product__lowest-price">
            {* Fraza jest ta sama co w starym szablonie („…w ciągu 30 dni przed
               obniżką:”) — ten klucz ma w ps_translation komplet 17 języków.
               Kwota pogrubiona, bo w starym sklepie tak wyglądała i o nią
               w tym komunikacie chodzi. *}
            {l s='Lowest price in the last 30 days before discount: ' d='Shop.Theme.Catalog'}
            <span class="product__lowest-price-value">{if isset($product.regular_price_to_display)}{$product.regular_price_to_display nofilter}{else}{$product.regular_price}{/if}</span>
          </div>
        {/if}

        {block name='product_pack_price'}
          {if $displayPackPrice}
            <span class="product__pack-price">
              {l s='Instead of %price%' d='Shop.Theme.Catalog' sprintf=['%price%' => $noPackPrice]}
            </span>
          {/if}
        {/block}

        {block name='product_ecotax'}
          {if $product.ecotax.amount > 0}
            <div class="product__tax-infos">
              <span class="product__ecotax-price">
                {l s='Including %amount% for ecotax' d='Shop.Theme.Catalog' sprintf=['%amount%' => $product.ecotax.value]}
                {if $product.has_discount}
                  {l s='(not impacted by the discount)' d='Shop.Theme.Catalog'}
                {/if}
              </span>
            </div>
          {/if}
        {/block}

        {block name='product_without_taxes'}
          {if $priceDisplay == 2}
            <span class="product__taxless-price">{l s='%price% tax excl.' d='Shop.Theme.Catalog' sprintf=['%price%' => $product.price_tax_exc]}</span>
          {/if}
        {/block}
      </div>
    {/block}

    {hook h='displayProductPriceBlock' product=$product type="weight" hook_origin='product_sheet'}
  </div>
{/if}
