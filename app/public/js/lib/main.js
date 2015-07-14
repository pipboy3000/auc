window.jQuery     = require('jquery');
var _             = require('lodash');
var Bacon         = require('baconjs');
var mustache      = require('mustache');
var ZeroClipboard = require('zeroclipboard');
var Util          = require('./util');
var Auc           = require('./auc');
var AucList       = require('./auclist');
var AucInfo       = require('./aucinfo');
var AucCSV        = require('./auccsv');
var vw            = require('visualwidth');
require('bootstrap');
require('../vendor/jquery.minicolors');

(function($) {

'use strict';

/**
 * auc object
 */
var auc = new Auc();
var aucList = new AucList();
var aucInfo = new AucInfo();

function updatePreview() {
  $('#preview').html(auc.render());
}

function updatePaymentInput() {
  var checkboxs = $('#payment-modal input[type="checkbox"]');
  _.forEach(aucInfo.payment, val => {
    _.forEach(checkboxs, el => {
      if (el.value == val) el.checked = "checked";
    });
  });
}

function attachDownloadData() {
  var button = $('#download');
  var csv = new AucCSV();
  var kanri_no_index = aucInfo.kanri_no_start;
  _.forEach(aucList.toJSON(), auc => {
    auc.__proto__ = Auc.prototype;
    auc.kanri_no_index = kanri_no_index;
    csv.push(auc);
    kanri_no_index += 1;
  });

  button.attr({
    'href': csv.url(),
    'download': 'data.csv'
  });

  if (window.navigator.msSaveBlob) {
    button.off('click');
    button.on('click', e => {
      e.preventDefault();
      csv.msDownload();
    });
  }
}

/**
 * 情報、設定の更新
 */
function getAucData(obj) {
  var el;
  var label;

  function taxUpdate(val) {
    auc.tax = val;
    label.attr('class', 'label label-primary');
    el.text(val);
    return;
  }

  function termUpdate(val) {
    auc.term = val;
    label.attr('class', 'label label-primary');
    el.text(`${val}日`);
    return;
  }

  function paymentUpdate(val) {
    var payment_str = val.join('_');
    auc.payment = payment_str;
    label.attr('class', 'label label-primary');
    el.text(payment_str);
    updatePaymentInput();
    return;
  }

  function colorUpdate(data) {
    el = $('.infobar .color');
    label = el.prev();
    var template = `
    ${data.name}
    <div class="colortip">
      <span style="background: ${data.title}"></span>
      <span style="background: ${data.frame}"></span>
      <span style="background: ${data.text1}"></span>
      <span style="background: ${data.text2}"></span>
      <span style="background: ${data.bg1}"></span>
      <span style="background: ${data.bg2}"></span>
    </div>
    `;
    auc.color = data;
    label.attr('class', 'label label-success');
    el.html(mustache.render(template, data));
    updatePreview();
    return;
  }

  function shopUpdate(data) {
    el = $('.infobar .shop');
    label = el.prev();
    label.attr('class', 'label label-success');
    el.text(data.name);
    $('.page-header h4').text(data.name);
    auc.shop = data;
    updatePreview();
    return;
  }

  function kanriPrefixUpdate(val) {
    var input = $('#kanri-no-prefix');
    if (input.length > 0 && input.val().length === 0) input.val(val);
    label.attr('class', 'label label-primary');
    el.text(val);
    auc.kanri_no_prefix = val;
    return;
  }

  function kanriNoStartUpdate(val) {
    var input = $('#kanri-no-start');
    if (input.length > 0 && input.val() == 1 ) input.val(val);
    label.attr('class', 'label label-primary');
    el.text(val);
    return;
  }

  _.forEach(obj, (val, key) => {
    if (!val || val.length === 0) return;

    el = $(`.infobar .${key}`);
    label = el.prev();

    if (key == "tax") return taxUpdate(val);
    if (key == "term") return termUpdate(val);
    if (key == "payment") return paymentUpdate(val);
    if (key == "kanri_no_prefix") return kanriPrefixUpdate(val);
    if (key == "kanri_no_start") return kanriNoStartUpdate(val);
    
    var jsonStream = Bacon.fromPromise($.getJSON(aucInfo.jsonURL(key)));

    jsonStream.onError(error => {
      el = $(`.infobar .${key}`);
      label = el.prev();
      label.attr('class', 'label label-danger');
      el.text(error.message);
    });

    if (key == "color") return jsonStream.onValue(colorUpdate);
    if (key == "shop") return jsonStream.onValue(shopUpdate);

    jsonStream.onValue(data => {
      el = $(`.infobar .${key}`);
      label = el.prev();
      auc[key] = data;
      label.attr('class', 'label label-success');
      el.text(data.name);
      updatePreview();
    });
  });
}

function inputValue(input, event) {
  var value = () => input.val();
  // var notEmpty = val => val.replace(/[\n\r]/g, '').length > 0;
  return input.asEventStream(event)
               .map(value)
               // .filter(notEmpty)
               .map(Util.nl2br)
               .toProperty('');
}

var allKeyUps = $(document).asEventStream('keyup');
var allKeyDowns = $(document).asEventStream('keydown');
var allKeyPress = $(document).asEventStream('keypress');

function keyCodeIs(keyCode) { return event => event.keyCode === keyCode; }
function isCtrlKey() { return event => event.ctrlKey; }

function keyUps(keyCode) {
  return allKeyUps.filter(keyCodeIs(keyCode));
}

function keyDowns(keyCode) {
  return allKeyDowns.filter(keyCodeIs(keyCode));
}

function keyPress(keyCode) {
  return allKeyPress.filter(keyCodeIs(keyCode));
}

/**
 * jQuery document ready
 */
$(function() {
  var $itemList = $('#item-list .content');

  function renderLists(items) {
    var template = `
  <div class="panel panel-default">
    <div class="panel-heading">
      <b>{{shohin_title}}</b>
      <div class="pull-right">
        <small>{{tmpl_date}}</small>
        <a href="#" data-uuid="{{uuid}}" class="btn btn-danger btn-xs">削除</a>
      </div>
    </div>
    <div class="panel-body">{{{shohin_detail}}}</div>
    <table class="table">
      <tr>
        <th>カテゴリID</th>
        <th>画像数</th>
        <th>消費税</th>
        <th>決済方法</th>
        <th>開催期間</th>
      </tr>
      <tr>
        <td>{{category}}</td>
        <td>{{attachments.length}}</td>
        <td>{{tax}}</td>
        <td>{{payment}}</td>
        <td>{{term}}日</td>
      </tr>
      <tr>
        <th colspan="2">店舗</th>
        <th>カラー</th>
        <th>HTMLテンプレート</th>
        <th>テキストテンプレート</th>
      </tr>
      <tr>
        <td colspan="2">{{shop.name}}</td>
        <td>{{color.name}}</td>
        <td>{{html_template.name}}</td>
        <td>{{text_template.name}}</td>
      </tr>
    </table>
  </div>
    `;
    $itemList.empty();
    items.forEach(item => {
      item.__proto__ = Auc.prototype;
      var itemHtml = mustache.render(template, item);
      $itemList.append(itemHtml);
    });
  }

  var ctrlEnterUp     = keyUps(13).filter(isCtrlKey());
  var ctrlEnterPress  = keyPress(13).filter(isCtrlKey());
  var ctrlEnterDown   = keyDowns(13).filter(isCtrlKey());
  var ctrlPeriodStream = keyUps(190).filter(isCtrlKey());

  // textareaではctrl + enterを無効化
  var ctrlEnter = Bacon.mergeAll(ctrlEnterUp, ctrlEnterPress, ctrlEnterDown);
  ctrlEnter.onValue((e) => {
    if (e.target.type == 'textarea' || e.target.id == 'category') {
      e.preventDefault();
      e.stopPropagation();
    }
    return e;
  });

  /**
   * jQeury miniColors
   */
  $('.color-picker').minicolors({ theme: 'bootstrap' });

  /**
   * ZeroClipboard
   */
  ZeroClipboard.config({swfPath: '/ZeroClipboard.swf'});
  var $copyButton = $('.copy-button');
  $copyButton
    .tooltip({
      title: "Copy!!!",
      trigger: 'manual'
    })
    .on('shown.bs.tooltip', () => {
      setTimeout(() => $copyButton.tooltip('hide'), 1000);
    });

  var zeroclip = new ZeroClipboard($copyButton);
  zeroclip.on('copy', e => {
    var clipboard = e.clipboardData;
    var htmlsource = auc.render();
    clipboard.setData('text/plain', htmlsource);
    $copyButton.tooltip('show');
  });

  /**
   * 昨日分のデータをlocalStorageから削除
   */
  _.forEach(aucList.toJSON(), item => {
    var now = (new Date()).getTime();
    var item_created = new Date(item.created_at);
    if (now - item_created > 60*60*18*1000) aucList.removeByUUID(item.uuid);
  });

  /**
   * 商品詳細入力
   */
  var clearButtonStream = $('#clear-input').asEventStream('click');

  var inputClear = clearButtonStream.merge(ctrlPeriodStream)
                                    .doAction('.preventDefault')
                                    .map(() => auc.clearDetail());

  var inputTitle = inputValue($('#input #shohin_title'), 'keyup')
                        .map(val => auc.shohin_title = val);

  var inputTitleBlur = inputValue($('#input #shohin_title'), 'blur')
                        .map(val => auc.shohin_title = val);

  var inputDetail = inputValue($('#input #shohin_detail'), 'keyup')
                        .map(val => auc.shohin_detail = val);

  var inputCategory = inputValue($('#input #category'), 'keyup')
                        .map(val => auc.category = val);

  /**
   * 店舗、カラー、HTML、テキストのテンプレート選択
   */

  // ページ読み込み後にレストア
  var restoreInfo = $('body').asEventStream('load')
                             .map(() => aucInfo).toProperty(aucInfo);
  
  // infobar操作時
  var infoStream = $('.info-select a')
                        .asEventStream('click')
                        .doAction('.preventDefault')
                        .map(e => {
                          var key = $(e.currentTarget).parents("ul").attr('id');
                          var id = $(e.currentTarget).data(key);

                          aucInfo[key] = id;
                          aucInfo.store();

                          var obj = {};
                          obj[key] = id;

                          return obj;
                        })
                        .toProperty();


  /**
   * 落札ナビ決済方法設定
   */
  var paySelected = $('#payment-modal input[type="checkbox"]')
                      .asEventStream('click')
                      .map('.target.value')
                      .map(val => {
                        aucInfo.updatePayment(val);
                        aucInfo.store();
                        return aucInfo;
                      })
                      .toProperty();

  /**
   * 管理番号設定
   */
  var kanriPrefix = $('#kanri-no-prefix').asEventStream('keyup')
                      .map(e => aucInfo.kanri_no_prefix = e.target.value)
                      .toProperty();

  var kanriNoStart = $('#kanri-no-start').asEventStream('keyup')
                .map(e => aucInfo.kanri_no_start = parseInt(e.target.value, 10))
                .toProperty(1);

  var kanriStream = Bacon.mergeAll(kanriPrefix, kanriNoStart)
                         .map(() => aucInfo.store());

  /**
   * 画像ドラッグ&ドロップ
   */
  var $dropzone = $('#dropzone');
  var enterStream = $dropzone.asEventStream('dragenter');
  var overStream = $dropzone.asEventStream('dragover');
  var leaveStream = $dropzone.asEventStream('dragleave');
  var dropStream = $dropzone.asEventStream('drop');

  // disable default event
  Bacon.mergeAll(enterStream, overStream, leaveStream, dropStream)
                      .onValue(e => {
                        e.preventDefault();
                        e.stopPropagation();
                      });

  // return upload files
  var dropFilesStream = dropStream
                          .map(e => e.originalEvent.dataTransfer.files)
                          .map(files => Bacon.fromArray(_.map(files)))
                          .flatMap(file => file)
                          .filter(file => file.type.match('image'));

  var fileRead = file => {
    return Bacon.fromCallback(callback => {
      var reader= new FileReader();
      reader.onloadend = e => callback([e, file]);
      reader.onerror = () => callback(new Bacon.Error(reader.error));
      reader.readAsDataURL(file);
    });
  };

  // each image stream has callback
  var fileReadStream = dropFilesStream.flatMap(fileRead);
  
  var dropedImage = fileReadStream.map(args => {
    var e = args[0];
    var file = args[1];
    var obj = {
      src: e.target.result,
      name: file.name,
      uuid: Util.uuid(),
    };
    return obj;
  }).toProperty();
  
  // 画像をクリックしたら削除
  $dropzone.asEventStream('click', 'a')
           .doAction('.preventDefault')
           .map(e => {
             var uuid = $(e.currentTarget).find('img').data('uuid');
             auc.removeAttachment(uuid);
             return e;
           })
           .onValue(e => (e.currentTarget).remove());

  /**
   * リスト
   */
  var $addListButton = $('#add-list');
  $addListButton
      .tooltip({
        title: '商品情報入力、各種設定した？',
        trigger: 'manual'
      })
      .on('shown.bs.tooltip', () => {
        setTimeout(() => $addListButton.tooltip('hide'), 1000);
      });

  var addButtonStream = $('#add-list').asEventStream('click');
  var addListStream = addButtonStream.merge(ctrlEnterUp)
                                     .doAction('.preventDefault');

  // 入力をチェック
  addListStream.filter(() => auc.isNotEntered())
               .onValue(() => $addListButton.tooltip('show'));

  // リストにアイテム追加
  var addItemStream = addListStream
                  .filter(() => auc.isEntered() && aucList.isUniqueItem(auc))
                  .map(() => {
                    var date = new Date();
                    auc.uuid = Util.uuid();
                    auc.created_at = date.getTime();
                    aucList.update(auc);
                    auc.clearDetail();
                  });

  // リストからアイテム削除
  var removeItemStream = $itemList.asEventStream('click', '.panel a')
  .doAction('.preventDefault')
  .map((e) => {
    var uuid = $(e.currentTarget).data('uuid');
    aucList.removeByUUID(uuid);
  });

  // リストアイテム全削除
  var removeAllItemStream = $('.clear-list').asEventStream('click')
  .doAction('.preventDefault')
  .map(() => aucList.clear());

  // リストのカウント処理
  var listCountResult = Bacon.mergeAll(
                               addItemStream.map(1),
                               removeItemStream.map(-1),
                               removeAllItemStream.map(0)
                             )
                             .scan(aucList.count(), (current, v) => {
                               if (v === 0) return 0;
                               return _.add(current, v);
                             });

  var updatedListItem = Bacon.mergeAll(
                                addItemStream,
                                removeItemStream,
                                removeAllItemStream
                              )
                              .map(() => aucList.toJSON());

  /**
   * Bus
   */
  // リストを更新
  var initialListItem = Bacon.once(aucList.toJSON());
  var listState = Bacon.mergeAll(initialListItem, updatedListItem);
  var listBus = new Bacon.Bus();
  listBus.plug(listState);
  listBus.onValue(renderLists);
  // listBus.log();

  // infobarの内容を更新
  var infoBus = new Bacon.Bus();
  infoBus.plug(paySelected);
  infoBus.plug(restoreInfo);
  infoBus.plug(infoStream);
  infoBus.plug(kanriStream);
  infoBus.onValue(getAucData);
  // infoBus.log();

  // リストのカウンター更新
  listCountResult.assign($('#list-badge'), 'text');

  // タイトルの文字数チェック
  
  var inputTitleWrap = $('#shohin_title').parents('.form-group');
  var title = Bacon.mergeAll(inputTitle, inputTitleBlur);

  title.filter(val => vw.width(val) > 60)
       .assign(inputTitleWrap, 'addClass', 'has-error');
  title.filter(val => vw.width(val) <= 60)
       .assign(inputTitleWrap, 'removeClass', 'has-error');

  // 入力されたらプレビュー更新
  var inputs = Bacon.mergeAll(
    inputClear,
    inputTitle,
    inputTitleBlur,
    inputDetail,
    inputCategory,
    addItemStream
  );
  var inputBus = new Bacon.Bus();
  inputBus.plug(inputs);
  inputBus.onValue(updatePreview);
  // inputBus.log();

  // 入力内容をクリア
  var clears = Bacon.mergeAll(inputClear, addItemStream);
  var clearBus = new Bacon.Bus();
  clearBus.plug(clears);
  clearBus.onValue(() => {
    $('#input textarea').val('');
    $('#input input').val('');
    $dropzone.find('a').remove();
    $('#shohin_title').focus();
  });
  // clearBus.log();

  // ダウンロードボタンのtoggle
  listCountResult.map(v => (v === 0))
                 .assign($('#download'), 'attr', 'disabled');

  // データが追加、削除されたらCSVの内容を更新
  var csvBus = new Bacon.Bus();
  csvBus.plug(kanriPrefix);
  csvBus.plug(kanriNoStart);
  csvBus.plug(listCountResult);
  csvBus.onError(error => console.log(error));
  csvBus.onValue(attachDownloadData);
  attachDownloadData();

  // 画像が追加されたら表示
  var fileDropBus = new Bacon.Bus();
  fileDropBus.plug(dropedImage);
  fileDropBus.onValue(obj => {
    var template = `
    <a href="#">
      <img src="{{src}}" data-name="{{name}}" data-uuid="{{uuid}}">
    </a>
    `;
    $dropzone.append(mustache.render(template, obj));
    auc.attachments.push({name: obj.name, uuid: obj.uuid});
    auc.attachments = _.sortBy(auc.attachments, 'name');
  });

});

})(jQuery);
