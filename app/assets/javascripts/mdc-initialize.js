'use strict';

document.addEventListener('turbolinks:load', (evt) => {
  mdc.autoInit();

  const onBlurSelect = (e) => {
    if (e.target.hasAttribute('required') && !e.target.value) {
      e.target.parentElement.classList.add('mdc-select--invalid');
    } else {
      e.target.parentElement.classList.remove('mdc-select--invalid');
    }
  };
  for (const element of document.querySelectorAll('div[data-mdc-auto-init="MDCSelect"]')) {
    element.MDCSelect.listen('change', onBlurSelect);
    element.querySelector('select[class="mdc-select__native-control"]').addEventListener('blur', onBlurSelect, false);
  }

  const onChangeFile = (e) => {
    let imgElm = e.target.parentElement.querySelector('img');
    if (!imgElm) {
      e.target.parentElement.querySelector('.mdce-image-field__button').style.display = 'none';
      imgElm = document.createElement('img');
      imgElm.style.maxWidth = e.target.parentElement.style.maxWidth;
      imgElm.style.maxHeight = e.target.parentElement.style.maxHeight;
      imgElm.classList.add('mdce-image-field__image');
      e.target.parentElement.insertBefore(imgElm, e.target);
    }
    const file = e.target.files[0];
    if (!file) {
      return;
    }
    const reader = new FileReader();
    reader.addEventListener('load', (ev) => {
      imgElm.removeAttribute('width');
      imgElm.src = ev.target.result;
    });
    reader.readAsDataURL(file);
  };
  for (const element of document.querySelectorAll('div[data-mdce-auto-init="MDCEImageField"]')) {
    const inputProxy = element.querySelector('.mdce-image-field__proxy');
    inputProxy.addEventListener('focusin', (e) => {
      e.target.parentElement.classList.add('mdce-image-field--focused');
    }, false);
    inputProxy.addEventListener('focusout', (e) => {
      e.target.parentElement.classList.remove('mdce-image-field--focused');
    }, false);
    element.querySelector('input[type="file"]').addEventListener('change', onChangeFile, false);
  }
}, false);
