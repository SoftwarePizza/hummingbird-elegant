{*
 * Nadpisanie modułowego search-1.7.tpl w motywie — przeżywa aktualizację
 * AmbJoliSearch.
 *
 * Co zmienione wobec oryginału:
 *
 * 1. Zdjęcia kategorii wyleciały. Kategorie w tym sklepie w większości nie mają
 *    okładki, więc PrestaShop podstawiał zastępczy obrazek „No image available"
 *    — pół ekranu szarego prostokąta na każdą trafioną kategorię.
 * 2. Nazwa kategorii wyświetlała się DWA razy. Oryginał ma dwa warianty tego
 *    samego bloku, rozdzielone klasami `hidden-sm-down` i `hidden-md-up`
 *    z Bootstrapa 4-alpha — w Bootstrapie 5 (a taki ma Hummingbird) te klasy
 *    nie istnieją, więc pokazywały się oba naraz.
 * 3. `<h1>` na każdą kategorię zamieniony na zwykły link. Strona ma już jeden
 *    `<h1>` z tytułem wyników; kilkanaście kolejnych to zarówno bałagan
 *    semantyczny, jak i sygnał dla wyszukiwarek.
 * 4. Obie grupy wyników są teraz podpisane — patrz tłumaczenia w
 *    themes/hummingbird/modules/ambjolisearch/translations/.
 *}

{extends file='catalog/listing/search.tpl'}

{block 'product_list_header' append}
  {if isset($categories) && is_array($categories) && count($categories) > 0}
    <section class="search-group search-group--categories">
      <h2 class="search-group__title">{l s='Category search results' mod='ambjolisearch'}</h2>
      <ul class="search-group__list">
        {foreach $categories as $category}
          <li class="search-group__item">
            <a class="search-group__link" href="{$category.url|escape:'html':'UTF-8'}">{$category.name}</a>
          </li>
        {/foreach}
      </ul>
    </section>
  {/if}

  {if isset($listing) && $listing.products|count}
    <h2 class="search-group__title search-group__title--products">{l s='Product search results' mod='ambjolisearch'}</h2>
  {/if}
{/block}
