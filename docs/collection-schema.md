# Collection JSON Schema

The app loads watch data entirely from JSON files. There are two types of files.

## `data/collections.json` — File list

A plain array of file paths (relative to project root). The app fetches every listed file at startup and reads the collection name from each file's `name` field.

To add a new collection: drop its JSON file in `data/` and append the path here.

```json
[
  "data/seiko-divers.json",
  "data/other-collection.json"
]
```

---

## Collection file

### Top-level fields

| Field        | Type   | Required | Description |
|--------------|--------|----------|-------------|
| `id`         | string | yes | Unique identifier, must match the manifest entry |
| `name`       | string | yes | Collection display name — rendered as the page title |
| `subtitle`   | string | no  | Secondary line shown below the title |
| `categories` | array  | yes | Category filter buttons; first entry must be `{ "id": "all", "label": "All" }` |
| `watches`    | array  | yes | Watch entries |

### `categories` item

| Field   | Type   | Description |
|---------|--------|-------------|
| `id`    | string | `"all"` or an arbitrary category slug |
| `label` | string | Button label |

### `watches` item

| Field              | Type    | Required | Description |
|--------------------|---------|----------|-------------|
| `cat`              | string  | yes | Category slug — must match a `categories[].id` value |
| `name`             | string  | yes | Model name |
| `sub`              | string  | yes | Spec summary string, segments separated by ` · ` (e.g. `"Cal. 6R54 · 72h · 42mm"`) |
| `refs`             | array   | yes | Reference numbers (e.g. `["SPB381", "SPB383"]`); each becomes a separate table row |
| `water_resistance` | integer | yes | Water resistance in metres (e.g. `200`, `300`, `600`) |
| `diameter`         | number  | yes | Case diameter in mm (e.g. `42`, `40.5`) |
| `gmt`              | boolean | yes | `true` if the watch has a GMT complication |
| `price`            | string  | yes | Display price string (e.g. `"~€950"`, `"—"` when unavailable) |
| `priceNote`        | string  | no  | Additional price context; newlines are rendered as line breaks |

### Water resistance colour coding

The UI derives the badge colour automatically from the `water_resistance` value:

| Range   | Colour |
|---------|--------|
| ≥ 600 m | purple `#e879f9` |
| ≥ 300 m | green `#4ade80` |
| < 300 m | blue `#60a5fa` |

---

## Images

Images live under `images/<ref>/` where `<ref>` is the reference number **lowercased**.

| Filename      | Description       | Required |
|---------------|-------------------|----------|
| `front.*`     | Front / dial view | yes |
| `profile.*`   | Side profile view | no  |

Extensions are tried in order: `.jpg` → `.png` → `.webp`. A placeholder icon is shown when no image is found.

---

## Minimal example

```json
{
  "id": "my-collection",
  "name": "My Watch Collection",
  "subtitle": "Optional subtitle",
  "categories": [
    { "id": "all",   "label": "All" },
    { "id": "sport", "label": "Sport" }
  ],
  "watches": [
    {
      "cat": "sport",
      "name": "Diver Pro 300",
      "sub": "Cal. XYZ · 48h · 42mm",
      "refs": ["ABC123", "ABC124"],
      "water_resistance": 300,
      "diameter": 42,
      "gmt": false,
      "price": "~€800",
      "priceNote": ""
    }
  ]
}
```
