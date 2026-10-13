# Nuva data

YAML data for antigen types, diseases, valences and vaccines. English names live
in the base files. Additional languages (`fr`, `de`, `lv`, `gr`, `pl`) live in
`translations/<language>/<concept>/`.

## Validate the YAML

```sh
bundle install
bundle exec rspec
```

Currently the specs cover antigen types, valences, diseases and their translations, following
`../vaccination_relevant_characteristics`. They check:

- Valid YAML, exact schemas and integer IDs matching `AGT-<id>.yml` and
  `VAL-<id>.yml` and `DIS-<id>.yml` filenames.
- Nonempty English names and nonnegative integer Unix timestamps, with
  `updated_at >= created_at`.
- Unique IDs, existing parents and no cycles in the hierarchy.
- For valences: nonempty abbreviations, optional antigen type references to
  existing entries, and exactly one unique SYADEM UUID code.
- For diseases: unique integer valence references to existing entries and
  exactly one unique SYADEM UUID code.
- One translation per entry in each supported language, with only `name`.
  Disease names must be nonempty strings in every translation. Antigen type
  and valence translations also accept `name:` (null).
- Supported language directories and no orphan translation files.

Specs for vaccines will be added when their schema and import are introduced.
