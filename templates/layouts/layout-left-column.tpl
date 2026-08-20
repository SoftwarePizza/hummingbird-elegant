{**
 * For the full copyright and license information, please view the
 * LICENSE.md file that was distributed with this source code.
 *}
{extends file='layouts/layout-both-columns.tpl'}

{block name="content_columns"}
  <div class="{block name="container_class"}columns-container container{/block}">
    <div class="row">
      {block name="left_column"}
        {if $page.page_name == 'product'}
          {capture name=leftColumn}{hook h='displayLeftColumnProduct'}{/capture}
        {else}
          {capture name=leftColumn}{hook h='displayLeftColumn'}{/capture}
        {/if}

        {* Szuflada filtrów (assets/js/custom.js, blok 2): na listingu z blokiem
           pm_advancedsearch4 skrypt przenosi lewą kolumnę do offcanvasu i włącza
           układ klasą `has-filters-drawer` na <body>. Skrypt leci z końca strony,
           więc klasę nadajemy już tutaj — zanim kolumny trafią do DOM — inaczej
           przeglądarka zdąży namalować lewą kolumnę i listing skacze. Warunek
           jest ten sam, co w skrypcie; gdy szuflady nie da się zbudować, skrypt
           klasę zdejmuje. *}
        {if isset($listing) && $smarty.capture.leftColumn|strpos:'PM_ASBlockOutput' !== false}
          {$spFiltersDrawer = true}
          <script>document.body.classList.add('has-filters-drawer');</script>
        {/if}

        <div id="left-column" class="left-column col-md-4 col-lg-3">
          {$smarty.capture.leftColumn nofilter}
        </div>
      {/block}

      {block name="content_wrapper"}
        <div id="center-column" class="center-column page col-md-8 col-lg-9">
          {hook h='displayContentWrapperTop'}
          {block name="content"}
            <p>Hello world! This is HTML5 Boilerplate.</p>
          {/block}
          {hook h='displayContentWrapperBottom'}
        </div>
      {/block}

      {block name='right_column'}{/block}
    </div>
  </div>
{/block}
