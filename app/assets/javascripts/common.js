'use strict';

((self) => {
  if (self.Restus) return;

  class Content {
    constructor(keyMap, properties) {
      this.snackbarElm = document.querySelector(keyMap.SNACKBAR_SELECTOR);
      this.snackbarDelay = keyMap.SNACKBAR_DELAY == null ? 150 : keyMap.SNACKBAR_DELAY;
      Object.assign(this, properties);

      if (this.snackbarDelay >= 0) {
        setTimeout(() => this.showSnackbar(), this.snackbarDelay);
      }
    }

    showSnackbar(message = null) {
      if (message) {
        this.snackbarElm.MDCSnackbar.labelText = message;
      }
      if (this.snackbarElm.MDCSnackbar.labelText) {
        this.snackbarElm.MDCSnackbar.open();
      }
    }
  }

  /** Class representing list type content. */
  class ListContent extends Content {
    /**
     * Create a ListContent instance.
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
      let cardLeft = (clickX + window.pageXOffset) + 96;
      let cardTop = (clickY + window.pageYOffset) - 96;
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
        if (cardLeft - window.pageXOffset < 8) {
          cardLeft = 8 + window.pageXOffset;
        } else if (window.innerWidth < (cardLeft - window.pageXOffset) + cardWidth + 8) {
          cardLeft = Math.max(window.innerWidth - cardWidth - 8, 8) + window.pageXOffset;
        }
        if (cardTop - window.pageYOffset < 72) {
          cardTop = 72 + window.pageYOffset;
        } else if (window.innerHeight < (cardTop - window.pageYOffset) + cardHeight + 8) {
          cardTop = Math.max(window.innerHeight - cardHeight - 8, 72) + window.pageYOffset;
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
  }

  /** Class for entering address from postcode */
  class PostcodeLoader {
    /**
     * Create a PostcodeLoader instance.
     * @param {HTMLInputElement} postcodeElm - Root element of MDC Text Field for postcode field.
     * @param {HTMLInputElement} addressElm - Root element of MDC Text Field for address field.
     * @param {HTMLElement} dialogElm - Root element of MDC Dialog instance for confirm dialog.
     * @param {String} addressLabelSelector - CSS selector to get element to save address
     *    temporarily.
     */
    constructor(postcodeElm, addressElm, dialogElm, addressLabelSelector) {
      this.codeElm = postcodeElm.MDCTextField.input_; // eslint-disable-line no-underscore-dangle
      this.addressElm = addressElm.MDCTextField.input_; // eslint-disable-line no-underscore-dangle
      this.dialog = dialogElm.MDCDialog;
      this.addressLabel = dialogElm.querySelector(addressLabelSelector);
      this._optBase = document.createElement('option');
      this.codeElm.addEventListener('change', this.onChangeCode.bind(this), false);
      this.codeElm.addEventListener('ajax:success', this.onSuccessGettingAddress.bind(this), false);
      this.dialog.listen('MDCDialog:closed', this.onClosedDialog.bind(this));
    }

    /**
     * Event listener called when postcode has changed.
     * @param {UIEvent} e - Event object.
     */
    onChangeCode(e) {
      if (!this.getCode() || !e.target.checkValidity()) {
        return;
      }
      const { codeElm } = this;
      Rails.ajax({
        type: 'GET',
        dataType: 'JSON',
        url: `/api/postcode?postcode=${encodeURIComponent(this.getCode())}`,
        beforeSend(xhr, options) {
          return Rails.fire(codeElm, 'ajax:beforeSend', { xhr, options });
        },
        success(responseBody, statusText, xhr) {
          if (responseBody.address) {
            Rails.fire(codeElm, 'ajax:success', { address: responseBody.address, xhr });
          }
        },
      });
    }

    /**
     * Event listener called when address is got from postcode.
     * @param {CustomEvent} e - Event object.
     */
    onSuccessGettingAddress(e) {
      if (!this.addressElm.value) {
        this.addressElm.value = e.detail.address;
      } else if (this.addressElm.value !== e.detail.address) {
        this.addressLabel.innerHTML = e.detail.address;
        this.dialog.open();
      }
      this._addAddressList(e.detail.address);
    }

    /**
     * Event listener called when dialog is closed.
     * @param {CustomEvent} e - Event object.
     */
    onClosedDialog(e) {
      if (e.detail.action === 'accept') {
        this.addressElm.value = this.addressLabel.innerHTML;
        this.addressLabel.innerHTML = '';
      }
    }

    /**
     * Return postcode.
     * @return {String} Postcode entered currently.
     */
    getCode() {
      return this.codeElm.value.trim();
    }

    _addAddressList(address) {
      const listElm = this.addressElm.list;
      if (!listElm) {
        return;
      }
      for (const optElm of listElm.options) {
        if (optElm.value === address) {
          return;
        }
      }
      const opt = this._optBase.cloneNode(true);
      opt.setAttribute('value', address);
      listElm.insertBefore(opt, listElm.firstChild);
    }
  }

  self.Restus = { // eslint-disable-line no-param-reassign
    Content,
    ListContent,
    PostcodeLoader,
    toCamelCase(str) {
      return str.replace(/[-_](.)/g, (matchMedia, group) => group.toUpperCase());
    },
  };
})(this);
