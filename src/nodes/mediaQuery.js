class MediaQueryList extends CSSObject {
    getType() {
        return 'MEDIA_QUERY_LIST'
    }

    add(mediaQuery) {
        if (!this.value) {
            this.value = []
        }

        if (mediaQuery) {
            this.value.push(mediaQuery)
        }

        return this
    }

    toJSON() {
        return {
            type: this.getType(),
            value: this.get('value').map((o) => toJSON(o))
        }
    }

    static create() {
        return new MediaQueryList()
    }
}

class MediaQuery extends CSSObject {
    getType() {
        return 'MEDIA_QUERY'
    }

    toJSON() {
        return {
            type: this.getType(),
            mediaType: toJSON(this.get('mediaType', null)),
            prefix: toJSON(this.get('prefix', null)),
            nextExpression: toJSON(this.get('nextExpression', null))
        }
    }

    static create() {
        return new MediaQuery()
    }
}

class MediaQueryExpression extends CSSObject {
    getType() {
        return 'MEDIA_QUERY_EXPRESSION'
    }

    toJSON() {
        return {
            type: this.getType(),
            feature: toJSON(this.get('mediaFeature', null)),
            value: toJSON(this.get('value', null)),
            nextExpression: toJSON(this.get('nextExpression', null))
        }
    }

    static create(feature, value) {
        return new MediaQueryExpression()
            .set('mediaFeature', feature)
            .set('value', value)
    }
}
