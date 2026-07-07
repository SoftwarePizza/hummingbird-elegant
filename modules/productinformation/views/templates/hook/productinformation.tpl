{**
 * Theme override of productinformation module view.
 * Figma "Ogólne parametry" tab: every product feature whose NAME matches an
 * active module entry belongs here (the module entry names define the set of
 * "general parameters"). When the feature value also matches an entry, the
 * enriched module content replaces the raw value. Trimmed comparisons — BO
 * data carries stray spaces. product-details.tpl excludes these same
 * features from the "Dane techniczne" tab by looking for the
 * data-general-parameter markers in this captured output — keep the
 * attribute format in sync with that check.
 *}
{if !isset($product.grouped_features)}{$product.grouped_features = $product.features}{/if}

{$productInformationRows = []}
{if $product.grouped_features && !empty($productinformation)}
  {foreach from=$product.grouped_features item=feature}
    {$isGeneralParameter = false}
    {$enrichedContent = ''}
    {foreach from=$productinformation item=prodinf}
      {if $prodinf.active && $feature.name|trim == $prodinf.name|trim}
        {$isGeneralParameter = true}
        {if $feature.value|trim == $prodinf.value|trim}
          {$enrichedContent = $prodinf.content|trim}
        {/if}
      {/if}
    {/foreach}
    {if $isGeneralParameter}
      {$productInformationRows[] = ['label' => $feature.name|trim, 'content' => $enrichedContent, 'value' => $feature.value]}
    {/if}
  {/foreach}
{/if}

{if $productInformationRows}
  <ul class="product-specs__list">
    {foreach from=$productInformationRows item=row}
      <li class="product-specs__row" data-general-parameter="{$row.label|escape:'html'}">
        <span class="product-specs__label">{$row.label}</span>
        <span class="product-specs__value">
          {if $row.content !== ''}
            {$row.content}
          {else}
            {$row.value|escape:'htmlall'|nl2br nofilter}
          {/if}
        </span>
      </li>
    {/foreach}
  </ul>
{/if}
