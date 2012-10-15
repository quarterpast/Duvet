(function(){
  var sync, fs, path, Renderer, slice$ = [].slice;
  sync = require("./magic").sync;
  fs = require('fs');
  path = require('path');
  module.exports = new (Renderer = (function(){
    Renderer.displayName = 'Renderer';
    var prototype = Renderer.prototype, constructor = Renderer;
    prototype.engines = {};
    prototype.render = function(template){
      var out, this$ = this;
      out = function(res, last){
        var ref$, content, that;
        (res.headers || (res.headers = {}))['content-type'] = 'text/html';
        content = find(compose$([
          (function(it){
            return it in this$.engines;
          }), tail, path.extname
        ]))(
        filter((function(it){
          return RegExp('^' + template).exec(it);
        }))(
        sync(bind$(fs, 'readdir'))(
        (ref$ = this$.folder) != null
          ? ref$
          : path.resolve(require.main.filename, "../templates"))));
        if ((that = content) != null) {
          return this$.engines[tail(path.extname(that))].compile(
          function(it){
            return it.toString('utf8');
          }(
          sync(bind$(fs, 'readFile'))(
          partialize$(path.join, [void 8, that], [0])(
          (ref$ = this$.folder) != null
            ? ref$
            : path.resolve(require.main.filename, "../templates")))))((ref$ = res.locals || (res.locals = {}), ref$.body = last, ref$));
        } else {
          res.statusCode = 404;
          return "Template " + template + " not found.";
        }
      };
      if (this.base === template || this.base == null) {
        return out;
      } else {
        return [out].concat(this.render(this.base));
      }
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
  function partialize$(f, args, where){
    return function(){
      var params = slice$.call(arguments), i,
          len = params.length, wlen = where.length,
          ta = args ? args.concat() : [], tw = where ? where.concat() : [];
      for(i = 0; i < len; ++i) { ta[tw[0]] = params[i]; tw.shift(); }
      return len < wlen && len ? partialize$(f, ta, tw) : f.apply(this, ta);
    };
  }
}).call(this);
