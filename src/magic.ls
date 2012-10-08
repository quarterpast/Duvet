require \sync
exports.sync = (fun)->(...args)->fun.sync null,...args
exports.async = (.async!)