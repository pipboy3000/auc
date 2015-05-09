'use strict';

var assert = require('power-assert');
var AucInfo = require('../app/public/js/lib/aucinfo');

describe('AucInfo test', () => {
  beforeEach(() => {
    window.localStorage.clear();
  });

  it('init', () => {
    var info = new AucInfo();
    assert(info.shop === false);
    assert(info.color === false);
    assert(info.html_template === false);
    assert(info.text_template === false);
  });

  it('store and restore', () => {
    var info = new AucInfo();

    info.shop = 1;
    info.color = 1;
    info.html_template = 1;
    info.text_template = 1;
    
    info.store();

    info.shop = 2;
    info.color = 2;
    info.html_template = 2;
    info.text_template = 2;

    info.restore();

    assert(info.shop == 1);
    assert(info.shop == 1);
    assert(info.html_template == 1);
    assert(info.text_template == 1);
  });

  it('jsonURL', () => {
    var info = new AucInfo();
    info.shop = 1;
    assert(info.jsonURL("shop") == `${location.protocol}//${location.host}/shop/1/json`);
  });
});

