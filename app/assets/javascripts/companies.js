'use strict';

document.addEventListener('turbolinks:load', (evt) => {
  if (!document.querySelector('.content-company')) {
    return;
  }

  // Contents object that manages company page
  const contents = {
    // HTML Dom Objects
    infoIcons: document.querySelectorAll('.res-company-info-link'),
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
        this.infoElm.querySelector(`.res-company-info__${field.replace('_', '-')}`).innerHTML = this.company[field] || '';
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
      for (const icon of this.infoIcons) {
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
      }
    },
  };

  // Behavior of info icon
  const onLoadComplete = (e) => {
    const xhr = e.detail[0];
    if (xhr.status >= 400) {
      const message = `Failed to get company info. (${xhr.status})`;
      document.querySelector('.res-companies-snackbar').MDCSnackbar.show({ message });
      return;
    }
    contents.company = JSON.parse(xhr.responseText);
    contents.showInfo();
    contents.setupForm();
    contents.changeInfoIconState();
  };
  for (const icon of contents.infoIcons) {
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
    if (xhr.status < 400) {
      contents.company = JSON.parse(e.detail[0].responseText);
      contents.showInfo();
      contents.setupForm();
      message =
        xhr.responseURL.match(`${contents.formElm.dataset.newPath}$`) ?
          'Company was successfully created.' : 'Company was successfully updated.';
    } else {
      message = `Failed to save data. (${xhr.status})`;
    }
    document.querySelector('.res-companies-snackbar').MDCSnackbar.show({ message });
  }, false);
}, false);
