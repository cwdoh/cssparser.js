## Change log

* 0.9.4 - October 10th, 2017
    * Fixed missing space after attribute selector by #23, thanks @kauffecup
* 0.9.3 - July 20th, 2017
	* Fixed producing undefined for expression when using simple mode.
    * Supported IE hacks including `_PROPERTY` pattern.
* 0.9.2 - March 17th, 2017
	* Now supports beautify delimiter option for simple & deep type.
    * Showing version will be run lower-case 'v' instead 'V'.
    * Fixed missing keyframe name and added type & level descriptions for simple type.
    * Fixed EOF error case.
    * Added '-b' option for beautify delimiters.
* 0.9.1 - March 8th, 2017
	* Added 'rule' type on the css style node when simple mode. 
* 0.9.0 - March 5th, 2017
	* Fully rewrited parser.
	* Supports three modes such as simple, deep, atomic.
		* Also, simple mode produced different results instead of the format of previous version.
* 0.2.2 - July 27th, 2013
	* Add ratio type expression with '/'. thanks to Mohsen Heydari.
* 0.2.1 - May 21st, 2013
	* Update grunt, dependencies, cli options & output message.
	* Add 'keyframe' type at child node of keyframes.
* 0.2.0 - May 20th, 2013
	* Initial release of cssparser.js.
	