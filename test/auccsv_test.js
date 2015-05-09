'use strict';

var assert = require('power-assert');
var AucCSV = require('../app/public/js/lib/auccsv');
var Encoding = require('encoding-japanese');

describe('AucCSV test', () => {
  it('toCell', () => {
    var csv = new AucCSV();
    var data = ["1", "two", "3"];
    assert(csv.toCell(data) == "1,two,3");
  });

  it('toCSV', () => {
    var csv = new AucCSV();
    csv.data = [
      ["1", "two", "3"],
      ["1", "two", "3"],
      ["1", "two", "3"],
    ];

    assert(csv.toCSV() == "1,two,3\r\n1,two,3\r\n1,two,3");
  });

  // it('toBlob', () => {
  //   var csv = new AucCSV();
  //   csv.data = [
  //     ["1", "one", "あ"],
  //     ["2", "two", "い"],
  //     ["3", "three", "う"],
  //   ];
  //   
  //   console.log(csv.toBlob());
  // });
});
