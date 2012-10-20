(function(){
  var mime, ref$, extname, join, resolve, relative, fs, toString$ = {}.toString;
  mime = require('mime');
  ref$ = require('path'), extname = ref$.extname, join = ref$.join, resolve = ref$.resolve, relative = ref$.relative;
  fs = require('fs');
  (function(){
    this.locals = function(obj){
      return function(res, last){
        return import$(res.locals || (res.locals = {}), (function(args$){
          switch (toString$.call(obj).slice(8, -1)) {
          case 'Function':
            return obj.apply(this, args$);
          default:
            return obj;
          }
        }.call(this, arguments)));
      };
    };
    this.set = function(obj){
      return function(res, last){
        return import$(res.headers || (res.headers = {}), (function(args$){
          switch (toString$.call(obj).slice(8, -1)) {
          case 'Function':
            return obj.apply(this, args$);
          default:
            return obj;
          }
        }.call(this, arguments)));
      };
    };
    this['static'] = function(file){
      var stat;
      stat = fs.statSync(file);
      return function(res){
        var path;
        path = (function(){
          var ref$;
          switch (ref$ = [stat], false) {
          case !function(it){
            return it.isDirectory;
          }(ref$[0]):
            return join(file, relative(this.route, this.pathname));
          default:
            return file;
          }
        }.call(this));
        (res.headers || (res.headers = {}))['content-type'] = mime.lookup(extname(path));
        if (!fs.exists.sync(fs, path)) {
          res.statusCode = 404;
        }
        return fs.createReadStream(path);
      };
    };
  }.call(exports));
  function import$(obj, src){
    var own = {}.hasOwnProperty;
    for (var key in src) if (own.call(src, key)) obj[key] = src[key];
    return obj;
  }
}).call(this);
