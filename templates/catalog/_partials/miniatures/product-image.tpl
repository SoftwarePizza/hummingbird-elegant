{**
 * For the full copyright and license information, please view the
 * LICENSE.md file that was distributed with this source code.
 *
 * 2026-08-17: do srcsetów doszły medium_default (452) i product_main (720),
 * bo listing dostał większe kafle, a poprzedni sufit default_xl (400) już nie
 * wystarczał. Oba formaty są wygenerowane dla wszystkich produktów; każdy
 * kandydat jest osłonięty {if isset(...)}, więc brak formatu nie wstawi
 * pustego wpisu do srcsetu.
 *
 * UWAGA na deskryptory `w`: PrestaShop podaje w `bySize.*.width` szerokość
 * RAMKI typu obrazka, nie realnego pliku. Zdjęcia produktów w tym sklepie są
 * pionowe 2:3, więc plik z ramki 400×400 ma naprawdę 267×400 px — deklarujemy
 * przeglądarce o 50 % więcej pikseli, niż dostanie, i dlatego listing wyglądał
 * na rozmyty. Rekompensata siedzi w `sizes`: podane tam szerokości to realna
 * szerokość kafla × 1,5, więc przeglądarka wybiera plik, który po korekcie ma
 * dość pikseli. Gdyby kiedyś doszły zdjęcia kwadratowe, wyjdzie na tym
 * pobranie za dużego pliku — nigdy rozmytego, więc błąd idzie w bezpieczną
 * stronę. Wartości `sizes` odpowiadają siatce z sekcji 6 w custom.css:
 * 2 kafle poniżej 768 px, 3 kafle poniżej 1400 px, 4 kafle wyżej.
 *}
{block name='product_miniature_image'}
  <div class="{$componentName}__image-container thumbnail-container">
    <a href="{$product.url}" class="{$componentName}__image-link outline outline--rounded">
      {if $product.cover}
        <picture>
          {if isset($product.cover.bySize.default_md.sources.avif)}
            <source
              srcset="
                {$product.cover.bySize.default_m.sources.avif} {$product.cover.bySize.default_m.width}w,
                {$product.cover.bySize.default_md.sources.avif} {$product.cover.bySize.default_md.width}w,
                {$product.cover.bySize.default_xl.sources.avif} {$product.cover.bySize.default_xl.width}w{if isset($product.cover.bySize.medium_default.sources.avif)},
                {$product.cover.bySize.medium_default.sources.avif} {$product.cover.bySize.medium_default.width}w{/if}{if isset($product.cover.bySize.product_main.sources.avif)},
                {$product.cover.bySize.product_main.sources.avif} {$product.cover.bySize.product_main.width}w{/if}"
              sizes="(min-width: 1400px) 33vw, (min-width: 768px) 45vw, 70vw"
              type="image/avif"
            >
          {/if}

          {if isset($product.cover.bySize.default_md.sources.webp)}
            <source
              srcset="
                {$product.cover.bySize.default_m.sources.webp} {$product.cover.bySize.default_m.width}w,
                {$product.cover.bySize.default_md.sources.webp} {$product.cover.bySize.default_md.width}w,
                {$product.cover.bySize.default_xl.sources.webp} {$product.cover.bySize.default_xl.width}w{if isset($product.cover.bySize.medium_default.sources.webp)},
                {$product.cover.bySize.medium_default.sources.webp} {$product.cover.bySize.medium_default.width}w{/if}{if isset($product.cover.bySize.product_main.sources.webp)},
                {$product.cover.bySize.product_main.sources.webp} {$product.cover.bySize.product_main.width}w{/if}"
              sizes="(min-width: 1400px) 33vw, (min-width: 768px) 45vw, 70vw"
              type="image/webp"
            >
          {/if}

          <img
            class="{$componentName}__image"
            srcset="
              {$product.cover.bySize.default_m.url} {$product.cover.bySize.default_m.width}w,
              {$product.cover.bySize.default_md.url} {$product.cover.bySize.default_md.width}w,
              {$product.cover.bySize.default_xl.url} {$product.cover.bySize.default_xl.width}w{if isset($product.cover.bySize.medium_default)},
              {$product.cover.bySize.medium_default.url} {$product.cover.bySize.medium_default.width}w{/if}{if isset($product.cover.bySize.product_main)},
              {$product.cover.bySize.product_main.url} {$product.cover.bySize.product_main.width}w{/if}"
            sizes="(min-width: 1400px) 33vw, (min-width: 768px) 45vw, 70vw"
            src="{$product.cover.bySize.default_md.url}"
            width="{$product.cover.bySize.default_md.width}"
            height="{$product.cover.bySize.default_md.height}"
            loading="lazy"
            alt="{$product.cover.legend}"
            title="{$product.cover.legend}"
            data-full-size-image-url="{$product.cover.bySize.home_default.url}"
          >
        </picture>
      {else}
        <picture>
          {if isset($urls.no_picture_image.bySize.default_md.sources.avif)}
            <source
              srcset="
                {$urls.no_picture_image.bySize.default_m.sources.avif} {$urls.no_picture_image.bySize.default_m.width}w,
                {$urls.no_picture_image.bySize.default_md.sources.avif} {$urls.no_picture_image.bySize.default_md.width}w,
                {$urls.no_picture_image.bySize.default_xl.sources.avif} {$urls.no_picture_image.bySize.default_xl.width}w"
              sizes="(min-width: 1400px) 33vw, (min-width: 768px) 45vw, 70vw"
              type="image/avif"
            >
          {/if}

          {if isset($urls.no_picture_image.bySize.default_md.sources.webp)}
            <source
              srcset="
                {$urls.no_picture_image.bySize.default_m.sources.webp} {$urls.no_picture_image.bySize.default_m.width}w,
                {$urls.no_picture_image.bySize.default_md.sources.webp} {$urls.no_picture_image.bySize.default_md.width}w,
                {$urls.no_picture_image.bySize.default_xl.sources.webp} {$urls.no_picture_image.bySize.default_xl.width}w"
              sizes="(min-width: 1400px) 33vw, (min-width: 768px) 45vw, 70vw"
              type="image/webp"
            >
          {/if}

          <img
            class="{$componentName}__image"
            srcset="
              {$urls.no_picture_image.bySize.default_m.url} {$urls.no_picture_image.bySize.default_m.width}w,
              {$urls.no_picture_image.bySize.default_md.url} {$urls.no_picture_image.bySize.default_md.width}w,
              {$urls.no_picture_image.bySize.default_xl.url} {$urls.no_picture_image.bySize.default_xl.width}w"
            sizes="(min-width: 1400px) 33vw, (min-width: 768px) 45vw, 70vw"
            width="{$urls.no_picture_image.bySize.default_md.width}"
            height="{$urls.no_picture_image.bySize.default_md.height}"
            src="{$urls.no_picture_image.bySize.default_md.url}"
            loading="lazy"
            alt="{l s='No image available' d='Shop.Theme.Catalog'}"
            title="{l s='No image available' d='Shop.Theme.Catalog'}"
            data-full-size-image-url="{$urls.no_picture_image.bySize.home_default.url}"
          >
        </picture>
      {/if}
    </a>
  </div>
{/block}
