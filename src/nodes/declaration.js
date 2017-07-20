class QualifiedRule extends CSSObject {
    getType() {
        return 'QUALIFIED_RULE'
    }

    toSimpleJSON() {
        return {
            type: 'rule',
            selectors: toSimple(this.get('selectors')),
            declarations: toSimple(this.get('value'))
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

    toSimpleJSON() {
        var json = {}
        var value = toSimple(this.get('value'))
        if (this.get('backslashHack', false)) {
            value += '\\9'
        }
        if (this.get('important', false)) {
            value += ' !important'
        }

        var property = toSimple(this.get('property'))
        if (this.get('asteriskHack', false)) {
            property = '*' + property
        }
        if (this.get('underscoreHack', false)) {
            property = '_' + property
        }
        json[property] = value

        return json
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

    toSimpleJSON() {
        var json = {}
        
        toSimple(this.get('value')).map((o) => {
            joinValues(json, o)
        })

        return json
    }

    static create(value) {
        return new DeclarationList()
            // force value to array
            .set('value', concat(value, []))
    }
}
