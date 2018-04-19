'use strict';

document.addEventListener('turbolinks:load', (evt) => {
  if (!document.querySelector('.content-companies')) {
    return;
  }

  // Contents object that manages companies page
  const contents = new Restus.ListContent({ // eslint-disable-line no-unused-vars
    SNACKBAR_SELECTOR: '.res-companies-snackbar',
    LIST_ITEM_SELECTOR: '.res-companies-item',
    CARD_SELECTOR: '.res-companies-card',
    CARD_CLOSE_SELECTOR: '.res-companies-card-close',
    CARD_KEY: 'companyId',
    URL_KEY: 'companyUrl',
  }, {
    // HTML Dom Objects
    cardFabElm: document.querySelector('.res-card__fab'),

    setCard(company) {
      if (company.id === Number(this.cardElm.dataset.companyId)) {
        return;
      }

      this.cardElm.dataset.companyId = company.id;
      this.cardElm.querySelector('.res-company-info__name').innerText = company.formalName;
      this._setCardField(company, 'kanaName');
      this._setCardField(company, 'enName');
      this._setCardAnchorField(company, 'webSite');
      this._setCardField(company, 'note');
      this.cardFabElm.href = company.editPath;
    },

    _setCardField(card, fieldName) {
      const elm = this.cardElm.querySelector(`.res-company-info__${this._camelToKebab(fieldName)}`);
      if (card[fieldName]) {
        elm.innerText = card[fieldName];
        elm.parentElement.style.display = '';
      } else {
        elm.innerText = '';
        elm.parentElement.style.display = 'none';
      }
    },

    _setCardAnchorField(card, fieldName, getHref = null, content = null) {
      const elm = this.cardElm.querySelector(`.res-company-info__${this._camelToKebab(fieldName)}`);
      const innerText = content == null ? card[fieldName] : content;
      if (innerText) {
        elm.href = getHref ? getHref(innerText, card) : innerText;
        elm.innerText = innerText;
        elm.parentElement.style.display = '';
      } else {
        elm.href = '#';
        elm.innerText = '';
        elm.parentElement.style.display = 'none';
      }
    },

    _camelToKebab(word) {
      return word.replace(/^[A-Z]/, c => c.toLowerCase()).replace(/[A-Z]/g, c => `-${c.toLowerCase()}`);
    },
  });
}, false);
