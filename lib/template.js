(function(){
  var Handlebars, sync, fs, path, Renderer;
  Handlebars = require('handlebars');
  sync = require("./magic").sync;
  fs = require('fs');
  path = require('path');
  module.exports = new (Renderer = (function(){
    Renderer.displayName = 'Renderer';
    var prototype = Renderer.prototype, constructor = Renderer;
    prototype.render = function(template){
      var that;
      switch (false) {
      case (that = this.engine) == null:
        return function(res, last){
          (res.headers || (res.headers = {}))['content-type'] = 'text/html';
          return (function(it){
            var ref$;
            return it((ref$ = res.locals || (res.locals = {}), ref$.body = last, ref$));
          })(
          that.compile(
          function(it){
            return it.toString('utf8');
          }(
          sync(bind$(fs, 'readFile'))(
          path.resolve(__dirname, "../templates", template + '.html')))));
        };
      default:
        throw new Error("Assign to renderer.engine first.");
      }
    };
    function Renderer(){}
    return Renderer;
  }()));
  function bind$(obj, key, target){
    return function(){ return (target || obj)[key].apply(obj, arguments) };
  }
}).call(this);
