{**
 * For the full copyright and license information, please view the
 * LICENSE.md file that was distributed with this source code.
 *}

<div class="products">
  {foreach from=$products item='product' key='position' name='productsList'}
    {include file='catalog/_partials/miniatures/product.tpl' product=$product position=$position}
    {if $smarty.foreach.productsList.iteration == 8}
      {capture name="listingBanner"}{hook h='displayListingBanner'}{/capture}
      {if $smarty.capture.listingBanner|trim}
        {block name='listing_banner'}
          <div class="products__banner">
            {$smarty.capture.listingBanner nofilter}
          </div>
        {/block}
      {/if}
    {/if}
  {/foreach}
</div>
