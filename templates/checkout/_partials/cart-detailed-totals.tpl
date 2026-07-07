{**
 * For the full copyright and license information, please view the
 * LICENSE.md file that was distributed with this source code.
 *}
{block name='cart_detailed_totals'}
  {* Wrapper is the ajax refresh target (core replaceWith on .js-cart-detailed-totals).
     The voucher stays nested here so a single refresh never duplicates the promo card. *}
  <div class="cart-summary__totals js-cart-detailed-totals">
    {* Promo code — own card on top, matching the Figma layout. *}
    {block name='cart_voucher'}
      {include file='checkout/_partials/cart-voucher.tpl'}
    {/block}

    {* Order summary — totals + checkout button. *}
    <div class="cart-summary__card cart-summary__card--totals">
      <div class="cart-summary__subtotals">
        {foreach from=$cart.subtotals item="subtotal"}
          {if $subtotal && $subtotal.value|count_characters> 0 && $subtotal.type !== 'tax'}
            <div class="cart-summary__line" id="cart-subtotal-{$subtotal.type}">
              <span class="cart-summary__label{if $subtotal.type === 'products'} js-subtotal{/if}">
                {if $subtotal.type === 'products'}
                  {$cart.summary_string}
                {else}
                  {$subtotal.label}
                {/if}
              </span>

              <span class="cart-summary__value">
                {if $subtotal.type === 'discount'}
                  -{$subtotal.value}
                {elseif $subtotal.type === 'shipping'}
                  {$subtotal.value}
                  <small class="cart-summary__value-inner">{hook h='displayCheckoutSubtotalDetails' subtotal=$subtotal}</small>
                {else}
                  {$subtotal.value}
                {/if}
              </span>
            </div>
          {/if}
        {/foreach}
      </div>

      {block name='cart_summary_totals'}
        {include file='checkout/_partials/cart-summary-totals.tpl' cart=$cart}
      {/block}

      {block name='cart_actions'}
        {include file='checkout/_partials/cart-detailed-actions.tpl' cart=$cart}
      {/block}
    </div>
  </div>
{/block}
