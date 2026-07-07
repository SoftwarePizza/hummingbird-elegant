{**
 * For the full copyright and license information, please view the
 * LICENSE.md file that was distributed with this source code.
 *}
{extends file=$layout}

{block name='head' append}
  <meta property="og:type" content="product">
  <meta content="{$product.url}">

  {if $product.cover}
    <meta property="og:image" content="{$product.cover.large.url}">
  {/if}

  {if $product.show_price}
    <meta property="product:pretax_price:amount" content="{$product.price_tax_exc}">
    <meta property="product:pretax_price:currency" content="{$currency.iso_code}">
    <meta property="product:price:amount" content="{$product.price_amount}">
    <meta property="product:price:currency" content="{$currency.iso_code}">
  {/if}
  {if isset($product.weight) && ($product.weight != 0)}
  <meta property="product:weight:value" content="{$product.weight}">
  <meta property="product:weight:units" content="{$product.weight_unit}">
  {/if}
{/block}

{block name='head_microdata_special'}
  {include file='_partials/microdata/product-jsonld.tpl'}
{/block}

{block name='content'}
  {* FIRST PART - PHOTO, NAME, PRICES, ADD TO CART*}
  <div class="product__container product-container js-product-container" data-ps-ref="product-container">
    <div class="product__left">
      {block name='product_cover_thumbnails'}
        {include file='catalog/_partials/product-cover-thumbnails.tpl'}
      {/block}
    </div>

    <div class="product__right" data-ps-ref="product-right" tabindex="-1">
      {block name='product_header'}
        <div class="product__header">
          <div class="product__header-titles">
            {block name='product_manufacturer'}
            {if !empty($product_manufacturer->name) && !empty($product_manufacturer->url)}
              <div class="product__manufacturer">
                <a href="{$product_manufacturer->url}" aria-label="{l s='Product brand: %brand_name%' sprintf=['%brand_name%' => $product_manufacturer->name] d='Shop.Theme.Catalog'}">
                  {$product_manufacturer->name}
                </a>
              </div>
            {/if}
            {/block}
            <h1 class="product__name h2 {if !empty($product_manufacturer->name) && !empty($product_brand_url)}mb-1{/if}">
              {block name='page_title'}{$product.name}{/block}
            </h1>
          </div>

          {* Figma: circular wishlist button pinned top-right of the info block.
             The blockwishlist markup (displayProductActions) is moved here from
             the add-to-cart row. *}
          <div class="product__header-actions js-product-header-actions">
            {hook h='displayProductActions' product=$product}
          </div>
        </div>
      {/block}

      {block name='product_prices'}
        {include file='catalog/_partials/product-prices.tpl'}
      {/block}

      {* Product summary under the price. Clamped to three lines; the toggle
         below reveals the rest inline. The full description stays in the
         "Opis produktu" section further down the page.
         Source is configurable in hummingbird_editor → Karta produktu
         ($hbe_product_summary_source: '' = standard/short, 'short', 'full'
         — 'full' falls back to the short description when empty). *}
      {block name='product_description_short'}
        {if isset($hbe_product_summary_source) && $hbe_product_summary_source === 'full' && $product.description}
          {assign var=hbeSummaryHtml value=$product.description}
        {else}
          {assign var=hbeSummaryHtml value=$product.description_short}
        {/if}
        {if $hbeSummaryHtml}
          <div class="product__summary" data-ps-ref="product-summary">
            <div class="product__description-short rich-text" data-ps-ref="product-summary-text">{$hbeSummaryHtml nofilter}</div>
            {* Revealed by JS only when the summary actually overflows. *}
            <button
              type="button"
              class="product__see-full"
              data-ps-action="toggle-product-summary"
              aria-expanded="false"
              hidden
            >
              <span class="product__see-full-label" data-summary-more>{l s='zobacz pełny opis' d='Shop.Theme.Catalog'}</span>
              <span class="product__see-full-label" data-summary-less>{l s='zwiń opis' d='Shop.Theme.Catalog'}</span>
            </button>
          </div>
        {/if}
      {/block}

      {block name='product_customization'}
        {if $product.is_customizable && count($product.customizations.fields)}
          {include file='catalog/_partials/product-customization.tpl' customizations=$product.customizations}
        {/if}
      {/block}

      <div class="product__actions js-product-actions">
        {block name='product_buy'}
          <form action="{$urls.pages.cart}" method="post" id="add-to-cart-or-refresh">
            <input type="hidden" name="token" value="{$static_token}">
            <input type="hidden" name="id_product" value="{$product.id}" id="product_page_product_id">
            <input type="hidden" name="id_customization" value="{$product.id_customization}" id="product_customization_id" class="js-product-customization-id">

            {block name='product_variants'}
              {include file='catalog/_partials/product-variants.tpl'}
            {/block}

            {block name='product_pack'}
              {include file='catalog/_partials/product-pack.tpl'}
            {/block}

            {block name='product_discounts'}
              {include file='catalog/_partials/product-discounts.tpl'}
            {/block}

            {block name='product_add_to_cart'}
              {include file='catalog/_partials/product-add-to-cart.tpl'}
            {/block}

            {block name='product_additional_info'}
              {include file='catalog/_partials/product-additional-info.tpl'}
            {/block}

            {block name='product_out_of_stock'}
              {hook h='actionProductOutOfStock' product=$product}
            {/block}

            {* Input to refresh product HTML removed, block kept for compatibility with themes *}
            {block name='product_refresh'}{/block}
          </form>
        {/block}
      </div>

      {* Figma: shipping perk + product enquiry under the buy box. *}
      {block name='product_shipping_info'}
        <ul class="product__shipping-info">
          <li class="product__shipping-item">
            <i class="material-icons" aria-hidden="true">&#xE558;</i>
            <span>{l s='Darmowa dostawa od 250 zł' d='Shop.Theme.Catalog'}</span>
          </li>
          <li class="product__shipping-item">
            <a class="product__ask" href="{if isset($urls.pages.contact)}{$urls.pages.contact}{else}#{/if}">
              <i class="material-icons" aria-hidden="true">&#xE8FD;</i>
              <span>{l s='Zapytaj o produkt' d='Shop.Theme.Catalog'}</span>
            </a>
          </li>
        </ul>
      {/block}

      {* Custom hummingbird_editor hook (FAQ + related carousel). Do NOT call
         displayProductButtons here: it is an alias of
         displayProductAdditionalInfo, already executed in
         _partials/product-additional-info.tpl, so modules would render twice. *}
      {block name='product_buttons'}
        {hook h='displayProductSections' product=$product}
      {/block}

      {* Figma: product code line at the bottom of the buy column. *}
      {block name='product_reference_code'}
        {if !empty($product.reference_to_display)}
          <p class="product__reference">
            {l s='Kod produktu:' d='Shop.Theme.Catalog'} <span>{$product.reference_to_display}</span>
          </p>
        {/if}
      {/block}
    </div>
  </div>
  {* END OF FIRST PART *}

  {* SECOND PART - DESCRIPTION & DETAILS (Figma: Details) *}
  <section class="product__bottom">
    {block name='product_tabs'}
      <h2 class="product__bottom-title">{l s='Opis produktu' d='Shop.Theme.Catalog'}</h2>

      <div class="product__bottom-grid">
        <div class="product__bottom-left">
          {block name='product_description'}
            {if $product.description}
              <div class="product__description rich-text" id="product_description">
                {$product.description nofilter}
              </div>
            {/if}
          {/block}

          {block name='product_attachments'}
            {if $product.attachments}
              <div class="product__attachments" id="product_attachments">
                {foreach from=$product.attachments item=attachment}
                  <div class="attachment">
                    <p class="attachment__name">
                      {$attachment.name}
                    </p>

                    {if $attachment.description}
                      <p class="attachment__description">
                        {$attachment.description}
                      </p>
                    {/if}

                    <a class="attachment__link stretched-link"
                      href="{url entity='attachment' params=['id_attachment' => $attachment.id_attachment]}"
                      aria-label="{l s='Download %attachment_name%' sprintf=['%attachment_name%' => $attachment.name] d='Shop.Theme.Actions'}"
                    >
                      <i class="material-icons" aria-hidden="true">&#xE2C4;</i> {l s='Download' d='Shop.Theme.Actions'} ({$attachment.file_size_formatted})
                    </a>
                  </div>
                {/foreach}
              </div>
            {/if}
          {/block}

          {* Module hooked content, rendered flat below the description *}
          {foreach from=$product.extraContent item=extra key=extraKey}
            <div class="product__extra" id="extra_{$extraKey}" {foreach $extra.attr as $key => $val} {$key}="{$val}"{/foreach}>
              <h3 class="product__extra-title">{$extra.title}</h3>
              {$extra.content nofilter}
            </div>
          {/foreach}
        </div>

        <div class="product__bottom-specs">
          {block name='product_details'}
            {include file='catalog/_partials/product-details.tpl'}
          {/block}
        </div>
      </div>
    {/block}
  </section>
  {* END OF SECOND PART *}

  {block name='product_accessories'}
    {if $accessories}
      {include file='catalog/_partials/product-accessories.tpl'}
    {/if}
  {/block}

  {block name='product_footer'}
    {hook h='displayFooterProduct' product=$product category=$category}
  {/block}

  {block name='page_footer_container'}
    {block name='page_footer'}
    {/block}
  {/block}
{/block}
