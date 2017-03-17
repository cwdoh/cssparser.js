class PrimitiveVal extends CSSObject {
    getType() {
        return 'PRIMITIVE_VALUE'
    }

    toDeepJSON() {
        return this.toSimpleJSON()
    }

    toSimpleJSON() {
        return this.get('value')
    }
}

class NumberVal extends PrimitiveVal {
    getType() {
        return 'NUMBER'
    }

    static create(value) {
        return new NumberVal().set('value', parseFloat(value))
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

class UnitVal extends PrimitiveVal {
    toSimpleJSON() {
        return this.get('value') + this.get('unit', '')
    }
}

class StringVal extends UnitVal {
    getType() {
        return 'STRING'
    }

    static create(value) {
        return new StringVal().set('value', value)
    }
}

class PercentageVal extends UnitVal {
    getType() {
        return 'PERCENTAGE'
    }

    static create(value) {
        var result = value.match(/(([\+\-]?[0-9]+(\.[0-9]+)?)|([\+\-]?\.[0-9]+))([%])/)

        return new PercentageVal()
            .set('value', parseFloat(result[1]))
            .set('unit', result[5])
    }
}

class DimensionVal extends UnitVal {
    getType() {
        return 'DIMENSION'
    }

    static create(value) {
        var result = value.match(/(([\+\-]?[0-9]+(\.[0-9]+)?)|([\+\-]?\.[0-9]+))([a-zA-Z]+)/)

        return new DimensionVal()
            .set('value', parseFloat(result[1]))
            .set('unit', result[5])
    }
}

class IdentVal extends PrimitiveVal {
    getType() {
        return 'ID'
    }

    toDeepJSON() {
        return this.toSimpleJSON()
    }

    toSimpleJSON() {
        return toSimple(this.get('vendorPrefix', '')) + toSimple(this.get('value'))
    }

    static create(value) {
        var result = value.match(/([-](webkit|moz|o|ms)[-])?([0-9a-zA-Z-]*)/)

        return new IdentVal()
            .set('vendorPrefix', result[1])
            .set('value', result[3])
    }
}

class UrlVal extends PrimitiveVal {
    getType() {
        return 'URL'
    }

    toSimpleJSON() {
        return toSimple(this.get('name')) + '(' + toSimple(this.get('value')) + ')'
    }

    static create(value) {
        var urlVal = new UrlVal()
        var result = value.match(/([0-9a-zA-Z\-]+)\((.+)\)/)

        if (result) {
            urlVal.set('name', IdentVal.create(result[1].trim()))
            urlVal.set('value', result[2].trim())
        }
        return urlVal
    }
}

class FunctionVal extends PrimitiveVal {
    getType() {
        return 'FUNCTION'
    }

    toSimpleJSON() {
        return toSimple(this.get('name'))
            + '('
            + join(toSimple(this.get('parameters')), this.options.commaDelimiter)
            + ')'
    }

    static create(name, parameters) {
        return new FunctionVal()
            .set('name', name)
            .set('parameters', parameters)
    }
}

class SequenceVal extends PrimitiveVal {
    getType() {
        return 'SEQUENCE'
    }

    toDeepJSON() {
        return {
            type: this.getType(),
            value: toSimple(this.get('value', []))
        }
    }

    toSimpleJSON() {
        return toSimple(this.get('value', [])).join(this.options.whitespaceDelimiter)
    }

    static create(item) {
        return new SequenceVal().add(item)
    }
}
