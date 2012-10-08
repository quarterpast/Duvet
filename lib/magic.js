(function(){
  var slice$ = [].slice;
    if (typeof window != 'undefined' && window !== null) {
    prelude.installPrelude(window);
  } else {
    require('prelude-ls').installPrelude(global);
  };
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
