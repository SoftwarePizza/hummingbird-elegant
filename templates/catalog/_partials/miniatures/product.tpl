{**
 * For the full copyright and license information, please view the
 * LICENSE.md file that was distributed with this source code.
 *}
{$componentName = 'product-miniature'}

{block name='product_miniature_item'}
  <article
    class="{$componentName} js-{$componentName}{if isset($product.pp_css) && !empty($product.pp_css)} {$product.pp_css}{/if}{if isset($product.id_pp_template)} id_pp_template_{$product.id_pp_template}{/if}"
    data-id-product="{$product.id_product}"
    data-id-product-attribute="{$product.id_product_attribute}"
  >
    <div class="{$componentName}__inner">
      {block name='product_miniature_top'}
        {* `thumbnail-container` is the hook blockwishlist's list JS looks for to
           append the wishlist (heart) button — keep it alongside the BEM class. *}
        <div class="{$componentName}__top thumbnail-container">
          {* Wishlist button is injected here by the blockwishlist module JS
             (.thumbnail-container) and restyled with the custom heart icon
             in src/scss/prestashop/modules/_blockwishlist.scss. *}

          {include file='catalog/_partials/product-flags.tpl'}

          {include file='catalog/_partials/miniatures/product-image.tpl'}

          {include file='catalog/_partials/miniatures/product-quickview.tpl'}
        </div>
      {/block}

      {block name='product_miniature_bottom'}
        <div class="{$componentName}__bottom">
          <div class="{$componentName}__infos">
            {block name='product_name'}
              {* `title` daje pelna nazwe w dymku: CSS (custom, sekcja 39) ucina
                 podpis do dwoch linii z wielokropkiem, wiec dluzsza nazwa jest
                 na ekranie niepelna, choc w HTML-u siedzi w calosci. *}
              <a class="{$componentName}__title" href="{$product.url}" title="{$product.name}" aria-label="{l s='View product %product_name%' sprintf=['%product_name%' => $product.name] d='Shop.Theme.Catalog'}">{$product.name}</a>
            {/block}

            {block name='product_variants'}
              {* Zwijany wybor koloru na kaflu (wzor: chanel.com, jak na karcie
                 produktu): zwiniete = stosik pierwszych probek + licznik +N
                 + strzalka; rozwiniecie to lista kolorow z nazwami — kazdy
                 wiersz linkuje do wariantu. Na desktopie panel wisi absolutnie
                 nad kaflami ponizej, na mobile custom.css robi z niego dolny
                 arkusz (sekcja 46). main_variants nie niesie referencji,
                 wiec numeru kombinacji tu nie ma — jest na karcie produktu. *}
              {if $product.main_variants}
                {assign var=vminiCount value=$product.main_variants|count}
                <details class="variant-mini js-variant-picker {$componentName}__variants">
                  <summary class="variant-mini__toggle">
                    <span class="visually-hidden">{$product.name}</span>
                    <span class="variant-mini__stack" aria-hidden="true">
                      {foreach from=$product.main_variants item=variant name=vmini}
                        {if $smarty.foreach.vmini.index < 5}
                          <span class="color variant-mini__swatch{if $variant.texture} texture{/if}"
                            {if $variant.texture}style="background-image: url({$variant.texture})"
                            {elseif $variant.html_color_code}style="background-color: {$variant.html_color_code}"{/if}></span>
                        {/if}
                      {/foreach}
                    </span>
                    {if $vminiCount > 5}
                      <span class="variant-mini__count" aria-hidden="true">+{$vminiCount-5}</span>
                    {/if}
                    <i class="material-icons variant-mini__chevron" aria-hidden="true">&#xE5CF;</i>
                  </summary>
                  <div class="variant-mini__panel">
                    <div class="variant-mini__head">
                      <span class="variant-mini__title">{$product.name} &middot; {$vminiCount}</span>
                      <button type="button" class="variant-mini__close js-variant-close" aria-label="{l s='Close' d='Shop.Theme.Global'}">
                        <i class="material-icons" aria-hidden="true">&#xE5CD;</i>
                      </button>
                    </div>
                    <div class="variant-mini__list">
                      {foreach from=$product.main_variants item=variant}
                        <a href="{$variant.url}" class="variant-mini__row" title="{$variant.name}">
                          <span class="color{if $variant.texture} texture{/if}"
                            {if $variant.texture}style="background-image: url({$variant.texture})"
                            {elseif $variant.html_color_code}style="background-color: {$variant.html_color_code}"{/if}
                            aria-hidden="true"></span>
                          <span class="variant-mini__name">{$variant.name}</span>
                        </a>
                      {/foreach}
                    </div>
                  </div>
                </details>
              {/if}
            {/block}

            {if $product.show_price}
              <div class="{$componentName}__prices">
                {block name='product_price'}
                  {hook h='displayProductPriceBlock' product=$product type="before_price"}

                  <div class="{$componentName}__price" aria-label="{l s='Price' d='Shop.Theme.Catalog'}">
                    {capture name='custom_price'}{hook h='displayProductPriceBlock' product=$product type='custom_price' hook_origin='products_list'}{/capture}
                    {if '' !== $smarty.capture.custom_price}
                      {$smarty.capture.custom_price nofilter}
                    {else}
                      {if isset($product.price_to_display)}{$product.price_to_display nofilter}{else}{$product.price}{/if}
                    {/if}
                    {* Dopisek „(brutto)" celowo zdjety: w kaflu kazda cena jest
                       brutto, a przy cenie z jednostka („123,00 zl za m.b.")
                       nawias lamal sie do drugiej linii i zabieral miejsce
                       nazwie produktu. Informacja o podatku zostaje na karcie
                       produktu (_partials/product-prices.tpl, .product__tax-label). *}
                  </div>

                  {hook h='displayProductPriceBlock' product=$product type='unit_price'}

                  {hook h='displayProductPriceBlock' product=$product type='weight'}
                {/block}

                {block name='product_discount_price'}
                  {if $product.show_price}
                    <div class="{$componentName}__discount-price">
                      {if $product.has_discount}
                        {hook h='displayProductPriceBlock' product=$product type="old_price"}

                        <span class="{$componentName}__regular-price" aria-label="{l s='Regular price' d='Shop.Theme.Catalog'}">{if isset($product.regular_price_to_display)}{$product.regular_price_to_display nofilter}{else}{$product.regular_price}{/if}</span>
                      {/if}
                    </div>
                  {/if}
                {/block}
              </div>
            {/if}

            {block name='product_reviews'}
              {hook h='displayProductListReviews' product=$product}
            {/block}
          </div>

          {block name='product_actions'}
            <div class="{$componentName}__actions">
              {if $product.add_to_cart_url}
                <form class="{$componentName}__form" action="{$urls.pages.cart}" method="post">
                  <input type="hidden" value="{$product.id_product}" name="id_product">
                  {if $product.id_product_attribute}
                      <input type="hidden" value="{$product.id_product_attribute}" name="id_product_attribute">
                  {/if}
                  <input type="hidden" name="token" value="{$static_token}">
  
                  {* Quantity stepper intentionally hidden on listings — kept only in the cart and on the product page.
                     Hidden input preserves the wanted/min quantity so add-to-cart still posts the right value. *}
                  <input type="hidden" name="qty" value="{$product.quantity_wanted|default:$product.quantity_required|default:1}">
  
                  <button 
                    data-button-action="add-to-cart" 
                    class="product-miniature__add btn btn-primary "
                    aria-label="{l s='Add to cart %product_name%' sprintf=['%product_name%' => $product.name] d='Shop.Theme.Actions'}"
                    title="{l s='Add to cart %product_name%' sprintf=['%product_name%' => $product.name] d='Shop.Theme.Actions'}"
                    data-ps-ref="add-to-cart"
                  >
                    
                    <span class="product-miniature__add-text-display">{l s='Add to cart' d='Shop.Theme.Actions'}</span>
                  </button>
                </form>
              {else}
                <a href="{$product.url}" class="product-miniature__details btn btn-outline-primary" aria-label="{l s='View product %product_name%' sprintf=['%product_name%' => $product.name] d='Shop.Theme.Catalog'}">
                  {l s='See details' d='Shop.Theme.Actions'}
                </a>
              {/if}
            </div>
          {/block}
        </div>
      {/block}
    </div>
  </article>
{/block}
