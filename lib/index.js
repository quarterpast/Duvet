(function(){
    if (typeof window != 'undefined' && window !== null) {
    prelude.installPrelude(window);
  } else {
    require('prelude-ls').installPrelude(global);
  };
  import$(exports, map(compose$([
    require, (function(it){
      return './' + it;
    })
  ]), {
    'magic': 'magic',
    'template': 'template',
    'middleware': 'middleware'
  }));
  exports.route = require('livewire');
  function import$(obj, src){
    var own = {}.hasOwnProperty;
    for (var key in src) if (own.call(src, key)) obj[key] = src[key];
    return obj;
  }
  function compose$(fs){
    return function(){
      var i, args = arguments;
      for (i = fs.length; i > 0; --i) { args = [fs[i-1].apply(this, args)]; }
      return args[0];
    };
  }
}).call(this);
