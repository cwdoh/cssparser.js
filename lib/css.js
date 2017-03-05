const _ = require('lodash')
var root = {}

const _copyProp = function(o, s, prop, defaultVal) {
    let propVal = _.get(s, prop, defaultVal)

    if (propVal) {
        _.set(o, prop, propVal)
    }
}

const _initObj = function(o, s) {
    return _copyProp({}, s, 'type')
}

const atCharSet = function(source) {
    var obj = _initObj(source, t)

    _copyProp(obj, source, 'rule')
    _.set(obj, 'value', getVal(t.value))
}

const mediaQueries = function(source, t) {

}

const mediaQuery = function(source, t) {

    if ('expressions' in o) {

    }
}

const mediaQueryExpression = function(source, t) {

}

const declarations = function(source, t) {
    _.forEach(source, (o) => {

    })
}

const declaration =  = function(source, t) {
    var object = {}

    _copyProp(object, source, 'type', 'UNKNOWN')
    _copyProp(object, source, 'property', 'UNKNOWN')
    _copyProp(object, source, 'type', 'UNKNOWN')
}

const demensions = function(source, t) {

}

const demension = function(source, t) {

}

const _function = function(source, t) {
    var object = {}

    _copyProp(object, source, 'type', 'UNKNOWN')
    _copyProp(object, source, 'name')
    _.set(object,
        'parameters',
        _.map(_.get(source, 'parameters', []), (o) => o.fullQuailfied || o.value)
    )
}