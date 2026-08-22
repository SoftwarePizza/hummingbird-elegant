{**
 * For the full copyright and license information, please view the
 * LICENSE.md file that was distributed with this source code.
 *}

<div class="cart-summary__subtotals js-cart-summary-subtotals-container">
  {foreach from=$cart.subtotals item="subtotal"}
    {if $subtotal && $subtotal.value|count_characters> 0 && $subtotal.type !== 'tax'}
      {* „Rabat za wzięcie całości" (hummingbird_editor) — informacyjny: kwota
         jest już w cenach pozycji, nie odejmuje się od sumy. Nota to mówi. *}
      <div class="cart-summary__line{if $subtotal.type === 'hbe_allstock'} cart-summary__line--allstock{/if}" id="cart-subtotal-{$subtotal.type}">
        <span class="cart-summary__label">
            {$subtotal.label}
            {if $subtotal.type === 'hbe_allstock' && !empty($subtotal.hbe_note)}
              <small class="cart-summary__note">{$subtotal.hbe_note}</small>
            {/if}
        </span>

        <span class="cart-summary__value">
          {if 'discount' == $subtotal.type}-&nbsp;{elseif $subtotal.type === 'hbe_allstock'}&minus;&nbsp;{/if}{$subtotal.value}
        </span>
      </div>
    {/if}
  {/foreach}
</div>
