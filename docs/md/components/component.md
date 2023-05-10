# Components
Components are used to interact with the user. They contain [attributes](attributes.md), included components, [properties](properties.md) and [rules](rules.md).

## Syntax
```javascript
// Comment
COMPONENT name {  // Component name
    ATTRIBUTES {  // name type default (all mandatory, no null)
        attr_name attr_type(size) default_value; 
    }

    COMPONENTS {  // Included components name type
        comp_name comp_type;
    }

    PROPERTIES {  // Possible properties used for rendering/value
        on hover enabled;
    }

    RULES {  // Rule sequence of properties
        property -> sequence -> result;
    }
}
```

### Example
```typescript
// Definition of a checkbox component
COMPONENT checkbox

com checkbox {
    elements : {
        icon : img,     // The icon of the checkbox
        label : txt,    // The label of the checkbox
    },
    

    // Possible states and transitions
    states : {
        // Array of possible states of this component.
        use : [on, hover, focus, enabled, readonly, modified, visible],

        // State transitions. Initial state -> transition -> New state.
        trns : [
            // Switch from on to off to on by click or touch. Add modified state.
            on -> lclick|touch -> !on&modified,
            !on -> lclick|touch -> on&modified,

            on&focus -> key(space) -> !on&modified,
            !on&focus -> key(space) -> on&modified
        ]
    },

    // Value of the object according to states
    value : {
        on => @on|1,   // Default value of 1 if @on not specified   
        _ => @off|0  // Default value of 0 if @off not specified   
    }
    

}
```
