class CSSObject {
    getType(type) {
        return 'OBJECT'
    }

    set(key, value) {
        if (value || value == false || value == 0) {
            this[key] = value
        }
        return this
    }

    get(key, defaultValue) {
        if (key in this) {
            return this[key]
        }
        return defaultValue
    }

    toJSON() {
        return {
            type: this.getType(),
            value: toJSON(this.get('value'))
        }
    }


    static create(value) {
        return (new CSSObject()).set('value', value)
    }
}

class StyleSheet extends CSSObject {
    getType(type) {
        return 'STYLESHEET'
    }

    add(component) {
        if (!this.value) {
            this.value = []
        }

        if (component) {
            this.value.push(component)
        }

        return this
    }

    toJSON() {
        var json = []
        var components = this.get('value', [])

        return {
            type: this.getType(),
            value: components.map((o) => toJSON(o))
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

    toJSON() {
        var json = super.toJSON()
        json.nextExpression = toJSON(this.get('nextExpression', null))

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

    toJSON() {
        return {
            type: this.getType(),
            operator: this.get('operator'),
            lhs: toJSON(this.get('lhs')),
            rhs: toJSON(this.get('rhs'))
        }
    }

    static create(operator, lhs, rhs) {
        return new Expression()
            .set('operator', operator)
            .set('lhs', lhs)
            .set('rhs', rhs)
    }
}
