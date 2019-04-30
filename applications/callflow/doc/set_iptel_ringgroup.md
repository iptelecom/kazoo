## Set Variable

### About Set Variable

Sets a ringgroup variable on the current leg (useful in other callflow actions or stats_collector).

#### Schema

Validator for the set_iptel_ringgroup callflow data object



Key | Description | Type | Default | Required | Support Level
--- | ----------- | ---- | ------- | -------- | -------------
`channel` | Which channel to set the variable on | `string('a', 'both')` | `a` | `false` |  
`skip_module` | When set to true this callflow action is skipped, advancing to the wildcard branch (if any) | `boolean()` |   | `false` |  
`value` | The value to set 'ringgroup' to | `string()` |   | `false` | 


### Example

Example of the `flow` part of a callflow.

This ***NEEDS*** to be before the ringgroup definition. 
It is advised to reset this variable after the ringgroup, otherwise all AMQP messages will have this variable even after the ringgroup. 

```json
{
    "data": {
        {{... OMITTED ...}}
        "flow": {
            "module": "set_iptel_ringgroup",
            "data": {
                "value": "{{group_id}}",
                "channel": "both"
            },
            "children": {
                "_": {
                    "module": "ring_group",
                    "data": {
                        "timeout": 20,
                        "strategy": "simultaneous",
                        "repeats": 1,
                        "name": "",
                        "ignore_forward": true,
                        "endpoints": [
                            {
                                "endpoint_type": "user",
                                "id": "{{user_id1}}",
                                "delay": 0,
                                "timeout": 20
                            },
                            {
                                "endpoint_type": "user",
                                "id": "{{user_id2}}",
                                "delay": 0,
                                "timeout": 20
                            }
                        ]
                    },
                    "children": {
                        "_": {
                            "module": "set_iptel_ringgroup",
                            "data": {
                                "value": "false",
                                "channel": "both"
                            },
                            "children": {}
                        }
                    }
                }
            }
        },
        {{... OMITTED ...}}
    }
}
```
