
/*jslint browser: true, node: true, nomen: true, vars: true, indent: 4, regexp: true */
'use strict';

var argscheck = require('cordova/argscheck'),
    exec = require('cordova/exec');


/**
 * Creates a renderengine which uses its platform dependent implementation
 * @constructor
 */
function RenderEngineBase() {
    
}

/**
 * Initialize the render engine
 * @param {Function} successCB success callback
 * @param {Function} errorCB error callback
 * @param {Object} options to initialize the render engine
 */
RenderEngineBase.prototype.initEngine = function (successCB, errorCB, options) {
    exec(successCB, errorCB, "RenderEngine", "initEngine", [options]);
};

/**
 * Resize the render engine
 * @param {Function} successCB success callback
 * @param {Function} errorCB error callback
 * @param {Object} options to initialize the render engine
 */
RenderEngineBase.prototype.resizeEngine = function (successCB, errorCB, options) {
    exec(successCB, errorCB, "RenderEngine", "resizeEngine", [options]);
};
    
/**
 * Hide the render engine
 * @param {Function} successCB success callback
 * @param {Function} errorCB error callback
 */
RenderEngineBase.prototype.hideEngine = function (successCB, errorCB) {
    exec(successCB, errorCB, "RenderEngine", "hideEngine", []);
};

module.exports = RenderEngineBase;

