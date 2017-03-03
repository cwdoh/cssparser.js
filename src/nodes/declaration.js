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

class Declaration extends CSSObject {
    getType() {
        return 'DECLARATION'
    }

    toJSON() {
        return {
            type: this.getType(),
            property: toJSON(this.get('property')),
            value:  toJSON(this.get('value')),
            important: this.get('important', false),
            ieOnlyHack: toJSON(this.get('ieOnlyHack', false))
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
