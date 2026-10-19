{**
 * Theme override of productinformation module view.
 * Renders bare <li> rows that product-details.tpl splices into the single
 * "Dane techniczne" list. Every product feature whose NAME matches an active
 * module entry is rendered here (the module entry names define the set of
 * "general parameters"); each of its values that also matches an entry is
 * replaced by the enriched module content. Repeated values are collapsed —
 * BO data carries the same value attached twice (e.g. "Tak\nTak"). Trimmed
 * comparisons — BO data carries stray spaces. product-details.tpl skips
 * these same features in its own loop by looking for the
 * data-general-parameter markers in this captured output — keep the
 * attribute format in sync with that check.
 *}
{if !isset($product.grouped_features)}{$product.grouped_features = $product.features}{/if}

{if $product.grouped_features && !empty($productinformation)}
  {foreach from=$product.grouped_features item=feature}
    {$isGeneralParameter = false}
    {foreach from=$productinformation item=prodinf}
      {if $prodinf.active && $feature.name|trim == $prodinf.name|trim}
        {$isGeneralParameter = true}
      {/if}
    {/foreach}
    {if $isGeneralParameter}
      {$seenValues = []}
      {$displayValues = []}
      {foreach from="\n"|explode:$feature.value item=rawValue}
        {$value = $rawValue|trim}
        {if $value !== '' && !($value|in_array:$seenValues)}
          {$seenValues[] = $value}
          {$enrichedContent = ''}
          {foreach from=$productinformation item=prodinf}
            {if $prodinf.active && $feature.name|trim == $prodinf.name|trim && $value == $prodinf.value|trim}
              {$enrichedContent = $prodinf.content|trim}
            {/if}
          {/foreach}
          {if $enrichedContent !== ''}
            {$displayValues[] = $enrichedContent}
          {else}
            {$displayValues[] = $value}
          {/if}
        {/if}
      {/foreach}
      <li class="product-specs__row" data-general-parameter="{$feature.name|trim|escape:'html'}">
        <span class="product-specs__label">{$feature.name|trim|escape:'html':'UTF-8'}</span>
        <span class="product-specs__value">{foreach from=$displayValues item=displayValue name=displayValues}{if !$smarty.foreach.displayValues.first}<br>{/if}{$displayValue|escape:'html':'UTF-8'}{/foreach}</span>
      </li>
    {/if}
  {/foreach}
{/if}
