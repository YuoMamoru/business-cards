'use strict';

((self) => {
  if (self.Restus) return;

  const Restus = {};
  Restus.Content = class Content {
    constructor(keyMap, properties) {
      this.snackbarElm = document.querySelector(keyMap.SNACKBAR_SELECTOR);
      this.snackbarDelay = keyMap.SNACKBAR_DELAY == null ? 150 : keyMap.SNACKBAR_DELAY;
      Object.assign(this, properties);

      if (this.snackbarDelay >= 0) {
        setTimeout(() => this.showSnackbar(), this.snackbarDelay);
      }
    }

    showSnackbar(message = null) {
      const snackbarMessage = message || this.snackbarElm.dataset.message;
      if (snackbarMessage) {
        this.snackbarElm.MDCSnackbar.show({ message: snackbarMessage });
      }
    }
  };

  /** Class representing list type content. */
  Restus.ListContent = class ListContent extends Restus.Content {
    /**
     * Create a ListContent.
     * @param {object} keyMap - keys of Dom.
     * @param {object} properties - properties added to ListContent.
     */
    constructor(keyMap, properties) {
      super(keyMap, properties);
      this.listItems = document.querySelectorAll(keyMap.LIST_ITEM_SELECTOR);
      this.cardElm = document.querySelector(keyMap.CARD_SELECTOR);
      this.cardKey = keyMap.CARD_KEY;
      this.urlKey = keyMap.URL_KEY;

      // Add EventListers
      for (const item of this.listItems) {
        item.addEventListener('click', this.onClickCardItem.bind(this, item), false);
        item.addEventListener('ajax:success', this.onLoadedAjaxRecord.bind(this, item), false);
      }
      this.cardElm.querySelector(keyMap.CARD_CLOSE_SELECTOR).addEventListener('click', this.hideCard.bind(this), false);
    }

    setCard(obj) {} // eslint-disable-line class-methods-use-this

    showCard(clickX = 400, clickY = 200) {
      let cardLeft = clickX + 96;
      let cardTop = clickY - 96;
      const hidden = !this.cardElm.clientHeight;
      this.cardElm.style.left = `${cardLeft}px`;
      this.cardElm.style.top = `${cardTop}px`;
      this.cardElm.style.display = '';
      const cardWidth = this.cardElm.clientWidth;
      const cardHeight = this.cardElm.clientHeight;
      if (window.innerWidth < cardLeft + cardWidth + 8 ||
          window.innerHeight < cardTop + cardHeight + 8) {
        if (hidden) {
          this.cardElm.style.transition = 'unset';
        }
        if (window.innerWidth < cardLeft + cardWidth + 8) {
          cardLeft = Math.max(window.innerWidth - cardWidth - 8, 8);
        }
        if (window.innerHeight < cardTop + cardHeight + 8) {
          cardTop = Math.max(window.innerHeight - cardHeight - 8, 72);
        }
        this.cardElm.style.left = `${cardLeft}px`;
        this.cardElm.style.top = `${cardTop}px`;
        if (hidden) {
          setTimeout(() => { this.cardElm.style.transition = ''; }, 150);
        }
      }
    }

    hideCard() {
      this.cardElm.style.display = 'none';
    }

    /**
     * Event listener called when the list item is clicked.
     * @param {HTMLElement} element - Element which event listener is added to.
     * @param {MouseEvent} e - Event object.
     */
    onClickCardItem(element, e) {
      if (Number(this.cardElm.dataset[this.cardKey]) === Number(element.dataset[this.cardKey])) {
        this.showCard(e.clientX, e.clientY);
        return;
      }
      Rails.ajax({
        type: 'GET',
        dataType: 'JSON',
        url: element.dataset[this.urlKey],
        beforeSend(xhr, options) {
          return Rails.fire(element, 'ajax:beforeSend', { xhr, options });
        },
        success(obj, statusText, xhr) {
          Rails.fire(element, 'ajax:success', { obj, xhr, x: e.clientX, y: e.clientY }); // eslint-disable-line object-curly-newline
        },
      });
    }

    /**
     * Event listener called when anax request is successful.
     * @param {HTMLElement} element - Element that triggered the request.
     * @param {CustomEvent} e - Event object.
     */
    onLoadedAjaxRecord(element, e) {
      this.setCard(e.detail.obj);
      this.showCard(e.detail.x, e.detail.y);
    }
  };

  self.Restus = Restus; // eslint-disable-line no-param-reassign
})(this);
