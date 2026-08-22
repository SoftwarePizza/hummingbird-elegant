{**
 * For the full copyright and license information, please view the
 * LICENSE.md file that was distributed with this source code.
 *}
{block name='cart_detailed_totals'}
  {* Wrapper is the ajax refresh target (core replaceWith on .js-cart-detailed-totals).
     The voucher stays nested here so a single refresh never duplicates the promo card. *}
  <div class="cart-summary__totals js-cart-detailed-totals">
    {* Progi rabatowe z kodami (hummingbird_editor): „dołóż X, a dostaniesz Y%”
       + aktywacja kodu jednym kliknięciem. Siedzi w tym wrapperze celowo —
       rdzeń podmienia go ajaxem po każdej zmianie ilości, więc pasek jest
       zawsze świeży bez własnego JS. Bez modułu hook renderuje pustkę. *}
    {hook h='displayHbeTiers' ctx='cart'}

    {* Promo code — own card on top, matching the Figma layout. *}
    {block name='cart_voucher'}
      {include file='checkout/_partials/cart-voucher.tpl'}
    {/block}

    {* Order summary — totals + checkout button. *}
    <div class="cart-summary__card cart-summary__card--totals">
      <div class="cart-summary__subtotals">
        {foreach from=$cart.subtotals item="subtotal"}
          {if $subtotal && $subtotal.value|count_characters> 0 && $subtotal.type !== 'tax'}
            {* Rabat za wzięcie całości (hummingbird_editor) siedzi już w cenach
               pozycji, więc — inaczej niż kupon — niczego nie odejmuje od sumy
               poniżej. Stąd własna klasa i nota pod etykietą: bez nich wiersz
               wyglądałby jak błąd w rachunku. *}
            <div class="cart-summary__line{if $subtotal.type === 'hbe_allstock'} cart-summary__line--allstock{/if}" id="cart-subtotal-{$subtotal.type}">
              <span class="cart-summary__label{if $subtotal.type === 'products'} js-subtotal{/if}">
                {if $subtotal.type === 'products'}
                  {$cart.summary_string}
                {else}
                  {$subtotal.label}
                {/if}
                {if $subtotal.type === 'hbe_allstock' && !empty($subtotal.hbe_note)}
                  <small class="cart-summary__note">{$subtotal.hbe_note}</small>
                {/if}
              </span>

              <span class="cart-summary__value">
                {if $subtotal.type === 'discount'}
                  -{$subtotal.value}
                {elseif $subtotal.type === 'hbe_allstock'}
                  &minus;{$subtotal.value}
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
