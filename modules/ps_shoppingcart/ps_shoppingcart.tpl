{**
 * For the full copyright and license information, please view the
 * LICENSE.md file that was distributed with this source code.
 *}

<div id="_desktop_ps_shoppingcart" class="order-5{if isset($hbe_cart_hover_enabled) && $hbe_cart_hover_enabled} ps-shoppingcart--has-preview{/if}">
  <div class="ps-shoppingcart">
    <div class="header-block d-flex align-items-center blockcart cart-preview {if $cart.products_count> 0}header-block--active{else}inactive{/if}" data-refresh-url="{$refresh_url}">
      {if $cart.products_count> 0}
        <a class="header-block__action-btn pe-md-0" rel="nofollow" href="{$cart_url}" aria-label="{l s='View cart (%d products)' d='Shop.Theme.Checkout' sprintf=[$cart.products_count]}">
      {else}
        <span class="header-block__action-btn pe-md-0">
      {/if}

      <span class="header-block__icon-wrap">
        <svg class="header-block__icon" width="20" height="20" viewBox="0 0 20 20" fill="none" xmlns="http://www.w3.org/2000/svg" aria-hidden="true"><path d="M11.8465 3.77778C11.8465 3.30628 11.6521 2.8541 11.306 2.5207C10.9598 2.1873 10.4904 2 10.0009 2C9.51144 2 9.042 2.1873 8.69588 2.5207C8.34976 2.8541 8.15532 3.30628 8.15532 3.77778M16.7005 7.952L17.9786 15.952C18.019 16.2052 18.0021 16.4638 17.9291 16.7102C17.8561 16.9565 17.7287 17.1847 17.5556 17.3792C17.3826 17.5737 17.1679 17.7299 16.9263 17.837C16.6847 17.9442 16.422 17.9998 16.156 18H3.84583C3.57972 18 3.31675 17.9446 3.07496 17.8376C2.83316 17.7306 2.61825 17.5744 2.44496 17.3799C2.27167 17.1854 2.14411 16.9571 2.071 16.7106C1.9979 16.4641 1.981 16.2053 2.02145 15.952L3.29953 7.952C3.36657 7.53208 3.58752 7.14917 3.92235 6.87262C4.25719 6.59608 4.68377 6.44418 5.12483 6.44444H14.877C15.3179 6.44439 15.7443 6.59639 16.0789 6.87291C16.4136 7.14944 16.6335 7.53223 16.7005 7.952Z" stroke="#242424" stroke-linecap="round" stroke-linejoin="round"/></svg>
        <span class="header-block__badge">{$cart.products_count}</span>
      </span>

      {if $cart.products_count> 0}
        </a>
      {else}
        </span>
      {/if}

      {if isset($hbe_cart_hover_enabled) && $hbe_cart_hover_enabled && $cart.products_count > 0}
        <div class="cart-preview-panel" data-ps-ref="cart-preview-panel">
          {include file='module:ps_shoppingcart/cart-preview.tpl'}
        </div>
      {/if}
    </div>
  </div>
</div>
