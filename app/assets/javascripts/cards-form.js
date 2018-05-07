'use strict';

document.addEventListener('turbolinks:load', (evt) => {
  if (!document.querySelector('.content-cards-form')) {
    return;
  }

  const contents = {
    frontImageElm: document.getElementById('card_front_image'),
    assistanceElm: document.getElementById('use-assistance'),
    companyElm: document.querySelector('.field-company'),
    postcodeElm: document.querySelector('.field-postcode'),
    addressElm: document.querySelector('.field-address'),
    telElm: document.querySelector('.field-tel'),
    mailElm: document.querySelector('.field-mail'),
    allListElm: document.getElementById('all-list'),
    postCodeListElm: document.getElementById('post-code-list'),
    phoneListElm: document.getElementById('phone-list'),
    mailListElm: document.getElementById('mail-list'),
    _optBase: document.createElement('option'),

    init() {
      this.frontImageElm.addEventListener('change', this.onChangeImage.bind(this), false);
      this.frontImageElm.addEventListener('ajax:success', this.onCompleteOcr.bind(this), false);
    },

    onChangeImage(e) {
      const imgElm = this.frontImageElm;
      if (!this.assistanceElm.checked || imgElm.files.length === 0) {
        return;
      }
      const formData = new FormData();
      formData.append('image', imgElm.files[0], imgElm.value);
      Rails.ajax({
        type: 'POST',
        data: formData,
        dataType: 'JSON',
        url: '/cards/ocr.json',
        beforeSend(xhr, options) {
          return Rails.fire(imgElm, 'ajax:beforeSend', { xhr, options });
        },
        success(ocrResults, statusText, xhr) {
          Rails.fire(imgElm, 'ajax:success', { ocrResults, xhr });
        },
      });
    },

    onCompleteOcr(e) {
      this.setField(e.detail.ocrResults);
      this.setDataList(e.detail.ocrResults);
    },

    setField(lists) {
      if (!this.companyElm.MDCSelect.value && lists.companyId != null) {
        this.companyElm.MDCSelect.value = lists.companyId.toString();
      }
      this._setProposedValue(this.postcodeElm.MDCTextField, lists.postCodes);
      this._setProposedValue(this.addressElm.MDCTextField, lists.addresses);
      this._setProposedValue(this.telElm.MDCTextField, lists.phones);
      this._setProposedValue(this.mailElm.MDCTextField, lists.mails);
    },

    setDataList(lists) {
      this._setProposedList(this.allListElm, lists.lines);
      this._setProposedList(this.postCodeListElm, lists.postCodes);
      this._setProposedList(this.phoneListElm, lists.phones);
      this._setProposedList(this.mailListElm, lists.mails);
    },

    _setProposedValue(component, proposedValues) {
      if (!component.value && proposedValues.length === 1) {
        [component.value] = proposedValues; // eslint-disable-line no-param-reassign
      }
    },

    _setProposedList(listElm, proposedValues) {
      listElm.textContent = ''; // eslint-disable-line no-param-reassign
      for (const value of proposedValues) {
        const opt = this._optBase.cloneNode(true);
        opt.setAttribute('value', value);
        listElm.appendChild(opt);
      }
    },
  };

  contents.init();
}, false);
