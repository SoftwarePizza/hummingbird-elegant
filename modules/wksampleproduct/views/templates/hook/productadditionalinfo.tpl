{**
 * Nadpisanie szablonu modułu wksampleproduct dla motywu hummingbird.
 * Oryginał: modules/wksampleproduct/views/templates/hook/productadditionalinfo.tpl
 * (Webkul, AFL-3.0) — pisany pod motyw Classic: `control-label`, `product-price`,
 * bootstrap-touchspin i przycisk kolorowany inline z konfiguracji modułu
 * (#2fb5d2), przez co blok nie miał nic wspólnego z kartą produktu Hummingbirda.
 *
 * Tu jest ten sam blok złożony jako osobny kafel („karta próbki”) z tokenów
 * motywu. Czego NIE wolno ruszać, bo trzyma to na sobie views/js/wksampleproduct.js:
 *   - id: wksamplebuybtn, wkquantity_wanted, wk_sp_standard_product_error,
 *     wk_sp_ajax_error_wrap, wk_sp_ajax_error, wksampleproductqty_spinerror,
 *     wksampleproductqty_stockerror
 *   - klasy: .wk-sample-block i .product-quantity na kontenerze akcji
 *     (JS robi na nich hide()/show()), .wkjs-touchspin + .wkbootstrap-touchspin-up/-down
 *   - klasa `alert` na obu komunikatach — getSampleMaxQuantity() czyści je
 *     zbiorczym $('div.alert').hide()
 *   - atrybuty data-* przycisku
 * Nazwa pliku też jest wiążąca: stary system tłumaczeń modułu kluczuje frazy
 * jako <{wksampleproduct}prestashop>productadditionalinfo_<md5>, więc frazy
 * modułu muszą zostać co do znaku takie jak w oryginale.
 *
 * Kolejność w pliku ma znaczenie dla ets_translate: jego regex na frazy motywu
 * jest zachłanny między `s=` a `d=` (modyfikator /s), więc frazę z d='Shop.…'
 * trzeba trzymać PRZED frazami modułu z mod='…' — inaczej ekstraktor sklei
 * pierwszą frazę modułu z domeną motywu i zgubi tę właściwą.
 *}

<div class="wk-sample-block sample-offer">
    <div class="sample-offer__card">
        <div class="sample-offer__head">
            <span class="sample-offer__icon" aria-hidden="true">
                <i class="material-icons">&#xE14E;</i>
            </span>

            <span class="sample-offer__title">{l s='Próbka produktu' d='Shop.Theme.Catalog'}</span>

            {if isset($samplePrice) && isset($sampleOrgPrice)}
                <span class="sample-offer__price{if $sampleOrgPrice == 0} sample-offer__price--free{/if}">
                    <span class="visually-hidden">{l s='Sample price' mod='wksampleproduct'} : </span>
                    {if $sampleOrgPrice == 0}
                        {l s='Free' mod='wksampleproduct'}
                    {else}
                        {$samplePrice}
                        <span class="sample-offer__tax">{if (($sample.price_type == 4) && ($sample.price_tax == 0)) || ($isTaxExclDisplay)}{l s='Tax excluded' mod='wksampleproduct'}{else}{l s='Tax included' mod='wksampleproduct'}{/if}</span>
                    {/if}
                </span>
            {/if}
        </div>

        {if isset($sample.description) && $sample.description|strip_tags|trim}
            <div class="sample-offer__desc">{$sample.description nofilter}</div>
        {/if}

        <div class="sample-offer__actions product-quantity clearfix" {if isset($standardAdded) && $standardAdded} style="display:none"{/if}>
            {if $wkShowQtySpin}
                <div class="sample-offer__qty wktouchspin quantity-button__group input-group">
                    <button class="btn btn-square-icon wkjs-touchspin wkbootstrap-touchspin-down" type="button" aria-label="{l s='Sample quantity' mod='wksampleproduct'}">
                        <i class="material-icons" aria-hidden="true">&#xE15B;</i>
                    </button>
                    <input type="text" name="wkqty" id="wkquantity_wanted" class="form-control" min="1" value="1" inputmode="numeric" pattern="[0-9]+" aria-label="{l s='Sample quantity' mod='wksampleproduct'}">
                    <button class="btn btn-square-icon wkjs-touchspin wkbootstrap-touchspin-up" type="button" aria-label="{l s='Sample quantity' mod='wksampleproduct'}">
                        <i class="material-icons" aria-hidden="true">&#xE145;</i>
                    </button>
                </div>
            {else}
                <input type="hidden" name="wkqty" id="wkquantity_wanted" value="1">
            {/if}

            <button class="btn sample-offer__btn add-to-cart"
                id="wksamplebuybtn"
                type="button"
                data-id-product="{$wkIdProduct}"
                data-id-customer="{$wkIdCustomer}"
                data-id-product-attr="{$wkIdProductAttr}"
                data-cart-url="{$cartPageURL}"
                {if $sampleFullInCart}disabled{/if}
            >
                {if empty($sample.button_label)}
                    {l s='Buy sample' mod='wksampleproduct'}
                {else}{$sample.button_label}{/if}
            </button>

            <span id="wksampleproductqty_spinerror" class="sample-offer__note wksampleproduct-lineerror" {if !$sampleQtyWarning}style="display:none;"{/if}>
                <i class="material-icons wkproduct-unavailable" aria-hidden="true">&#xE88F;</i>
                {* Limit bywa podmieniany stanem magazynowym, a ten na tkaninach jest
                   ułamkowy („maksymalnie 16.4 próbkę”) — próbki liczą się w sztukach. *}
                {l s='You can buy maximum ' mod='wksampleproduct'}{if $sample.max_cart_qty >= 1}{$sample.max_cart_qty|intval}{else}1{/if} {l s='samples.' mod='wksampleproduct'}
            </span>

            {if !$addToCartEnabled || $sampleFullInCart}
                <span id="wksampleproductqty_stockerror" class="sample-offer__note wksampleproduct-lineerror">
                    <i class="material-icons wkproduct-unavailable" aria-hidden="true">&#xE002;</i>
                    {l s='Out-of-stock' mod='wksampleproduct'}
                </span>
            {/if}
        </div>

        {* Komunikaty modułu siedzą w karcie, w miejscu przycisku: gdy w koszyku
           jest już zwykły produkt, JS chowa .product-quantity i pokazuje ten alert. *}
        <div class="alert sample-offer__alert" role="alert" id="wk_sp_standard_product_error" {if !isset($standardAdded) || !$standardAdded} style="display:none"{/if}>
            <i class="material-icons" aria-hidden="true">&#xE002;</i>
            <span>{l s='You have added this standard product in cart. Please proceed or delete that cart then you can buy the sample product' mod='wksampleproduct'}</span>
        </div>

        <div class="alert sample-offer__alert" role="alert" id="wk_sp_ajax_error_wrap" style="display:none">
            <i class="material-icons" aria-hidden="true">&#xE002;</i>
            <span id="wk_sp_ajax_error"></span>
        </div>
    </div>
</div>
