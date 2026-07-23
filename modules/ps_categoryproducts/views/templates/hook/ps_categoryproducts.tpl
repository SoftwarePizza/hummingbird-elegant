{**
 * For the full copyright and license information, please view the
 * LICENSE.md file that was distributed with this source code.
 *}
{extends file="components/module-products.tpl"}

{block name='module_products_variables'}
  {assign var="need_container" value=false}
  {* hummingbird_editor: carousel-source override — when a fixed category is set,
     use its products instead of those from the current product's category. *}
  {if isset($hbe_cp_override_products)}
    {assign var="hbe_cp_list" value=$hbe_cp_override_products}
  {else}
    {assign var="hbe_cp_list" value=$products}
  {/if}
{/block}

{block name='module_products_name'}ps-categoryproducts{/block}

{block name='module_products_title'}
  {if !empty($hbe_cp_title)}
    {include file='components/section-title.tpl' title=$hbe_cp_title}
  {else}
    {if $hbe_cp_list|@count == 1}
      {include file='components/section-title.tpl' title={l s='%s other product in the same category' sprintf=[$hbe_cp_list|@count] d='Shop.Theme.Catalog'}}
    {else}
      {include file='components/section-title.tpl' title={l s='%s other products in the same category' sprintf=[$hbe_cp_list|@count] d='Shop.Theme.Catalog'}}
    {/if}
  {/if}
  {if !empty($hbe_cp_text)}
    <p class="hbe-section-text">{$hbe_cp_text|escape:'html':'UTF-8'}</p>
  {/if}
{/block}

{block name='module_products_list'}
  {if $hbe_cp_list}
    <div class="module-products__list">
      {include file='catalog/_partials/productlist.tpl' products=$hbe_cp_list}
    </div>
  {/if}
{/block}

{block name='module_products_footer'}
  {if !empty($hbe_cp_link_text) && !empty($hbe_cp_link_url)}
    <a class="btn btn-primary hbe-section-link" href="{$hbe_cp_link_url|escape:'html':'UTF-8'}">
      {$hbe_cp_link_text|escape:'html':'UTF-8'}
    </a>
  {/if}
{/block}
