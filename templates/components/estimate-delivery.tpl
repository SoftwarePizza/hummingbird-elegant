{**
 * Termin wysyłki („Zamów dzisiaj — Twoje produkty wyślemy jutro!”).
 *
 * Port bloku ze starego szablonu (fashion → components/estimate-delivery.tpl,
 * sklep 1.7.8.5 pod dev.izpol.pl). Zachowane są DOKŁADNIE te same frazy
 * źródłowe `l s='…' d='Shop.Theme.Catalog'` — razem ze spacjami na końcu —
 * bo na nich stoją tłumaczenia w ps_translation (17 języków). Zmiana choćby
 * spacji odcina tłumaczenie i na froncie zostaje angielski oryginał.
 *
 * Różnice wobec starego szablonu:
 *  - ikona to material icon `schedule` z motywu, a nie ciężarówka z PNG-a
 *    z /themes/fashion: linijka stoi teraz nad „Darmowa dostawa od…”, która ma
 *    ciężarówkę, a dwie takie same ikony jedna pod drugą czytały się jak błąd.
 *    Ta mówi o CZASIE, tamta o przewoźniku — zielony akcent zostaje,
 *  - obliczenia bez `{math}` (zwykłe wyrażenia Smarty czytają się lepiej),
 *  - klasy w konwencji motywu (`product__delivery*`), style w custom.css sekcja 13.
 *
 * Logika (bez zmian): wysyłka tego samego dnia do godziny CUTOFF, w sobotę
 * i niedzielę oraz po CUTOFF w piątek — w poniedziałek, w pozostałe dni — jutro.
 * Godzina bierze się ze strefy czasowej sklepu (PS_TIMEZONE), nie z przeglądarki.
 *}

{assign var='hbeCutoff' value=11}

{assign var='hbeDay' value=$smarty.now|date_format:'%u'|intval}
{assign var='hbeHour' value=$smarty.now|date_format:'%H'|intval}
{assign var='hbeMinute' value=$smarty.now|date_format:'%M'|intval}

{assign var='hbeHoursLeft' value=$hbeCutoff-$hbeHour-1}
{if $hbeMinute == 0}
  {assign var='hbeMinutesLeft' value=59}
{else}
  {assign var='hbeMinutesLeft' value=60-$hbeMinute}
{/if}

<p class="product__delivery">
  <i class="material-icons" aria-hidden="true">&#xE8B5;</i>
  <span class="product__delivery-text">
    {if $hbeDay == 6 || $hbeDay == 7}
      {* weekend — najbliższa wysyłka w poniedziałek *}
      {l s='Order ' d='Shop.Theme.Catalog'}
      <span class="product__delivery-accent">{l s='today ' d='Shop.Theme.Catalog'}</span>
      {l s='and we will send your products in ' d='Shop.Theme.Catalog'}
      <span class="product__delivery-accent">{l s='monday!' d='Shop.Theme.Catalog'}</span>
    {elseif $hbeHoursLeft >= 1}
      {* przed cutoffem — zostało jeszcze co najmniej godzina *}
      {l s='Order within' d='Shop.Theme.Catalog'}
      <span class="product__delivery-accent">{$hbeHoursLeft}</span>
      {if $hbeHoursLeft == 1}
        {l s='hour and' d='Shop.Theme.Catalog'}
      {else}
        {l s='hours and' d='Shop.Theme.Catalog'}
      {/if}
      <span class="product__delivery-accent">{$hbeMinutesLeft} </span>
      {l s='minutes and we will send your package ' d='Shop.Theme.Catalog'}
      <span class="product__delivery-accent">{l s='today!' d='Shop.Theme.Catalog'}</span>
    {elseif $hbeHoursLeft == 0}
      {* ostatnia godzina przed cutoffem — same minuty *}
      {l s='Order within' d='Shop.Theme.Catalog'}
      <span class="product__delivery-accent">{$hbeMinutesLeft} </span>
      {l s='minutes and we will send your package ' d='Shop.Theme.Catalog'}
      <span class="product__delivery-accent">{l s='today!' d='Shop.Theme.Catalog'}</span>
    {elseif $hbeDay == 5}
      {* piątek po cutoffie *}
      {l s='Order ' d='Shop.Theme.Catalog'}
      <span class="product__delivery-accent">{l s='today ' d='Shop.Theme.Catalog'}</span>
      {l s='and we will send your products in ' d='Shop.Theme.Catalog'}
      <span class="product__delivery-accent">{l s='monday!' d='Shop.Theme.Catalog'}</span>
    {else}
      {* dzień roboczy po cutoffie *}
      {l s='Order ' d='Shop.Theme.Catalog'}
      <span class="product__delivery-accent">{l s='today ' d='Shop.Theme.Catalog'}</span>
      {l s='and we will send your products ' d='Shop.Theme.Catalog'}
      <span class="product__delivery-accent">{l s='tommorow!' d='Shop.Theme.Catalog'}</span>
    {/if}
  </span>
</p>
