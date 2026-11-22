# Field values for the G desk issue (Pip's feature_request.yml form)

Not filed. Alex files it, or says to.

| Form field | Value |
|---|---|
| Title | `[Feature]: G desk -- an optional, simpler main screen (playable build; PR on your OK)` |
| Problem or Motivation | the text under `### Problem or Motivation` in `issue-draft.md` |
| Proposed Solution | the text under `### Proposed Solution` |
| Alternatives Considered | the text under `### Alternatives Considered` |
| Category | User Interface |
| Contribution | [x] I would be willing to implement this feature |
| Label | `enhancement` (the form adds it; from the command line it may need Pip's triage rights, and the issue files without it if refused) |

Filing in the browser: open the form at
https://github.com/PipFoweraker/pdoom1/issues/new?template=feature_request.yml and paste
each section of `issue-draft.md` (without its `###` heading) into its field.

Filing from the command line (gh does not fill forms; the `###` headings in the body
match what the form produces):

```
gh issue create -R PipFoweraker/pdoom1 \
  --title "[Feature]: G desk -- an optional, simpler main screen (playable build; PR on your OK)" \
  --label enhancement \
  --body-file fork/design/godot-g/upstream/issue-draft.md
```

After filing: send Pip `PDoom-G-desk-431ea001.zip` (it is not attached to the issue; the
issue says Alex can send it).
