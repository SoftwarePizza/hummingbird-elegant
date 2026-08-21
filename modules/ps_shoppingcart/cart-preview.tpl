{**
 * For the full copyright and license information, please view the
 * LICENSE.md file that was distributed with this source code.
 *
 * Shared cart preview content (Modal Figma design). Reused by:
 *  - the header hover panel (ps_shoppingcart.tpl)
 *  - the add-to-cart modal replacement (modal.tpl)
 *
 * Expected variables: $cart, $cart_url, $hbe_cart_free_shipping
 *}

<div
  class="cart-preview"
  data-ps-ref="cart-preview"
  {if isset($hbe_cart_preview_url)}data-ps-data='{ldelim}"refreshUrl":"{$hbe_cart_preview_url|escape:'javascript':'UTF-8'}"{rdelim}'{/if}
>
  <p class="cart-preview__title">
    {l s='Twój koszyk' d='Shop.Theme.Checkout'} ({$cart.products_count})
  </p>

  {if isset($hbe_cart_free_shipping) && $hbe_cart_free_shipping.enabled}
    <div class="cart-preview__shipping">
      {if $hbe_cart_free_shipping.reached}
        <p class="cart-preview__shipping-label">
          {l s='Masz darmową dostawę!' d='Shop.Theme.Checkout'}
        </p>
      {else}
        <p class="cart-preview__shipping-label">
          {l s='Do darmowej dostawy brakuje Ci %amount%' sprintf=['%amount%' => $hbe_cart_free_shipping.remaining_formatted] d='Shop.Theme.Checkout'}
        </p>
      {/if}
      <div
        class="cart-preview__progress"
        role="progressbar"
        aria-valuenow="{$hbe_cart_free_shipping.progress}"
        aria-valuemin="0"
        aria-valuemax="100"
      >
        <span class="cart-preview__progress-bar" style="width: {$hbe_cart_free_shipping.progress}%;"></span>
      </div>
    </div>
  {/if}

  {* Progi rabatowe z kodami (hummingbird_editor) — podgląd renderuje się na
     serwerze przy każdej zmianie (cartpreview.php), więc pasek nadąża sam. *}
  {hook h='displayHbeTiers' ctx='preview'}

  {if $cart.products_count > 0}
    <ul class="cart-preview__products">
      {foreach from=$cart.products item=product}
        <li class="cart-preview__product cart-preview-product">
          {include file='module:ps_shoppingcart/cart-preview-product-line.tpl' product=$product}
        </li>
      {/foreach}
    </ul>

    <div class="cart-preview__footer">
      {if isset($cart.subtotals.shipping) && $cart.subtotals.shipping.amount}
        <div class="cart-preview__row">
          <span class="cart-preview__row-label">{l s='Wysyłka' d='Shop.Theme.Checkout'}</span>
          <span class="cart-preview__row-value">{$cart.subtotals.shipping.value}</span>
        </div>
      {/if}
      <div class="cart-preview__row cart-preview__row--total">
        <span class="cart-preview__row-label">{l s='Razem' d='Shop.Theme.Checkout'}</span>
        <span class="cart-preview__row-value">{$cart.totals.total.value}</span>
      </div>

      <a class="cart-preview__cta" href="{$cart_url|escape:'htmlall':'UTF-8'}">
        {l s='Zobacz koszyk' d='Shop.Theme.Actions'}
      </a>
    </div>
  {else}
    <p class="cart-preview__empty">{l s='Twój koszyk jest pusty.' d='Shop.Theme.Checkout'}</p>
  {/if}
</div>
