# Field values for the G desk issue (Pip's feature_request.yml form)

Not filed. Alex files it, or says to.

The body is `fork/design/godot-g/upstream/issue-draft.md` as of commit `98d830aa`
(`98d830aa2b361c03028981f5453740bcacb40967`) on branch `design/ui-concepts` of
SwitchOCE/pdoom1. The file is not on `lean`.

| Form field | Value |
|---|---|
| Title | `[Feature]: G desk -- an optional, simpler main screen (playable build; PR on your OK)` |
| Problem or Motivation | the text under `### Problem or Motivation` in the draft |
| Proposed Solution | the text under `### Proposed Solution` |
| Alternatives Considered | the text under `### Alternatives Considered` |
| Category | User Interface |
| Contribution | [x] I would be willing to implement this feature |

## Default: the browser form

Open https://github.com/PipFoweraker/pdoom1/issues/new?template=feature_request.yml ,
put the title in, and paste each section of the draft (without its `###` heading) into its
field. Pick "User Interface" and tick the contribution box. The form adds the
`enhancement` label itself.

## Fallback: the command line

`gh` does not fill forms; the `###` headings in the body match what the form produces.
No `--label`: Pip can add it.

From any clone of the fork, in Git Bash:

```
git fetch https://github.com/SwitchOCE/pdoom1 design/ui-concepts
git show 98d830aa2b361c03028981f5453740bcacb40967:fork/design/godot-g/upstream/issue-draft.md > "$TEMP/g-issue-body.md"
gh issue create -R PipFoweraker/pdoom1 \
  --title "[Feature]: G desk -- an optional, simpler main screen (playable build; PR on your OK)" \
  --body-file "$TEMP/g-issue-body.md"
```

(On Linux use `/tmp` or any folder in place of `$TEMP`.)

After filing: send Pip `PDoom-G-desk-431ea001.zip`. It is not attached to the issue; the
issue says Alex can send it.
