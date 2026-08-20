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
              "data-value" => "{$product.quantity_wanted}",
              "step" => "{if isset($product.pp_qty_step) && $product.pp_qty_step > 0}{$product.pp_qty_step}{else}1{/if}",
              "inputmode" => "{if (isset($product.pp_qty_step) && $product.pp_qty_step > 0 && $product.pp_qty_step != $product.pp_qty_step|intval) || (isset($product.pp_qty_decimals) && $product.pp_qty_decimals > 0)}decimal{else}numeric{/if}",
              "pattern" => "{if (isset($product.pp_qty_step) && $product.pp_qty_step > 0 && $product.pp_qty_step != $product.pp_qty_step|intval) || (isset($product.pp_qty_decimals) && $product.pp_qty_decimals > 0)}[0-9]*[.,]?[0-9]*{else}[0-9]+{/if}",
              "min" => "{if is_array($product.quantity_required)}1{else}{$product.quantity_required}{/if}"
            ]
          }
        </div>

        <div class="product__add-to-cart add">
          <button
            class="product__add-to-cart-button btn btn-primary"
            data-button-action="add-to-cart"
            type="submit"
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

    {block name='product_stock_hint'}
      {* Ile jeszcze zostało na belce — pod przyciskiem koszyka, żeby klient nie
         musiał szukać stanu w specyfikacji pod opisem. Gdy po jego zamówieniu
         zostałaby końcówka krótsza niż próg z data-threshold (3 m), komunikat
         zmienia się w zachętę do zabrania całości razem z przyciskiem, który
         wpisuje pełny stan w pole ilości.

         Warianty przełącza JS (assets/js/custom.js, sekcja 4) — tutaj idzie
         wariant wyjściowy, więc sama informacja o stanie jest na stronie także
         bez JS-a. Blok pomijamy, gdy sklep pozwala zamawiać ponad stan
         (allow_oosp): wtedy żaden limit nie obowiązuje i zachęta kłamałaby.
         Warunek show_quantities niesie też decyzję pproperties — szablon
         z ukrytymi ilościami zeruje to pole (PP::productPresenterPresent). *}
      {* Włącznik i próg zachęty siedzą w hummingbird_editor (BO → Hummingbird →
         Karta produktu → „Stan magazynowy przy koszyku"). Brak wpisu w
         konfiguracji = blok włączony z progiem 3: świeży sklep ma zachowywać
         się tak, jak przed dołożeniem tych ustawień. *}
      {assign var=stock_hint_threshold value=Configuration::get('HBE_STOCK_HINT_THRESHOLD')|floatval}
      {if $stock_hint_threshold <= 0}{assign var=stock_hint_threshold value=3}{/if}
      {if !empty($product.show_quantities) && empty($product.allow_oosp) && $product.quantity > 0 && Configuration::get('HBE_STOCK_HINT_ENABLED') !== '0'}
        {if isset($product.quantity_to_display)}
          {assign var=stock_to_display value=$product.quantity_to_display|strip_tags}
        {else}
          {assign var=stock_to_display value=$product.quantity|cat:' '|cat:$product.quantity_label}
        {/if}
        {* Teksty jadą do JS-a z nietkniętym %quantity% — podstawia je dopiero
           on, bo liczba zmienia się przy każdym ruchu w polu ilości. *}
        {capture assign='stock_hint_available'}{l s='In stock: %quantity% — that is the most you can add' d='Shop.Theme.Catalog'}{/capture}
        {capture assign='stock_hint_rest'}{l s='Only %quantity% would be left — take it all!' d='Shop.Theme.Catalog'}{/capture}
        {capture assign='stock_hint_all'}{l s='You are taking our whole stock — %quantity%. Thank you!' d='Shop.Theme.Catalog'}{/capture}
        {capture assign='stock_hint_over'}{l s='We only have %quantity% in stock' d='Shop.Theme.Catalog'}{/capture}
        {capture assign='stock_hint_button'}{l s='Take all — %quantity%' d='Shop.Theme.Catalog'}{/capture}
        {* Rabat za zabranie całości liczy hummingbird_editor na pozycji koszyka
           (hook actionProductPriceCalculation), więc cena na tej stronie się nie
           zmienia — komunikat mówi wprost, że odliczymy go w koszyku. Gdy rabat
           jest wyłączony, data-discount zostaje puste i JS bierze warianty bez
           obietnicy zniżki. *}
        {assign var=stock_hint_discount value=''}
        {if Configuration::get('HBE_ALLSTOCK_DISCOUNT_ENABLED')}
          {* Produkt już przeceniony ma własną, mniejszą stawkę — ten sam podział
             robi moduł przy liczeniu ceny pozycji koszyka, tyle że po swojej
             stronie rozpoznaje przecenę po specific price. *}
          {if !empty($product.has_discount)}
            {assign var=stock_hint_rate value=Configuration::get('HBE_ALLSTOCK_DISCOUNT_RATE_SALE')|floatval}
          {else}
            {assign var=stock_hint_rate value=Configuration::get('HBE_ALLSTOCK_DISCOUNT_RATE')|floatval}
          {/if}
          {if $stock_hint_rate > 0}
            {assign var=stock_hint_discount value=$stock_hint_rate|string_format:"%g"|cat:'%'}
          {/if}
        {/if}
        {capture assign='stock_hint_rest_discount'}{l s='Only %quantity% would be left — take it all and we will take %discount% off in the cart!' d='Shop.Theme.Catalog'}{/capture}
        {capture assign='stock_hint_all_discount'}{l s='You are taking our whole stock — %quantity%. We will take %discount% off in the cart!' d='Shop.Theme.Catalog'}{/capture}
        {capture assign='stock_hint_button_discount'}{l s='Take all — %quantity% (−%discount%)' d='Shop.Theme.Catalog'}{/capture}
        <div
          class="product__stock-hint js-product-stock-hint"
          data-stock="{$product.quantity}"
          data-stock-text="{$stock_to_display}"
          data-threshold="{$stock_hint_threshold}"
          data-msg-available="{$stock_hint_available}"
          data-msg-rest="{$stock_hint_rest}"
          data-msg-all="{$stock_hint_all}"
          data-msg-over="{$stock_hint_over}"
          data-msg-button="{$stock_hint_button}"
          data-discount="{$stock_hint_discount}"
          data-msg-rest-discount="{$stock_hint_rest_discount}"
          data-msg-all-discount="{$stock_hint_all_discount}"
          data-msg-button-discount="{$stock_hint_button_discount}"
        >
          <i class="product__stock-hint-icon material-icons rtl-no-flip" aria-hidden="true">&#xE88E;</i>
          <span class="product__stock-hint-text js-product-stock-hint-text" aria-live="polite">
            {l s='In stock: %quantity% — that is the most you can add' d='Shop.Theme.Catalog' sprintf=['%quantity%' => $stock_to_display]}
          </span>
          <button type="button" class="product__stock-hint-button js-product-stock-hint-button" hidden>
            {if $stock_hint_discount}
              {l s='Take all — %quantity% (−%discount%)' d='Shop.Theme.Catalog' sprintf=['%quantity%' => $stock_to_display, '%discount%' => $stock_hint_discount]}
            {else}
              {l s='Take all — %quantity%' d='Shop.Theme.Catalog' sprintf=['%quantity%' => $stock_to_display]}
            {/if}
          </button>
        </div>
      {/if}
    {/block}

    {hook h="displayProductPproperties" product=$product type="explanation"}
    {block name='product_minimal_quantity'}
      <div
        class="product__minimal-quantity product-minimal-quantity js-product-minimal-quantity"
        {if $product.minimal_quantity <= 1}
          hidden
        {/if}
      >
        {if isset($product.minimum_quantity_to_display)}{assign var=minimum_quantity_to_display value=$product.minimum_quantity_to_display}{else}{assign var=minimum_quantity_to_display value=$product.minimal_quantity}{/if}{if $product.minimal_quantity > 1}
          <i class="material-icons" aria-hidden="true">&#xE88F;</i>
          {l
            s='The minimum purchase order quantity for the product is %quantity%.'
            d='Shop.Theme.Checkout'
            sprintf=['%quantity%' => $minimum_quantity_to_display]
          }
        {/if}
      </div>
    {/block}
  </div>
{/if}
