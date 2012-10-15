(function(){
  var slice$ = [].slice;
  require('sync');
  exports.sync = function(fun){
    return function(){
      var args;
      args = slice$.call(arguments);
      return fun.sync.apply(fun, [null].concat(slice$.call(args)));
    };
  };
  exports.async = function(it){
    return it.async();
  };
}).call(this);
