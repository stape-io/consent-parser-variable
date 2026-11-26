# Consent Parser Variable for Google Tag Manager Server Container

Returns the consent state of a request in the server container. It decodes the Google Consent Mode `gcd` or `gcs` string, or reads the `consent_state` sent by the Data Tag. Decoding runs in the template, with no external requests.

## Consent sources

Pick the source in the **Consent Source** field:

- **Google Consent Mode gcd** (default): reads the `gcd` or `x-ga-gcd` Event Data, or the `gcd` query parameter. Returns the `default` and `update` state of `ad_storage`, `analytics_storage`, `ad_user_data` and `ad_personalization` (`granted`, `denied` or `-` when not set), plus `allow_ad_personalization_signals` (`true`, `false` or `null`) and `global_privacy_control` (`opted-out` or `null`). An invalid `gcd` returns `{"code": 400, "type": "error", "message": "invalid consent mode string"}`, and no `gcd` returns an empty object.
- **Data Tag consent_state**: reads the `consent_state` Event Data sent by the [Data Tag](https://github.com/stape-io/data-tag) with the **Add consent state** option on. Returns an object with each consent type as `granted`, `denied`, or `-` when not set.
- **Google Consent Mode gcs**: reads the `x-ga-gcs` Event Data or the `gcs` query parameter (e.g. `G110`). Returns an object with `ad_storage` and `analytics_storage` as `granted`, `denied`, or `-` when not set.
- **All sources**: returns an object with the `gcd`, `gcs` and `consent_state` keys, each holding that source's decoded object (an empty object when the source is not found).

## Return

The **Return** field picks the output format. It isn't available for **All sources**.

| Return | Google Consent Mode gcd | Data Tag consent_state and gcs |
|---|---|---|
| **Full output as object** (default for new variables) | `{query: {consent_string}, result: {...}}` | The source's object |
| **Full output as JSON string (legacy)** | The same data as a 4-space-indented JSON string, byte for byte what the Analytics Debugger API returned in earlier versions | The source's object, as with **Full output as object** |
| **Selected values** | See below | See below |

Variables saved before the **Return** field existed keep returning the legacy JSON string. New variables default to **Full output as object**.

### Selected values

**Selected values** returns only the values picked in the **Values** table. The values each source offers:

- **Google Consent Mode gcd**: `ad_storage`, `analytics_storage`, `ad_user_data`, `ad_personalization`, `allow_ad_personalization_signals`, `global_privacy_control`.
- **Data Tag consent_state**: `ad_storage`, `analytics_storage`, `ad_user_data`, `ad_personalization`, `functionality_storage`, `personalization_storage`, `security_storage`.
- **Google Consent Mode gcs**: `ad_storage`, `analytics_storage`.

The output type depends on how many values are picked:

| Values picked | Returns | Example |
|---|---|---|
| One | That value on its own | `'granted'` |
| Two or more | An object keyed by value name | `{ad_storage: 'granted', ad_user_data: 'denied'}` |

So adding a second row changes the variable's type from a single value to an object. Check triggers and tags that use the variable when you do.

For gcd, **gcd State** picks which state of each consent type is returned:

- **Effective** (default): the update state when it is `granted` or `denied`, otherwise the default state. This is the state Google tags apply.
- **Update** or **Default**: only that state.
- **Both**: an object with `default` and `update`, as in the full output.

It doesn't apply to `allow_ad_personalization_signals` and `global_privacy_control`.

A consent type the request doesn't contain returns `-`. When the source is not found, or the gcd is invalid, the output is an empty object, or the error object.

## Useful Resources:

- [Step-by-step guide on how to configure Consent Parser Variable](https://stape.io/blog/consent-parser-variable-for-google-tag-manager-server-container)

## Open Source

Consent Parser Variable for GTM Server Side is developed and maintained by [Stape Team](https://stape.io/) under the Apache 2.0 license.

### GTM Gallery Status
🟢 [Listed](https://tagmanager.google.com/gallery/#/owners/stape-io/templates/consent-parser-variable)
