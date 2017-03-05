class MediaQueryList extends CSSObject {
    getType() {
        return 'MEDIA_QUERY_LIST'
    }

    toDeepJSON() {
        return this.toSimpleJSON()
    }

    toSimpleJSON() {
        return toSimple(this.get('value'))
    }

    static create() {
        return new MediaQueryList()
    }
}

class MediaQuery extends CSSObject {
    getType() {
        return 'MEDIA_QUERY'
    }

    toDeepJSON() {
        return this.toSimpleJSON()
    }

    toSimpleJSON() {
        var json = toSimple(this.get('mediaType'))

        var prefix = this.get('prefix')
        if (prefix) {
            json = toSimple(prefix) + ' ' + json
        }
        var nextExpression = this.get('nextExpression')
        if (nextExpression) {
            json += ' ' + toSimple(nextExpression)
        }

        return json
    }


    static create() {
        return new MediaQuery()
    }
}

class MediaQueryExpression extends CSSObject {
    getType() {
        return 'MEDIA_QUERY_EXPRESSION'
    }

    toDeepJSON() {
        return this.toSimpleJSON()
    }

    toSimpleJSON() {
        var expression = '(' + toSimple(this.get('mediaFeature'))

        var value = toSimple(this.get('value'))
        if (value) {
            expression += ': ' + value
        }

        expression += ')'

        var nextExpression = this.get('nextExpression')
        if (nextExpression) {
            expression += ' ' + toSimple(nextExpression)
        }

        return expression
    }

    static create(feature, value) {
        return new MediaQueryExpression()
            .set('mediaFeature', feature)
            .set('value', value)
    }
}
