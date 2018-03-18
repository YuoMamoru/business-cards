'use strict';

document.addEventListener('turbolinks:load', (evt) => {
  if (!document.querySelector('.content-company')) {
    return;
  }

  // Contents object that manages company page
  const contents = {
    // HTML Dom Objects
    listElm: document.querySelector('.res-company-list'),
    infoElm: document.querySelector('.res-company-info'),
    dialogElm: document.querySelector('.res-company-dialog'),
    formElm: document.querySelector('.res-company-form'),

    // Fields of company
    valueFields: ['name', 'short_name', 'kana_name', 'en_name', 'web_site', 'note'],
    listFields: ['category', 'category_position'],
    imageFields: ['logo_image'],

    // Company object
    // Sets null if new company will be create.
    company: null,

    showInfo() {
      for (const field of ['formal_name', 'short_name', 'kana_name', 'en_name', 'web_site', 'note']) {
        this.infoElm.querySelector(`.res-company-info__${field.replace('_', '-')}`).innerText = this.company[field] || '';
      }
      this.infoElm.style.display = '';
    },

    hideInfo() {
      this.infoElm.style.display = 'none';
    },

    setupForm() {
      this._setupHttpMethod();
      this._setupValueFields();
      this._setupListFields();
      this._setupImageFields();
    },

    changeInfoIconState() {
      for (const icon of this.listElm.querySelectorAll('.res-company-info-link')) {
        if (Number(icon.parentElement.dataset.companyId) === (this.company && this.company.id)) {
          icon.classList.add('res-company-info-link--selected');
        } else {
          icon.classList.remove('res-company-info-link--selected');
        }
      }
    },

    /** @returns {boolean} */
    validateForm() {
      return this.formElm.reportValidity();
    },

    updateList() {
      for (const item of document.querySelectorAll('.res-company-item')) {
        if (Number(item.dataset.companyId) !== this.company.id) {
          continue;
        }
        let logoElm = item.querySelector('.res-company-item__logo');
        const logo = this.company.logo_image;
        if (logo) {
          if (logoElm.tagName !== 'IMG') {
            logoElm = this._createCompLogoElm(logoElm);
          }
          logoElm.width = parseInt(40 * (logo.width / logo.height), 10);
          logoElm.src = `data:${logo.content_type};base64,${logo.base64_data}`;
        } else if (logoElm.tagName === 'IMG') {
          logoElm = this._createCompIconElm(logoElm);
        }
        let omitNameElm = item.querySelector('.res-company-item__omit-name');
        if (this.company.web_site) {
          if (omitNameElm.tagName !== 'A') {
            omitNameElm = this._createCompOmitNameAnchorElm(omitNameElm);
          }
          omitNameElm.href = this.company.web_site;
        } else if (omitNameElm.tagName === 'A') {
          omitNameElm = this._createCompOmitNameElm(omitNameElm);
        }
        omitNameElm.innerText = this.company.omit_name;
        break;
      }
    },

    insertList() {
      const itemElm = this._createCompItemElm();
      const logo = this.company.logo_image;
      let logoElm;
      let omitNameElm;
      if (logo) {
        logoElm = this._createCompLogoElm();
        logoElm.width = parseInt(40 * (logo.width / logo.height), 10);
        logoElm.src = `data:${logo.content_type};base64,${logo.base64_data}`;
      } else {
        logoElm = this._createCompIconElm();
      }
      if (this.company.web_site) {
        omitNameElm = this._createCompOmitNameAnchorElm();
        omitNameElm.href = this.company.web_site;
      } else {
        omitNameElm = this._createCompOmitNameElm();
      }
      omitNameElm.innerText = this.company.omit_name;
      itemElm.insertBefore(omitNameElm, itemElm.firstChild);
      itemElm.insertBefore(logoElm, itemElm.firstChild);
      this.listElm.insertBefore(itemElm, this.listElm.firstChild);
      return this.listElm;
    },

    _setupHttpMethod() {
      let methodElm = this.formElm.querySelector('input[name="_method"]');
      if (this.company) {
        this.formElm.action = this.company.url;
        if (!methodElm) {
          methodElm = document.createElement('input');
          methodElm.type = 'hidden';
          methodElm.name = '_method';
          this.formElm.appendChild(methodElm, this.formElm.firstChild);
        }
        methodElm.value = 'patch';
      } else {
        this.formElm.action = this.formElm.dataset.newPath;
        if (methodElm) {
          this.formElm.removeChild(methodElm);
        }
      }
    },

    _setupValueFields() {
      for (const field of this.valueFields) {
        const inputElm = this.formElm.querySelector(`input[name="company[${field}]"]`);
        Rails.fire(inputElm, 'focus');
        inputElm.value = this.company ? (this.company[field] || '') : '';
        Rails.fire(inputElm, 'blur');
      }
    },

    _setupListFields() {
      for (const field of this.listFields) {
        const inputElm = this.formElm.querySelector(`input[name="company[${field}]"]`);
        inputElm.value = this.company ? (this.company[field] || '') : '';
        let mdcSelectElm = inputElm.parentElement;
        while (!mdcSelectElm.classList.contains('mdc-select')) {
          mdcSelectElm = mdcSelectElm.parentElement;
        }
        const mdcSelect = mdcSelectElm.MDCSelect;
        mdcSelect.selectedIndex = -1;
        if (this.company && this.company[field]) {
          for (let i = 0, len = mdcSelect.options.length; i < len; i += 1) {
            if (mdcSelect.options[i].dataset.value === this.company[field]) {
              mdcSelect.selectedIndex = i;
              break;
            }
          }
        }
      }
    },

    _setupImageFields() {
      for (const field of this.imageFields) {
        const inputElm = this.formElm.querySelector(`input[name="company[${field}]"]`);
        let proxyElm = inputElm.parentElement;
        while (!proxyElm.classList.contains('mdce-image-field__proxy')) {
          proxyElm = proxyElm.parentElement;
        }
        let img = proxyElm.querySelector('.mdce-image-field__image');
        if (this.company && this.company[field]) {
          proxyElm.querySelector('.mdce-image-field__button').style.display = 'none';
          if (!img) {
            img = document.createElement('img');
            img.style.maxWidth = proxyElm.style.maxWidth;
            img.style.maxHeight = proxyElm.style.maxHeight;
            img.classList.add('mdce-image-field__image');
            proxyElm.insertBefore(img, inputElm);
          }
          img.src = `data:${this.company[field].content_type};base64,${this.company[field].base64_data}`;
        } else {
          proxyElm.querySelector('.mdce-image-field__button').style.display = '';
          if (img) {
            proxyElm.removeChild(img);
          }
        }
        inputElm.value = '';
      }
    },

    _baseCompItemElm: null,
    _createCompItemElm() {
      if (!this._baseCompItemElm) {
        this._baseCompItemElm = document.createElement('li');
        this._baseCompItemElm.className = 'mdc-list-item res-company-item';
        const infoIcon = document.createElement('a');
        infoIcon.title = 'More info';
        infoIcon.className = 'res-company-info-link mdc-list-item__meta material-icons res-company-info-link--selected';
        infoIcon.setAttribute('aria-label', 'View more information');
        infoIcon.dataset.remote = 'true';
        infoIcon.innerText = 'info';
        this._baseCompItemElm.appendChild(infoIcon);
      }
      const elm = this._baseCompItemElm.cloneNode(true);
      elm.dataset.companyId = this.company.id;
      elm.firstChild.href = this.company.url;
      return elm;
    },

    _baseCompIconElm: null,
    _createCompIconElm(replacedElm = null) {
      if (!this._baseCompIconElm) {
        this._baseCompIconElm = document.createElement('i');
        this._baseCompIconElm.className = 'material-icons mdc-list-item__graphic res-company-item__logo';
        this._baseCompIconElm.setAttribute('aria-hidden', 'true');
        this._baseCompIconElm.innerText = 'business';
      }
      const elm = this._baseCompIconElm.cloneNode(true);
      if (replacedElm) {
        replacedElm.parentElement.replaceChild(elm, replacedElm);
      }
      return elm;
    },

    _baseCompLogoElm: null,
    _createCompLogoElm(replacedElm = null) {
      if (!this._baseCompLogoElm) {
        this._baseCompLogoElm = document.createElement('img');
        this._baseCompLogoElm.alt = 'logo';
        this._baseCompLogoElm.className = 'mdc-list-item__graphic res-company-item__logo';
        this._baseCompLogoElm.height = 40;
      }
      const elm = this._baseCompLogoElm.cloneNode(true);
      if (replacedElm) {
        replacedElm.parentElement.replaceChild(elm, replacedElm);
      }
      return elm;
    },

    _baseCompOmitNameElm: null,
    _createCompOmitNameElm(replacedElm = null) {
      if (!this._baseCompOmitNameElm) {
        this._baseCompOmitNameElm = document.createElement('span');
        this._baseCompOmitNameElm.className = 'res-company-item__omit-name';
      }
      const elm = this._baseCompOmitNameElm.cloneNode(true);
      if (replacedElm) {
        replacedElm.parentElement.replaceChild(elm, replacedElm);
      }
      return elm;
    },

    _baseCompOmitNameAnchroElm: null,
    _createCompOmitNameAnchorElm(replacedElm = null) {
      if (!this._baseCompOmitNameAnchroElm) {
        this._baseCompOmitNameAnchroElm = document.createElement('a');
        this._baseCompOmitNameAnchroElm.className = 'res-list-item__link res-company-item__omit-name';
      }
      const elm = this._baseCompOmitNameAnchroElm.cloneNode(true);
      if (replacedElm) {
        replacedElm.parentElement.replaceChild(elm, replacedElm);
      }
      return elm;
    },
  };

  // Behavior of info icon
  const onLoadComplete = (e) => {
    const xhr = e.detail[0];
    if (xhr.status === 0 || xhr.status >= 400) {
      const message = I18n.t('js.companies.failed_to_get_company_info', { status: xhr.status });
      document.querySelector('.res-companies-snackbar').MDCSnackbar.show({ message });
      return;
    }
    contents.company = JSON.parse(xhr.responseText);
    contents.showInfo();
    contents.setupForm();
    contents.changeInfoIconState();
  };
  for (const icon of contents.listElm.querySelectorAll('.res-company-info-link')) {
    icon.addEventListener('ajax:complete', onLoadComplete, false);
  }

  // Behavior of edit button
  document.querySelector('.res-company-edit-button').addEventListener('click', (e) => {
    contents.dialogElm.MDCDialog.show();
  }, false);

  // Behavior of add FAB
  document.querySelector('.res-company-add-button').addEventListener('click', (e) => {
    contents.company = null;
    contents.setupForm();
    contents.dialogElm.MDCDialog.show();
    contents.hideInfo();
    contents.changeInfoIconState();
  }, false);

  // Behavior of submit button
  document.querySelector('.res-company-submit').addEventListener('click', (e) => {
    if (!contents.validateForm()) {
      e.preventDefault();
      e.stopPropagation();
    }
  }, false);

  // Behavior after returns resposne
  contents.formElm.addEventListener('ajax:complete', (e) => {
    const xhr = e.detail[0];
    let message;
    if (xhr.status !== 0 && xhr.status < 400) {
      contents.company = JSON.parse(e.detail[0].responseText);
      contents.showInfo();
      contents.setupForm();
      if (xhr.responseURL === contents.company.url) {
        contents.updateList();
        message = I18n.t('js.companies.successfully_updated');
      } else {
        const listItemElm = contents.insertList();
        const icon = listItemElm.querySelector('.res-company-info-link');
        icon.addEventListener('ajax:complete', onLoadComplete, false);
        message = I18n.t('js.companies.successfully_created');
      }
    } else {
      message = I18n.t('js.companies.failed_to_save', { status: xhr.status });
    }
    document.querySelector('.res-companies-snackbar').MDCSnackbar.show({ message });
  }, false);
}, false);
