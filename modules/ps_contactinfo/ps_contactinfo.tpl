{**
 * For the full copyright and license information, please view the
 * LICENSE.md file that was distributed with this source code.
 *
 * KONTAKT — bespoke Rosenthal footer column (design from Figma).
 * Content is store-specific and edited here in the fork. Social URLs are
 * placeholders (href="#") — replace with the real Instagram / Facebook links.
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
    <p class="ps-contactinfo__line">
      {l s='Infolinia' d='Shop.Theme.Global'}: <a href="tel:+48613072080">61 307 20 80</a>
    </p>

    <p class="ps-contactinfo__line">
      <strong>{l s='Online shop (7:30-15:30)' d='Shop.Theme.Global'}</strong><br>
      {l s='Telefon' d='Shop.Theme.Global'}: <a href="tel:+48730900116">730 900 116</a><br>
      Email: <a href="mailto:sklep@rosenthal.pl">sklep@rosenthal.pl</a>
    </p>

    <p class="ps-contactinfo__line">
      <strong>{l s='Rosenthal Polska - biuro' d='Shop.Theme.Global'}</strong><br>
      Email: <a href="mailto:office@rosenthal.pl">office@rosenthal.pl</a>
    </p>

    <div class="footer__social">
      <a href="#" aria-label="Instagram" target="_blank" rel="noopener">
        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" aria-hidden="true"><rect x="2" y="2" width="20" height="20" rx="5"/><circle cx="12" cy="12" r="4"/><circle cx="17.5" cy="6.5" r="1" fill="currentColor" stroke="none"/></svg>
      </a>
      <a href="#" aria-label="Facebook" target="_blank" rel="noopener">
        <svg width="18" height="18" viewBox="0 0 24 24" fill="currentColor" aria-hidden="true"><path d="M14 8h2V5h-2c-2 0-3 1-3 3v2H9v3h2v6h3v-6h2l1-3h-3V8c0-.6.4-1 1-1z"/></svg>
      </a>
    </div>
  </div>
</section>
