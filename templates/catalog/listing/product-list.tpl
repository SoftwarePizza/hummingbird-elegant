{**
 * For the full copyright and license information, please view the
 * LICENSE.md file that was distributed with this source code.
 *}
{extends file=$layout}

{block name='head_microdata_special'}
  {include file='_partials/microdata/product-list-jsonld.tpl' listing=$listing}
{/block}

{block name='content'}
  {block name='product_list_header'}
    <div id="js-product-list-header">
      {include file='components/page-title-section.tpl' title=$listing.label}
    </div>
  {/block}

  {hook h='displayHeaderCategory'}

  <section id="products">
    {if $listing.products|count}
      {block name='product_list_top'}
        {* Kopia licznika nad paskiem (na telefonie pasek ma przez to jeden
           wiersz) — tę samą robi custom.js (blok 7, syncCount), ale żeby nic
           nie skakało, stoi tu od razu; o widoczności decyduje custom.css
           (.listing-count, tylko poniżej 768 px). Celowo tutaj, a nie
           w products-top.tpl — ten leci też z ajaxa i byłaby dublowana. *}
        <p class="listing-count">
          {if $listing.pagination.total_items > 1}
            {l s='There are %product_count% products.' d='Shop.Theme.Catalog' sprintf=['%product_count%' => $listing.pagination.total_items]}
          {elseif $listing.pagination.total_items > 0}
            {l s='There is 1 product.' d='Shop.Theme.Catalog'}
          {/if}
        </p>
        {include file='catalog/_partials/products-top.tpl' listing=$listing}
      {/block}

      {block name='product_list_active_filters'}
        {$listing.rendered_active_filters nofilter}
      {/block}

      {block name='product_list'}
        {include file='catalog/_partials/products.tpl' listing=$listing}
      {/block}

      {block name='product_list_bottom'}
        {include file='catalog/_partials/products-bottom.tpl' listing=$listing}
      {/block}
    {else}
      <div id="js-product-list-top"></div>

      <div id="js-product-list">
        {capture assign="errorContent"}
          <p class="h3">{l s='No products available at the moment' d='Shop.Theme.Catalog'}</p>
          <p>{l s='Stay tuned! More products will be shown here as they are added.' d='Shop.Theme.Catalog'}</p>
        {/capture}

        {include file='errors/not-found.tpl' errorContent=$errorContent}
      <div>

      <div id="js-product-list-bottom"></div>
    {/if}
  </section>

  {block name='product_list_footer'}{/block}

  {hook h='displayFooterCategory'}
{/block}
