{**
 * Nadpisanie szablonu modulu revolutpayment (izpol).
 * Zmiana wzgledem oryginalu: pole karty i przycisk "Zaplac" siedza w jednym wierszu
 * (flex), przycisk jest wiekszy. Style: themes/hummingbird/assets/css/custom.css,
 * sekcja "Revolut - dedykowana strona platnosci".
 * ID elementow (#revolut_card, #revolutPayButton, #revolutForm, #revolutPublicId,
 * .revolutPaymentPageErrors) musza zostac - trzyma je JS modulu
 * (views/js/version17/revolut.payment.js).
 *}
{extends file='page.tpl'}
{block name='page_content'}

<h1 class="page-heading revolut-payment__title">{$revolut_payment_title|escape:'htmlall':'UTF-8'}</h1>

{if isset($nbProducts) && $nbProducts <= 0}
	<p class="warning">{l s='Shopping cart is empty.' mod='revolutpayment'}</p>
{else}
	<div class="revolut-payment">
		{if $payment_description != ''}
			<p class="revolut-payment__description">{$payment_description|escape:'htmlall':'UTF-8'}</p>
		{/if}

		{if $cardholderNameFieldEnabled}
			<div id="CARD_HOLDER_FILED_CONTAINER" class="form-group revolut-payment__cardholder"></div>
		{/if}

		<div class="revolut-payment__row">
			<div class="revolut-payment__field">
				<div id="revolut_card"></div>
			</div>
			<button id="revolutPayButton" type="button" class="btn btn-primary revolut-payment__btn" data-widget-type="deticated-page">
				<span>{l s='Pay' mod='revolutpayment'}</span>
			</button>
		</div>

		<div class="revolutPaymentPageErrors error hidden"></div>
	</div>

	<form id="revolutForm" method="post" action="{$controller_link|escape:'htmlall':'UTF-8'}">
		<input type="hidden" name="revolut_payment_title" id="revolutPaymentTitle" value="{$revolut_payment_title|escape:'htmlall':'UTF-8'}" />
		<input type="hidden" name="merchant_type" id="revolutMerchantType" value="{$merchant_type|escape:'htmlall':'UTF-8'}" />
		<input type="hidden" name="public_id" id="revolutPublicId" value="{$public_id|escape:'htmlall':'UTF-8'}" />
		<input type="hidden" name="email" value="{$customer_email|escape:'htmlall':'UTF-8'}" />
		<input type="hidden" name="customer_name" value="{$customer_name|escape:'htmlall':'UTF-8'}" />
		<input type="hidden" name="country" value="{$country->iso_code|escape:'htmlall':'UTF-8'}" />
		<input type="hidden" name="state" value="{$state->iso_code|escape:'htmlall':'UTF-8'}" />
		<input type="hidden" name="city" value="{$address->city|escape:'htmlall':'UTF-8'}" />
		<input type="hidden" name="line1" value="{$address->address1|escape:'htmlall':'UTF-8'}" />
		<input type="hidden" name="line2" value="{$address->address2|escape:'htmlall':'UTF-8'}" />
		<input type="hidden" name="postal" value="{$address->postcode|escape:'htmlall':'UTF-8'}" />
		<input type="hidden" id="revolutLocale" name="locale" value="{$locale|escape:'htmlall':'UTF-8'}"/>
	</form>
{/if}
{/block}
