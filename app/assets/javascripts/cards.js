'use strict';

document.addEventListener('turbolinks:load', (evt) => {
  if (!document.querySelector('.content-cards')) {
    return;
  }

  // Contents object that manages cards page
  const contents = new Restus.ListContent({ // eslint-disable-line no-unused-vars
    SNACKBAR_SELECTOR: '.res-cards-snackbar',
    LIST_ITEM_SELECTOR: '.res-card-item',
    CARD_SELECTOR: '.res-cards-card',
    CARD_CLOSE_SELECTOR: '.res-cards-card-close',
    CARD_KEY: 'cardId',
    URL_KEY: 'cardUrl',
  }, {
    // HTML Dom Objects
    cardListElm: document.querySelector('.res-cards-list'),
    cardElm: document.querySelector('.res-cards-card'),
    cardFabElm: document.querySelector('.res-card__fab'),
    fabElm: document.querySelector('.res-card-add-button'),
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
        'post-address-building',
        (value, c) => `https://www.google.co.jp/maps/place/${encodeURIComponent(c.address)}`,
        card.postcode ? `〒${card.postcode} ${card.address} ${card.building}` : `${card.address} ${card.building}`,
      );
      this._setCardAnchorField(card, 'tel', value => `tel:${value.replace(/-/g, '')}`);
      this._setCardField(card, 'fax');
      this._setCardAnchorField(card, 'mail', value => `mailto:${value}`);
      this._setCardField(card, 'note');
      this.cardFabElm.href = card.editPath;
      const mediaElm = this.cardElm.querySelector('.mdc-card__media');
      if (card.company.color) {
        mediaElm.style.setProperty('background-color', card.company.color);
      } else {
        mediaElm.style.removeProperty('background-color');
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
  });

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
}, false);
