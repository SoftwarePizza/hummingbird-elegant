{**
 * For the full copyright and license information, please view the
 * LICENSE.md file that was distributed with this source code.
 *}

{assign var="increment_icon" value="E145"}
{assign var="decrement_icon" value="E15B"}
{assign var="submit_icon" value="E5CA"}
{assign var="cancel_icon" value="E5CD"}
{assign var="increment_label" value={l s='Increase quantity of %product_name%' sprintf=['%product_name%' => $product.name] d='Shop.Theme.Actions'}}
{assign var="decrement_label" value={l s='Decrease quantity of %product_name%' sprintf=['%product_name%' => $product.name] d='Shop.Theme.Actions'}}
{assign var="quantity_label" value={l s='Change quantity of %product_name%' sprintf=['%product_name%' => $product.name] d='Shop.Theme.Actions'}}

{* Software Pizza: ilości ułamkowe (tkaniny na metry, pproperties) dostają dwa
   kroki. Wewnętrzne przyciski zmieniają o `step` (0,1 m = 10 cm), zewnętrzne
   o całą jednostkę (1 m) — klient nie klika dziesięć razy, żeby dołożyć metr.
   Krok czyta z przycisku pproperties-hummingbird.js (data-step); motyw tych
   przycisków nie zna, bo szuka tylko .js-increment-button/.js-decrement-button,
   a te zostają przy małym kroku. Przy kroku całkowitym (sztuki, kupony)
   komponent wygląda jak w oryginale: ikona minus / plus. *}
{assign var="qty_step" value=1}
{if isset($attributes.step) && $attributes.step > 0}
  {assign var="qty_step" value=$attributes.step}
{/if}
{assign var="has_big_step" value=false}
{if $qty_step < 1}
  {assign var="has_big_step" value=true}
  {assign var="qty_step_label" value=$qty_step|formatQty}
  {assign var="qty_unit" value=''}
  {if isset($attributes['data-qty-unit'])}{assign var="qty_unit" value=$attributes['data-qty-unit']}{/if}
{/if}

{* The spin button placement for RTL should be same as LTR *}
{* To fix mirroring by CSS need to place them in reverse for RTL *}
{if $language.is_rtl}
  {assign var="prepend" value=["button"=>"increment", "icon"=>$increment_icon, "confirm_icon"=>$submit_icon, "label"=>$increment_label, "sign"=>"+"]}
  {assign var="append" value=["button"=>"decrement", "icon"=>$decrement_icon, "confirm_icon"=>$cancel_icon, "label"=>$decrement_label, "sign"=>"−"]}
{else}
  {assign var="prepend" value=["button"=>"decrement", "icon"=>$decrement_icon, "confirm_icon"=>$cancel_icon, "label"=>$decrement_label, "sign"=>"−"]}
  {assign var="append" value=["button"=>"increment", "icon"=>$increment_icon, "confirm_icon"=>$submit_icon, "label"=>$increment_label, "sign"=>"+"]}
{/if}

<div class="quantity-button__group input-group{if $has_big_step} has-big-step{/if}">
  {if $has_big_step}
    <button aria-label="{$prepend.label} (1 {$qty_unit})" title="{$prepend.sign}1 {$qty_unit}" class="btn btn-square-icon qty-step qty-step--big" type="button" data-action="{$prepend.button}" data-step="1">{$prepend.sign}1</button>
  {/if}

  <button aria-label="{$prepend.label}{if $has_big_step} ({$qty_step_label} {$qty_unit}){/if}" {if $has_big_step}title="{$prepend.sign}{$qty_step_label} {$qty_unit}" {/if}class="btn {$prepend.button} btn-square-icon js-{$prepend.button}-button{if $has_big_step} qty-step qty-step--small{/if}" type="button" id="decrement_button_{$product.id_product}">
    {if $has_big_step}
      <span class="qty-step__label">{$prepend.sign}{$qty_step_label}</span>
    {else}
      <i class="material-icons" aria-hidden="true">&#x{$prepend.icon};</i>
      <i class="material-icons confirmation d-none" aria-hidden="true">&#x{$prepend.confirm_icon};</i>
    {/if}
    <div class="spinner-border spinner-border-sm align-middle d-none" role="status"></div>
  </button>

  <input
    {foreach $attributes as $key=>$value}
      {$key}="{$value}"
    {/foreach}
    {if !isset($attributes.id)}id="quantity_input_{$product.id_product}"{/if}
    {if !isset($attributes.class)}class="form-control"{/if}
    {if !isset($attributes.name)}name="qty"{/if}
    {if !isset($attributes['aria-label'])}aria-label="{$quantity_label}"{/if}
    {if !isset($attributes.type)}type="text"{/if}
    {if !isset($attributes.inputmode)}inputmode="numeric"{/if}
    {if !isset($attributes.pattern)}pattern="[0-9]+"{/if}
    {if !isset($attributes.value)}value="1"{/if}
    {if !isset($attributes.min)}min="1"{/if}
  >

  <button aria-label="{$append.label}{if $has_big_step} ({$qty_step_label} {$qty_unit}){/if}" {if $has_big_step}title="{$append.sign}{$qty_step_label} {$qty_unit}" {/if}class="btn {$append.button} btn-square-icon js-{$append.button}-button{if $has_big_step} qty-step qty-step--small{/if}" type="button" id="increment_button_{$product.id_product}">
    {if $has_big_step}
      <span class="qty-step__label">{$append.sign}{$qty_step_label}</span>
    {else}
      <i class="material-icons" aria-hidden="true">&#x{$append.icon};</i>
      <i class="material-icons confirmation d-none" aria-hidden="true">&#x{$append.confirm_icon};</i>
    {/if}
    <div class="spinner-border spinner-border-sm align-middle d-none" role="status"></div>
  </button>

  {if $has_big_step}
    <button aria-label="{$append.label} (1 {$qty_unit})" title="{$append.sign}1 {$qty_unit}" class="btn btn-square-icon qty-step qty-step--big" type="button" data-action="{$append.button}" data-step="1">{$append.sign}1</button>
  {/if}
</div>
