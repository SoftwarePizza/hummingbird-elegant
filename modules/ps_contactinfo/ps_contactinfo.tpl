{**
 * For the full copyright and license information, please view the
 * LICENSE.md file that was distributed with this source code.
 *
 * KONTAKT — bespoke Rosenthal footer column (design from Figma).
 * Content is store-specific and edited here in the fork. Social profile URLs
 * come from hummingbird_editor (BO: Hummingbird Editor > Ustawienia > Social
 * media); this template only owns the icon set.
 *}
<section
  class="ps-contactinfo footer-block"
  aria-labelledby="footer_contactinfo_title"
>
  <p
    id="footer_contactinfo_title"
    class="footer-block__title footer-block__title--toggle"
  >
    {l s='Kontakt' d='Shop.Theme.Global'}
    <button
      class="stretched-link collapsed d-md-none"
      type="button"
      data-bs-toggle="collapse"
      data-bs-target="#footer_contactinfo"
      aria-expanded="false"
      aria-controls="footer_contactinfo"
    >
      <span class="visually-hidden">{l s='Toggle contact information' d='Shop.Theme.Global'}</span>
      <i class="material-icons" aria-hidden="true">&#xE313;</i>
    </button>
  </p>

  <div class="footer-block__content collapse" id="footer_contactinfo">
    {* Sklep stacjonarny: adres z konfiguracji sklepu (Preferencje > Kontakt),
       godziny otwarcia i link do Google Maps wpisane tu na sztywno. Klucze
       fraz są angielskie, tłumaczenia (w tym polskie) leżą w
       themes/hummingbird/translations/<locale>/ShopThemeGlobal.<locale>.xlf *}
    <div class="ps-contactinfo__store">
      <p class="ps-contactinfo__store-label">
        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M20 10c0 6-8 12-8 12s-8-6-8-12a8 8 0 0 1 16 0z"/><circle cx="12" cy="10" r="3"/></svg>
        {l s='Our store' d='Shop.Theme.Global'}
      </p>
      <address class="ps-contactinfo__address">
        {if $contact_infos.address.address1}{$contact_infos.address.address1}<br>{/if}
        {if $contact_infos.address.address2}{$contact_infos.address.address2}<br>{/if}
        {$contact_infos.address.postcode} {$contact_infos.address.city}{if $contact_infos.address.country}, {$contact_infos.address.country}{/if}
      </address>
      <p class="ps-contactinfo__hours">
        <span class="ps-contactinfo__hours-row"><span class="ps-contactinfo__hours-day">{l s='Mon–Fri' d='Shop.Theme.Global'}</span> 9:00–17:00</span>
        <span class="ps-contactinfo__hours-row"><span class="ps-contactinfo__hours-day">{l s='Sat' d='Shop.Theme.Global'}</span> 9:00–14:00</span>
      </p>
      <a class="ps-contactinfo__map" href="https://maps.app.goo.gl/AD5qVMWZEVgGCXZt8" target="_blank" rel="noopener">
        {l s='Show on Google Maps' d='Shop.Theme.Global'}
        <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M7 17 17 7M8 7h9v9"/></svg>
      </a>
    </div>

    {if $contact_infos.phone}
      <p class="ps-contactinfo__line">
        {l s='Call us' d='Shop.Theme.Global'}: <a href="tel:{$contact_infos.phone|escape:'html':'UTF-8'|replace:' ':''|replace:'-':''}">{$contact_infos.phone}</a>
      </p>
    {/if}

    {if $contact_infos.email}
      <p class="ps-contactinfo__line">
        Email: <a href="mailto:{$contact_infos.email|escape:'html':'UTF-8'}">{$contact_infos.email}</a>
      </p>
    {/if}

    {if !empty($hbe_social_links)}
      <div class="footer__social">
        {foreach from=$hbe_social_links item='hbe_social'}
          <a href="{$hbe_social.url}" aria-label="{$hbe_social.label}" target="_blank" rel="noopener">
            {if $hbe_social.key === 'instagram'}
              <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" aria-hidden="true"><rect x="2" y="2" width="20" height="20" rx="5"/><circle cx="12" cy="12" r="4"/><circle cx="17.5" cy="6.5" r="1" fill="currentColor" stroke="none"/></svg>
            {elseif $hbe_social.key === 'facebook'}
              <svg width="18" height="18" viewBox="0 0 24 24" fill="currentColor" aria-hidden="true"><path d="M14 8h2V5h-2c-2 0-3 1-3 3v2H9v3h2v6h3v-6h2l1-3h-3V8c0-.6.4-1 1-1z"/></svg>
            {elseif $hbe_social.key === 'youtube'}
              <svg width="18" height="18" viewBox="0 0 24 24" fill="currentColor" aria-hidden="true"><path d="M21.6 7.2c-.2-.9-.9-1.5-1.7-1.7C18.3 5.1 12 5.1 12 5.1s-6.3 0-7.9.4c-.8.2-1.5.8-1.7 1.7C2 8.8 2 12 2 12s0 3.2.4 4.8c.2.9.9 1.5 1.7 1.7 1.6.4 7.9.4 7.9.4s6.3 0 7.9-.4c.8-.2 1.5-.8 1.7-1.7.4-1.6.4-4.8.4-4.8s0-3.2-.4-4.8zM10 15.1V8.9l5.2 3.1-5.2 3.1z"/></svg>
            {elseif $hbe_social.key === 'pinterest'}
              <svg width="18" height="18" viewBox="0 0 24 24" fill="currentColor" aria-hidden="true"><path d="M12 2a10 10 0 0 0-3.65 19.31c-.09-.78-.17-1.98.03-2.83.19-.78 1.2-4.96 1.2-4.96s-.31-.61-.31-1.52c0-1.42.83-2.48 1.85-2.48.88 0 1.3.66 1.3 1.45 0 .88-.56 2.2-.85 3.42-.24 1.03.51 1.86 1.53 1.86 1.84 0 3.25-1.94 3.25-4.73 0-2.47-1.78-4.2-4.32-4.2-2.94 0-4.67 2.21-4.67 4.49 0 .89.34 1.84.77 2.36.08.1.1.19.07.29-.08.32-.25.99-.28 1.13-.05.19-.15.23-.35.14-1.3-.61-2.11-2.5-2.11-4.03 0-3.28 2.38-6.29 6.87-6.29 3.6 0 6.4 2.57 6.4 6 0 3.58-2.26 6.46-5.39 6.46-1.05 0-2.04-.55-2.38-1.2l-.65 2.47c-.23.9-.86 2.03-1.29 2.72A10 10 0 1 0 12 2z"/></svg>
            {elseif $hbe_social.key === 'tiktok'}
              <svg width="18" height="18" viewBox="0 0 24 24" fill="currentColor" aria-hidden="true"><path d="M16.6 5.82A4.28 4.28 0 0 1 15.54 3h-3.09v12.4a2.59 2.59 0 0 1-2.59 2.5 2.59 2.59 0 1 1 .77-5.06V9.66a5.68 5.68 0 0 0-.77-.05A5.69 5.69 0 1 0 15.54 15.3V8.9a7.35 7.35 0 0 0 4.3 1.38V7.19a4.29 4.29 0 0 1-3.24-1.37z"/></svg>
            {elseif $hbe_social.key === 'linkedin'}
              <svg width="18" height="18" viewBox="0 0 24 24" fill="currentColor" aria-hidden="true"><path d="M6.94 5a1.94 1.94 0 1 1-3.88 0 1.94 1.94 0 0 1 3.88 0zM3.5 8.5h3.4V21H3.5V8.5zm5.8 0h3.26v1.7h.05c.45-.86 1.56-1.77 3.21-1.77 3.43 0 4.06 2.26 4.06 5.2V21h-3.4v-6.5c0-1.55-.03-3.54-2.16-3.54-2.16 0-2.49 1.69-2.49 3.43V21H9.3V8.5z"/></svg>
            {elseif $hbe_social.key === 'x'}
              <svg width="18" height="18" viewBox="0 0 24 24" fill="currentColor" aria-hidden="true"><path d="M18.24 2.25h3.31l-7.23 8.26 8.5 11.24h-6.66l-5.21-6.82-5.97 6.82H1.66l7.73-8.84L1.24 2.25h6.83l4.71 6.23 5.46-6.23zm-1.16 17.52h1.83L7.08 4.13H5.11l11.97 15.64z"/></svg>
            {/if}
          </a>
        {/foreach}
      </div>
    {/if}
  </div>
</section>
