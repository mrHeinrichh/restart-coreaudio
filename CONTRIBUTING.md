# Contributing

Bug reports, clearer documentation, and focused improvements are welcome.

## Report an issue

Use the repository's GitHub Issues page. Include:

- Mac model and chip family, plus the macOS version.
- Audio device and connection type (built-in, USB, Bluetooth, or other).
- What stopped working, what triggered it, and whether other applications were affected.
- Whether authorization succeeded and the exact error message, if any.
- Whether this workaround restored audio and whether the issue returned.

Do not include passwords, serial numbers, or an unfiltered process list. Check diagnostic output for private information before posting it. A successful workaround is useful evidence, but does not identify the root cause by itself.

## Propose a change

1. Fork the repository and create a branch for one focused change.
2. Edit the readable source or documentation. Keep `original/main.scpt` unchanged as the historical reference.
3. Explain the problem, the resulting behavior, and how you checked it.
4. Update usage and technical documentation if behavior changes.
5. Open a pull request with small, descriptive commits.

Avoid including generated application bundles, signing materials, credentials, or unrelated files. New source behavior should be clearly distinguished from the archived original.

## Validate

For documentation, verify commands, relative links, and claims against the source. For code, compile without executing first:

```sh
validation_dir=$(mktemp -d)
osacompile -o "$validation_dir/main.scpt" src/restart-coreaudio.applescript
osadecompile "$validation_dir/main.scpt"
```

If you choose to test runtime behavior, stop active audio sessions first. Record the macOS version, hardware, authorization result, and observed recovery. Never describe compilation alone as a successful audio-recovery test. Avoid automatic tests that restart a contributor's audio service.

Contributions are provided under this project's MIT License.
