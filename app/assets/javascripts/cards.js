'use strict';

document.addEventListener('turbolinks:load', (evt) => {
  if (!document.querySelector('.content-cards')) {
    return;
  }

  // Contents object that manages company page
  const contents = {
    cardListElm: document.querySelector('.res-cards-list'),
    cardElm: document.querySelector('.res-cards-card'),
    cardFabElm: document.querySelector('.res-card__fab'),
    fabElm: document.querySelector('.res-card-add-button'),
    formContainerElm: document.querySelector('.res-cards-form-container'),
    snackbarElm: document.querySelector('.res-cards-snackbar'),

    toggleListItem(companyId, willOpen) {
      const listItems = this.cardListElm.querySelectorAll(`.res-card-item[data-company-id="${companyId}"]`);
      for (const item of listItems) {
        const hLine = item.parentElement.previousElementSibling.previousElementSibling;
        if (willOpen) {
          item.classList.remove('res-none');
          item.parentElement.classList.remove('res-none');
          item.parentElement.previousElementSibling.classList.remove('res-none');
          if (hLine) {
            hLine.classList.remove('res-none');
          }
        } else {
          item.classList.add('res-none');
          if (!item.parentElement.querySelector('.res-card-item:not(.res-none)')) {
            item.parentElement.classList.add('res-none');
            item.parentElement.previousElementSibling.classList.add('res-none');
            if (hLine) {
              hLine.classList.add('res-none');
            }
          }
        }
      }
    },

    setCard(card) {
      if (card.id === Number(this.cardElm.dataset.cardId)) {
        return;
      }

      this.cardElm.dataset.cardId = card.id;
      this.cardElm.querySelector('.res-card-info__name').innerText = card.name;
      this.cardElm.querySelector('.res-card-info__qualification').innerText = card.qualification;
      this._setCardCompanyNameField(card);
      this.cardElm.querySelector('.res-card-info__department').innerText = `${card.department} ${card.position}`;
      this._setCardAnchorField(
        card,
        'post-address',
        (value, c) => `https://www.google.co.jp/maps/place/${encodeURIComponent(c.address)}`,
        card.postcode ? `〒${card.postcode} ${card.address}` : card.address,
      );
      this._setCardAnchorField(card, 'tel', value => `tel:${value.replace(/-/g, '')}`);
      this._setCardField(card, 'fax');
      this._setCardAnchorField(card, 'mail', value => `mailto:${value}`);
      this._setCardField(card, 'note');
      this.cardFabElm.href = card.editPath;
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

    _setCardCompanyNameField(card) {
      const companyNameElm = card.company.webSite ?
        this.cardElm.querySelector('.res-card-info__company-name--link') :
        this.cardElm.querySelector('.res-card-info__company-name--label');
      const hideNameElm = card.company.webSite ?
        this.cardElm.querySelector('.res-card-info__company-name--label') :
        this.cardElm.querySelector('.res-card-info__company-name--link');
      hideNameElm.style.display = 'none';
      companyNameElm.style.display = '';
      companyNameElm.innerText = card.company.omitName;
      if (card.company.webSite) {
        companyNameElm.href = card.company.webSite;
      }
    },

    _setCardField(card, fieldName) {
      const elm = this.cardElm.querySelector(`.res-card-info__${fieldName}`);
      if (card[fieldName]) {
        elm.innerText = card[fieldName];
        elm.parentElement.style.display = '';
      } else {
        elm.innerText = '';
        elm.parentElement.style.display = 'none';
      }
    },

    _setCardAnchorField(card, fieldName, getHref, value = null) {
      const elm = this.cardElm.querySelector(`.res-card-info__${fieldName}`);
      const val = value == null ? card[fieldName] : value;
      if (val) {
        elm.href = getHref(val, card);
        elm.innerText = val;
        elm.parentElement.style.display = '';
      } else {
        elm.href = '#';
        elm.innerText = '';
        elm.parentElement.style.display = 'none';
      }
    },
  };

  const onClickCompanyList = (e) => {
    const checkbox = e.currentTarget.querySelector('.mdc-checkbox').MDCCheckbox;
    if (e.target.tagName !== 'INPUT' || e.target.type !== 'checkbox') {
      checkbox.checked = !checkbox.checked;
    }
    contents.toggleListItem(checkbox.value, checkbox.checked);
  };
  for (const listItemElm of document.querySelectorAll('.res-item-company')) {
    listItemElm.addEventListener('click', onClickCompanyList, false);
  }

  const onClickCardItem = (e) => {
    if (Number(contents.cardElm.dataset.cardId) === Number(e.currentTarget.dataset.cardId)) {
      contents.showCard(e.clientX, e.clientY);
      return;
    }
    Rails.ajax({
      type: 'GET',
      dataType: 'JSON',
      url: e.currentTarget.dataset.cardUrl,
      beforeSend(xhr, options) {
        return true;
      },
      success(card, statusText, xhr) {
        contents.setCard(card);
        contents.showCard(e.clientX, e.clientY);
      },
    });
  };
  for (const cardItem of document.querySelectorAll('.res-card-item')) {
    cardItem.addEventListener('click', onClickCardItem, false);
  }

  contents.cardElm.querySelector('.res-cards-card-close').addEventListener('click', (e) => {
    contents.hideCard();
  }, false);

  window.contents = contents; // TODO

  setTimeout(() => contents.showSnackbar(), 150);
}, false);
