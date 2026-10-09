{**
 * For the full copyright and license information, please view the
 * LICENSE.md file that was distributed with this source code.
 *}
{if !$configuration.is_catalog}
  <div class="product__add-to-cart-container product-add-to-cart js-product-add-to-cart">
    {block name='product_availability'}
      <div
        id="product-availability"
        class="product__availability js-product-availability"
        {if empty($product.availability_message) && empty($product.delivery_information)}
          hidden
        {/if}
      >
        {if !empty($product.availability_message)}
          {** First, we prepare the icons and colors we want to use *}
          {if $product.availability == 'in_stock'}
            {assign 'availability_icon' 'E5CA'}
            {assign 'availability_class' 'text-success'}
          {elseif $product.availability == 'available'}
            {assign 'availability_icon' 'E002'}
            {assign 'availability_class' 'text-warning'}
          {elseif $product.availability == 'last_remaining_items'}
            {assign 'availability_icon' 'E002'}
            {assign 'availability_class' 'text-warning'}
          {else}
            {assign 'availability_icon' 'E14B'}
            {assign 'availability_class' 'text-danger'}
          {/if}

          {** And render the availability message with icon *}
          <div class="product__availability-status {$availability_class}" aria-live="off" data-ps-ref="product-availability">
            <i class="product__availability-icon material-icons rtl-no-flip" aria-hidden="true">&#x{$availability_icon};</i>

            <div class="product__availability-messages">
              <span class="visually-hidden">{l s='Product availability:' d='Shop.Theme.Global'}</span>
              <span>{$product.availability_message}</span>

              {if !empty($product.availability_submessage)}
                <small class="d-block">{$product.availability_submessage}</small>
              {/if}
            </div>
          </div>
        {/if}

        {block name='product_delivery_times'}
          {if !empty($product.delivery_information)}
            <div class="product__delivery-infos">{$product.delivery_information}</div>
          {/if}
        {/block}
      </div>
    {/block}

    {block name='product_quantity'}
      {* .product-quantity needed for JS *}
      <div class="product__actions-qty-add product-quantity">
        <div class="product-actions__quantity product__quantity quantity-button js-quantity-button">
          {include file='components/qty-input.tpl'
            attributes=[
              "id" => "quantity_wanted",
              "class" => "form-control js-quantity-wanted",
              "value" => "{$product.quantity_wanted}",
              "min" => "{$product.quantity_required}"
            ]
          }
        </div>

        {* Wariant bez stanu przy "nie pozwalaj zamawiac": zamiast przycisku komunikat,
           a formularz powiadomienia (ps_emailalerts) renderuje sie ponizej.
           Ten div podmienia core.js przy zmianie wariantu (selector .add). *}
        {$isOutOfStock = $product.availability == 'unavailable' && $product.quantity <= 0}
        <div class="product__add-to-cart add{if $isOutOfStock} product__add-to-cart--unavailable{/if}">
          {if $isOutOfStock}
            <p class="product__unavailable" role="status">
              {l s='Tego wariantu nie ma obecnie na stanie, więc nie można go zamówić. Zapisz się poniżej, a damy znać, gdy wróci.' d='Shop.Theme.Catalog'}
            </p>
          {/if}
          <button
            class="product__add-to-cart-button btn btn-primary"
            data-button-action="add-to-cart"
            type="submit"
            {if $isOutOfStock}
              hidden
            {/if}
            {if !$product.add_to_cart_url}
              aria-disabled="true"
              disabled
            {/if}
            data-ps-ref="add-to-cart"
            aria-label="{l s='Add to cart %product_name%' sprintf=['%product_name%' => $product.name] d='Shop.Theme.Actions'}"
            title="{l s='Add to cart %product_name%' sprintf=['%product_name%' => $product.name] d='Shop.Theme.Actions'}"
          >
            {l s='Add to cart' d='Shop.Theme.Actions'}
          </button>
        </div>
        {* displayProductActions (wishlist) moved to the product header — see product.tpl *}
      </div>
    {/block}

    {block name='product_minimal_quantity'}
      <div
        class="product__minimal-quantity product-minimal-quantity js-product-minimal-quantity"
        {if $product.minimal_quantity <= 1}
          hidden
        {/if}
      >
        {if $product.minimal_quantity > 1}
          <i class="material-icons" aria-hidden="true">&#xE88F;</i>
          {l
            s='The minimum purchase order quantity for the product is %quantity%.'
            d='Shop.Theme.Checkout'
            sprintf=['%quantity%' => $product.minimal_quantity]
          }
        {/if}
      </div>
    {/block}
  </div>
{/if}
