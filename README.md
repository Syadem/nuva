# Nuva data

YAML data for antigen types, diseases, valences and vaccines. English names live
in the base files. Additional languages (`fr`, `de`, `lv`, `gr`, `pl`) live in
`translations/<language>/<concept>/`.

## Validate the YAML

```sh
bundle install
bundle exec rspec
```

Currently the specs cover antigen types, valences, diseases, vaccines and their translations, following
`../vaccination_relevant_characteristics`. They check:

- Valid YAML, exact schemas and integer IDs matching `AGT-<id>.yml` and
  `VAL-<id>.yml`, `DIS-<id>.yml` and `VAC-<id>.yml` filenames.
- Nonempty English names and nonnegative integer Unix timestamps, with
  `updated_at >= created_at`.
- Unique IDs, existing parents and no cycles in the hierarchy.
- For valences: nonempty abbreviations, optional antigen type references to
  existing entries, and exactly one unique SYADEM UUID code.
- For diseases: unique integer valence references to existing entries and
  exactly one unique SYADEM UUID code.
- For vaccines: boolean `generic` and `immunoglobulin`, nullable descriptions,
  string-array `other_names`, integer references to existing valences, one unique
  SYADEM UUID code, and `injection_methods` restricted to `intramuscular`,
  `subcutaneous`, `intradermal`, `intranasal` and `oral`.
- One translation per entry in each supported language, with only `name` (and
  nullable `description` for vaccines). Diseases require nonempty names in every
  language. Vaccines and valences require nonempty names in English and French;
  their other translations accept `name:` (null). Antigen type translations
  also accept `name:` (null).
- Supported language directories and no orphan translation files.
