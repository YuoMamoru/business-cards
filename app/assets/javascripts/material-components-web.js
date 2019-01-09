/**
 * @license
 * Copyright 2016 Google Inc.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

//= require @material/auto-init/dist/mdc.autoInit
//= require @material/base/dist/mdc.base
//= require @material/checkbox/dist/mdc.checkbox
// require @material/chips/dist/mdc.chips
//= require @material/dialog/dist/mdc.dialog
//= require @material/dom/dist/mdc.dom
//= require @material/drawer/dist/mdc.drawer
//= require @material/floating-label/dist/mdc.floatingLabel
//= require @material/form-field/dist/mdc.formField
// require @material/grid-list/dist/mdc.gridList
//= require @material/icon-button/dist/mdc.iconButton
//= require @material/icon-toggle/dist/mdc.iconToggle
// require @material/linear-progress/dist/mdc.linearProgress
//= require @material/line-ripple/dist/mdc.lineRipple
//= require @material/list/dist/mdc.list
//= require @material/menu/dist/mdc.menu
//= require @material/menu-surface/dist/mdc.menuSurface
//= require @material/notched-outline/dist/mdc.notchedOutline
//= require @material/radio/dist/mdc.radio
//= require @material/ripple/dist/mdc.ripple
//= require @material/select/dist/mdc.select
//= require @material/selection-control/dist/mdc.selectionControl
// require @material/slider/dist/mdc.slider
//= require @material/snackbar/dist/mdc.snackbar
//= require @material/switch/dist/mdc.switch
// require @material/tab/dist/mdc.tab
// require @material/tab-bar/dist/mdc.tabBar
// require @material/tab-indicator/dist/mdc.tabIndicator
// require @material/tab-scroller/dist/mdc.tabScroller
//= require @material/textfield/dist/mdc.textfield
// require @material/toolbar/dist/mdc.toolbar
//= require @material/top-app-bar/dist/mdc.topAppBar

'use strict';

mdc.autoInit = mdc.autoInit.default;

mdc.autoInit.register('MDCCheckbox', mdc.checkbox.MDCCheckbox);
// mdc.autoInit.register('MDCChip', mdc.chips.MDCChip);
// mdc.autoInit.register('MDCChipSet', mdc.chips.MDCChipSet);
mdc.autoInit.register('MDCDialog', mdc.dialog.MDCDialog);
mdc.autoInit.register('MDCDrawer', mdc.drawer.MDCDrawer);
mdc.autoInit.register('MDCFloatingLabel', mdc.floatingLabel.MDCFloatingLabel);
mdc.autoInit.register('MDCFormField', mdc.formField.MDCFormField);
mdc.autoInit.register('MDCRipple', mdc.ripple.MDCRipple);
// mdc.autoInit.register('MDCGridList', mdc.gridList.MDCGridList);
mdc.autoInit.register('MDCIconButtonToggle', mdc.iconButton.MDCIconButtonToggle);
mdc.autoInit.register('MDCIconToggle', mdc.iconToggle.MDCIconToggle);
mdc.autoInit.register('MDCLineRipple', mdc.lineRipple.MDCLineRipple);
// mdc.autoInit.register('MDCLinearProgress', mdc.linearProgress.MDCLinearProgress);
mdc.autoInit.register('MDCList', mdc.list.MDCList);
mdc.autoInit.register('MDCNotchedOutline', mdc.notchedOutline.MDCNotchedOutline);
mdc.autoInit.register('MDCRadio', mdc.radio.MDCRadio);
mdc.autoInit.register('MDCSnackbar', mdc.snackbar.MDCSnackbar);
// mdc.autoInit.register('MDCTabBar', mdc.tabBar.MDCTabBar);
mdc.autoInit.register('MDCTextField', mdc.textfield.MDCTextField);
mdc.autoInit.register('MDCMenu', mdc.menu.MDCMenu);
mdc.autoInit.register('MDCMenuSurface', mdc.menuSurface.MDCMenuSurface);
mdc.autoInit.register('MDCSelect', mdc.select.MDCSelect);
// mdc.autoInit.register('MDCSlider', mdc.slider.MDCSlider);
mdc.autoInit.register('MDCSwitch', mdc.switch.MDCSwitch);
// mdc.autoInit.register('MDCToolbar', mdc.toolbar.MDCToolbar);
mdc.autoInit.register('MDCTopAppBar', mdc.topAppBar.MDCTopAppBar);
