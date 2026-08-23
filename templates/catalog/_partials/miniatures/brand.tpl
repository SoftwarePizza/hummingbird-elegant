{**
 * For the full copyright and license information, please view the
 * LICENSE.md file that was distributed with this source code.
 *}
{block name='brand_miniature_item'}
  <li class="brand">
    {* 2026-08-23: caly blok obrazka jest teraz warunkowy.

       Dla czesci producentow $brand.image przychodzi jako LANCUCH, a nie tablica.
       Gole odczyty w rodzaju {$brand.image.bySize.small_default.url} probowaly wtedy
       indeksowac lancuch kluczem tekstowym. Pod PHP 7.4 bylo to ostrzezenie i pusta
       wartosc, pod PHP 8 to TypeError "Cannot access offset of type string on string",
       czyli fatal - cala strona marek konczyla sie bledem 500.

       empty() i isset() na takim odczycie sa bezpieczne (sprawdzone), fatalny jest
       dopiero goly odczyt - dlatego wystarczy warunek na zewnatrz. Marka bez poprawnego
       obrazka renderuje sie teraz bez miniatury zamiast wywracac strone. *}
    {if !empty($brand.image.bySize.small_default.url)}
      <div class="brand__image">
        <picture>
          {if !empty($brand.image.bySize.small_default.sources.avif)}<source srcset="{$brand.image.bySize.small_default.sources.avif}" type="image/avif">{/if}
          {if !empty($brand.image.bySize.small_default.sources.webp)}<source srcset="{$brand.image.bySize.small_default.sources.webp}" type="image/webp">{/if}
          <img
            class="brand__img img-fluid"
            src="{$brand.image.bySize.small_default.url}"
            alt="{if !empty($brand.image.legend)}{$brand.image.legend}{else}{$brand.name}{/if}"
            {if !empty($brand.image.bySize.small_default.width)}width="{$brand.image.bySize.small_default.width}"{/if}
            {if !empty($brand.image.bySize.small_default.height)}height="{$brand.image.bySize.small_default.height}"{/if}
            loading="lazy"
          >
        </picture>
      </div>
    {/if}

    <div class="brand__infos">
      <a class="brand__title stretched-link" href="{$brand.url}">
        {$brand.name}
      </a>
    </div>

    <p class="brand__products">
      {if $brand.nb_products > 1}
        {l s='%number% products' sprintf=['%number%' => $brand.nb_products] d='Shop.Theme.Catalog'}
      {elseif $brand.nb_products == 1}
        {l s='%number% product' sprintf=['%number%' => $brand.nb_products] d='Shop.Theme.Catalog'}
      {else}
        {l s='No products' d='Shop.Theme.Catalog'}
      {/if}
    </p>
  </li>
{/block}
