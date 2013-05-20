child_process = require 'child_process'

module.exports = (grunt) ->

	grunt.initConfig
		pkg: grunt.file.readJSON('package.json')
		meta:
			banner:	'/** <%= pkg.name %> - v<%= pkg.version %> - ' +
					'<%= grunt.template.today("yyyy-mm-dd") %>\n' +
					'<%= pkg.homepage ? " * " + pkg.homepage + "\\n" : "" %>' +
					' * Git Build: SHA1 : ' + '<%= global.gitSHA1 %>\n' +
					' * Copyright (c) <%= grunt.template.today("yyyy") %> <%= pkg.author.name %>;' +
					' Licensed <%= pkg.license.type + ", " + pkg.license.url %>\n **/\n\n'
		concat:
			cssparser:
				options:
					banner: "<%= meta.banner %>"
				src: [
					'lib/cssparser.js'
				]
				dest: 'lib/cssparser.js'
		uglify:
			cssparser:
				options:
					banner: '<%= meta.banner %>'
				src: '<%= concat.cssparser.dest %>',
				dest: 'lib/cssparser.js'
			site:
				src: '<%= concat.cssparser.dest %>',
				dest: 'web/cssparser.js'
		copy:
			cssparser:
				src: 'lib/cssparser.js'
				dest: 'web/cssparser.js'
			site:
				src: 'web/cssparser.js'
				dest: '../cssparser-pages/cssparser.js'

		yuidoc:
			compile:
				name: "cssparser.js API"
				description: "cssparser.js JavaScript API documents"
				version: ".0.0"
				url: ""
				options:
					paths: "lib/"
					outdir: "doc/"
					themedir: "docs/yuidoc_theme"
					nocode: true
				
		global:
			gitSHA1 : 'git log -1 --format=format:"%H"'

		clean:
			all: 
				options:
					force: true
				src: [
					"lib/cssparser.js"
					"web/cssparser.js"
					"doc"
				]

	grunt.loadNpmTasks 'grunt-contrib-jshint'
	grunt.loadNpmTasks 'grunt-contrib-concat'
	grunt.loadNpmTasks 'grunt-contrib-uglify'
	grunt.loadNpmTasks 'grunt-contrib-copy'
	grunt.loadNpmTasks 'grunt-contrib-yuidoc'
	grunt.loadNpmTasks 'grunt-contrib-clean'
	
	# load the project's default tasks
	# grunt.loadTasks 'build/tasks'
	
	# get SHA1 of git.
	grunt.registerTask 'gitSHA1', 'git hashes for output', ->
		done = this.async()
		global = grunt.config.get( 'global' )
		child_process.exec global.gitSHA1, ( err, stdout, stderr ) ->
			global.gitSHA1 = stdout
			grunt.config.set( 'global', global )
			done();
			
	# build task
	grunt.registerTask 'build', 'build parser from jison', ->
		command = "jison src/cssparser.y src/css.l -o lib/cssparser.js"
		done = this.async()
		child_process.exec command, ( err, stdout, stderr ) ->
			done();
	
	# deploy
	grunt.registerTask 'deploy', 'deploy site', ->
		command = "cd ../cssparser-pages && git commit -a -m 'deploy site updates' && git push origin gh-pages"
		done = this.async()
		child_process.exec command, ( err, stdout, stderr ) ->
			done();
	
	# Default task.
	grunt.registerTask 'default', [
		'gitSHA1'
		'clean'
		'build'
		'concat'
		'copy:cssparser'
	]

	grunt.registerTask 'doc', [
		'default'
		'yuidoc'
	]
	
	grunt.registerTask 'release', [
		'default'
		'uglify:cssparser'
	]

	grunt.registerTask 'all', [
		'default'
		'yuidoc'
		'uglify:site'
		'copy:site'
		'deploy'
	]
