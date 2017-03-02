class CSSObject {
    constructor(type) {
        this.type = type   
    }

    access(key, value) {
        if (key in this) {
            if (value) {
                this[key] = value
            }

            return this[key]
        }

        return null
    }

    value(value) {
        return access('value', value)
    }

    toObject() {
        return {
            type: this.type
        }
    }
}

class StyleSheet extends CSSObject {
    constructor(type) {
        super('STYLESHEET')
    }
}

class AtRule extends CSSObject {
    constructor() {
        super('AT_RULE')
    }

    rule(rule) {
        return access('rule', rule)
    }
}

class AtCharsetRule extends AtRule {
    constructor(rule, ) {
        super.rule()
    }
}

class String extends CSSObject {
    constructor() {
        super('STRING')
    }
}