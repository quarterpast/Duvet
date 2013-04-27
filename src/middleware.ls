mime = require \mime
{extname,join,resolve,relative} = require \path
fs = require \fs
{sync} = require "./magic"
zlib = require \zlib
crypto = require \crypto

export
	locals: (...args)->(last)->@locals ...args
	set: (obj,val)->(last)->
		headers: switch typeof! obj
		| \Function => obj this
		| \Object   => obj
		| \String   => (obj): val

	static: (file)->
		stat = fs.stat-sync file
		exists = (file,cb)->
			fs.exists file, cb null _
		->
			path = match stat
			| (.is-directory!) => join file, relative @route,@pathname
			| otherwise => file

			res.set-header 'Content-Type' mime.lookup extname path
			console.log path
			if (sync exists) path
				pstat = (sync fs.stat) path
				mod = @headers."if-modified-since"
				if not mod? or (new Date mod) < pstat.mtime
					res.set-header 'Last-Modified' pstat.mtime.to-ISO-string!
					fs.create-read-stream path
				else
					res.status-code = 304
					"304 Not Modified"
			else
				res.status-code = 404
				"404 #path"
