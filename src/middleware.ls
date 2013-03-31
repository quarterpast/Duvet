mime = require \mime
{extname,join,resolve,relative} = require \path
fs = require \fs
{sync} = require "./magic"
zlib = require \zlib
crypto = require \crypto

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
			console.log path
			if (sync exists) path
				pstat = (sync fs.stat) path
				mod = @headers."if-modified-since"
				if not mod? or new Date mod < pstat.mtime
					res{}headers.'last-modified' = pstat.mtime.to-ISO-string!
					fs.create-read-stream path
				else
					res.status-code = 304
					"304 Not Modified"
			else
				res.status-code = 404
				"404 #path"

	gzip: (res,last)->
		res{}headers.vary = "Accept-encoding"
		if @headers."accept-encoding" == /gzip/
			res{}headers."content-encoding" = "gzip"
			last.pipe zlib.create-gzip!
		else last