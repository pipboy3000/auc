var _ = require('lodash');

class AucList {
  constructor() {
    this.storage = window.localStorage;
    if (!this.storage.getItem('aucList')) {
      this.storage.aucList = '';
    }
  }

  count() {
    return this.toJSON().length;
  }
  
  update(item) {
    var list = this.toJSON();
    list.push(item);
    this.storage.aucList = JSON.stringify(list);
  }

  remove(item) {
    var list = this.toJSON();
    list = list.filter(v => {
      return (v.shohin_title !== item.shohin_title &&
              v.shohin_detail !== item.shohin_detail);
    });
    this.storage.aucList = JSON.stringify(list);
  }

  removeByUUID(uuid) {
    var list = this.toJSON();
    list = list.filter(v => (v.uuid !== uuid));
    this.storage.aucList = JSON.stringify(list);
  }

  clear() {
    this.storage.aucList = '';
  }

  toJSON() {
    if (this.storage.aucList.length > 0) {
      return JSON.parse(this.storage.aucList);
    }
    return [];
  }

  isUniqueItem(item) {
    return this.isUnique(['shohin_title', 'shohin_detail'], item);
  }

  isUnique(keys, item) {
    var results = keys.map(key => _.some(this.toJSON(), key, item[key]));
    return !(_.every(results));
  }
}

module.exports = AucList;
