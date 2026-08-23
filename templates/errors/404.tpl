{**
 * For the full copyright and license information, please view the
 * LICENSE.md file that was distributed with this source code.
 *
 * Software Pizza, 23.08.2026 — strona 404 zamiast ślepego zaułka.
 * Zamiast samego „nie znaleziono" daje trzy wyjścia: wyszukiwarkę (tę samą,
 * co w nagłówku — z ikoną aparatu, jeśli spimagesearch jest włączony),
 * kafle kategorii i skróty do stron, których ludzie i tak szukają.
 * Kategorie i skróty renderuje hummingbird_editor na hooku displayNotFound —
 * dzięki temu nazwy idą z bazy w bieżącym języku i nie trzeba ich tłumaczyć
 * osobno dla 16 wersji sklepu.
 *}
{extends file='page.tpl'}

{block name='breadcrumb'}{/block}

{block name='container_class'}container container--limited-lg{/block}

{block name='page_header_container'}{/block}

{block name='page_content_container'}
  {assign var=spis_on value=Module::isEnabled('spimagesearch')}
  {if $spis_on}
    {assign var=hbe_404_search_url value=$link->getModuleLink('spimagesearch', 'search', [], true)}
  {else}
    {assign var=hbe_404_search_url value=$link->getPageLink('search', true)}
  {/if}

  <section id="content" class="page-content page-content--not-found hbe-404">

    <div class="hbe-404__head">
      <p class="hbe-404__code" aria-hidden="true">404</p>

      <h1 class="hbe-404__title">
        {l s='The page you are looking for is no longer available' d='Shop.Theme.Catalog'}
      </h1>

      <p class="hbe-404__lead">
        {l s='The address may have changed, or the fabric is no longer in our offer. Search for it below — we probably have something similar.' d='Shop.Theme.Catalog'}
      </p>
    </div>

    <form class="hbe-404__search" method="get" action="{$hbe_404_search_url}" role="search">
      {if !$spis_on}<input type="hidden" name="controller" value="search">{/if}

      <label for="hbe-404-search-input" class="visually-hidden">{l s='Search' d='Shop.Theme.Catalog'}</label>

      <span class="hbe-404__search-icon" aria-hidden="true">
        <svg width="20" height="20" viewBox="0 0 17 17" fill="none" stroke="currentColor" stroke-width="1.3" stroke-linecap="round" stroke-linejoin="round"><path d="M12.5974 12.5976L16.4998 16.5M7.57984 0.5C9.53504 0.5 11.3054 1.292 12.5862 2.5736C13.7445 3.73182 14.4653 5.25581 14.6259 6.88591C14.7865 8.51602 14.3769 10.1514 13.4669 11.5133C12.5569 12.8753 11.2028 13.8796 9.63536 14.3551C8.0679 14.8306 6.38407 14.7479 4.87074 14.1211C3.35742 13.4943 2.10825 12.3622 1.33608 10.9176C0.563904 9.47306 0.3165 7.80544 0.636021 6.19891C0.955542 4.59239 1.82222 3.14635 3.08838 2.10719C4.35454 1.06803 5.94185 0.500039 7.57984 0.5Z"/></svg>
      </span>

      <input
        class="hbe-404__search-input"
        type="text"
        name="s"
        value=""
        placeholder="{l s='Search our catalog' d='Shop.Theme.Catalog'}"
        id="hbe-404-search-input"
        aria-label="{l s='Search' d='Shop.Theme.Catalog'}"
        autocomplete="off"
      >

      {if $spis_on}
        <span class="hbe-404__search-photo">{hook h='displayImageSearchButton'}</span>
      {/if}

      <button type="submit" class="btn btn-primary hbe-404__search-submit">
        {l s='Search' d='Shop.Theme.Catalog'}
      </button>
    </form>

    {block name='hook_not_found'}
      {hook h='displayNotFound'}
    {/block}

    <p class="hbe-404__contact">
      {l
        s='If this is a recurring problem, please [1]contact us[/1].'
        d='Shop.Theme.Catalog'
        sprintf=[
          '[1]' => '<a href="'|cat:{$urls.pages.contact|escape:'htmlall'}|cat:'">',
          '[/1]' => '</a>'
        ]
      }
    </p>

  </section>
{/block}
