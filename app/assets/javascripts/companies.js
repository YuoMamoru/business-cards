'use strict';

document.addEventListener('turbolinks:load', (evt) => {
  if (!document.querySelector('.content-companies')) {
    return;
  }

  // Contents object that manages companies page
  const contents = {
    // HTML Dom Objects
    listElm: document.querySelector('.res-companies-list'),
    cardElm: document.querySelector('.res-companies-card'),
    cardFabElm: document.querySelector('.res-card__fab'),
    fabElm: document.querySelector('.res-card-add-button'),
    snackbarElm: document.querySelector('.res-companies-snackbar'),

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

    showCard(clickX = 400, clickY = 200) {
      let cardLeft = clickX - 16;
      let cardTop = clickY - 32;
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
    },

    hideCard() {
      this.cardElm.style.display = 'none';
    },

    showSnackbar(message = null) {
      const snackbarMessage = message || this.snackbarElm.dataset.message;
      if (snackbarMessage) {
        this.snackbarElm.MDCSnackbar.show({ message: snackbarMessage });
      }
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
  };

  // Initialize events
  const onClickCardItem = (e) => {
    if (Number(contents.cardElm.dataset.companyId) === Number(e.currentTarget.dataset.companyId)) {
      contents.showCard(e.clientX, e.clientY);
      return;
    }
    Rails.ajax({
      type: 'GET',
      dataType: 'JSON',
      url: e.currentTarget.dataset.companyUrl,
      beforeSend(xhr, options) {
        return true;
      },
      success(company, statusText, xhr) {
        contents.setCard(company);
        contents.showCard(e.clientX, e.clientY);
      },
    });
  };
  for (const cardItem of document.querySelectorAll('.res-companies-item')) {
    cardItem.addEventListener('click', onClickCardItem, false);
  }

  contents.cardElm.querySelector('.res-companies-card-close').addEventListener('click', (e) => {
    contents.hideCard();
  }, false);

  setTimeout(() => contents.showSnackbar(), 150);
}, false);
