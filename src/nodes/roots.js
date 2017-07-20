class CSSObject {
    constructor() {
        this._props_ = {}
    }

    static _options = {
        commaDelimiter: ',',
        whitespaceDelimiter: ' '
    }

    setOptions(customOptions) {
        CSSObject._options = mixin(this.options, customOptions)
    }

    get options() {
        return CSSObject._options
    }

    set options(customOptions) {
        console.warn('For beautify AST output, `setOptions()` method would be recommended instead of assigning directly.')
        this.setOptions(customOptions)
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

    toAtomicJSON() {
        var json = super.toAtomicJSON()
        json.level = 'atomic'

        return json
    }

    toDeepJSON() {
        var json = super.toDeepJSON()
        json.level = 'deep'

        return json
    }

    toSimpleJSON() {
        return {
            type: 'stylesheet',
            level: 'simple',
            value: toSimple(this.get('value', []))
        }
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
        var lhs = toSimple(this.get('lhs'))
        var operator = toSimple(this.get('operator'))
        var rhs = toSimple(this.get('rhs'))

        // for beautifying, added some spaces bewteen nodes
        return lhs + ' ' + operator + ' ' + rhs
    }

    static create(operator, lhs, rhs) {
        return new Expression()
            .set('operator', operator)
            .set('lhs', lhs)
            .set('rhs', rhs)
    }
}
