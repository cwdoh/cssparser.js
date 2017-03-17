class AtRule extends CSSObject {
    getType() {
        return 'AT_RULE'
    }

    toSimpleJSON() {
        return {
            type: '@' + toSimple(this.get('rule')),
            value: toSimple(this.get('value'))
        }
    }

    setRule(rule) {
        const regexp = /@(.+)/
        var result = rule.match(regexp)

        if (result) {
            var identVal = IdentVal.create(result[1])
            identVal.set('prefix', '@')
            this.set('rule', identVal)
        }

        return this
    }
}

class AtCharset extends AtRule {
    static create(rule) {
        return new AtCharset().setRule(rule)
    }
}

class AtImport extends AtRule {
    toSimpleJSON() {
        return joinValues(super.toSimpleJSON(), {
            mediaQuery: toSimple(this.get('nextExpression'))
        })
    }
    
    static create(rule) {
        return new AtImport().setRule(rule)
    }
}

class AtNamespace extends AtRule {
    toSimpleJSON() {
        return joinValues(super.toSimpleJSON(), {
            prefix: toSimple(this.get('prefix'))
        })
    }
    static create(rule) {
        return new AtNamespace().setRule(rule)
    }
}

class AtFontface extends AtRule {
    static create(rule) {
        return new AtFontface().setRule(rule)
    }
}

class AtNestedRule extends AtRule {
    toSimpleJSON() {
        return joinValues(super.toSimpleJSON(), {
            nestedRules: toSimple(this.get('nestedRules'))
        })
    }
}

class AtMedia extends AtNestedRule {
    static create(rule) {
        return new AtMedia().setRule(rule)
    }
}

class AtKeyframes extends AtRule {
    toSimpleJSON() {
        return {
            type: '@' + toSimple(this.get('rule')),
            name: toSimple(this.get('name')),
            keyframes: toSimple(this.get('value'))
        }
    }

    static create(rule) {
        return new AtKeyframes().setRule(rule)
    }
}


class AtKeyframesBlockList extends CSSObject {
    getType(type) {
        return 'KEYFRAME_BLOCK_LIST'
    }

    toSimpleJSON() {
        var json = {}
        toSimple(this.get('value')).map((o) => {
            joinValues(json, o)
        })

        return json
    }

    static create() {
        return new AtKeyframesBlockList()
    }
}

class AtKeyframesBlock extends CSSObject {
    getType(type) {
        return 'KEYFRAME_BLOCK'
    }

    toSimpleJSON() {
        var json = {}
        json[toSimple(this.get('selector'))] = toSimple(this.get('value'))
        
        return json
    }

    static create(selector) {
        return new AtKeyframesBlock()
            .set('selector', selector)
    }
}

class AtSupport extends AtNestedRule {
    static create(rule) {
        return new AtSupport().setRule(rule)
    }
}

class AtSupportExpression extends CSSObject {
    getType(type) {
        return 'SUPPORT_EXPRESSION'
    }

    static create(selector) {
        return new AtSupportExpression()
    }
}

class AtPage extends AtNestedRule {
    static create(rule) {
        return new AtPage().setRule(rule)
    }
}

class AtDocument extends AtNestedRule {
    static create(rule) {
        return new AtDocument().setRule(rule)
    }
}
