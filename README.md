# NUVA

### A shared vocabulary for understanding vaccines.

Vaccination records use different product names, languages, and coding systems. **NUVA** is a collaborative project that brings vaccines, valences, diseases, and antigen types together in a structured nomenclature—giving contributors and developers a common language to describe vaccines and connect vaccination data across systems.

[**Open the admin interface →**](https://admin.nuva.syadem.com/) · [**Explore the full changelog →**](https://syadem.github.io/nuva/)

---

## Shared knowledge, ready to connect

NUVA brings together a collaboratively maintained vocabulary, multilingual content, and structured data designed for integration into software.

The nomenclature is maintained in **YAML**, a popular, easy-to-read format that makes the data straightforward to review and edit.

| | What NUVA offers |
| --- | --- |
| 🤝 **Collaborative by design** | A shared repository for maintaining and improving vaccine knowledge. |
| 🔗 **Connected to external nomenclatures** | Code mappings connect vaccine entries to other nomenclatures, supporting interoperability across systems. |
| ✨ **Approachable administration** | A user-friendly interface connected directly to this GitHub repository. |
| 🌍 **Six languages, with room to grow** | English, French, German, Greek, Latvian, and Polish, with the possibility of adding more. |
| 📖 **A traceable history** | A complete changelog makes it easy to follow the evolution of the nomenclature. |
| 🛠️ **Built for integration** | Structured data connects vaccines, their valences, target diseases, and antigen types for use in applications. |

## Contribute through a friendly interface

The [NUVA administration interface](https://admin.nuva.syadem.com/) provides an accessible way to work with the nomenclature, backed by this GitHub repository. It brings a friendly editing experience to a collaborative, version-controlled project.

Want to improve a vaccine entry, suggest a code mapping, or help extend language coverage? Contribute through the admin interface.

## One vocabulary, multiple languages

NUVA supports **English, French, German, Greek, Latvian, and Polish**. Contributors can help complete and improve translations through the admin interface. Additional languages can be added as the project and its community grow, helping the same shared vocabulary serve more people and applications.

## From shared data to your application

NUVA connects vaccine products to generic vaccines. Generic vaccines reference valences, which connect to target diseases and antigen types. This shared structure lets applications work with individual vaccine entries and the concepts behind them.

Code mappings to external nomenclatures help connect NUVA entries with the terminology already used in other systems.

### Vaccine data structure

Each vaccine is stored in `vaccines/VAC-<id>.yml`, with a positive integer `id`.
The `generic` boolean determines which fields are required:

| Field | Generic vaccine (`generic: true`) | Non-generic vaccine (`generic: false`) |
| --- | --- | --- |
| `valence_ids` | Required array of unique positive integer valence IDs | Must be absent |
| `generic_vaccine_id` | Must be absent | Required positive integer vaccine ID |
| `immunoglobulin` | Required boolean | Must be absent; resolved through the generic vaccine |

Every `valence_ids` entry references an existing `valences/VAL-<id>.yml` file.
The `generic_vaccine_id` references an existing `vaccines/VAC-<id>.yml` file
whose `generic` value is `true`. A vaccine cannot reference itself.
Forbidden fields must be omitted entirely, including when their value would be null
or an empty array.

For example, the relationship fields for a generic vaccine are:

```yaml
id: 345
generic: true
immunoglobulin: false
valence_ids:
- 156
```

A non-generic vaccine referring to it has these relationship fields:

```yaml
id: 1
generic: false
generic_vaccine_id: 345
```

Applications resolve a non-generic vaccine's valences and `immunoglobulin` value
through its generic vaccine.
During import from Apollon, a generic vaccine's `immunoglobulin` is set to `true`
if it or any of its associated non-generic vaccines has a source value of `true`;
it is `false` only when all these source values are `false`.
Disease-to-valence relationships continue to use `valence_ids` directly.
The other vaccine fields and translation files follow the same rules for both
vaccine types. The complete data contract is checked by `spec/vaccines_spec.rb`
with `bundle exec rspec`.

## Follow every change

The nomenclature evolves as contributions are made. Browse the [complete changelog](https://syadem.github.io/nuva/) to explore its history and keep track of updates.
