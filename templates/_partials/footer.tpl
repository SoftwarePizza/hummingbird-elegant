{**
 * For the full copyright and license information, please view the
 * LICENSE.md file that was distributed with this source code.
 *}
{capture name="footer_before"}{hook h='displayFooterBefore'}{/capture}
{if $smarty.capture.footer_before}
  {block name='hook_footer_before'}
    <div class="footer footer__before">
      {$smarty.capture.footer_before nofilter}
    </div>
  {/block}
{/if}

{block name='footer_main'}
  <div class="footer footer__main">
    <div class="container">
      {capture name="footer_main_top"}{hook h='displayFooter'}{/capture}
      {if $smarty.capture.footer_main_top}
        {block name='hook_footer_main'}
          <div class="footer__main-top">
            {$smarty.capture.footer_main_top nofilter}
          </div>
        {/block}
      {/if}

      {capture name="footer_after"}{hook h='displayFooterAfter'}{/capture}
      {if $smarty.capture.footer_after}
        {block name='hook_footer_after'}
          <div class="footer__main-bottom">
            {$smarty.capture.footer_after nofilter}
          </div>
        {/block}
      {/if}

      {block name='footer_bottom'}
        <div class="footer__bottom">
          {block name='footer_legal'}
            <ul class="footer__bottom-links">
              <li><a href="/content/2-polityka-prywatnosci">{l s='Polityka prywatności' d='Shop.Theme.Global'}</a></li>
              <li><a href="/content/3-regulamin">{l s='Regulamin' d='Shop.Theme.Global'}</a></li>
              <li><a href="/content/14-informacje-o-rodo">{l s='Informacje o RODO' d='Shop.Theme.Global'}</a></li>
              {* TODO: brak dedykowanych stron CMS — placeholdery do podmiany *}
              <li><a href="#">{l s='Programy i karty' d='Shop.Theme.Global'}</a></li>
              <li><a href="#">{l s='Informacje GPSR' d='Shop.Theme.Global'}</a></li>
            </ul>
          {/block}

          {include file='_partials/copyright.tpl'}
        </div>
      {/block}
    </div>
  </div>
{/block}
