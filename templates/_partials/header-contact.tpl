{$headerTop = 'header-top'}

{capture name="header_nav_1"}{hook h='displayNav1'}{/capture}
{capture name="header_nav_2"}{hook h='displayNav2'}{/capture}
{block name='header_nav'}
  {if !empty($smarty.capture.header_nav_1) || !empty($smarty.capture.header_nav_2)}
    <div class="{$headerTop} d-none d-md-block">
      <div class="container-md">
        <div class="row">
          <div class="{$headerTop}__left col-md-4">
            {$smarty.capture.header_nav_1 nofilter}
          </div>

          <div class="{$headerTop}__right col-md-8">
            {$smarty.capture.header_nav_2 nofilter}
          </div>
        </div>
      </div>
    </div>
  {/if}
{/block}
