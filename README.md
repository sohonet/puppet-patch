# patch

## Table of Contents

1. [Description](#description)
1. [Usage - Configuration options and additional functionality](#usage)

## Description

Apply a [diff] using the [patch] command.

## Usage

```puppet
patch { 'patch vendor templates':
  target => '/opt/application/templates',
  source => file("${module_name}/vendor.patch"),
  strip  => 1,
}
```

[patch]: https://en.wikipedia.org/wiki/Patch_(Unix)
[diff]: https://en.wikipedia.org/wiki/Diff
