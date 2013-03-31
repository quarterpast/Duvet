mime = require \mime
{extname,join,resolve,relative} = require \path
fs = require \fs
{sync} = require "./magic"

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
			console.log @route,@pathname
			path = match stat
			| (.is-directory!) => join file, relative @route,@pathname
			| otherwise => file

			res{}headers.'content-type' = mime.lookup extname path
			if (sync exists) path
				fs.create-read-stream path
			else
				res.status-code = 404
				"404 #path"