const concat = function(l, r) {
    l = (l)? l : []
    r = (r)? r : []

    l = (l instanceof(Array))? l : [l]
    r = (r instanceof(Array))? r : [r]

    return l.concat(r)
}

const toJSON = (o) => {
    if (!o) {
        return o
    }

    return (o.hasOwnProperty('toJSON'))? o.toJSON() : o
}

