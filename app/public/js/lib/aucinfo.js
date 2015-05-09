var _ = require('lodash');

class AucInfo {
  constructor() {
    this.shop            = false;
    this.color           = false;
    this.html_template   = false;
    this.text_template   = false;
    this.tax             = false;
    this.term            = 5;
    this.payment         = [];
    this.kanri_no_prefix = "";
    this.kanri_no_start  = 1;
    this.restore();
  }

  updatePayment(value) {
    if (_.indexOf(this.payment, value) !== -1) {
      _.pull(this.payment, value);
    } else {
      this.payment.push(value);
    }
    this.payment = this.payment.sort();
    return this.payment;
  }

  restore(callback) {
    var storage = window.localStorage;
    if (!storage.getItem('aucInfo')) return;
    if (storage.aucInfo.length <= 0) return;
    _.forEach(JSON.parse(storage.aucInfo), (v, key) => this[key] = v);
    if (typeof callback === 'function') callback(this);
  }

  store() {
    var storage = window.localStorage;
    if (!storage.getItem('aucInfo')) storage.aucInfo = '';
    storage.aucInfo = JSON.stringify(this);
    return this;
  }

  jsonURL(key) {
    return `${location.protocol}//${location.host}/${key}/${this[key]}/json`;
  }
}

module.exports = AucInfo;
