const concat = function(l, r) {
    l = (l)? l : []
    r = (r)? r : []

    l = (l instanceof(Array))? l : [l]
    r = (r instanceof(Array))? r : [r]

    return l.concat(r)
}

const toJSON = (o) => {
    if (!o) {
        return null
    }
    return (o.hasOwnProperty('toJSON'))? o.toJSON() : o
}

class CSSObject {
    getType(type) {
        return 'OBJECT'
    }

    set(key, value) {
        if (value) {
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

class AtRule extends CSSObject {
    getType() {
        return 'AT_RULE'
    }

    rule(rule) {
        return set('rule', rule)
    }
}

class AtCharsetRule extends AtRule {
    getType(rule) {
        return 'AT_RULE'
    }
}

class StringVal extends CSSObject {
    getType() {
        return 'STRING'
    }

    static create(value) {
        return new StringVal().set('value', value)
    }
}

class PrimitiveVal extends CSSObject {
    getType() {
        return 'PRIMITIVE_VALUE'
    }

    toJSON() {
        return {
            type: this.getType(),
            value: this.get('value')
        }
    }
}

class NumberVal extends PrimitiveVal {
    getType() {
        return 'NUMBER'
    }

    static create(value) {
        return new NumberVal().set('value', value)
    }
}

class HashVal extends PrimitiveVal {
    getType() {
        return 'HASH'
    }

    static create(value) {
        return new HashVal().set('value', value)
    }
}

class PercentageVal extends PrimitiveVal {
    getType() {
        return 'PERCENTAGE'
    }

    toJSON() {
        return {
            type: this.getType(),
            value: this.get('value'),
            unit: this.get('unit')
        }
    }

    static create(value) {
        var result = value.match(/(([\+\-]?[0-9]+(\.[0-9]+)?)|([\+\-]?\.[0-9]+))([%])/)

        return new PercentageVal()
            .set('value', parseFloat(result[1]))
            .set('unit', result[5])
    }
}

class DimensionVal extends PrimitiveVal {
    getType() {
        return 'DIMENSION'
    }

    toJSON() {
        return {
            type: this.getType(),
            value: this.get('value'),
            unit: this.get('unit')
        }
    }

    static create(value) {
        var result = value.match(/(([\+\-]?[0-9]+(\.[0-9]+)?)|([\+\-]?\.[0-9]+))([a-zA-Z]+)/)

        return new DimensionVal()
            .set('value', parseFloat(result[1]))
            .set('unit', result[5])
    }
}

class IdentVal extends CSSObject {
    getType() {
        return 'ID'
    }

    toJSON() {
        return {
            type: this.getType(),
            vendorPrefix: this.get('vendorPrefix', ''),
            value: this.get('value')
        }
    }

    static create(value) {
        var result = value.match(/([-](webkit|moz|o|ms)[-])?([0-9a-zA-Z-]*)/)

        return new IdentVal()
            .set('vendorPrefix', result[1])
            .set('value', result[3])
    }
}

class UrlVal extends CSSObject {
    getType() {
        return 'URL'
    }

    static create(value) {
        return new UrlVal().set('value', value)
    }
}

class FunctionVal extends CSSObject {
    getType() {
        return 'FUNCTION'
    }

    toJSON() {
        return {
            type: this.getType(),
            name: this.get('name'),
            parameters:  toJSON(this.get('parameters'))
        }
    }

    static create(name, parameters) {
        return new FunctionVal()
            .set('name', name)
            .set('parameters', parameters)
    }
}

class SequenceVal extends CSSObject {
    getType() {
        return 'SEQUENCE'
    }

    toJSON() {
        return {
            type: this.getType(),
            value: this.get('value').map((o) => toJSON(o))
        }
    }

    static create(list) {
        if (typeof(list) == 'array' && list.length > 1){
            return new SequenceVal().set('value', list)
        }

        return list
    }
}

class Declaration extends CSSObject {
    getType() {
        return 'DECLARATION'
    }

    toJSON() {
        return {
            type: this.getType(),
            property: toJSON(this.get('property')),
            value:  toJSON(this.get('value')),
            important: this.get('important', false)
        }
    }

    static create(property, value) {
        return new Declaration()
            .set('property', property)
            .set('value', value)
    }
}

class DeclarationList extends CSSObject {
    getType() {
        return 'DECLARATION_LIST'
    }

    toJSON() {
        return {
            type: this.getType(),
            value: this.get('value').map((o) => toJSON(o))
        }
    }

    static create(value) {
        return new DeclarationList()
            // force value to array
            .set('value', concat(value, []))
    }
}

class QualifiedRule extends CSSObject {
    getType() {
        return 'QUALIFIED_RULE'
    }

    toJSON() {
        return {
            type: this.getType(),
            selectors: toJSON(this.get('selectors')),
            value: toJSON(this.get('value'))
        }
    }

    static create(value) {
        return new QualifiedRule()
            .set('value', value)
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


class Selector extends CSSObject {
    getType() {
        return 'SELECTOR'
    }

    toJSON() {
        return {
            type: this.getType(),
            value: toJSON(this.get('value')),
            nextSelector: toJSON(this.get('nextSelector'))
        }
    }
}

class SelectorList extends Selector {
    getType() {
        return 'SELECTOR_LIST'
    }

    add(rootSelector) {
        if (!this.value) {
            this.value = []
        }

        this.value.push(rootSelector)

        return this
    }

    toJSON() {
        return {
            type: this.getType(),
            value: this.get('value').map((o) => toJSON(o))
        }
    }

    static create(value) {
        return new SelectorList()
    }
}

class RootSelector extends Selector {
    getType() {
        return 'SELECTOR_ROOT'
    }

    toJSON() {
        return {
            type: this.getType(),
            value: toJSON(this.get('value'))
        }
    }

    static create(value) {
        return new RootSelector()
            .set('value', value)
    }
}

class SelectorCombinator extends Selector {
    getType() {
        return 'SELECTOR_COMBINATOR'
    }

    getRelation() {
        return 'UNKNOWN'
    }

    toJSON() {
        return {
            type: this.getType(),
            relation: this.getRelation(),
            value:  toJSON(this.get('value')),
            nextSelector: toJSON(this.get('nextSelector'))
        }
    }

    static create(value) {
        return new SelectorCombinator()
            .set('value', value)
    }
}

class DescendantSelectorCombinator extends SelectorCombinator {
    getRelation() {
        return 'DESCEDANT'
    }

    static create(value) {
        return new DescendantSelectorCombinator()
            .set('value', value)
    }
}

class ChildSelectorCombinator extends SelectorCombinator {
    getRelation() {
        return 'CHILD'
    }

    static create(value) {
        return new ChildSelectorCombinator()
            .set('value', value)
    }
}

class AdjacentSiblingSelectorCombinator extends SelectorCombinator {
    getRelation() {
        return 'ADJACENT_SIBLING'
    }

    static create(value) {
        return new AdjacentSiblingSelectorCombinator()
            .set('value', value)
    }
}

class SiblingSelectorCombinator extends SelectorCombinator {
    getRelation() {
        return 'SIBLING'
    }

    static create(value) {
        return new SiblingSelectorCombinator()
            .set('value', value)
    }
}

class ClassSelector extends Selector {
    getType() {
        return 'CLASS_SELECTOR'
    }

    static create(value) {
        return new ClassSelector()
            .set('value', value)
    }
}

class TypeSelector extends Selector {
    getType() {
        return 'TYPE_SELECTOR'
    }

    static create(value) {
        return new TypeSelector()
            .set('value', value)
    }
}

class IdSelector extends Selector {
    getType() {
        return 'ID_SELECTOR'
    }

    static create(value) {
        return new IdSelector()
            .set('value', value)
    }
}

class UniversalSelector extends Selector {
    getType() {
        return 'UNIVERSAL_SELECTOR'
    }

    static create(value) {
        return new UniversalSelector()
            .set('value', value)
    }
}
