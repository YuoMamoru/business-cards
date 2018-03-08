document.addEventListener 'turbolinks:load', ->
  mdc.autoInit()

  for element in document.querySelectorAll 'div[data-mdc-auto-init="MDCSelect"]'
    element.MDCSelect.listen 'MDCSelect:change', (e) ->
      hiddenEl = e.target.querySelector 'input[type="hidden"]'
      if hiddenEl
        hiddenEl.value = e.detail.value

  for element in document.querySelectorAll 'div[data-mdce-auto-init="MDCEImageField"]'
    inputProxy = element.querySelector '.mdce-image-field__proxy'
    inputProxy.addEventListener 'focusin', (e) ->
      e.target.parentElement.classList.add 'mdce-image-field--focused'
    , false
    inputProxy.addEventListener 'focusout', (e) ->
      e.target.parentElement.classList.remove 'mdce-image-field--focused'
    , false
    element.querySelector('input[type="file"]').addEventListener 'change', (e) ->
      imgElm = e.target.parentElement.querySelector 'img'
      unless imgElm
        e.target.parentElement.removeChild(e.target.parentElement.querySelector 'span')
        imgElm = document.createElement 'img'
        imgElm.setAttribute 'height', '192'
        e.target.parentElement.insertBefore imgElm, e.target.parentElement.firstChild
      file = e.target.files[0]
      reader = new FileReader()
      reader.imageElement = e.target.parentElement.querySelector 'img'
      reader.addEventListener 'load', (e) ->
        imgElm.removeAttribute('width')
        e.target.imageElement.setAttribute 'src', e.target.result
      reader.readAsDataURL file
    , false
, false
