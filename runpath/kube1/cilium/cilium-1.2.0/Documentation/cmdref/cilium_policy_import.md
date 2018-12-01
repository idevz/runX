<!-- This file was autogenerated via cilium cmdref, do not edit manually-->

## cilium policy import

Import security policy in JSON format

### Synopsis


Import security policy in JSON format

```
cilium policy import <path>
```

### Examples

```
  cilium policy import ~/policy.json
  cilium policy import ./policies/app/
```

### Options

```
  -o, --output string   json| jsonpath='{}'
      --print           Print policy after import
```

### Options inherited from parent commands

```
      --config string   config file (default is $HOME/.cilium.yaml)
  -D, --debug           Enable debug messages
  -H, --host string     URI to server-side API
```

### SEE ALSO
* [cilium policy](cilium_policy.html)	 - Manage security policies
