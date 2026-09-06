{**
 * For the full copyright and license information, please view the
 * LICENSE.md file that was distributed with this source code.
 *
 * Adresy i teksty wchodza tu przez |jsonld_url i |json_encode (plugins/), bo
 * domyslny escape HTML Smarty'ego robi w JSON-LD szkody: encja `&amp;` zostaje
 * w <script> encja, a znaki narodowe ze slugow ida surowym UTF-8. Search Console
 * zglaszala jedno i drugie jako „Nieprawidlowy URL w polu id”.
 *}
<script type="application/ld+json">
  {
    "@context": "https://schema.org",
    "@type": "Organization",
    "name" : {$shop.name|json_encode nofilter},
    "url" : {$urls.pages.index|jsonld_url nofilter}
    {if $shop.logo_details}
      ,"logo": {
        "@type": "ImageObject",
        "url": {$shop.logo_details.src|jsonld_url nofilter}
      }
    {/if}
  }
</script>

<script type="application/ld+json">
  {
    "@context": "https://schema.org",
    "@type": "WebPage",
    "isPartOf": {
      "@type": "WebSite",
      "url":  {$urls.pages.index|jsonld_url nofilter},
      "name": {$shop.name|json_encode nofilter}
    },
    "name": {$page.meta.title|json_encode nofilter},
    "url":  {$urls.current_url|jsonld_url nofilter}
  }
</script>

{if $page.page_name == 'index'}
  <script type="application/ld+json">
    {
      "@context": "https://schema.org",
      "@type": "WebSite",
      "url" : {$urls.pages.index|jsonld_url nofilter},
      "image": {
        "@type": "ImageObject",
        "url": {$shop.logo_details.src|jsonld_url nofilter}
      },
      {* Bez |jsonld_url: Google wymaga tu doslownych klamer {search_term_string}. *}
      "potentialAction": {
        "@type": "SearchAction",
        "target": "{'--search_term_string--'|str_replace:'{search_term_string}':$link->getPageLink('search',true,null,['search_query'=>'--search_term_string--'])}",
        "query-input": "required name=search_term_string"
      }
    }
  </script>
{/if}

{if isset($breadcrumb.links[1])}
  <script type="application/ld+json">
    {
      "@context": "https://schema.org",
      "@type": "BreadcrumbList",
      "itemListElement": [
        {foreach from=$breadcrumb.links item=path name=breadcrumb}
          {
            "@type": "ListItem",
            "position": {$smarty.foreach.breadcrumb.iteration},
            "name": {$path.title|json_encode nofilter},
            "item": {$path.url|jsonld_url nofilter}
            }{if !$smarty.foreach.breadcrumb.last},{/if}
          {/foreach}]
        }
  </script>
{/if}
