var _ = require('lodash');
var mustache = require('mustache');

class Auc {
  constructor() {
    this.shop            = false;
    this.color           = false;
    this.html_template   = false;
    this.text_template   = false;
    this.shohin_title    = '';
    this.shohin_detail   = '';
    this.keyword         = '';
    this.attachments     = [];
    this.uuid            = '';
    this.created_at      = '';
    this.category        = false;
    this.tax             = false;
    this.term            = 5;
    this.payment         = false;
    this.kanri_no_prefix = false;
    this.kanri_no_index  = 1;
  }

  isEntered() {
    return _.every([
      this.shohin_title,
      this.shohin_detail,
      this.category,
      this.tax,
      this.payment,
      this.shop,
      this.color,
      this.html_template,
      this.text_template
    ], Boolean);
  }

  isNotEntered() {
    return !(this.isEntered());
  }

  update(data, key) {
    this[key] = data;
  }
  
  clear(key) {
    if (key === 'attachments') {
      this[key] = [];
      return;
    }

    if (key === ('shohin_title' || 'shohin_detail' || 'category' || 'keyword')) {
      this[key] = '';
      return;
    }

    if (key === 'term') {
      this[key] = 5;
      return;
    }

    if (key === 'kanri_no_index') {
      this[key] = 1;
      return;
    }

    this[key] = false;
  }

  clearAll() {
    _.forEach(this, (val, key) => this.clear(key));
  }

  clearDetail() {
    this.shohin_detail = this.shohin_title = this.category = this.keyword = '';
    this.attachments = [];
  }

  removeAttachment(uuid) {
    _.remove(this.attachments, item => item.uuid === uuid);
  }

  render() {
    if (this.html_template) {
      return mustache.render(this.html_template.contents, this);
    }
  }

  tmpl_date() {
    var d = new Date(this.created_at);
    return d.toLocaleDateString() + ' ' + d.toLocaleTimeString();
  }
}

module.exports = Auc;
