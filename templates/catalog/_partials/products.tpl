{**
 * For the full copyright and license information, please view the
 * LICENSE.md file that was distributed with this source code.
 *}
<div id="js-product-list">
  {block name='pagination_top'}
    {if $listing.pagination.should_be_displayed}
      <div class="products__pagination products__pagination--top">
        {include file='_partials/pagination.tpl' pagination=$listing.pagination}
      </div>
    {/if}
  {/block}

  {include file='catalog/_partials/productlist.tpl' products=$listing.products}

  {block name='pagination'}
    <div class="products__pagination">
      {include file='_partials/pagination.tpl' pagination=$listing.pagination}
    </div>
  {/block}
</div>
