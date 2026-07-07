{**
 * For the full copyright and license information, please view the
 * LICENSE.md file that was distributed with this source code.
 *}
{extends file=$layout}

{block name='content'}
  <div class="cart-grid row">
    <!-- Left Block: cart product informations & shipping -->
    <div class="cart-grid__content col-lg-8">
      {block name='page_title_section'}
        <h1 class="cart__title">
          {l s='Koszyk' d='Shop.Theme.Checkout'}{if $cart.products_count > 0} ({$cart.products_count}){/if}
        </h1>
      {/block}

      {if isset($hbe_cart_free_shipping) && $hbe_cart_free_shipping.enabled}
        <div class="cart__shipping">
          {if $hbe_cart_free_shipping.reached}
            <p class="cart__shipping-label">
              {l s='Masz darmową dostawę!' d='Shop.Theme.Checkout'}
            </p>
          {else}
            <p class="cart__shipping-label">
              {l s='Do darmowej dostawy brakuje Ci %amount%' sprintf=['%amount%' => $hbe_cart_free_shipping.remaining_formatted] d='Shop.Theme.Checkout'}
            </p>
          {/if}
          <div
            class="cart__progress"
            role="progressbar"
            aria-valuenow="{$hbe_cart_free_shipping.progress}"
            aria-valuemin="0"
            aria-valuemax="100"
          >
            <span class="cart__progress-bar" style="width: {$hbe_cart_free_shipping.progress}%;"></span>
          </div>
        </div>
      {/if}

      {block name="cart_update_alert"}
        <div class="js-cart-update-alert" data-ps-data="{l s='has been removed from the cart.' d='Shop.Theme.Actions' js=1}" data-ps-data-close="{l s='Close' d='Shop.Theme.Actions' js=1}" aria-atomic="true"></div>
      {/block}

      <!-- cart products detailed -->
      <div class="cart-grid__products-details js-cart-container">
        {block name='cart_overview'}
          {include file='checkout/_partials/cart-detailed.tpl' cart=$cart}
        {/block}

        <!-- gift wrapping (rsgiftbag) -->
        {block name='hook_cart_gift_wrapping'}
          {hook h='displayCartGiftWrapping'}
        {/block}

        <!-- shipping informations -->
        {block name='hook_shopping_cart_footer'}
          {hook h='displayShoppingCartFooter'}
        {/block}
      </div>
    </div>

    <!-- Right Block: cart subtotal & cart total -->
    <div class="cart-grid__aside col-lg-4">
      <div class="cart-grid__aside-wrapper">
        <h2 class="visually-hidden">{l s='Order summary' d='Shop.Theme.Checkout'}</h2>

        {block name='cart_summary'}
          <div class="cart-summary js-cart-summary">
            {block name='hook_shopping_cart'}
              {hook h='displayShoppingCart'}
            {/block}

            {block name='cart_totals'}
              {include file='checkout/_partials/cart-detailed-totals.tpl' cart=$cart}
            {/block}
          </div>
        {/block}
      </div>
    </div>
  </div>

  <div class="cart-grid__footer row">
    {hook h='displayCrossSellingShoppingCart'}
  </div>
{/block}
