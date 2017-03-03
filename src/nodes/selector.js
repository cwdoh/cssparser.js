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

class PseudoClassSelector extends Selector {
    getType() {
        return 'PSEUDO_CLASS_SELECTOR'
    }

    static create(value) {
        return new PseudoClassSelector()
            .set('value', value)
    }
}

class PseudoElementSelector extends Selector {
    getType() {
        return 'PSEUDO_ELEMENT_SELECTOR'
    }

    static create(value) {
        return new PseudoElementSelector()
            .set('value', value)
    }
}

class AttributeSelector extends Selector {
    getType() {
        return 'ATTRIBUTE_SELECTOR'
    }

    static create(value) {
        return new AttributeSelector()
            .set('value', value)
    }
}
