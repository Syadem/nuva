# Nuva data

YAML data for antigen types, diseases, valences and vaccines. English names live
in the base files. Additional languages (`fr`, `de`, `lv`, `gr`, `pl`) live in
`translations/<language>/<concept>/`.

## Validate the YAML

```sh
bundle install
bundle exec rspec
```

Currently the specs cover antigen types, valences and their translations, following
`../vaccination_relevant_characteristics`. They check:

- Valid YAML, exact schemas and integer IDs matching `AGT-<id>.yml` and
  `VAL-<id>.yml` filenames.
- Nonempty English names and nonnegative integer Unix timestamps, with
  `updated_at >= created_at`.
- Unique IDs, existing parents and no cycles in the hierarchy.
- For valences: nonempty abbreviations, optional antigen type references to
  existing entries, and exactly one unique SYADEM UUID code.
- One translation per entry in each supported language, with only `name`
  (string or null). Missing translations represented as `name:` are valid.
- Supported language directories and no orphan translation files.

Specs for diseases and vaccines will be added as their schemas and
imports are introduced.
