#!/usr/bin/env node

(function () {
	var cssparser  = require('./cssparser.js');
	var nomnom     = require('nomnom');
	var fs         = require('fs');
	var path       = require('path');
	
	var version = require('../package.json').version;
	
	var opts = require("nomnom")
	  .script('cssparser')
	  .option('file', {
	    flag: true,
	    position: 0,
	    help: 'CSS document file'
	  })
	  .option('outfile', {
	    abbr: 'o',
	    metavar: 'FILE',
	    help: 'Filename and base module name of the generated JSON'
	  })
	  .option('indent', {
	    abbr: 'i',
	    default: 0,
	    help: 'space count of indent-step'
	  })
	  .option('parsing-mode', {
	    abbr: 'm',
	    default: 'simple',
	    metavar: 'TYPE',
	    help: 'The type of JSON to generate (simple, deep, atomic)'
	  })
	  .option('console', {
	    abbr: 'c',
	    default: true,
	    help: 'to console'
	  })
	  .option('version', {
	    abbr: 'V',
	    flag: true,
	    help: 'print version and exit',
	    callback: function() {
	       return version;
	    }
	  })
	  .parse();
	  
	function toJSON( raw, mode, indent ) {
		var parser = new cssparser.Parser();
		
		return JSON.stringify( parser.parse( raw ), null, indent );
	}
	
    if (opts.file) {
        var raw = fs.readFileSync(path.normalize(opts.file), 'utf8');
        var name = path.basename((opts.outfile||opts.file)).replace(/\..*$/g,'');
        var mode = opts["parsing-mode"];
        var indent = opts.indent;
        var json = toJSON(raw, mode, indent);

        fs.writeFileSync(opts.outfile||(name + '.json'), json );
		if ( opts.console )
	        console.log( json );
    }
})();