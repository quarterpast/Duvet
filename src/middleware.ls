mime = require \mime
{extname,join,resolve,relative} = require \path
fs = require \fs

with exports
	@locals = (obj)->(res,last)->
		res{}locals import switch typeof! obj
		| \Function => obj ...
		| otherwise => obj

	@set = (obj)->(res,last)->
		res{}headers import switch typeof! obj
		| \Function => obj ...
		| otherwise => obj

	@static = (file)->
		stat = fs.stat-sync file
		(res)->
			path = match stat
			| (.is-directory) => join file, relative @route,@pathname
			| otherwise => file

			res{}headers.'content-type' = mime.lookup extname path
			res.status-code = 404 unless fs.exists.sync fs, path
			fs.create-read-stream path