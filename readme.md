# Github Docker Build Action

This action can be used to build & push docker image

## Example usage (Minimum)

```
- uses: webjet/action-build-image@v1
  with:
    image-name: 'flight-xxx'

```

## Example usage (Full)
```
- uses: webjet/action-build-image@v1
  with:
    image-name: 'flight-xxx'
    build-args: 'region=au,arg2=test'
    dockerfile-path: 'src/dockerfile'
    push: 'true'

### build-args (no space)
### dockerfile-path (if your dockerfile not in root path)
### push (push built image directly)
```