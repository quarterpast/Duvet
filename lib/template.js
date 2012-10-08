(function(){
  var sync, fs, path, Renderer;
  sync = require("./magic").sync;
  fs = require('fs');
  path = require('path');
  module.exports = new (Renderer = (function(){
    Renderer.displayName = 'Renderer';
    var prototype = Renderer.prototype, constructor = Renderer;
    prototype.engines = {};
    prototype.render = function(template){
      var this$ = this;
      return function(res, last){
        var ref$, template, that;
        (res.headers || (res.headers = {}))['content-type'] = 'text/html';
        template = find(compose$([
          (function(it){
            return it in this$.engines;
          }), path.extname
        ]))(
        filter((function(it){
          return RegExp('^' + template).exec(it);
        }))(
        sync(bind$(fs, 'readdir'))(
        (ref$ = this$.folder) != null
          ? ref$
          : path.resolve(require.main.filename, "../templates"))));
        if ((that = template) != null) {
          return this$.engines[path.extname(that)].compile(
          function(it){
            return it.toString('utf8');
          }(
          sync(bind$(fs, 'readFile'))(
          that)))((ref$ = res.locals || (res.locals = {}), ref$.body = last, ref$));
        } else {
          res.statusCode = 404;
          return "Template " + template + " not found.";
        }
      };
    };
    function Renderer(){}
    return Renderer;
  }()));
  function compose$(fs){
    return function(){
      var i, args = arguments;
      for (i = fs.length; i > 0; --i) { args = [fs[i-1].apply(this, args)]; }
      return args[0];
    };
  }
  function bind$(obj, key, target){
    return function(){ return (target || obj)[key].apply(obj, arguments) };
  }
}).call(this);
