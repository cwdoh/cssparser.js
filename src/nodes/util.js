const concat = function(l, r) {
    l = (l)? l : []
    r = (r)? r : []

    l = (l instanceof(Array))? l : [l]
    r = (r instanceof(Array))? r : [r]

    return l.concat(r)
}

const stripFalsy = (o) => {
    for (var k in o) {
        if (!o[k]) {
            delete o[k]
        }
    }

    return o
}

const join = function(o, delimiter) {
    if (isArray(o)) {
        return o.join(delimiter)
    }

    return o
}

const joinValues = (target, source) => {
    for (var prop in source) {
        if (prop in target) {
            target[prop] = concat(target[prop], source[prop])
        } else {
            target[prop] = source[prop]
        }
    }

    return target
}

const mixin = (target, source) => {
    var result = {}

    for (var prop in target) {
        result[prop] = target[prop]
    }

    for (var prop in source) {
        result[prop] = source[prop]
    }

    return result
}

const isArray = (o) => Object.prototype.toString.call(o) === '[object Array]'

const toAtomic = (o) => {
    if (o instanceof CSSObject) {
        return o.toAtomicJSON()
    }
    else if (isArray(o)) {
        return o.map((item) => toAtomic(item))
    }

    return o
}

const toDeep = (o) => {
    if (o instanceof CSSObject) {
        return o.toDeepJSON()
    }
    else if (isArray(o)) {
        return o.map((item) => toDeep(item))
    }

    return o
}

const toSimple = (o) => {
    if (o instanceof CSSObject) {
        return o.toSimpleJSON()
    }
    else if (isArray(o)) {
        return o.map((item) => toSimple(item))
    }

    return o
}

const toJSON = (o, level) => {
    level = level.toLowerCase()

    if (!o) {
        return o
    }

    switch(level) {
        case 'atomic':
            return toAtomic(o)
        case 'deep':
            return toDeep(o)
        case 'simple':
            return toSimple(o)
    }

    return o;
}

