# Installation in OSX

```
brew install libressl
sh -c "$(curl --proto '=https' --tlsv1.2 -sSf https://raw.githubusercontent.com/ponylang/ponyup/latest-release/ponyup-init.sh)"
```

Add the pony path to the environment:

```
#!/bin/bash

export PATH=<YOUR-HOME-PATH>/.local/share/ponyup/bin:$PATH
```


Update Pony to have a release version.

```
ponyup update ponyc release
```

# Making something bigger than a ToyExample

If you want to play with other libraries, install the package manager
`corral`

```
ponyup update corral release
```

Make sure to init the corral project with:

```
corral init
```

Add packages with:

```
corral add github.com/ponylang/net_ssl.git
```

Fetch packages with:

```
corral fetch
```

Run project with dependencies:

```
corral run -- ponyc
```
