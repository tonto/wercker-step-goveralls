# wercker goveralls step

[![wercker status](https://app.wercker.com/status/5f86828180437545e3c8cd6131de2e3c/m "wercker status")](https://app.wercker.com/project/bykey/5f86828180437545e3c8cd6131de2e3c)

This [wercker](http://wercker.com) step runs [goveralls](https://github.com/mattn/goveralls)
to extract code coverage from your project and uploads it to [Coveralls](https://coveralls.io/).

## Usage

```yaml
box: google/golang
build:
  steps:
    - setup-go-workspace
    - golint
    - script:
        name: go build
        code: |
          go build ./...
    - script:
        name: go test
        code: |
          go test ./...
    - zhevron/goveralls:
        token: $COVERALLS_TOKEN
```

## Properties

Name     | Type   | Default                 | Description
-------- | ------ | ----------------------- | -------------------
token    | string |                         | Your Coveralls repository token.

## Changelog

### 1.1.0

- Resolve branch name if build is run as a detached head.

### 1.0.4

- Reverted old cover tool check as the new one was far too slow

### 1.0.3

- Simplified old cover tool check

### 1.0.2

- Removed manual exits on script end

### 1.0.1

- Debug release

### 1.0.0

- Initial release

## License

**wercker-step-goveralls** is licensed under the [MIT license](http://opensource.org/licenses/MIT).
See `LICENSE.md` for the full license.
