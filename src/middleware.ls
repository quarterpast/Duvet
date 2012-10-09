mime = require \mime
path = require \path
fs = require \fs

with exports
	@locals = (obj)->(res,last)->
		res@locals import switch typeof! obj
		| \Function => obj ...
		| otherwise => obj

	@set = (obj)->(res,last)->
		res@headers import switch typeof! obj
		| \Function => obj ...
		| otherwise => obj

	@static-file = (file)->(res)->
		res@headers.'content-type' = mime.lookup path.extname file
		fs.create-read-stream file