{**
 * For the full copyright and license information, please view the
 * LICENSE.md file that was distributed with this source code.
 *
 * izpol: "Juz obejrzane produkty" jako karuzela na tym samym szkielecie, co
 * ps_newproducts (kolumna wprowadzenia + przewijany pas + strzalki). Uklad
 * i przeciaganie dostarcza hummingbird_editor (home.css, carousel-drag.js),
 * ktory wylicza .ps-viewedproduct obok .ps-newproducts i .hbe-products.
 * Bez tego szkieletu motyw renderowal modul jako zwykla siatke listingu —
 * na telefonie dwie kolumny zamiast karuzeli.
 *}

{extends file="components/module-products.tpl"}

{block name='module_products_name'}ps-viewedproduct{/block}

{block name='module_products'}
  <section class="ps-viewedproduct">
    <div class="module-products container">
      <div class="module-products__split">

        <div class="module-products__intro">
          {include file='components/section-title.tpl' title={l s='Viewed products' d='Shop.Theme.Catalog'}}

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
