# Factor vocabularies and commands useful for the command-line

## Directory Recursion
The `io.directories.search` vocabulary

```factor
USE: io.directories.search
"M:/" [ ".txt" tail? ] find-all-files
```

## Simple serialization
Use the prettiprinting vocabulary.

```factor
"saved.factor" utf8 [ ... ] with-file-writer
"saved.factor" parse-file call
```
