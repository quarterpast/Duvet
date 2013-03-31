mime = require \mime
{extname,join,resolve,relative} = require \path
fs = require \fs
{sync} = require "./magic"
zlib = require \zlib

export
	locals: (obj)->(res,last)->
		res{}locals import switch typeof! obj
		| \Function => obj ...
		| otherwise => obj

	set: (obj)->(res,last)->
		res{}headers import switch typeof! obj
		| \Function => obj ...
		| otherwise => obj

	static: (file)->
		stat = fs.stat-sync file
		exists = (file,cb)->
			fs.exists file, cb null _
		(res)->
			path = match stat
			| (.is-directory!) => join file, relative @route,@pathname
			| otherwise => file

			res{}headers.'content-type' = mime.lookup extname path
			if (sync exists) path
				fs.create-read-stream path
			else
				res.status-code = 404
				"404 #path"

	gzip: (res,last)->
		res{}headers.vary = "Accept-encoding"
		if req.headers."Accept-encoding" == /gzip/
			res{}headers."content-encoding" = "gzip"
			last.pipe zlib.create-gzip!
		else last