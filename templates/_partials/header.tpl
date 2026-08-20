{**
 * For the full copyright and license information, please view the
 * LICENSE.md file that was distributed with this source code.
 *
 * Układ „katalogowy": pasek pomocniczy (header-contact.tpl) → rząd główny
 * z logo, szerokim polem wyszukiwania i grupą ikon → osobny pasek menu.
 *
 * Rząd główny nie zawiera już menu — ps_mainmenu przeniesiony na
 * displayNavFullWidth, więc dostaje własny pasek pod spodem. Hamburger
 * mobilny został tutaj, bo offcanvas #mobileMenu i tak renderuje się globalnie.
 *
 * Grupa ikon po prawej (#_desktop_ps_customersignin, #_desktop_blockwishlist,
 * #_desktop_ps_shoppingcart) stoi od razu w <div class="header-bottom__icons">
 * — stąd displayTop jest wołany dwa razy: raz bez tych modułów (excl), raz
 * po jednym (mod). Wcześniej składał ją dopiero wrapHeaderIcons() z
 * assets/js/theme.js po DOMContentLoaded i ikony widocznie się przestawiały;
 * teraz ta funkcja (src/js/theme.ts) widzi gotowy kontener i nic nie robi.
 * Pole wyszukiwania celowo NIE
 * nazywa się _desktop_ps_searchbar — inaczej ta sama funkcja wciągnęłaby je
 * do kubełka z ikonami zamiast zostawić szerokie.
 *
 * Serduszko ulubionych renderuje sam motyw (blok header_wishlist_icon), nie
 * moduł: blockwishlist nie ma hooka nagłówkowego, a kupny advansedwishlist,
 * który kiedyś je dawał, jest wyłączony (osobne tabele, JS na jQuery). Klik
 * otwiera szufladę hummingbird_editor (data-ps-action="wishlist-preview-open"),
 * href to fallback dla nowej karty/bez JS. Licznik na sercu wypełnia
 * wishlist-preview.js (data-ps-ref="wishlist-count"); klasa empty_list chowa „0".
 *}

{$headerBanner = 'header-banner'}
{$headerTop = 'header-top'}
{$headerBottom = 'header-bottom'}
{$headerNavFullWidth = 'header-nav-full-width'}

{capture name="header_banner"}{hook h='displayBanner'}{/capture}
{block name='header_banner'}
  {if !empty($smarty.capture.header_banner)}
    <div class="{$headerBanner}">
      {$smarty.capture.header_banner nofilter}
    </div>
  {/if}
{/block}

{block name='header_bottom'}
  <div class="{$headerBottom}">
    <div class="{$headerBottom}__container container-md">
      <div class="{$headerBottom}__row gx-2 gx-md-3 align-items-center d-flex flex-wrap">

        {block name='header_burger'}
          {* Kolejność rzędów na telefonie: logo (0), potem hamburger (1)
             i ikony (2). Od md wraca układ jednorzędowy motywu.
             Klasami Bootstrapa, bo `order` z @layer utilities jest !important
             i z custom.css (poza warstwami) się tego nie przebije. *}
          <div class="{$headerBottom}__burger col-auto order-1 order-md-0 d-xl-none">
            <button
              class="header-block__action-btn {$headerBottom}__burger-btn"
              type="button"
              data-bs-toggle="offcanvas"
              data-bs-target="#mobileMenu"
              aria-controls="mobileMenu"
              aria-label="{l s='Open mobile menu' d='Shop.Theme.Menu'}"
            >
              <span class="material-icons" aria-hidden="true">&#xE5D2;</span>
            </button>
          </div>
        {/block}

        <div class="{$headerBottom}__logo d-flex align-items-center col-auto order-0 order-md-1 me-auto me-md-0">
          {if $shop.logo_details}
            {if $page.page_name == 'index'}<h1 class="{$headerBottom}__h1 mb-0">{/if}
              {renderLogo}
            {if $page.page_name == 'index'}</h1>{/if}
          {/if}
        </div>

        {* ambjolisearch (order-3/order-md-2) i reszta displayTop bez ikon
           konta i koszyka — te idą niżej, do wspólnego kontenera. *}
        {hook h='displayTop' excl='ps_customersignin,ps_shoppingcart'}

        {* Kontener grupy ikon; miejsce w rzędzie daje mu custom.css
           (.header-bottom__row > .header-bottom__icons, order 9). *}
        <div class="{$headerBottom}__icons">
        {hook h='displayTop' mod='ps_customersignin'}

        {block name='header_wishlist_icon'}
          <div id="_desktop_blockwishlist" class="order-4">
            <div class="header-block">
              <a
                href="{$link->getModuleLink('blockwishlist', 'lists', [], true)}"
                class="header-block__action-btn"
                rel="nofollow"
                data-ps-action="wishlist-preview-open"
                aria-label="{l s='My wishlists' d='Shop.Theme.Customeraccount'}"
              >
                <span class="header-block__icon-wrap">
                  <svg class="header-block__icon" width="20" height="20" viewBox="0 0 20 20" fill="none" xmlns="http://www.w3.org/2000/svg" aria-hidden="true"><path d="M1 7.86266C1.00002 6.8817 1.30383 5.92381 1.87132 5.11552C2.4388 4.30722 3.24326 3.68655 4.17844 3.33547C5.11362 2.98439 6.13553 2.91943 7.10919 3.14915C8.08286 3.37888 8.96248 3.89249 9.63187 4.62215C9.67902 4.67153 9.73602 4.7109 9.79934 4.73781C9.86266 4.76472 9.93095 4.77861 9.99997 4.77861C10.069 4.77861 10.1373 4.76472 10.2006 4.73781C10.2639 4.7109 10.3209 4.67153 10.3681 4.62215C11.0354 3.88775 11.9152 3.36982 12.8904 3.1373C13.8657 2.90478 14.8901 2.96871 15.8273 3.32056C16.7646 3.67241 17.5702 4.2955 18.1369 5.10691C18.7037 5.91831 19.0047 6.87954 18.9999 7.86266C18.9999 9.88137 17.6499 11.3888 16.3 12.7111L11.3572 17.3947C11.1895 17.5833 10.9827 17.7349 10.7506 17.8392C10.5185 17.9436 10.2664 17.9984 10.011 18C9.75565 18.0015 9.50286 17.9499 9.26943 17.8484C9.03601 17.7469 8.8273 17.598 8.65718 17.4114L3.69999 12.7111C2.35 11.3888 1 9.89019 1 7.86266Z" stroke="#242424" stroke-linecap="round" stroke-linejoin="round"/></svg>
                  <span class="header-block__badge empty_list" data-ps-ref="wishlist-count">0</span>
                </span>
              </a>
            </div>
          </div>
        {/block}

        {hook h='displayTop' mod='ps_shoppingcart'}
        </div>

        {block name='header_mobile_icons'}
          <div class="{$headerBottom}__icons {$headerBottom}__icons--mobile order-2 d-flex align-items-center d-md-none">
            {* Lupa rozwijająca wiersz wyszukiwarki — na telefonie pole zjeżdża
               pod ikonę zamiast zajmować własny rząd na stałe.
               Obsługa: assets/js/custom.js, sekcja 7. *}
            <div class="{$headerBottom}__search">
              <button
                class="header-block__action-btn {$headerBottom}__search-toggle js-header-search-toggle"
                type="button"
                aria-expanded="false"
                aria-controls="ps_searchbar"
                aria-label="{l s='Search' d='Shop.Theme.Catalog'}"
              >
                <svg class="header-block__icon" width="20" height="20" viewBox="0 0 17 17" fill="none" stroke="currentColor" stroke-width="1.2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M12.5974 12.5976L16.4998 16.5M7.57984 0.5C9.53504 0.5 11.3054 1.292 12.5862 2.5736C13.7445 3.73182 14.4653 5.25581 14.6259 6.88591C14.7865 8.51602 14.3769 10.1514 13.4669 11.5133C12.5569 12.8753 11.2028 13.8796 9.63536 14.3551C8.0679 14.8306 6.38407 14.7479 4.87074 14.1211C3.35742 13.4943 2.10825 12.3622 1.33608 10.9176C0.563904 9.47306 0.3165 7.80544 0.636021 6.19891C0.955542 4.59239 1.82222 3.14635 3.08838 2.10719C4.35454 1.06803 5.94185 0.500039 7.57984 0.5Z"/></svg>
              </button>
            </div>

            <div id="_mobile_ps_customersignin">
              <div class="header-block">
                <a href="{$urls.pages.my_account}" class="header-block__action-btn" rel="nofollow" aria-label="{l s='Log in to your customer account' d='Shop.Theme.Customeraccount'}">
                  <svg class="header-block__icon" width="20" height="20" viewBox="0 0 20 20" fill="none" xmlns="http://www.w3.org/2000/svg" aria-hidden="true"><circle cx="10" cy="10" r="9.5" stroke="#242424"/><g transform="translate(2.37, 3.8) scale(1.1)"><path d="M0.5 10.7883C0.5 10.7883 2.3575 8.41667 6.94083 8.41667C11.5242 8.41667 13.3825 10.7883 13.3825 10.7883" stroke="#242424" stroke-linecap="round" stroke-linejoin="round"/><path d="M6.94083 5.5C7.60387 5.5 8.23976 5.23661 8.7086 4.76777C9.17744 4.29893 9.44083 3.66304 9.44083 3C9.44083 2.33696 9.17744 1.70107 8.7086 1.23223C8.23976 0.763392 7.60387 0.5 6.94083 0.5C6.27779 0.5 5.64191 0.763392 5.17307 1.23223C4.70423 1.70107 4.44083 2.33696 4.44083 3C4.44083 3.66304 4.70423 4.29893 5.17307 4.76777C5.64191 5.23661 6.27779 5.5 6.94083 5.5Z" stroke="#242424" stroke-linecap="round" stroke-linejoin="round"/></g></svg>
                </a>
              </div>
            </div>

            <div id="_mobile_blockwishlist">
              <div class="header-block">
                <a
                  href="{$link->getModuleLink('blockwishlist', 'lists', [], true)}"
                  class="header-block__action-btn"
                  rel="nofollow"
                  data-ps-action="wishlist-preview-open"
                  aria-label="{l s='My wishlists' d='Shop.Theme.Customeraccount'}"
                >
                  <span class="header-block__icon-wrap">
                    <svg class="header-block__icon" width="20" height="20" viewBox="0 0 20 20" fill="none" xmlns="http://www.w3.org/2000/svg" aria-hidden="true"><path d="M1 7.86266C1.00002 6.8817 1.30383 5.92381 1.87132 5.11552C2.4388 4.30722 3.24326 3.68655 4.17844 3.33547C5.11362 2.98439 6.13553 2.91943 7.10919 3.14915C8.08286 3.37888 8.96248 3.89249 9.63187 4.62215C9.67902 4.67153 9.73602 4.7109 9.79934 4.73781C9.86266 4.76472 9.93095 4.77861 9.99997 4.77861C10.069 4.77861 10.1373 4.76472 10.2006 4.73781C10.2639 4.7109 10.3209 4.67153 10.3681 4.62215C11.0354 3.88775 11.9152 3.36982 12.8904 3.1373C13.8657 2.90478 14.8901 2.96871 15.8273 3.32056C16.7646 3.67241 17.5702 4.2955 18.1369 5.10691C18.7037 5.91831 19.0047 6.87954 18.9999 7.86266C18.9999 9.88137 17.6499 11.3888 16.3 12.7111L11.3572 17.3947C11.1895 17.5833 10.9827 17.7349 10.7506 17.8392C10.5185 17.9436 10.2664 17.9984 10.011 18C9.75565 18.0015 9.50286 17.9499 9.26943 17.8484C9.03601 17.7469 8.8273 17.598 8.65718 17.4114L3.69999 12.7111C2.35 11.3888 1 9.89019 1 7.86266Z" stroke="#242424" stroke-linecap="round" stroke-linejoin="round"/></svg>
                    <span class="header-block__badge empty_list" data-ps-ref="wishlist-count">0</span>
                  </span>
                </a>
              </div>
            </div>

            {if !$configuration.is_catalog}
              <div id="_mobile_ps_shoppingcart">
                <div class="header-block">
                  <a href="{$urls.pages.cart}" class="header-block__action-btn" rel="nofollow" aria-label="{l s='Cart' d='Shop.Theme.Checkout'}">
                    <span class="header-block__icon-wrap">
                      <svg class="header-block__icon" width="20" height="20" viewBox="0 0 20 20" fill="none" xmlns="http://www.w3.org/2000/svg" aria-hidden="true"><path d="M11.8465 3.77778C11.8465 3.30628 11.6521 2.8541 11.306 2.5207C10.9598 2.1873 10.4904 2 10.0009 2C9.51144 2 9.042 2.1873 8.69588 2.5207C8.34976 2.8541 8.15532 3.30628 8.15532 3.77778M16.7005 7.952L17.9786 15.952C18.019 16.2052 18.0021 16.4638 17.9291 16.7102C17.8561 16.9565 17.7287 17.1847 17.5556 17.3792C17.3826 17.5737 17.1679 17.7299 16.9263 17.837C16.6847 17.9442 16.422 17.9998 16.156 18H3.84583C3.57972 18 3.31675 17.9446 3.07496 17.8376C2.83316 17.7306 2.61825 17.5744 2.44496 17.3799C2.27167 17.1854 2.14411 16.9571 2.071 16.7106C1.9979 16.4641 1.981 16.2053 2.02145 15.952L3.29953 7.952C3.36657 7.53208 3.58752 7.14917 3.92235 6.87262C4.25719 6.59608 4.68377 6.44418 5.12483 6.44444H14.877C15.3179 6.44439 15.7443 6.59639 16.0789 6.87291C16.4136 7.14944 16.6335 7.53223 16.7005 7.952Z" stroke="#242424" stroke-linecap="round" stroke-linejoin="round"/></svg>
                      <span class="header-block__badge">{$cart.products_count}</span>
                    </span>
                  </a>
                </div>
              </div>
            {/if}
          </div>
        {/block}
      </div>
    </div>
  </div>

  {capture name="nav_full_width"}{hook h='displayNavFullWidth'}{/capture}
  {if !empty($smarty.capture.nav_full_width)}
    <div class="{$headerNavFullWidth}">
      <div class="{$headerNavFullWidth}__container container-md">
        {$smarty.capture.nav_full_width nofilter}
      </div>
    </div>
  {/if}
{/block}
