class AtRule extends CSSObject {
    getType() {
        return 'AT_RULE'
    }

    toJSON() {
        return {
            type: this.getType(),
            rule: toJSON(this.get('rule', null)),
            value: toJSON(this.get('value', null))
        }
    }
}

class AtCharset extends AtRule {
    static create(rule) {
        return new AtCharset().set('rule', rule)
    }
}

class AtImport extends AtRule {
    toJSON() {
        var json = super.toJSON()
        json.nextExpression = toJSON(this.get('nextExpression', null))

        return json
    }

    static create(rule) {
        return new AtImport().set('rule', rule)
    }
}

class AtNamespace extends AtRule {
    toJSON() {
        var json = super.toJSON()
        json.prefix = toJSON(this.get('prefix', null))

        return json
    }

    static create(rule) {
        return new AtNamespace().set('rule', rule)
    }
}

class AtFontface extends AtRule {
    static create(rule) {
        return new AtFontface().set('rule', rule)
    }
}

class AtNestedRule extends AtRule {
    toJSON() {
        var json = super.toJSON()
        json.nestedRules = toJSON(this.get('nestedRules', null))

        return json
    }
}

class AtMedia extends AtNestedRule {
    static create(rule) {
        return new AtMedia().set('rule', rule)
    }
}

class AtKeyframes extends CSSObject {
    toJSON() {
        var json = super.toJSON()

        json.name = toJSON(this.get('name'))
    }

    static create(rule) {
        return new AtKeyframes().set('rule', rule)
    }
}


class AtKeyframesBlockList extends CSSObject {
    getType(type) {
        return 'KEYFRAME_BLOCK_LIST'
    }

    add(block) {
        if (!this.value) {
            this.value = []
        }

        this.value.push(block)

        return this
    }

    toJSON() {
        return {
            type: this.getType(),
            value: this.get('value', []).map((o) => toJSON(o))
        }
    }

    static create(selector) {
        return new AtKeyframesBlockList()
    }
}

class AtKeyframesBlock extends CSSObject {
    getType(type) {
        return 'KEYFRAME_BLOCK'
    }

    toJSON() {
        var json = super.toJSON()
        json.selector = toJSON(this.get('selector', null))

        return json
    }

    static create(selector) {
        return new AtKeyframesBlock()
            .set('selector', selector)
    }
}

class AtSupport extends AtNestedRule {
    toJSON() {
        var json = super.toJSON()
        json.property = toJSON(this.get('property', null))
        json.operator = toJSON(this.get('operator', null))

        return json
    }

    static create(rule) {
        return new AtSupport().set('rule', rule)
    }
}

class AtSupportExpression extends CSSObject {
    getType(type) {
        return 'SUPPORT_EXPRESSION'
    }

    toJSON() {
        var json = super.toJSON()
        json.property = toJSON(this.get('property', null))
        json.operator = toJSON(this.get('operator', null))
        json.nextExpression = toJSON(this.get('nextExpression', null))

        return json
    }

    static create(selector) {
        return new AtSupportExpression()
    }
}

class AtPage extends AtNestedRule {
    static create(rule) {
        return new AtPage().set('rule', rule)
    }
}

class AtDocument extends AtNestedRule {
    static create(rule) {
        return new AtDocument().set('rule', rule)
    }
}
