'use strict';

document.addEventListener('turbolinks:load', (evt) => {
  const drawerElm = document.querySelector('.res-drawer');
  const drawer = new mdc.drawer.MDCDrawer(drawerElm);
  document.querySelector('.res-main-menu').addEventListener('click', (e) => {
    drawer.open = !drawer.open;
  }, false);
}, false);
