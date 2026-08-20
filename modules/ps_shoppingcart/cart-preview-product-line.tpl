{**
 * For the full copyright and license information, please view the
 * LICENSE.md file that was distributed with this source code.
 *
 * One product row of the cart preview panel (matches the Modal Figma design).
 *}

<a class="cart-preview-product__image" href="{$product.url}" tabindex="-1" aria-hidden="true">
  {if $product.default_image}
    <img
      class="cart-preview-product__img"
      src="{$product.default_image.medium.url}"
      alt="{$product.name|escape:'html':'UTF-8'}"
      loading="lazy"
      width="96"
      height="96"
    >
  {else}
    <img
      class="cart-preview-product__img"
      src="{$urls.no_picture_image.bySize.medium_default.url}"
      alt="{$product.name|escape:'html':'UTF-8'}"
      loading="lazy"
      width="96"
      height="96"
    >
  {/if}
</a>

<div class="cart-preview-product__info">
  <a class="cart-preview-product__name" href="{$product.url}">{$product.name}</a>

  {foreach from=$product.attributes key="attribute" item="value"}
    <div class="cart-preview-product__attr">{$attribute}: {$value}</div>
  {/foreach}

  {if empty($product.is_gift)}
    <div class="cart-preview-product__qty" role="group" aria-label="{l s='Change quantity' d='Shop.Theme.Actions'}" data-ps-ref="cart-preview-qty">
      <a
        class="cart-preview-product__qty-btn"
        href="{$product.down_quantity_url}{if isset($product.pp_settings.qty_step) && $product.pp_settings.qty_step > 0}&amp;qty={$product.pp_settings.qty_step}{/if}"
        rel="nofollow"
        data-ps-action="cart-preview-update"
        data-ps-qty-op="down"
        data-id-product="{$product.id_product|escape:'javascript'}"
        data-id-product-attribute="{$product.id_product_attribute|escape:'javascript'}"
        data-id-customization="{$product.id_customization|escape:'javascript'}"
        data-link-action="update-quantity-in-cart"
        aria-label="{l s='Decrease quantity' d='Shop.Theme.Actions'}"
      >&minus;</a>
      <span class="cart-preview-product__qty-value" data-ps-target="cart-preview-qty-value" aria-live="polite">{if isset($product.cart_quantity_to_display)}{$product.cart_quantity_to_display nofilter}{elseif isset($product.pp_product_quantity)}{$product.pp_product_quantity}{else}{$product.quantity}{/if}</span>
      <a
        class="cart-preview-product__qty-btn"
        href="{$product.up_quantity_url}{if isset($product.pp_settings.qty_step) && $product.pp_settings.qty_step > 0}&amp;qty={$product.pp_settings.qty_step}{/if}"
        rel="nofollow"
        data-ps-action="cart-preview-update"
        data-ps-qty-op="up"
        data-id-product="{$product.id_product|escape:'javascript'}"
        data-id-product-attribute="{$product.id_product_attribute|escape:'javascript'}"
        data-id-customization="{$product.id_customization|escape:'javascript'}"
        data-link-action="update-quantity-in-cart"
        aria-label="{l s='Increase quantity' d='Shop.Theme.Actions'}"
      >+</a>
    </div>
  {else}
    <div class="cart-preview-product__attr">{l s='Gift' d='Shop.Theme.Checkout'} &times; {$product.quantity}</div>
  {/if}
</div>

<div class="cart-preview-product__right">
  <span class="cart-preview-product__price">{$product.total}</span>
  {if empty($product.is_gift)}
    <a
      class="cart-preview-product__remove"
      href="{$product.remove_from_cart_url}"
      rel="nofollow"
      data-ps-action="cart-preview-update"
      data-id-product="{$product.id_product|escape:'javascript'}"
      data-id-product-attribute="{$product.id_product_attribute|escape:'javascript'}"
      data-id-customization="{$product.id_customization|escape:'javascript'}"
      data-link-action="delete-from-cart"
      aria-label="{l s='Remove %productName% from cart' sprintf=['%productName%' => $product.name] d='Shop.Theme.Checkout'}"
    >{l s='usuń' d='Shop.Theme.Actions'}</a>
  {/if}
</div>
