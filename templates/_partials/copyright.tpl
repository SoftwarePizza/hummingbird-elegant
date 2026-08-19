{**
 * For the full copyright and license information, please view the
 * LICENSE.md file that was distributed with this source code.
 *}
{block name='copyright'}
  <div class="copyright">
    {block name='copyright_text'}
      {l s='© %year% %shop_name%. Wszelkie prawa zastrzeżone.' sprintf=['%year%' => 'Y'|date, '%shop_name%' => $shop.name] d='Shop.Theme.Global'}
    {/block}
    {block name='copyright_author'}
      <div class="copyright__author">
        {l s='Sklep wykonał' d='Shop.Theme.Global'}
        <a href="https://softwarepizza.com" target="_blank" rel="noopener">Software Pizza E-commerce Team</a>
      </div>
    {/block}
  </div>
{/block}
