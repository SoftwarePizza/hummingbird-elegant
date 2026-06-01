{**
 * For the full copyright and license information, please view the
 * LICENSE.md file that was distributed with this source code.
 *}
{extends file="components/module-products.tpl"}

{block name='module_products_variables'}
  {assign var="need_container" value=false}
{/block}

{block name='module_products_name'}ps-categoryproducts{/block}

{block name='module_products_title'}
  {if !empty($hbe_cp_title)}
    {include file='components/section-title.tpl' title=$hbe_cp_title}
  {else}
    {if $products|@count == 1}
      {include file='components/section-title.tpl' title={l s='%s other product in the same category' sprintf=[$products|@count] d='Shop.Theme.Catalog'}}
    {else}
      {include file='components/section-title.tpl' title={l s='%s other products in the same category' sprintf=[$products|@count] d='Shop.Theme.Catalog'}}
    {/if}
  {/if}
  {if !empty($hbe_cp_text)}
    <p class="hbe-section-text">{$hbe_cp_text|escape:'html':'UTF-8'}</p>
  {/if}
{/block}

{block name='module_products_footer'}
  {if !empty($hbe_cp_link_text) && !empty($hbe_cp_link_url)}
    <a class="btn btn-primary hbe-section-link" href="{$hbe_cp_link_url|escape:'html':'UTF-8'}">
      {$hbe_cp_link_text|escape:'html':'UTF-8'}
    </a>
  {/if}
{/block}
