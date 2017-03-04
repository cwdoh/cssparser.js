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
            value: toJSON(this.get('value')),
            unit: toJSON(this.get('unit'))
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
            value: toJSON(this.get('value')),
            unit: toJSON(this.get('unit'))
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
            vendorPrefix: toJSON(this.get('vendorPrefix', '')),
            value: toJSON(this.get('value'))
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

    toJSON() {
        return {
            type: this.getType(),
            name: toJSON(this.get('name', null)),
            value: toJSON(this.get('value', null))
        }
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

class FunctionVal extends CSSObject {
    getType() {
        return 'FUNCTION'
    }

    toJSON() {
        return {
            type: this.getType(),
            name: toJSON(this.get('name')),
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
    constructor() {
        super()
        this.value = new Array()
    }

    getType() {
        return 'SEQUENCE'
    }

    add(value) {
        this.value.push(value)
        return this
    }

    toJSON() {
        return {
            type: this.getType(),
            value: this.get('value').map((o) => toJSON(o))
        }
    }

    static create(item) {
        return new SequenceVal().add(item)
    }
}
