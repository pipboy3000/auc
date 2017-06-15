'use strict';

var assert = require('power-assert');
var Auc = require('../app/public/js/lib/auc');

describe('Auc test', () => {
  it('isEntered', () => {
    var auc = new Auc();

    auc.shohin_title = "title";
    auc.shohin_detail = "detail";
    auc.category = auc.tax = auc.payment = auc.shop = auc.kanri_prefix = auc.color = auc.html_template = auc.text_template = true;
    auc.keyword = 'keyword'
    assert(auc.isEntered() === true);

    auc.shohin_detail = "";
    assert(auc.isEntered() === false);
  });

  it('isNotEnterd', () => {
    var auc = new Auc();

    auc.shohin_title = "title";
    auc.shohin_detail = "detail";
    auc.category = auc.tax = auc.payment = auc.shop = auc.kanri_prefix = auc.color = auc.html_template = auc.text_template = true;
    auc.keyword = 'keyword'
    assert(auc.isNotEntered() === false);

    auc.shohin_detail = "";
    assert(auc.isNotEntered() === true);
  });

  it('clear', () => {
    var auc = new Auc();

    auc.shop = 1;

    auc.clear("shop");

    assert(auc.shop === false);
  });

  it('clearAll', () => {
    var auc = new Auc();

    auc.shop = 1;
    auc.color = 1;
    auc.html_template = 1;
    auc.text_template = 1;

    auc.clearAll();

    assert(auc.shop === false);
    assert(auc.color === false);
    assert(auc.html_template === false);
    assert(auc.text_template === false);
  });

  it('clearDetail', () => {
    var auc = new Auc();

    auc.shohin_title = 'title';
    auc.shohin_detail = 'detail';

    auc.clearDetail();

    assert(auc.shohin_title === '');
    assert(auc.shohin_detail === '');
  });

  it('render', () => {
    var auc = new Auc();
    
    auc.shohin_title = "test";
    auc.html_template = {contents: "<div>{{{shohin_title}}}</div>"};
    assert(auc.render() == "<div>test</div>");
  });

  it('tmpl_date', () => {
    var unixtime = 1435396896268;
    var d = new Date(unixtime);
    var auc = new Auc();
    auc.created_at = unixtime;
    var date_str = d.toLocaleDateString() + ' ' + d.toLocaleTimeString();
    assert(auc.tmpl_date() == date_str);
  });
});

