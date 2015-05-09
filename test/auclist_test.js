'use strict';

var assert = require('power-assert');
var AucList = require('../app/public/js/lib/auclist');

describe('AucList test', () => {
  beforeEach(() => {
    window.localStorage.clear();
  });

  it('init', () => {
    var auc_list = new AucList();
    assert(auc_list.storage.aucList === '');
  });

  it('update', () => {
    var auc_list = new AucList();
    auc_list.update({"shop": 1});
    assert(auc_list.storage.aucList === "[{\"shop\":1}]");
  });

  it('count', () => {
    var auc_list = new AucList();
    assert(auc_list.count() === 0);

    auc_list.update({"shop": 1});
    assert(auc_list.count() == 1);
  });

  it('clear', () => {
    var auc_list = new AucList();
    auc_list.update({"shop": 1});

    auc_list.clear();
    assert(auc_list.storage.aucList === '');
  });

  it('toJSON', () => {
    var auc_list = new AucList();
    auc_list.update({"shop": 1});

    var json = auc_list.toJSON();
    assert(json[0].shop == 1);
  });

  it('toJSON when empty list', () => {
    var auc_list = new AucList();
    var json = auc_list.toJSON();
    assert.deepEqual(json, []);
  });

  it('isUnique', () => {
    var auc_list = new AucList();
    var item1 = {"name": "John", "age": 28};
    var item2 = {"name": "Paul", "age": 25};
    var item3 = {"name": "John", "age": 22};

    auc_list.update(item1);

    assert(auc_list.isUnique(["name", "age"], item2) === true,
           "item should unique");
    assert(auc_list.isUnique(["name", "age"], item1) === false,
           "item should not unique");
    assert(auc_list.isUnique(["name", "age"], item3) === true,
           "item should unique");
  });
});
