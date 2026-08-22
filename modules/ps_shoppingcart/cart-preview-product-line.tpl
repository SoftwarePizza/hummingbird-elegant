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

  {* Probka (wksampleproduct) wyglada w podgladzie jak zwykla pozycja za 0 zl —
     dopisek mowi, czym jest. Flage dokłada hummingbird_editor. *}
  {if !empty($product.hbe_is_sample)}
    <div class="cart-preview-product__sample">
      <i class="material-icons rtl-no-flip" aria-hidden="true">&#xE14E;</i>
      {l s='Sample' d='Shop.Theme.Checkout'}
    </div>
  {/if}

  {* Ilosc pokazywana przy pozycji — tekst od pproperties: „1,5" dla tkanin na
     metry, „2 x 0,8 m" przy kilku kuponach, zwykla liczba dla sztuk. *}
  {capture name='qty_display'}{if isset($product.cart_quantity_to_display)}{$product.cart_quantity_to_display nofilter}{elseif isset($product.pp_product_quantity)}{$product.pp_product_quantity}{else}{$product.quantity}{/if}{/capture}

  {if !empty($product.is_gift)}
    <div class="cart-preview-product__attr">{l s='Gift' d='Shop.Theme.Checkout'} &times; {$product.quantity}</div>
  {elseif !empty($product.hbe_is_sample)}
    {* Probka (wksampleproduct) ma w koszyku cene 0 obowiazujaca dla kazdej
       ilosci, wiec zmiana ilosci przy tej pozycji rozdawalaby tkanine za darmo.
       Ilosc probek ustawia sie tam, gdzie sie je zamawia — na karcie produktu.
       Flage dokłada hummingbird_editor w actionPresentCart. *}
    <div class="cart-preview-product__qty cart-preview-product__qty--fixed">
      <span class="cart-preview-product__qty-value">{$smarty.capture.qty_display nofilter}</span>
    </div>
  {else}
    {* Zanim klient cokolwiek kliknie, JS musi wiedziec, CZYM jest ta pozycja —
       stad komplet data-ps-* ponizej (cart-preview.js):
        - tkanina na metry (pproperties, qty_policy = 2) — ilosc z przecinkiem,
          drobny krok 0,1 m osiagalny z klawiatury;
        - towar na sztuki — tylko liczby calkowite;
        - pozycja, ktorej przegladarka nie policzy („2 x 0,8 m", czyli kilka
          kuponow jednej tkaniny, oraz produkty z wymiarami) — zostaje bez
          data-ps-qty i czeka na serwer.
       Klikniecie zmienia ilosc o jedna cala jednostke (1 m albo 1 szt.), bo
       w podgladzie miesci sie tylko jedna para przyciskow. Nowa ilosc pokazuje
       sie od razu, a zadanie do serwera idzie dopiero, gdy klient przestanie
       ja zmieniac. *}
    {assign var=qty_now value=$product.quantity}
    {if isset($product.pp_product_quantity)}{assign var=qty_now value=$product.pp_product_quantity}{/if}
    {assign var=qty_kind value='units'}
    {if isset($product.pp_settings.qty_policy) && $product.pp_settings.qty_policy == 2}
      {assign var=qty_kind value='decimal'}
    {/if}
    {assign var=qty_step value=1}
    {if isset($product.pp_settings.qty_step) && $product.pp_settings.qty_step > 0}
      {assign var=qty_step value=$product.pp_settings.qty_step|floatval}
    {/if}
    {assign var=qty_predictable value=true}
    {if isset($product.pp_settings.qty_policy) && $product.pp_settings.qty_policy != 0 && $product.quantity > 1}
      {assign var=qty_predictable value=false}
    {/if}
    {if !empty($product.pp_settings.pp_ext) || !empty($product.pp_settings.pp_data_type)}
      {assign var=qty_predictable value=false}
    {/if}
    <div
      class="cart-preview-product__qty"
      role="group"
      aria-label="{l s='Change quantity' d='Shop.Theme.Actions'}"
      data-ps-ref="cart-preview-qty"
      data-ps-kind="{$qty_kind}"
      {if $qty_predictable}
        data-ps-qty="{$qty_now|floatval}"
        data-ps-step="{$qty_step}"
        data-ps-click-step="1"
        data-ps-min="{if isset($product.pp_settings.minimum_quantity) && $product.pp_settings.minimum_quantity > 0}{$product.pp_settings.minimum_quantity|floatval}{else}{$product.minimal_quantity|floatval}{/if}"
        data-ps-decimals="{if isset($product.pp_settings.qty_decimals) && $product.pp_settings.qty_decimals > 0}{$product.pp_settings.qty_decimals|intval}{else}0{/if}"
        {if empty($product.allow_oosp) && isset($product.stock_quantity) && $product.stock_quantity > 0}data-ps-max="{$product.stock_quantity|floatval}"{/if}
      {/if}
    >
      <a
        class="cart-preview-product__qty-btn"
        href="{$product.down_quantity_url}&amp;qty=1"
        rel="nofollow"
        data-ps-action="cart-preview-update"
        data-ps-qty-op="down"
        data-id-product="{$product.id_product|escape:'javascript'}"
        data-id-product-attribute="{$product.id_product_attribute|escape:'javascript'}"
        data-id-customization="{$product.id_customization|escape:'javascript'}"
        data-link-action="update-quantity-in-cart"
        aria-label="{l s='Decrease quantity' d='Shop.Theme.Actions'}"
      >&minus;</a>
      {* Tapniecie w liczbe otwiera pole do wpisania ilosci — z 35 m na 12 m
         bez klikania 23 razy (cart-preview.js). *}
      <span class="cart-preview-product__qty-value" data-ps-target="cart-preview-qty-value" role="button" tabindex="0" aria-live="polite">{$smarty.capture.qty_display nofilter}</span>
      <a
        class="cart-preview-product__qty-btn"
        href="{$product.up_quantity_url}&amp;qty=1"
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
