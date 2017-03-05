class CSSObject {
    constructor() {
        this._props_ = {}
    }

    getType(type) {
        return 'OBJECT'
    }

    set(key, value) {
        if (value || value !== undefined) {
            this._props_[key] = value
        }
        return this
    }

    get(key, defaultValue) {
        if (key in this._props_) {
            return this._props_[key]
        }
        return defaultValue
    }

    add(component, prop) {
        prop = prop || 'value'

        if (component) {
            var source = this.get(prop, [])
            source.push(component)
            this.set(prop, source)
        }

        return this
    }

    toAtomicJSON() {
        var json = {
            type: this.getType()
        }

        var self = this
        Object.keys(this._props_).map((key) => {
            json[key] = toAtomic(this.get(key, null))
        })

        return json
    }

    toDeepJSON() {
        var json = {
            type: this.getType()
        }

        var self = this
        Object.keys(this._props_).map((key) => {
            json[key] = toDeep(this.get(key, null))
        })

        return json
    }

    toSimpleJSON() {
        return toSimple(this.get('value'))
    }

    toJSON(level) {
        switch(level) {
            case 'atomic':
                return toAtomic(this)
            case 'deep':
                return toDeep(this)
            case 'simple':
                return toSimple(this)
        }
    }

    static create(value) {
        return (new CSSObject()).set('value', value)
    }
}

class StyleSheet extends CSSObject {
    constructor() {
        super()
    }

    getType(type) {
        return 'STYLESHEET'
    }

    static create() {
        return new StyleSheet()
    }
}

class Operator extends CSSObject {
    getType() {
        return 'OPERATOR'
    }

    toSimpleJSON() {
        var json = toSimple(this.get('value'))
        var nextExpression = this.get('nextExpression')
        if (nextExpression) {
            json += ' '  + toSimple(nextExpression)
        }

        return json
    }

    static create(value) {
        return new Operator().set('value', value)
    }
}

class Expression extends CSSObject {
    getType() {
        return 'EXPRESSION'
    }

    toSimpleJSON() {
        return
            toSimple(this.get('lhs'))
            // for beautify
            + ' ' + toSimple(this.get('operator')) + ' '
            + toSimple(this.get('rhs'))
    }

    static create(operator, lhs, rhs) {
        return new Expression()
            .set('operator', operator)
            .set('lhs', lhs)
            .set('rhs', rhs)
    }
}
