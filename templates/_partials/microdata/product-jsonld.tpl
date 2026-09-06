{**
 * For the full copyright and license information, please view the
 * LICENSE.md file that was distributed with this source code.
 *}
{assign var=hasAggregateRating value=false}

{if !empty($product.productComments.averageRating) && !empty($product.productComments.nbComments)}
  {assign var=hasAggregateRating value=true}
  {assign var=ratingValue value=$product.productComments.averageRating}
  {assign var=ratingReviewCount value=$product.productComments.nbComments}
{/if}

{if !empty($ratings.avg) && !empty($nbComments)}
  {assign var=hasAggregateRating value=true}
  {assign var=ratingValue value=$ratings.avg}
  {assign var=ratingReviewCount value=$nbComments}
{/if}

{assign var=hasWeight value=false}

{if isset($product.weight) && ($product.weight != 0)}
  {assign var=hasWeight value=true}
{/if}

{assign var=hasOffers value=$product.show_price}

{**
 * Daty obowiazywania ceny (Google Merchant listings: validFrom + priceValidUntil
 * na wezle Offer, gdy `price` to aktualna cena sprzedazy).
 * Cena promocyjna z okreslonym terminem podaje swoje wlasne daty; przy promocji
 * bezterminowej i cenie zwyklej `validFrom` to data dodania produktu, a
 * `priceValidUntil` zostaje krotkim, ruchomym terminem jak dotad.
 *}
{assign var=offerValidFrom value=''}
{assign var=offerValidUntil value=($smarty.now + (int) (60*60*24*15))|date_format:"%Y-%m-%d"}

{if !empty($product.specific_prices.from) && $product.specific_prices.from|substr:0:4 != '0000'}
  {assign var=offerValidFrom value=$product.specific_prices.from|date_format:"%Y-%m-%d"}
{elseif !empty($product.date_add) && $product.date_add|substr:0:4 != '0000'}
  {assign var=offerValidFrom value=$product.date_add|date_format:"%Y-%m-%d"}
{/if}

{if !empty($product.specific_prices.to) && $product.specific_prices.to|substr:0:4 != '0000'}
  {assign var=offerValidUntil value=$product.specific_prices.to|date_format:"%Y-%m-%d"}
{/if}

{**
 * Opis: meta description, a gdy pusta (rdzen buduje ja z krotkiego opisu, wiec produkt
 * bez krotkiego opisu nie ma zadnej) — pelny opis, na koncu nazwa. Google zglasza
 * pusty `description` jako brakujace pole. `sku`/`mpn` nigdy puste (pusta referencja -> id).
 *}
{assign var=jsonDescription value=$page.meta.description|regex_replace:"/[\r\n]+/":" "|trim}
{if $jsonDescription == '' && !empty($product.description_short)}
  {assign var=jsonDescription value=$product.description_short|replace:'&nbsp;':' '|strip_tags:' '|regex_replace:"/\s+/":" "|trim}
{/if}
{if $jsonDescription == '' && !empty($product.description)}
  {assign var=jsonDescription value=$product.description|replace:'&nbsp;':' '|strip_tags:' '|regex_replace:"/\s+/":" "|trim|truncate:1000:"…"}
{/if}
{if $jsonDescription == ''}
  {assign var=jsonDescription value=$product.name}
{/if}
{assign var=jsonSku value=$product.reference|default:''|trim}
{if $jsonSku == ''}{assign var=jsonSku value=$product.id}{/if}
{assign var=jsonMpn value=$product.mpn|default:''|trim}
{if $jsonMpn == ''}{assign var=jsonMpn value=$jsonSku}{/if}

<script type="application/ld+json">
  {
    "@context": "https://schema.org/",
    "@type": "Product",
    "name": "{$product.name}",
    "description": "{$jsonDescription}",
    "category": "{$product.category_name}",
    {if !empty($product.cover)}"image": {$product.cover.bySize.home_default.url|jsonld_url nofilter},{/if}
    "sku": "{$jsonSku}",
    "mpn": "{$jsonMpn}"
    {if $product.ean13},"gtin": "{$product.ean13}"{/if}
    {if $product.upc},"gtin12": "{$product.upc}"{/if}
    {if isset($product_manufacturer) && $product_manufacturer->name},
    "brand": {
      "@type": "Brand",
      "name": "{$product_manufacturer->name|escape:'html':'UTF-8'}"
    }
    {elseif $shop.name},
    {* Google oczekuje w `brand` typu Brand — Organization jest raportowane
       w Search Console jako nieprawidlowy typ obiektu. *}
    "brand": {
      "@type": "Brand",
      "name": "{$shop.name}"
    }
    {/if}
    {if $hasAggregateRating},
    "aggregateRating": {
      "@type": "AggregateRating",
      "ratingValue": "{$ratingValue|round:1|escape:'html':'UTF-8'}",
      "reviewCount": "{$ratingReviewCount|escape:'html':'UTF-8'}"
    }
    {/if}
    {if $hasWeight},
    "weight": {
        "@context": "https://schema.org",
        "@type": "QuantitativeValue",
        "value": "{$product.weight}",
        "unitCode": "{$product.weight_unit}"
    }
    {/if}
    {if $hasOffers},
    "offers": {
      "@type": "Offer",
      "priceCurrency": "{$currency.iso_code}",
      "price": "{$product.price_amount}",
      "url": {$product.url|jsonld_url nofilter},
      {if $offerValidFrom}"validFrom": "{$offerValidFrom}",{/if}
      "priceValidUntil": "{$offerValidUntil}",
      {if $product.images|count > 0}
        "image": {strip}[
          {foreach from=$product.images item=p_img name="p_img_list"}
            {$p_img.large.url|jsonld_url nofilter}{if not $smarty.foreach.p_img_list.last},{/if}
          {/foreach}
        ]{/strip},
      {/if}
      {if !empty($product.show_condition) && !empty($product.condition)}"itemCondition": "{$product.condition.schema_url}",{/if}
      "availability": "{$product.seo_availability}",
      "seller": {
        "@type": "Organization",
        "name": "{$shop.name}"
      }
      {* Google Merchant listings: koszt/czas dostawy i polityka zwrotow. Gotowy JSON
         przekazuje modul sp_merchantdata (liczy z konfiguracji przewoznikow) — bez niego
         obu pol po prostu nie ma, jak dotad. *}
      {if isset($sp_merchant_shipping_json) && $sp_merchant_shipping_json},
      "shippingDetails": {$sp_merchant_shipping_json nofilter}
      {/if}
      {if isset($sp_merchant_return_json) && $sp_merchant_return_json},
      "hasMerchantReturnPolicy": {$sp_merchant_return_json nofilter}
      {/if}
    }
    {/if}
  }
</script>
