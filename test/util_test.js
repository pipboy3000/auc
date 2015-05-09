'use strict';

var assert = require('power-assert');
var Util = require('../app/public/js/lib/util');

describe('Util test', () => {
  it('nl2br', () => {
    assert(Util.nl2br("first\nsecond") == "first<br>second");
  });
  
  it('uuid', () => {
    assert(Util.uuid().length == 36);
  });
});

