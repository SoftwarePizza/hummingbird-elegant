{**
 * For the full copyright and license information, please view the
 * LICENSE.md file that was distributed with this source code.
 *}

{extends file="components/module-products.tpl"}

{block name='module_products_name'}ps-newproducts{/block}

{block name='module_products'}
  <section class="ps-newproducts">
    <div class="module-products container">
      <div class="module-products__split">

        <div class="module-products__intro">
          {if !empty($hbe_np_title)}
            {include file='components/section-title.tpl' title=$hbe_np_title}
          {else}
            {include file='components/section-title.tpl' title={l s='Latest arrivals' d='Shop.Theme.Catalog'}}
          {/if}

          {if !empty($hbe_np_text)}
            <p class="hbe-section-text">{$hbe_np_text|escape:'html':'UTF-8'}</p>
          {/if}

          <div class="module-products__buttons module-products__buttons--intro">
            {* izpol: przycisk jest zawsze, jak w karuzelach edytora. Domyslnie
               "Wiecej tkanin" (tlumaczenie 'All products' z motywu, 17 jezykow)
               prowadzi na strone "Nowe produkty" biezacej domeny/jezyka —
               $urls.pages.new_products przechodzi przez override Link, wiec
               na izpol.de to izpol.de/neue-produkte. Pola "Tekst linku" i
               "URL linku" w zakladce Strona glowna edytora nadpisuja kazde
               z osobna. *}
            {if !empty($hbe_np_link_text)}
              {assign var=hbe_np_btn_text value=$hbe_np_link_text}
            {else}
              {assign var=hbe_np_btn_text value={l s='All products' d='Shop.Theme.Catalog'}}
            {/if}
            {if !empty($hbe_np_link_url)}
              {assign var=hbe_np_btn_url value=$hbe_np_link_url}
            {else}
              {assign var=hbe_np_btn_url value=$urls.pages.new_products}
            {/if}
            {if !empty($hbe_np_btn_text) && !empty($hbe_np_btn_url)}
              <a class="btn btn-primary hbe-section-link" href="{$hbe_np_btn_url|escape:'html':'UTF-8'}">
                {$hbe_np_btn_text|escape:'html':'UTF-8'}
              </a>
            {/if}
          </div>

          <div class="hbe-carousel-nav" data-hbe-carousel-nav>
            <button type="button" class="hbe-carousel-nav__btn" data-hbe-carousel-prev aria-label="{l s='Previous' d='Shop.Theme.Global'}">
              <i class="material-icons" aria-hidden="true">&#xE314;</i>
            </button>
            <button type="button" class="hbe-carousel-nav__btn" data-hbe-carousel-next aria-label="{l s='Next' d='Shop.Theme.Global'}">
              <i class="material-icons" aria-hidden="true">&#xE315;</i>
            </button>
          </div>
        </div>

        <div class="module-products__carousel">
          {* hummingbird_editor: carousel-source override — show a chosen category's
             products instead of the native "new products" when configured. *}
          {if isset($hbe_np_override_products)}
            {assign var=hbe_np_list value=$hbe_np_override_products}
          {else}
            {assign var=hbe_np_list value=$products}
          {/if}
          {if $hbe_np_list}
            <div class="module-products__list">
              {include file='catalog/_partials/productlist.tpl' products=$hbe_np_list}
            </div>
          {/if}
        </div>

      </div>
    </div>
  </section>
{/block}
