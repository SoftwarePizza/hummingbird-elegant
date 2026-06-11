{**
 * For the full copyright and license information, please view the
 * LICENSE.md file that was distributed with this source code.
 *}
<section class="ps-emailsubscription ps-emailsubscription--column footer-block col-md-6 col-lg-3" id="emailsubscription_anchor_{$hookName}">
  <p class="footer-block__title">{l s='Newsletter' d='Shop.Theme.Global'}</p>

  <div class="footer-block__content">
    <p class="ps-emailsubscription__intro">
      {l s='Otrzymuj informacje o najnowszych produktach, promocjach i wydarzeniach.' d='Shop.Theme.Global'}
    </p>

    <form class="ps-emailsubscription__form" action="{$urls.current_url}#emailsubscription_anchor_{$hookName}" method="post">
      {if $msg}
        <div class="alert {if $nw_error}alert-danger{else}alert-success{/if} alert-dismissible fade show mb-2" role="alert" tabindex="0">
          {$msg}
          <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="{l s='Close' d='Shop.Theme.Global'}"></button>
        </div>
      {/if}

      <div class="ps-emailsubscription__field">
        <label for="newsletter_input_{$hookName}" class="visually-hidden">{l s='Your email address' d='Modules.Emailsubscription.Shop'}</label>
        <input
          class="ps-emailsubscription__input"
          type="email"
          name="email"
          value="{$value}"
          placeholder="{l s='Email' d='Shop.Theme.Global'}"
          id="newsletter_input_{$hookName}"
          autocomplete="email"
          required
        />
        <button class="ps-emailsubscription__submit" type="submit" name="submitNewsletter" aria-label="{l s='Subscribe to our newsletter' d='Modules.Emailsubscription.Shop'}">
          <i class="material-icons rtl-no-flip" aria-hidden="true">&#xE5CC;</i>
        </button>
      </div>

      {capture name="display_gdpr_consent"}{hook h='displayGDPRConsent' id_module=$id_module}{/capture}
      {if isset($smarty.capture.display_gdpr_consent) && $smarty.capture.display_gdpr_consent}
        <div class="ps-emailsubscription__gdpr">
          {$smarty.capture.display_gdpr_consent nofilter}
        </div>
      {/if}

      {if $conditions}
        <p class="ps-emailsubscription__fineprint">{$conditions}</p>
      {/if}

      {hook h='displayNewsletterRegistration'}

      <input type="hidden" value="{$hookName}" name="blockHookName" />
      <input type="hidden" name="action" value="0" />
    </form>
  </div>
</section>
