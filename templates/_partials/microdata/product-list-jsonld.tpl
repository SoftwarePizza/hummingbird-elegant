{**
 * For the full copyright and license information, please view the
 * LICENSE.md file that was distributed with this source code.
 *
 * 2026-08-23: wartosci sa wypisywane przez |json_encode, a nie recznie
 * cudzyslowami z |escape:'json'.
 *
 * Powod: Smarty nie zna typu 'json' w modyfikatorze escape (zna html, htmlall,
 * url, urlpathinfo, quotes, hex, hexentity, decentity, javascript, mail,
 * nonstd). Dla nieznanego typu zwracal LANCUCH BEZ ZMIAN i logowal notice.
 * Skutkiem byl niepoprawny JSON wszedzie tam, gdzie nazwa albo opis zawieral
 * cudzyslow (636 nazw produktow) albo znak nowej linii - Google nie czytal
 * wtedy calej listy ItemList. Potwierdzone na /43-promocje.
 *
 * json_encode sam dodaje cudzyslowy i escapuje wszystko poprawnie, dlatego
 * cudzyslowy wokol {$...} zniknely. "nofilter" wylacza auto-escapowanie
 * Smarty'ego, ktore inaczej zamienilo by cudzyslowy z json_encode na &quot;.
 *
 * Uwaga na przyszlosc: json_encode dziala tu jako funkcja PHP uzyta w roli
 * modyfikatora. Smarty 4 to akceptuje (z ostrzezeniem E_DEPRECATED), Smarty 5
 * juz nie - przy aktualizacji PrestaShopa trzeba to zamienic na wlasny
 * modyfikator rejestrowany przez modul.
 *
 * 2026-09-29 (Novehi): lista wypisuje tylko adresy produktow (ListItem: position + url),
 * bez zagniezdzonego Product/Offer. Google traktowal kazdy kafel listingu jak osobna
 * oferte do „Informacji o sprzedawcy” i zglaszal na kategoriach brak marki, opisu,
 * shippingDetails i hasMerchantReturnPolicy — pelne dane oferty sa na karcie produktu
 * (product-jsonld.tpl), a kategorie i tak nie dostaja wynikow produktowych.
 *}
<script type="application/ld+json">
  {
    "@context": "https://schema.org",
    "@type": "ItemList",
    "itemListElement": [
    {$needsComma = false}
    {$position = 0}
    {foreach from=$listing.products item=item name=productsForJsonLd}
      {$position = $position + 1}
      {if $needsComma},{/if}
      {$needsComma = true}
      {
        "@type": "ListItem",
        "position": {$position},
        "url": {$item.url|jsonld_url nofilter}
      }
    {/foreach}
    ]
  }
</script>
