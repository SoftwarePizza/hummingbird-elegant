/**
 * For the full copyright and license information, please view the
 * LICENSE.md file that was distributed with this source code.
 */

import SelectorsMap from '@constants/selectors-map';
import debounce from '@helpers/debounce';

type ProductSlideEvent = Event & {to: number};

export default () => {
  const {prestashop, Theme: {events}} = window;

  const initProductSlide = () => {
    document.querySelectorAll(SelectorsMap.product.carousel)?.forEach((carousel) => {
      carousel.addEventListener('slide.bs.carousel', onProductSlide);
    });
  };

  function onProductSlide(event: ProductSlideEvent): void {
    const carousel = event.target as HTMLElement;
    const parent = carousel.closest(SelectorsMap.product.images);

    if (parent) {
      parent.querySelectorAll(SelectorsMap.product.thumbnail).forEach((e) => e.classList.remove('active'));
      parent.querySelector(SelectorsMap.product.activeThumbail(event.to))?.classList.add('active');
    }
  }

  initProductSlide();
  prestashop.on(events.updatedProduct, initProductSlide);
  prestashop.on(events.quickviewOpened, initProductSlide);

  function detectQuantityChange() {
    const quantityInput = document.querySelector(
      SelectorsMap.qtyInput.quantityWanted,
    ) as HTMLInputElement;
    const incrementButton = document.querySelector(
      SelectorsMap.qtyInput.increment,
    ) as HTMLButtonElement;
    const decrementButton = document.querySelector(
      SelectorsMap.qtyInput.decrement,
    ) as HTMLButtonElement;

    if (quantityInput && incrementButton && decrementButton) {
      // Function to trigger emit
      const triggerEmit = async () => {
        const inputValue = parseInt(quantityInput.value, 10);
        const minQuantity = getMinValue(quantityInput);

        // Check if the input value is a valid and greater or equal than the minimum value
        if (inputValue >= minQuantity) {
          quantityInput.value = inputValue.toString();
        } else {
          quantityInput.value = minQuantity.toString();
        }

        prestashop.emit('updateProduct', {
          eventType: 'updatedProductQuantity',
        });
      };

      const debouncedTriggerEmit = debounce(triggerEmit, 500);

      quantityInput.addEventListener('input', () => {
        debouncedTriggerEmit();
      });

      quantityInput.addEventListener('blur', () => {
        triggerEmit();
      });

      quantityInput.addEventListener('change', triggerEmit);
      incrementButton.addEventListener('click', triggerEmit);
      decrementButton.addEventListener('click', triggerEmit);
    }
  }

  const getMinValue = (input: HTMLInputElement): number => Number(input.getAttribute('min')) || 1;

  // Call the function to start listening for quantity changes
  detectQuantityChange();

  // Summary "zobacz pełny opis" toggle: the short description is clamped to a
  // couple of lines and the button reveals the hidden remainder inline.
  const EXPANDED_CLASS = 'product__description-short--expanded';

  const initSummaryToggle = () => {
    const summary = document.querySelector<HTMLElement>(SelectorsMap.product.summary);
    const text = summary?.querySelector<HTMLElement>(SelectorsMap.product.summaryText);
    const toggle = summary?.querySelector<HTMLButtonElement>(SelectorsMap.product.summaryToggle);

    if (!text || !toggle) {
      return;
    }

    // Whether the clamped text is taller than its visible box.
    const isOverflowing = (): boolean => text.scrollHeight - text.clientHeight > 1;

    // Offer the toggle only when the clamped summary is actually truncated.
    // Skip while expanded, since the clamp is off and nothing overflows then.
    const syncToggleVisibility = async (): Promise<void> => {
      if (text.classList.contains(EXPANDED_CLASS)) {
        return;
      }

      toggle.hidden = !isOverflowing();
    };

    toggle.addEventListener('click', () => {
      const expanded = text.classList.toggle(EXPANDED_CLASS);
      toggle.setAttribute('aria-expanded', String(expanded));
    });

    syncToggleVisibility();
    window.addEventListener('resize', debounce(syncToggleVisibility, 150));
  };

  initSummaryToggle();

  // Specs tabs (Figma: "Ogólne parametry" / "Dane techniczne") — W3C tabs
  // pattern: click or arrow keys move activation, inactive tabs leave the
  // tab order, panels are toggled through the [hidden] attribute.
  const ACTIVE_TAB_CLASS = 'product-specs__tab--active';

  const initSpecsTabs = () => {
    const specs = document.querySelector<HTMLElement>(SelectorsMap.product.specs);
    const tabs = specs
      ? Array.from(specs.querySelectorAll<HTMLButtonElement>(SelectorsMap.product.specsTab))
      : [];

    if (tabs.length < 2) {
      return;
    }

    const activateTab = (tab: HTMLButtonElement, focus: boolean): void => {
      tabs.forEach((other) => {
        const selected = other === tab;
        other.classList.toggle(ACTIVE_TAB_CLASS, selected);
        other.setAttribute('aria-selected', String(selected));
        other.tabIndex = selected ? 0 : -1;

        const panelId = other.getAttribute('aria-controls');
        const panel = panelId ? document.getElementById(panelId) : null;

        if (panel) {
          panel.hidden = !selected;
        }
      });

      if (focus) {
        tab.focus();
      }
    };

    tabs.forEach((tab, index) => {
      tab.addEventListener('click', () => activateTab(tab, false));

      tab.addEventListener('keydown', (event: KeyboardEvent) => {
        const offset = event.key === 'ArrowRight' ? 1 : event.key === 'ArrowLeft' ? -1 : 0;

        if (offset === 0) {
          return;
        }

        event.preventDefault();
        const next = tabs[(index + offset + tabs.length) % tabs.length];
        activateTab(next, true);
      });
    });
  };

  initSpecsTabs();
};
