{**
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 *}
{if isset($groups) && $groups}
  <div class="product__variants js-product-variants">
    {foreach from=$groups key=id_attribute_group item=group}
      {if !empty($group.attributes)}
        {assign var=groupId value="group_{$id_attribute_group}_{$product.id}"}
        {assign var=inputId value="input_{$id_attribute_group}_{$product.id}"}
        {assign var=legendId value="legend_{$id_attribute_group}_{$product.id}"}

        <fieldset class="product-variant">
          <div class="product-variant__label">
            <legend class="form-label product-variant__legend" id="{$legendId}">{$group.name}</legend>
            {if $group.group_type != 'color'}
              <span class="selected-value product-variant__selected" aria-hidden="true">
                {l s=': ' d='Shop.Theme.Catalog'}
                {foreach from=$group.attributes key=id_attribute item=group_attribute}
                  {if $group_attribute.selected}{$group_attribute.name}{/if}
                {/foreach}
              </span>
            {/if}
          </div>

          {if $group.group_type == 'select'}
            <select
              class="form-select"
              id="{$inputId}"
              aria-labelledby="{$legendId}"
              data-product-attribute="{$id_attribute_group}"
              name="group[{$id_attribute_group}]">
              {foreach from=$group.attributes key=id_attribute item=group_attribute}
                <option value="{$id_attribute}" {if $group_attribute.selected} selected="selected"{/if}>{$group_attribute.name}</option>
              {/foreach}
            </select>
          {elseif $group.group_type == 'color'}
            {* Zwijany wybór koloru multiproduktu (wzór: chanel.com).
               Domyślnie widać tylko wybrany kolor — próbka, numer kombinacji
               i nazwa; kliknięcie rozwija pełną listę z nagłówkiem,
               przełącznikiem lista/siatka i zamknięciem. <details> działa
               bez JS; custom.js (variant-picker) domyka po wyborze,
               po kliknięciu obok i po Escape.

               Numer kombinacji: mapka id_attribute → reference budowana
               z $combinations. Tylko kombinacje jednoatrybutowe — na izpol
               każdy kolor multiproduktu to osobna kombinacja z własną
               referencją; przy kombinacjach wielogrupowych numer byłby
               niejednoznaczny, więc go wtedy nie pokazujemy. *}
            {assign var=pickerRefs value=[]}
            {if isset($combinations) && $combinations}
              {foreach from=$combinations item=pickerCombo}
                {if isset($pickerCombo.attributes) && $pickerCombo.attributes|count == 1 && $pickerCombo.reference}
                  {$pickerRefs[$pickerCombo.attributes[0]] = $pickerCombo.reference}
                {/if}
              {/foreach}
            {/if}

            {assign var=pickerCount value=$group.attributes|count}
            {assign var=pickerSelected value=null}
            {assign var=pickerSelectedId value=0}
            {foreach from=$group.attributes key=id_attribute item=group_attribute}
              {if $group_attribute.selected && !$pickerSelected}
                {assign var=pickerSelected value=$group_attribute}
                {assign var=pickerSelectedId value=$id_attribute}
              {/if}
            {/foreach}
            {if !$pickerSelected}
              {foreach from=$group.attributes key=id_attribute item=group_attribute}
                {assign var=pickerSelected value=$group_attribute}
                {assign var=pickerSelectedId value=$id_attribute}
                {break}
              {/foreach}
            {/if}

            <details class="variant-picker js-variant-picker">
              <summary class="variant-picker__toggle">
                <span class="color variant-picker__swatch{if $pickerSelected.texture} texture{/if}"
                  {if $pickerSelected.texture}
                    style="background-image: url({$pickerSelected.texture})"
                  {elseif $pickerSelected.html_color_code}
                    style="background-color: {$pickerSelected.html_color_code}"
                  {/if}
                  aria-hidden="true"></span>
                <span class="variant-picker__current">
                  {if isset($pickerRefs[$pickerSelectedId])}
                    <span class="variant-picker__ref">{$pickerRefs[$pickerSelectedId]}</span>
                    <span class="variant-picker__sep" aria-hidden="true">&ndash;</span>
                  {/if}
                  <span class="variant-picker__name">{$pickerSelected.name}</span>
                </span>
                {if $pickerCount > 1}
                  <span class="variant-picker__count" aria-hidden="true">+{$pickerCount-1}</span>
                {/if}
                <i class="material-icons variant-picker__chevron" aria-hidden="true">&#xE5CF;</i>
              </summary>

              <div class="variant-picker__panel">
                <div class="variant-picker__head">
                  <span class="variant-picker__title">{$group.name} &middot; {$pickerCount}</span>
                  <span class="variant-picker__tools">
                    <button type="button" class="variant-picker__view js-variant-view" data-view="list" aria-pressed="true">
                      <i class="material-icons" aria-hidden="true">&#xE8EF;</i>
                    </button>
                    <button type="button" class="variant-picker__view js-variant-view" data-view="grid" aria-pressed="false">
                      <i class="material-icons" aria-hidden="true">&#xE8F0;</i>
                    </button>
                    <button type="button" class="variant-picker__close js-variant-close" aria-label="{l s='Close' d='Shop.Theme.Global'}">
                      <i class="material-icons" aria-hidden="true">&#xE5CD;</i>
                    </button>
                  </span>
                </div>

                <div id="{$groupId}" class="product-variant__colors variant-picker__options" role="radiogroup" aria-labelledby="{$legendId}">
                  {foreach from=$group.attributes key=id_attribute item=group_attribute}
                    {assign var=inputId value="input_{$id_attribute_group}_{$id_attribute}_{$product.id}"}
                    {assign var=labelId value="label_{$id_attribute_group}_{$id_attribute}_{$product.id}"}

                    <div class="product-variant__color input-color variant-picker__option">
                      <input
                        class="input-color__input"
                        type="radio"
                        id="{$inputId}"
                        data-product-attribute="{$id_attribute_group}"
                        name="group[{$id_attribute_group}]"
                        value="{$id_attribute}"
                        aria-labelledby="{$labelId}"
                        {if $group_attribute.selected} checked="checked" aria-checked="true"{/if}
                      >
                      <label
                        class="input-color__label variant-picker__row{if $group_attribute.texture} input-color__label--texture{/if}{if $group_attribute.selected} input-color__label--active variant-picker__row--active{/if}"
                        for="{$inputId}"
                        title="{if isset($pickerRefs[$id_attribute])}{$pickerRefs[$id_attribute]} &ndash; {/if}{$group_attribute.name}"
                      >
                        <span id="{$labelId}"
                          {if $group_attribute.texture}
                            class="color texture {if $group_attribute.selected}active{/if}" style="background-image: url({$group_attribute.texture})"
                          {elseif $group_attribute.html_color_code}
                            class="color {if $group_attribute.selected}active{/if}" style="background-color: {$group_attribute.html_color_code}"
                          {else}
                            class="color {if $group_attribute.selected}active{/if}"
                          {/if}
                        >
                          <span class="visually-hidden">{$group.group_name} - {$group_attribute.name}</span>
                        </span>
                        <span class="variant-picker__row-text" aria-hidden="true">
                          {if isset($pickerRefs[$id_attribute])}
                            <span class="variant-picker__ref">{$pickerRefs[$id_attribute]}</span>
                            <span class="variant-picker__sep">&ndash;</span>
                          {/if}
                          <span class="variant-picker__name">{$group_attribute.name}</span>
                        </span>
                      </label>
                    </div>
                  {/foreach}
                </div>
              </div>
            </details>
          {elseif $group.group_type == 'radio'}
            <div id="{$groupId}" class="product-variant__radios" role="radiogroup" aria-labelledby="{$legendId}">
              {foreach from=$group.attributes key=id_attribute item=group_attribute}
                {assign var=inputId value="input_{$id_attribute_group}_{$id_attribute}_{$product.id}"}
                {assign var=labelId value="label_{$id_attribute_group}_{$id_attribute}_{$product.id}"}

                <div class="product-variant__radio form-check">
                  <input
                    class="form-check-input"
                    type="radio"
                    id="{$inputId}"
                    data-product-attribute="{$id_attribute_group}"
                    name="group[{$id_attribute_group}]"
                    value="{$id_attribute}"
                    aria-labelledby="{$labelId}"
                    {if $group_attribute.selected} checked="checked" aria-checked="true"{/if}
                  >
                  <label for="{$inputId}">
                    <span class="form-check-label" id="{$labelId}"><span class="visually-hidden">{$group.group_name} - </span>{$group_attribute.name}</span>
                  </label>
                </div>
              {/foreach}
            </div>
          {/if}
        </fieldset>
      {/if}
    {/foreach}
  </div>
{/if}
