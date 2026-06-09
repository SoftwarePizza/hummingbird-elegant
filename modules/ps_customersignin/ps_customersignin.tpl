{**
 * For the full copyright and license information, please view the
 * LICENSE.md file that was distributed with this source code.
 *}

<div id="_desktop_ps_customersignin" class="order-3">
  <div class="ps-customersignin">
    {if $customer.is_logged}
      <div class="dropdown header-block">
        <button
          class="dropdown-toggle header-block__action-btn border-0 bg-transparent"
          id="userMenuButton"
          data-bs-toggle="dropdown"
          aria-haspopup="true"
          aria-expanded="false"
          aria-label="{l s='View my account (%customerName%)' sprintf=['%customerName%' => $customerName] d='Shop.Theme.Customeraccount'}"
        >
          <svg class="header-block__icon" width="20" height="20" viewBox="0 0 20 20" fill="none" xmlns="http://www.w3.org/2000/svg" aria-hidden="true"><circle cx="10" cy="10" r="9.5" stroke="#242424"/><g transform="translate(2.37, 3.8) scale(1.1)"><path d="M0.5 10.7883C0.5 10.7883 2.3575 8.41667 6.94083 8.41667C11.5242 8.41667 13.3825 10.7883 13.3825 10.7883" stroke="#242424" stroke-linecap="round" stroke-linejoin="round"/><path d="M6.94083 5.5C7.60387 5.5 8.23976 5.23661 8.7086 4.76777C9.17744 4.29893 9.44083 3.66304 9.44083 3C9.44083 2.33696 9.17744 1.70107 8.7086 1.23223C8.23976 0.763392 7.60387 0.5 6.94083 0.5C6.27779 0.5 5.64191 0.763392 5.17307 1.23223C4.70423 1.70107 4.44083 2.33696 4.44083 3C4.44083 3.66304 4.70423 4.29893 5.17307 4.76777C5.64191 5.23661 6.27779 5.5 6.94083 5.5Z" stroke="#242424" stroke-linecap="round" stroke-linejoin="round"/></g></svg>

        </button>

        <div class="dropdown-menu dropdown-menu-start" aria-labelledby="userMenuButton">
          <a
            href="{$urls.pages.my_account}"
            class="dropdown-item"
            rel="nofollow"
            {if $urls.current_url == $urls.pages.my_account}aria-current="page"{/if}
          >
            <i class="material-icons me-2" aria-hidden="true">&#xF02E;</i>
            {l s='Your account' d='Shop.Theme.Customeraccount'}
          </a>

          <div class="dropdown-divider"></div>

          <a
            href="{$urls.pages.identity}"
            class="dropdown-item"
            rel="nofollow"
            {if $urls.current_url == $urls.pages.identity}aria-current="page"{/if}
          >
            <i class="material-icons me-2" aria-hidden="true">&#xE853;</i>
            {l s='Information' d='Shop.Theme.Customeraccount'}
          </a>

          {if $customer.addresses|count}
            <a
              href="{$urls.pages.addresses}"
              class="dropdown-item"
              rel="nofollow"
              {if $urls.current_url == $urls.pages.addresses}aria-current="page"{/if}
            >
              <i class="material-icons me-2" aria-hidden="true">&#xF00F;</i>
              {l s='Addresses' d='Shop.Theme.Customeraccount'}
            </a>
          {else}
            <a
              href="{$urls.pages.address}"
              class="dropdown-item"
              rel="nofollow"
              {if $urls.current_url == $urls.pages.address}aria-current="page"{/if}
            >
              <i class="material-icons me-2" aria-hidden="true">&#xEF3A;</i>
              {l s='Add first address' d='Shop.Theme.Customeraccount'}
            </a>
          {/if}

          {if !$configuration.is_catalog}
            <a
              href="{$urls.pages.history}"
              class="dropdown-item"
              rel="nofollow"
              {if $urls.current_url == $urls.pages.history}aria-current="page"{/if}
            >
              <i class="material-icons me-2" aria-hidden="true">&#xE916;</i>
              {l s='Orders' d='Shop.Theme.Customeraccount'}
            </a>
          {/if}

          {if !$configuration.is_catalog}
            <a
              href="{$urls.pages.order_slip}"
              class="dropdown-item"
              rel="nofollow"
              {if $urls.current_url == $urls.pages.order_slip}aria-current="page"{/if}
            >
              <i class="material-icons me-2" aria-hidden="true">&#xE8B0;</i>
              {l s='Credit slips' d='Shop.Theme.Customeraccount'}
            </a>
          {/if}

          {if $configuration.voucher_enabled && !$configuration.is_catalog}
            <a
              href="{$urls.pages.discount}"
              class="dropdown-item"
              rel="nofollow"
              {if $urls.current_url == $urls.pages.discount}aria-current="page"{/if}
            >
              <i class="material-icons me-2" aria-hidden="true">&#xE54E;</i>
              {l s='Vouchers' d='Shop.Theme.Customeraccount'}
            </a>
          {/if}

          {if $configuration.return_enabled && !$configuration.is_catalog}
            <a
              href="{$urls.pages.order_follow}"
              class="dropdown-item"
              rel="nofollow"
              {if $urls.current_url == $urls.pages.order_follow}aria-current="page"{/if}
            >
              <i class="material-icons me-2" aria-hidden="true">&#xE860;</i>
              {l s='Merchandise returns' d='Shop.Theme.Customeraccount'}
            </a>
          {/if}

          <div class="dropdown-divider"></div>

          <a 
            href="{$logout_url}"
            class="dropdown-item"
            rel="nofollow"
          >
            <i class="material-icons me-2" aria-hidden="true">&#xE879;</i>
            {l s='Sign out' d='Shop.Theme.Actions'}
          </a>
        </div>
      </div>
    {else}
      <div class="header-block">
        <a
          href="{$urls.pages.authentication}?back={$urls.current_url|urlencode}"
          class="header-block__action-btn"
          rel="nofollow"
          aria-label="{l s='Sign in' d='Shop.Theme.Actions'}"
        >
          <svg class="header-block__icon" width="20" height="20" viewBox="0 0 20 20" fill="none" xmlns="http://www.w3.org/2000/svg" aria-hidden="true"><circle cx="10" cy="10" r="9.5" stroke="#242424"/><g transform="translate(2.37, 3.8) scale(1.1)"><path d="M0.5 10.7883C0.5 10.7883 2.3575 8.41667 6.94083 8.41667C11.5242 8.41667 13.3825 10.7883 13.3825 10.7883" stroke="#242424" stroke-linecap="round" stroke-linejoin="round"/><path d="M6.94083 5.5C7.60387 5.5 8.23976 5.23661 8.7086 4.76777C9.17744 4.29893 9.44083 3.66304 9.44083 3C9.44083 2.33696 9.17744 1.70107 8.7086 1.23223C8.23976 0.763392 7.60387 0.5 6.94083 0.5C6.27779 0.5 5.64191 0.763392 5.17307 1.23223C4.70423 1.70107 4.44083 2.33696 4.44083 3C4.44083 3.66304 4.70423 4.29893 5.17307 4.76777C5.64191 5.23661 6.27779 5.5 6.94083 5.5Z" stroke="#242424" stroke-linecap="round" stroke-linejoin="round"/></g></svg>
        </a>
      </div>
    {/if}
  </div>
</div>
