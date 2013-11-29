/*jslint browser: true, node: true, nomen: true, vars: true, indent: 4, regexp: true */
/*global cordova*/
'use strict';

var argscheck = require('cordova/argscheck'),
    exec = require('cordova/exec'),
    utils = require('cordova/utils'),
    RenderEngineBase = require('./RenderEngineBase');

var RenderEngineImpl = function () {
    RenderEngineImpl.__super__.constructor.call(this);
};

utils.extend(RenderEngineImpl, RenderEngineBase);

module.exports = RenderEngineImpl;
