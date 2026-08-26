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
            {* Content comes from hummingbird_editor (BO: Hummingbird Editor >
               Stopka > Linki na dole stopki); the theme only owns the markup. *}
            {if !empty($hbe_footer_links)}
              <ul class="footer__bottom-links">
                {foreach from=$hbe_footer_links item='hbe_footer_link'}
                  {if $hbe_footer_link.url == '#cookies'}
                    {* Umowny adres '#cookies' zamienia pozycje paska w przycisk
                       otwierajacy okno zgod modulu seigicookie: `data-cc="c-settings"`
                       to jego wlasny selektor (modul sam robi preventDefault i
                       dokłada aria-haspopup). Etykieta zostaje w konfiguracji
                       edytora, wiec kazdy jezyk ma swoja.
                       Potrzebne, odkad ikona ciastka chowa sie poza strona glowna
                       (sekcja 44 custom.css) - to jedyne stale wejscie do zmiany
                       albo wycofania zgody. *}
                    <li><a href="#" data-cc="c-settings">{$hbe_footer_link.label|escape:'html':'UTF-8'}</a></li>
                  {else}
                    <li><a href="{$hbe_footer_link.url|escape:'html':'UTF-8'}">{$hbe_footer_link.label|escape:'html':'UTF-8'}</a></li>
                  {/if}
                {/foreach}
              </ul>
            {/if}
          {/block}

          {include file='_partials/copyright.tpl'}
        </div>
      {/block}
    </div>
  </div>
{/block}
