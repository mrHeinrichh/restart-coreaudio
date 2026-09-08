# Original-code provenance and validation

## Source

The author supplied a Desktop application named `Restart CoreAudio.app`. The script was taken from its `Contents/Resources/Scripts/main.scpt` resource on September 8, 2026.

- `original/main.scpt`: an unchanged copy of that compiled AppleScript.
- `src/restart-coreaudio.applescript`: readable output from macOS `osadecompile` applied to the original resource.

No command, handler, privilege request, or runtime behavior was changed during extraction. Decompiled text is a readable representation of the compiled script; it is not a claim to recover the author's exact pre-compilation formatting or comments.

The Apple-generated applet executable, icons, resources, bundle metadata, and code signature are excluded. Users can build a fresh application wrapper with Script Editor or `osacompile`, as documented in the README. This repository preserves the original program, not a byte-for-byte archive of the entire app bundle.

## Integrity

SHA-256 of `original/main.scpt`:

```text
67dad2cebdc1a8ffcf8862623f64b2f847c9c3e044b98ef457921ff2d576fa6b
```

Verify locally:

```sh
shasum -a 256 original/main.scpt
```

## Checks performed before publication

1. Compared the copied compiled script against the Desktop resource using `cmp`; they matched byte-for-byte.
2. Extracted and inspected the complete AppleScript source.
3. Compiled the readable source using `osacompile`; compilation succeeded.
4. Reviewed the source for embedded credentials, personal paths, and network operations; none are present in the extracted source.

These checks establish preservation and syntax validity. They do not establish runtime success, hardware compatibility, or recovery timing. The restart command was not executed during publication.

## Reproduce the syntax check without restarting audio

```sh
validation_dir=$(mktemp -d)
osacompile -o "$validation_dir/main.scpt" src/restart-coreaudio.applescript
osadecompile "$validation_dir/main.scpt"
```

Compilation and decompilation do not invoke the script's run handler. Compiled-file bytes can vary across compiler environments; compare decompiled behavior when reviewing a rebuilt script.

## Publication history

The repository was published incrementally, with a separate push for each commit: original code; README and usage; technical details and provenance; then open-source licensing and contribution guidance. Git history records the exact changes.
