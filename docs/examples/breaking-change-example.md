# Breaking Change Commit Example

Demonstrates a `BREAKING CHANGE` commit — triggers a **major** version bump.

## Commit format

```
perf(pencil): remove graphiteWidth option

BREAKING CHANGE: The graphiteWidth option has been removed.
The default graphite width of 10mm is always used for performance reasons.
```

## Version impact

`1.0.0` → `2.0.0`

## Note

The `BREAKING CHANGE:` token must appear in the commit footer, not the subject line.
