{**
 * For the full copyright and license information, please view the
 * LICENSE.md file that was distributed with this source code.
 *}

{extends file="components/module-products.tpl"}

{block name='module_products_name'}ps-bestsellers{/block}

{block name='module_products'}
  <section class="ps-bestsellers">
    <div class="module-products container">
      <div class="module-products__split">

        <div class="module-products__intro">
          {if !empty($hbe_bs_title)}
            {include file='components/section-title.tpl' title=$hbe_bs_title}
          {else}
            {include file='components/section-title.tpl' title={l s='Best sellers' d='Shop.Theme.Catalog'}}
          {/if}

          {if !empty($hbe_bs_text)}
            <p class="hbe-section-text">{$hbe_bs_text|escape:'html':'UTF-8'}</p>
          {/if}

          <div class="module-products__buttons module-products__buttons--intro">
            {if !empty($hbe_bs_link_text) && !empty($hbe_bs_link_url)}
              <a class="btn btn-primary hbe-section-link" href="{$hbe_bs_link_url|escape:'html':'UTF-8'}">
                {$hbe_bs_link_text|escape:'html':'UTF-8'}
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
          {if $products}
            <div class="module-products__list">
              {include file='catalog/_partials/productlist.tpl' products=$products}
            </div>
          {/if}
        </div>

      </div>
    </div>
  </section>
{/block}
