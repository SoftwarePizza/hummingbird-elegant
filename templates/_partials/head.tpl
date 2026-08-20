{**
 * For the full copyright and license information, please view the
 * LICENSE.md file that was distributed with this source code.
 *}
{block name='head_charset'}
  <meta charset="utf-8">
{/block}

{block name='head_ie_compatibility'}
  <meta http-equiv="x-ua-compatible" content="ie=edge">
{/block}

{block name='head_seo'}
  {block name='head_preload'}
    {include file='_partials/preload.tpl'}
    {* Preload the above-the-fold web fonts (Lora = headings, Geist = body/buttons)
       so text paints in its final font instead of flashing from the fallback (FOUT).
       Hashes are content-stable; update them only if the @fontsource files change. *}
    <link rel="preload" href="{$urls.theme_assets}fonts/lora-latin-400-normal-68bde7ec05b4d942f07f.woff2" as="font" type="font/woff2" crossorigin>
    <link rel="preload" href="{$urls.theme_assets}fonts/geist-sans-latin-400-normal-32c502ac52226b7f181e.woff2" as="font" type="font/woff2" crossorigin>
    <link rel="preload" href="{$urls.theme_assets}fonts/geist-sans-latin-500-normal-2e03668b3b5a378f2799.woff2" as="font" type="font/woff2" crossorigin>

    {* eTrusted (Trusted Shops) — skrypt startowy widgetów opinii. Tak samo jak
       w starym szablonie ładuje się na każdej stronie: sam nic nie rysuje,
       dopiero podnosi znaczniki <etrusted-widget> (karta produktu). *}
    <script src="https://integrations.etrusted.com/applications/widget.js/v2" defer async></script>
  {/block}

  <title>{block name='head_seo_title'}{$page.meta.title}{/block}</title>

  {block name='hook_after_title_tag'}
    {hook h='displayAfterTitleTag'}
  {/block}

  <meta name="description" content="{block name='head_seo_description'}{$page.meta.description}{/block}">

  {if $page.meta.robots !== 'index'}
    <meta name="robots" content="{$page.meta.robots}">
  {/if}

  {if $page.canonical}
    <link rel="canonical" href="{$page.canonical}">
  {/if}

  {block name='head_hreflang'}
    {foreach from=$urls.alternative_langs item=pageUrl key=code}
      <link rel="alternate" href="{$pageUrl}" hreflang="{$code}">
    {/foreach}
  {/block}

  {block name='head_microdata'}
    {include file='_partials/microdata/head-jsonld.tpl'}
  {/block}

  {block name='head_microdata_special'}{/block}

  {block name='head_pagination_seo'}
    {include file='_partials/pagination-seo.tpl'}
  {/block}

  {block name='head_open_graph'}
    <meta property="og:title" content="{$page.meta.title}">
    <meta property="og:description" content="{$page.meta.description}">
    <meta property="og:url" content="{$urls.current_url}">
    <meta property="og:site_name" content="{$shop.name}">
    {if !isset($product) && $page.page_name != 'product'}<meta property="og:type" content="website">{/if}
  {/block}
{/block}

{block name='head_viewport'}
  <meta name="viewport" content="width=device-width, initial-scale=1">
{/block}

{block name='head_icons'}
  <link rel="icon" type="image/vnd.microsoft.icon" href="{$shop.favicon}?{$shop.favicon_update_time}">
  <link rel="shortcut icon" type="image/x-icon" href="{$shop.favicon}?{$shop.favicon_update_time}">
{/block}

{block name='stylesheets'}
  {include file='_partials/stylesheets.tpl' stylesheets=$stylesheets}
{/block}

{block name='javascript_head'}
  {include file='_partials/javascript.tpl' javascript=$javascript.head vars=$js_custom_vars}
{/block}

{block name='hook_header'}
  {$HOOK_HEADER nofilter}
{/block}

{block name='hook_extra'}{/block}
