{**
 * For the full copyright and license information, please view the
 * LICENSE.md file that was distributed with this source code.
 *}
{block name='copyright'}
  <div class="copyright">
    {block name='copyright_text'}
      {l s='© %year% %shop_name%. All rights reserved.' sprintf=['%year%' => 'Y'|date, '%shop_name%' => $shop.name] d='Shop.Theme.Global'}
    {/block}
    {block name='recaptcha_notice'}
      {* Znaczek reCAPTCHA jest schowany (custom.css, sekcja 40) — Google
         wymaga wtedy widocznej informacji z odnosnikami do swojej polityki
         prywatnosci i regulaminu. Skrypt api.js leci na kazdej stronie
         (modul googlerecaptcha, displayHeader), wiec notka stoi w stopce,
         a nie przy pojedynczym formularzu. *}
      {* Zdanie sklada sie w {capture} i wypisuje przez `nofilter`, bo linki
         musza przejsc jako HTML. `nofilter` NIE moze stac przy samym {l} —
         Smarty liczy go wtedy jako skrocony atrybut i przewraca caly szablon
         bledem „too many shorthand attributes" (front 500). *}
      {capture name='recaptcha_privacy'}<a href="https://policies.google.com/privacy" target="_blank" rel="noopener nofollow">{l s='Privacy Policy' d='Shop.Theme.Global'}</a>{/capture}
      {capture name='recaptcha_terms'}<a href="https://policies.google.com/terms" target="_blank" rel="noopener nofollow">{l s='Terms of Service' d='Shop.Theme.Global'}</a>{/capture}
      {capture name='recaptcha_notice'}{l s='This site is protected by reCAPTCHA and the Google %privacy_policy% and %terms_of_service% apply.' sprintf=['%privacy_policy%' => $smarty.capture.recaptcha_privacy, '%terms_of_service%' => $smarty.capture.recaptcha_terms] d='Shop.Theme.Global'}{/capture}
      <p class="footer__recaptcha">{$smarty.capture.recaptcha_notice nofilter}</p>
    {/block}
    {block name='copyright_author'}
      <div class="copyright__author">
        {l s='Store by' d='Shop.Theme.Global'}
        <a href="https://softwarepizza.com" target="_blank" rel="noopener">Software Pizza E-commerce Team</a>
      </div>
    {/block}
  </div>
{/block}
