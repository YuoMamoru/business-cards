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
      if (!this.postcodeElm.MDCTextField.value && lists.postCodes.length === 1) {
        [this.postcodeElm.MDCTextField.value] = lists.postCodes;
      }
      if (!this.addressElm.MDCTextField.value && lists.addresses.length === 1) {
        [this.addressElm.MDCTextField.value] = lists.addresses;
      }
      if (!this.telElm.MDCTextField.value && lists.phones.length === 1) {
        [this.telElm.MDCTextField.value] = lists.phones;
      }
      if (!this.mailElm.MDCTextField.value && lists.mails.length === 1) {
        [this.mailElm.MDCTextField.value] = lists.mails;
      }
    },

    setDataList(lists) {
      this.allListElm.textContent = '';
      this.postCodeListElm.textContent = '';
      this.phoneListElm.textContent = '';
      this.mailListElm.textContent = '';
      const optBase = document.createElement('option');
      for (const line of lists.lines) {
        const opt = optBase.cloneNode(true);
        opt.setAttribute('value', line);
        this.allListElm.appendChild(opt);
      }
      for (const postCode of lists.postCodes) {
        const opt = optBase.cloneNode(true);
        opt.setAttribute('value', postCode);
        this.postCodeListElm.appendChild(opt);
      }
      for (const phone of lists.phones) {
        const opt = optBase.cloneNode(true);
        opt.setAttribute('value', phone);
        this.phoneListElm.appendChild(opt);
      }
      for (const mail of lists.mails) {
        const opt = optBase.cloneNode(true);
        opt.setAttribute('value', mail);
        this.mailListElm.appendChild(opt);
      }
    },
  };

  contents.init();
}, false);
