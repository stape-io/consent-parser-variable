___TERMS_OF_SERVICE___

By creating or modifying this file you agree to Google Tag Manager's Community
Template Gallery Developer Terms of Service available at
https://developers.google.com/tag-manager/gallery-tos (or such other URL as
Google may provide), as modified from time to time.


___INFO___

{
  "type": "MACRO",
  "id": "cvt_temp_public_id",
  "version": 1,
  "securityGroups": [],
  "displayName": "Consent Parser",
  "description": "Returns the consent state of the request, decoded from the Google Consent Mode gcs (GCM v1) or gcd (GCM v2) string or from the Data Tag consent_state object.",
  "containerContexts": [
    "SERVER"
  ]
}


___TEMPLATE_PARAMETERS___

[
  {
    "type": "SELECT",
    "name": "consentSource",
    "displayName": "Consent Source",
    "macrosInSelect": false,
    "selectItems": [
      {
        "value": "gcd",
        "displayValue": "Google Consent Mode gcd (Event Data gcd or x-ga-gcd, or gcd query parameter)"
      },
      {
        "value": "consent_state",
        "displayValue": "Data Tag consent_state (Event Data)"
      },
      {
        "value": "gcs",
        "displayValue": "Google Consent Mode gcs (Event Data x-ga-gcs, or gcs query parameter)"
      },
      {
        "value": "all",
        "displayValue": "All sources"
      }
    ],
    "simpleValueType": true,
    "defaultValue": "gcd",
    "alwaysInSummary": true,
    "help": "Where the consent state is read from. Every source is decoded in the template, with no external requests.<br/><br/><b>Google Consent Mode gcd</b>: the <i>gcd</i> string Google tags send, read from the <i>gcd</i> or <i>x-ga-gcd</i> Event Data or the <i>gcd</i> query parameter. Returns the <i>default</i> and <i>update</i> state of <i>ad_storage</i>, <i>analytics_storage</i>, <i>ad_user_data</i> and <i>ad_personalization</i> (<i>granted</i>, <i>denied</i>, or <i>-</i> when not set), plus <i>allow_ad_personalization_signals</i> and <i>global_privacy_control</i>. <i>Return</i> picks whether this comes as an object, as the JSON string earlier versions of this variable returned, or as selected values only. Returns an error object for an invalid gcd and an empty object when no gcd is found.<br/><br/><b>Data Tag consent_state</b>: the <i>consent_state</i> Event Data sent by the Data Tag with the <i>Add consent state</i> option on. Returns an object with each consent type it holds as <i>granted</i>, <i>denied</i>, or <i>-</i> when not set.<br/><br/><b>Google Consent Mode gcs</b>: the <i>gcs</i> string Google tags send (e.g. <i>G110</i>), read from the <i>x-ga-gcs</i> Event Data or the <i>gcs</i> query parameter. Returns an object with <i>ad_storage</i> and <i>analytics_storage</i> as <i>granted</i>, <i>denied</i>, or <i>-</i> when not set.<br/><br/><b>All sources</b>: returns an object with the <i>gcd</i>, <i>gcs</i> and <i>consent_state</i> keys, each holding that source's decoded object (an empty object when the source is not found)."
  },
  {
    "type": "RADIO",
    "name": "returnMode",
    "displayName": "Return",
    "radioItems": [
      {
        "value": "object",
        "displayValue": "Full output as object",
        "help": "The full output of the source as an object. For gcd: <i>{query: {consent_string}, result: {...}}</i>."
      },
      {
        "value": "string",
        "displayValue": "Full output as JSON string (legacy)",
        "help": "For gcd, the full output as the 4-space indented JSON string earlier versions of this variable returned. Variables created before this option existed keep returning it. For the Data Tag and gcs sources, this returns the same object as <i>Full output as object</i>."
      },
      {
        "value": "selected",
        "displayValue": "Selected values",
        "help": "Only the values picked in the table.<br/><br/><b>One value</b> returns that value on its own (e.g. <i>granted</i>), so the variable can be used directly in a trigger condition such as <i>equals granted</i>.<br/><br/><b>Two or more values</b> return an object keyed by value name, e.g. <i>{ad_storage: 'granted', ad_user_data: 'denied'}</i>. Adding a second row therefore changes the variable's type from a single value to an object.<br/><br/>A consent type the request doesn't contain returns <i>-</i>. When the source is not found, or the gcd is invalid, the output is an empty object, or the error object.",
        "subParams": [
          {
            "type": "SIMPLE_TABLE",
            "name": "gcdValues",
            "displayName": "Values",
            "simpleTableColumns": [
              {
                "defaultValue": "",
                "displayName": "Consent value",
                "name": "consentValue",
                "type": "SELECT",
                "macrosInSelect": false,
                "selectItems": [
                  {
                    "value": "ad_storage",
                    "displayValue": "ad_storage"
                  },
                  {
                    "value": "analytics_storage",
                    "displayValue": "analytics_storage"
                  },
                  {
                    "value": "ad_user_data",
                    "displayValue": "ad_user_data"
                  },
                  {
                    "value": "ad_personalization",
                    "displayValue": "ad_personalization"
                  },
                  {
                    "value": "allow_ad_personalization_signals",
                    "displayValue": "allow_ad_personalization_signals"
                  },
                  {
                    "value": "global_privacy_control",
                    "displayValue": "global_privacy_control"
                  }
                ],
                "isUnique": true,
                "valueValidators": [
                  {
                    "type": "NON_EMPTY"
                  }
                ]
              }
            ],
            "newRowButtonText": "Add value",
            "valueValidators": [
              {
                "type": "NON_EMPTY"
              }
            ],
            "enablingConditions": [
              {
                "paramName": "consentSource",
                "paramValue": "gcd",
                "type": "EQUALS"
              }
            ]
          },
          {
            "type": "SELECT",
            "name": "gcdState",
            "displayName": "gcd State",
            "macrosInSelect": false,
            "selectItems": [
              {
                "value": "effective",
                "displayValue": "Effective (update, otherwise default)"
              },
              {
                "value": "update",
                "displayValue": "Update"
              },
              {
                "value": "default",
                "displayValue": "Default"
              },
              {
                "value": "both",
                "displayValue": "Both (default and update)"
              }
            ],
            "simpleValueType": true,
            "defaultValue": "effective",
            "help": "Which state of each consent type to return.<br/><br/><b>Effective</b>: the update state when it is <i>granted</i> or <i>denied</i>, otherwise the default state. This is the state Google tags apply.<br/><b>Update</b> or <b>Default</b>: only that state.<br/><b>Both</b>: an object with <i>default</i> and <i>update</i>, as in the full output.<br/><br/>Doesn't apply to <i>allow_ad_personalization_signals</i> and <i>global_privacy_control</i>.",
            "enablingConditions": [
              {
                "paramName": "consentSource",
                "paramValue": "gcd",
                "type": "EQUALS"
              }
            ]
          },
          {
            "type": "SIMPLE_TABLE",
            "name": "gcsValues",
            "displayName": "Values",
            "simpleTableColumns": [
              {
                "defaultValue": "",
                "displayName": "Consent value",
                "name": "consentValue",
                "type": "SELECT",
                "macrosInSelect": false,
                "selectItems": [
                  {
                    "value": "ad_storage",
                    "displayValue": "ad_storage"
                  },
                  {
                    "value": "analytics_storage",
                    "displayValue": "analytics_storage"
                  }
                ],
                "isUnique": true,
                "valueValidators": [
                  {
                    "type": "NON_EMPTY"
                  }
                ]
              }
            ],
            "newRowButtonText": "Add value",
            "valueValidators": [
              {
                "type": "NON_EMPTY"
              }
            ],
            "enablingConditions": [
              {
                "paramName": "consentSource",
                "paramValue": "gcs",
                "type": "EQUALS"
              }
            ]
          },
          {
            "type": "SIMPLE_TABLE",
            "name": "consentStateValues",
            "displayName": "Values",
            "simpleTableColumns": [
              {
                "defaultValue": "",
                "displayName": "Consent value",
                "name": "consentValue",
                "type": "SELECT",
                "macrosInSelect": false,
                "selectItems": [
                  {
                    "value": "ad_storage",
                    "displayValue": "ad_storage"
                  },
                  {
                    "value": "analytics_storage",
                    "displayValue": "analytics_storage"
                  },
                  {
                    "value": "ad_user_data",
                    "displayValue": "ad_user_data"
                  },
                  {
                    "value": "ad_personalization",
                    "displayValue": "ad_personalization"
                  },
                  {
                    "value": "functionality_storage",
                    "displayValue": "functionality_storage"
                  },
                  {
                    "value": "personalization_storage",
                    "displayValue": "personalization_storage"
                  },
                  {
                    "value": "security_storage",
                    "displayValue": "security_storage"
                  }
                ],
                "isUnique": true,
                "valueValidators": [
                  {
                    "type": "NON_EMPTY"
                  }
                ]
              }
            ],
            "newRowButtonText": "Add value",
            "valueValidators": [
              {
                "type": "NON_EMPTY"
              }
            ],
            "enablingConditions": [
              {
                "paramName": "consentSource",
                "paramValue": "consent_state",
                "type": "EQUALS"
              }
            ]
          }
        ]
      }
    ],
    "simpleValueType": true,
    "defaultValue": "object",
    "enablingConditions": [
      {
        "paramName": "consentSource",
        "paramValue": "all",
        "type": "NOT_EQUALS"
      }
    ]
  }
]


___SANDBOXED_JS_FOR_SERVER___

const getEventData = require('getEventData');
const getRequestQueryParameter = require('getRequestQueryParameter');
const getType = require('getType');
const JSON = require('JSON');
const makeString = require('makeString');

/*==============================================================================
==============================================================================*/

const BASE64URL = '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ-_';
const GCD_CONSENT_TYPES = ['ad_storage', 'analytics_storage', 'ad_user_data', 'ad_personalization'];
const GCS_CONSENT_TYPES = ['ad_storage', 'analytics_storage'];
const GCD_LENGTH = 12;
const GCD_FLAGS_POSITION = 9;
const GCD_STATE_LABELS = ['unknown', '-', 'denied', 'granted'];
const GCD_ADS_SIGNALS_VALUES = ['error', null, true, false];
const GCD_INVALID_ERROR = { code: 400, type: 'error', message: 'invalid consent mode string' };

const NOT_SET = '-';

const consentSource = data.consentSource || 'gcd';
// Variables saved before the Return option existed have no returnMode and keep the legacy JSON string.
const returnMode = data.returnMode || 'string';
const returnSelectedValues = returnMode === 'selected';

if (consentSource === 'consent_state') {
  const consentState = parseConsentState(getEventData('consent_state'));
  return returnSelectedValues ? pickValues(consentState, data.consentStateValues) : consentState;
}

if (consentSource === 'gcs') {
  const gcs = parseGcs(readGcs());
  return returnSelectedValues ? pickValues(gcs, data.gcsValues) : gcs;
}

if (consentSource === 'all') {
  const gcd = readGcd();
  return {
    gcd: gcd ? decodeGcd(gcd) : {},
    gcs: parseGcs(readGcs()),
    consent_state: parseConsentState(getEventData('consent_state'))
  };
}

const consentString = readGcd();
if (!consentString) return {};

const decodedGcd = decodeGcd(consentString);
if (returnMode === 'object') return decodedGcd;
if (!returnSelectedValues) return toPrettyJson(decodedGcd, '') + '\n';
if (!decodedGcd.result) return decodedGcd;

return pickValues(resolveGcdState(decodedGcd.result, data.gcdState), data.gcdValues);

/*==============================================================================
  Helpers
==============================================================================*/

function readGcd() {
  return getEventData('gcd') || getEventData('x-ga-gcd') || getRequestQueryParameter('gcd');
}

function readGcs() {
  return getEventData('x-ga-gcs') || getRequestQueryParameter('gcs');
}

// gcd, as gtag.js builds it: "1" + one 2-char block per consent type + flags char + 2 chars.
// The 2nd char of each block holds declare (bits 4-5), default (bits 2-3) and update (bits 0-1),
// each as 3 = granted, 2 = denied, 1 = not set ('-').
// The flags char holds GPC (bit 3), consent mode active (bit 2) and
// allow_ad_personalization_signals (bits 0-1) as 2 = true, 3 = false, 1 = not set (null).
// Labels, validation and the error object match the previous decoding endpoint.
function decodeGcd(consentString) {
  const gcd = makeString(consentString);
  if (!isValidGcd(gcd)) return GCD_INVALID_ERROR;

  const result = {};
  GCD_CONSENT_TYPES.forEach((consentType, i) => {
    const value = readBase64UrlChar(gcd, 2 + i * 2);
    result[consentType] = {
      default: GCD_STATE_LABELS[(value >> 2) & 3],
      update: GCD_STATE_LABELS[value & 3]
    };
  });

  const flags = readBase64UrlChar(gcd, GCD_FLAGS_POSITION);
  result.allow_ad_personalization_signals = GCD_ADS_SIGNALS_VALUES[flags & 3];
  result.global_privacy_control = (flags >> 3) & 1 ? 'opted-out' : null;

  return {
    query: { consent_string: gcd },
    result: result
  };
}

function isValidGcd(gcd) {
  if (gcd.length !== GCD_LENGTH || gcd.charAt(0) !== '1') return false;
  for (let i = 1; i < gcd.length; i++) {
    if (readBase64UrlChar(gcd, i) === -1) return false;
  }
  return true;
}

function readBase64UrlChar(str, position) {
  return BASE64URL.indexOf(str.charAt(position));
}

// gcs: "G1" + ad_storage digit + analytics_storage digit. 1 = granted, 0 = denied, '-' = not set.
function parseGcs(consentString) {
  if (!consentString) return {};

  const gcs = makeString(consentString).trim();
  if (gcs.length < 4 || gcs.substring(0, 2) !== 'G1') return {};

  const result = {};
  GCS_CONSENT_TYPES.forEach((consentType, i) => {
    const digit = gcs.charAt(2 + i);
    if (digit === '1') result[consentType] = 'granted';
    else if (digit === '0') result[consentType] = 'denied';
    else result[consentType] = NOT_SET;
  });

  return result;
}

// consent_state: object set by the Data Tag, e.g. { ad_storage: true, analytics_storage: false }.
function parseConsentState(consentState) {
  if (getType(consentState) !== 'object') return {};

  const result = {};
  for (const consentType in consentState) {
    result[consentType] = normalizeConsentValue(consentState[consentType]);
  }

  return result;
}

function normalizeConsentValue(value) {
  const normalized = makeString(value).trim().toLowerCase();
  if (['true', 'granted', '1'].indexOf(normalized) !== -1) return 'granted';
  if (['false', 'denied', '0'].indexOf(normalized) !== -1) return 'denied';
  return NOT_SET;
}

// Effective = the update state when it is set, otherwise the default state, as Google tags apply it.
function resolveGcdState(gcdResult, gcdState) {
  const state = gcdState || 'effective';
  const resolved = {};

  for (const key in gcdResult) {
    const value = gcdResult[key];
    if (getType(value) !== 'object' || state === 'both') resolved[key] = value;
    else if (state === 'update') resolved[key] = value.update;
    else if (state === 'default') resolved[key] = value.default;
    else if (['granted', 'denied'].indexOf(value.update) !== -1) resolved[key] = value.update;
    else resolved[key] = value.default;
  }

  return resolved;
}

// One selected value returns that value on its own; two or more return an object keyed by value name.
function pickValues(values, rows) {
  if (isEmptyObject(values)) return values;

  const keys = [];
  (rows || []).forEach((row) => {
    if (row && row.consentValue && keys.indexOf(row.consentValue) === -1) keys.push(row.consentValue);
  });
  if (keys.length === 0) return {};

  const picked = {};
  keys.forEach((key) => {
    picked[key] = values[key] === undefined ? NOT_SET : values[key];
  });

  return keys.length === 1 ? picked[keys[0]] : picked;
}

function isEmptyObject(value) {
  for (const key in value) return false;
  return true;
}

// Reproduces the 4-space indented JSON text the previous decoding endpoint returned.
function toPrettyJson(value, indent) {
  const type = getType(value);
  if (type === 'null' || type === 'undefined') return 'null';
  if (type !== 'object') return JSON.stringify(value);

  const childIndent = indent + '    ';
  const entries = [];
  for (const key in value) {
    entries.push(childIndent + JSON.stringify(key) + ': ' + toPrettyJson(value[key], childIndent));
  }

  if (entries.length === 0) return '{}';
  return '{\n' + entries.join(',\n') + '\n' + indent + '}';
}


___SERVER_PERMISSIONS___

[
  {
    "instance": {
      "key": {
        "publicId": "read_request",
        "versionId": "1"
      },
      "param": [
        {
          "key": "queryParametersAllowed",
          "value": {
            "type": 8,
            "boolean": true
          }
        },
        {
          "key": "queryParameterAccess",
          "value": {
            "type": 1,
            "string": "specific"
          }
        },
        {
          "key": "requestAccess",
          "value": {
            "type": 1,
            "string": "specific"
          }
        },
        {
          "key": "queryParameterWhitelist",
          "value": {
            "type": 2,
            "listItem": [
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "queryParameter"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "gcd"
                  }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "queryParameter"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "gcs"
                  }
                ]
              }
            ]
          }
        },
        {
          "key": "headerAccess",
          "value": {
            "type": 1,
            "string": "any"
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "read_event_data",
        "versionId": "1"
      },
      "param": [
        {
          "key": "keyPatterns",
          "value": {
            "type": 2,
            "listItem": [
              {
                "type": 1,
                "string": "gcd"
              },
              {
                "type": 1,
                "string": "x-ga-gcd"
              },
              {
                "type": 1,
                "string": "x-ga-gcs"
              },
              {
                "type": 1,
                "string": "consent_state"
              }
            ]
          }
        },
        {
          "key": "eventDataAccess",
          "value": {
            "type": 1,
            "string": "specific"
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  }
]


___TESTS___

scenarios:
- name: '[gcd] Returns the legacy JSON string for variables saved before the source and return options existed'
  code: |-
    eventData.gcd = '13v3v3v3v5l1';

    const variableResult = runCode({});

    const expected = [
      '{',
      '    "query": {',
      '        "consent_string": "13v3v3v3v5l1"',
      '    },',
      '    "result": {',
      '        "ad_storage": {',
      '            "default": "granted",',
      '            "update": "granted"',
      '        },',
      '        "analytics_storage": {',
      '            "default": "granted",',
      '            "update": "granted"',
      '        },',
      '        "ad_user_data": {',
      '            "default": "granted",',
      '            "update": "granted"',
      '        },',
      '        "ad_personalization": {',
      '            "default": "granted",',
      '            "update": "granted"',
      '        },',
      '        "allow_ad_personalization_signals": null,',
      '        "global_privacy_control": null',
      '    }',
      '}'
    ].join('\n') + '\n';
    assertThat(variableResult).isStrictlyEqualTo(expected);
    assertApi('getRequestQueryParameter').wasNotCalled();
    assertApi('getEventData').wasNotCalledWith('x-ga-gcs');
    assertApi('getEventData').wasNotCalledWith('consent_state');
- name: '[gcd] Reads the gcd query parameter when the Event Data has no gcd'
  code: |-
    queryParameters.gcd = '13v3v3v3v5l1';

    const variableResult = runCode(mockData);

    assertThat(getType(variableResult)).isEqualTo('string');
    assertThat(JSON.parse(variableResult)).isEqualTo(
      buildGcdOutput('13v3v3v3v5l1', ['granted', 'granted'], ['granted', 'granted'], ['granted', 'granted'], ['granted', 'granted'], null, null)
    );
    assertApi('getRequestQueryParameter').wasCalledWith('gcd');
- name: '[gcd] Reads the x-ga-gcd Event Data when the Event Data has no gcd'
  code: |-
    eventData['x-ga-gcd'] = '13r3r3r2r7l1';
    queryParameters.gcd = '13v3v3v3v5l1';

    const variableResult = runCode(mockData);

    assertThat(getType(variableResult)).isEqualTo('string');
    assertThat(JSON.parse(variableResult)).isEqualTo(
      buildGcdOutput('13r3r3r2r7l1', ['denied', 'granted'], ['denied', 'granted'], ['denied', 'granted'], ['denied', 'granted'], false, null)
    );
    assertApi('getRequestQueryParameter').wasNotCalled();
- name: '[gcd] Event Data gcd takes precedence over x-ga-gcd and the gcd query parameter'
  code: |-
    eventData.gcd = '13p1r1q1tfl1';
    eventData['x-ga-gcd'] = '13r3r3r2r7l1';
    queryParameters.gcd = '13v3v3v3v5l1';

    const variableResult = runCode(mockData);

    assertThat(JSON.parse(variableResult).query.consent_string).isEqualTo('13p1r1q1tfl1');
- name: '[gcd] Decodes default and update states and the flags with bitwise operations'
  code: |-
    [
      {
        gcd: '13p1r1q1tfl1',
        expected: buildGcdOutput('13p1r1q1tfl1', ['denied', '-'], ['denied', 'granted'], ['denied', 'denied'], ['granted', '-'], false, 'opted-out')
      },
      {
        gcd: '11l1l1l1l6l1',
        expected: buildGcdOutput('11l1l1l1l6l1', ['-', '-'], ['-', '-'], ['-', '-'], ['-', '-'], true, null)
      },
      {
        gcd: '13v3v3v3v9l1',
        expected: buildGcdOutput('13v3v3v3v9l1', ['granted', 'granted'], ['granted', 'granted'], ['granted', 'granted'], ['granted', 'granted'], null, 'opted-out')
      },
      {
        gcd: '1000000000l1',
        expected: buildGcdOutput('1000000000l1', ['unknown', 'unknown'], ['unknown', 'unknown'], ['unknown', 'unknown'], ['unknown', 'unknown'], 'error', null)
      },
      {
        gcd: '13V3V3V3Vcl1',
        expected: buildGcdOutput('13V3V3V3Vcl1', ['denied', '-'], ['denied', '-'], ['denied', '-'], ['denied', '-'], 'error', 'opted-out')
      },
      {
        gcd: '13r3r3r2r7l1',
        expected: buildGcdOutput('13r3r3r2r7l1', ['denied', 'granted'], ['denied', 'granted'], ['denied', 'granted'], ['denied', 'granted'], false, null)
      }
    ].forEach((scenario) => {
      eventData = { gcd: scenario.gcd };

      const variableResult = runCode(mockData);

      assertThat(JSON.parse(variableResult)).isEqualTo(scenario.expected);
    });
- name: '[gcd] Returns the endpoint error JSON for invalid gcd strings'
  code: |-
    const expected = [
      '{',
      '    "code": 400,',
      '    "type": "error",',
      '    "message": "invalid consent mode string"',
      '}'
    ].join('\n') + '\n';

    [
      '1',
      '13',
      '1*******',
      '##########',
      '13v3v3v3v5l',
      '13v3v3v3v5l1x',
      '23v3v3v3v5l1',
      '13v3v3v3v5!1',
      '13v3"v3v3v5l',
      ' 13v3v3v3v5l'
    ].forEach((gcd) => {
      eventData = { gcd: gcd };

      const variableResult = runCode(mockData);

      assertThat(variableResult).isStrictlyEqualTo(expected);
    });
- name: '[gcd] Full output as object returns the decoded object or the error object'
  code: |-
    mockData.returnMode = 'object';

    eventData.gcd = '13p1r1q1tfl1';
    assertThat(runCode(mockData)).isEqualTo(
      buildGcdOutput('13p1r1q1tfl1', ['denied', '-'], ['denied', 'granted'], ['denied', 'denied'], ['granted', '-'], false, 'opted-out')
    );

    eventData.gcd = '13v3v3v3v5l';
    assertThat(runCode(mockData)).isEqualTo({ code: 400, type: 'error', message: 'invalid consent mode string' });

    eventData = {};
    assertThat(runCode(mockData)).isEqualTo({});
- name: '[Data Tag and gcs] Full output as object and as JSON string return the same object'
  code: |-
    eventData = { 'x-ga-gcs': 'G110', consent_state: { ad_storage: true } };

    ['object', 'string'].forEach((returnMode) => {
      mockData.returnMode = returnMode;

      mockData.consentSource = 'gcs';
      assertThat(runCode(mockData)).isEqualTo({ ad_storage: 'granted', analytics_storage: 'denied' });

      mockData.consentSource = 'consent_state';
      assertThat(runCode(mockData)).isEqualTo({ ad_storage: 'granted' });
    });
- name: '[gcd] Returns an empty object when no gcd is found'
  code: |-
    const variableResult = runCode(mockData);

    assertThat(variableResult).isEqualTo({});
    assertApi('getEventData').wasCalledWith('gcd');
    assertApi('getEventData').wasCalledWith('x-ga-gcd');
    assertApi('getRequestQueryParameter').wasCalledWith('gcd');
- name: '[gcs] Decodes ad_storage and analytics_storage from the x-ga-gcs Event Data'
  code: |-
    mockData.consentSource = 'gcs';

    [
      { gcs: 'G100', expected: { ad_storage: 'denied', analytics_storage: 'denied' } },
      { gcs: 'G110', expected: { ad_storage: 'granted', analytics_storage: 'denied' } },
      { gcs: 'G101', expected: { ad_storage: 'denied', analytics_storage: 'granted' } },
      { gcs: 'G111', expected: { ad_storage: 'granted', analytics_storage: 'granted' } },
      { gcs: ' G111 ', expected: { ad_storage: 'granted', analytics_storage: 'granted' } },
      { gcs: 'G1-1', expected: { ad_storage: '-', analytics_storage: 'granted' } }
    ].forEach((scenario) => {
      eventData = { 'x-ga-gcs': scenario.gcs };

      const variableResult = runCode(mockData);

      assertThat(variableResult).isEqualTo(scenario.expected);
    });
- name: '[gcs] Reads the gcs query parameter when the Event Data has no x-ga-gcs'
  code: |-
    mockData.consentSource = 'gcs';
    queryParameters.gcs = 'G110';

    const variableResult = runCode(mockData);

    assertThat(variableResult).isEqualTo({ ad_storage: 'granted', analytics_storage: 'denied' });
    assertApi('getRequestQueryParameter').wasCalledWith('gcs');
    assertApi('getRequestQueryParameter').wasNotCalledWith('gcd');
- name: '[gcs] Returns an empty object when gcs is missing or malformed'
  code: |-
    mockData.consentSource = 'gcs';

    [undefined, '', 'G10', 'g111', 'G211', '13v3v3v3v5l1'].forEach((gcs) => {
      eventData = { 'x-ga-gcs': gcs };

      const variableResult = runCode(mockData);

      assertThat(variableResult).isEqualTo({});
    });
- name: '[Data Tag] Maps the consent_state booleans to granted or denied'
  code: |-
    mockData.consentSource = 'consent_state';
    eventData.consent_state = {
      ad_storage: true,
      ad_user_data: false,
      ad_personalization: true,
      analytics_storage: true,
      functionality_storage: false,
      personalization_storage: true,
      security_storage: true
    };

    const variableResult = runCode(mockData);

    assertThat(variableResult).isEqualTo({
      ad_storage: 'granted',
      ad_user_data: 'denied',
      ad_personalization: 'granted',
      analytics_storage: 'granted',
      functionality_storage: 'denied',
      personalization_storage: 'granted',
      security_storage: 'granted'
    });
    assertApi('getRequestQueryParameter').wasNotCalled();
- name: '[Data Tag] Accepts string or number consent values'
  code: |-
    mockData.consentSource = 'consent_state';
    eventData.consent_state = {
      ad_storage: 'granted',
      analytics_storage: 'DENIED',
      ad_user_data: 'true',
      ad_personalization: 0,
      functionality_storage: 1,
      security_storage: 'unknown',
      personalization_storage: null
    };

    const variableResult = runCode(mockData);

    assertThat(variableResult).isEqualTo({
      ad_storage: 'granted',
      analytics_storage: 'denied',
      ad_user_data: 'granted',
      ad_personalization: 'denied',
      functionality_storage: 'granted',
      security_storage: '-',
      personalization_storage: '-'
    });
- name: '[Data Tag] Returns an empty object when consent_state is missing or not an object'
  code: |-
    mockData.consentSource = 'consent_state';

    [undefined, null, '', 'granted', '{"ad_storage":true}', '{bad}', true, ['ad_storage']].forEach((consentState) => {
      eventData = { consent_state: consentState };

      const variableResult = runCode(mockData);

      assertThat(variableResult).isEqualTo({});
    });
- name: '[All] Returns every source decoded as an object'
  code: |-
    mockData.consentSource = 'all';
    eventData = {
      gcd: '13r3r3r2r7l1',
      'x-ga-gcs': 'G101',
      consent_state: { ad_storage: false, analytics_storage: true }
    };

    const variableResult = runCode(mockData);

    assertThat(variableResult).isEqualTo({
      gcd: buildGcdOutput('13r3r3r2r7l1', ['denied', 'granted'], ['denied', 'granted'], ['denied', 'granted'], ['denied', 'granted'], false, null),
      gcs: { ad_storage: 'denied', analytics_storage: 'granted' },
      consent_state: { ad_storage: 'denied', analytics_storage: 'granted' }
    });
- name: '[All] Reads the query parameters and returns empty objects for missing sources'
  code: |-
    mockData.consentSource = 'all';
    queryParameters.gcs = 'G111';

    const variableResult = runCode(mockData);

    assertThat(variableResult).isEqualTo({
      gcd: {},
      gcs: { ad_storage: 'granted', analytics_storage: 'granted' },
      consent_state: {}
    });
    assertApi('getRequestQueryParameter').wasCalledWith('gcd');
    assertApi('getRequestQueryParameter').wasCalledWith('gcs');
- name: '[All] Returns the endpoint error object for an invalid gcd'
  code: |-
    mockData.consentSource = 'all';
    eventData.gcd = '13v3v3v3v5l';

    const variableResult = runCode(mockData);

    assertThat(variableResult).isEqualTo({
      gcd: { code: 400, type: 'error', message: 'invalid consent mode string' },
      gcs: {},
      consent_state: {}
    });
- name: '[Selected values] gcd returns one value on its own for each gcd State'
  code: |-
    mockData.returnMode = 'selected';

    [
      { gcd: '13p1r1q1tfl1', state: undefined, value: 'ad_storage', expected: 'denied' },
      { gcd: '13p1r1q1tfl1', state: 'effective', value: 'analytics_storage', expected: 'granted' },
      { gcd: '1383838385l1', state: 'effective', value: 'ad_storage', expected: 'denied' },
      { gcd: '13p1r1q1tfl1', state: 'update', value: 'ad_storage', expected: '-' },
      { gcd: '13p1r1q1tfl1', state: 'default', value: 'analytics_storage', expected: 'denied' },
      { gcd: '13p1r1q1tfl1', state: 'both', value: 'ad_storage', expected: { default: 'denied', update: '-' } },
      { gcd: '13p1r1q1tfl1', state: 'update', value: 'global_privacy_control', expected: 'opted-out' },
      { gcd: '13p1r1q1tfl1', state: 'both', value: 'allow_ad_personalization_signals', expected: false },
      { gcd: '13v3v3v3v5l1', state: 'effective', value: 'global_privacy_control', expected: null }
    ].forEach((scenario) => {
      eventData = { gcd: scenario.gcd };
      mockData.gcdState = scenario.state;
      mockData.gcdValues = [{ consentValue: scenario.value }];

      const variableResult = runCode(mockData);

      assertThat(variableResult).isEqualTo(scenario.expected);
    });
- name: '[Selected values] gcd returns an object for two or more values'
  code: |-
    mockData.returnMode = 'selected';
    mockData.gcdState = 'effective';
    eventData.gcd = '13p1r1q1tfl1';

    mockData.gcdValues = [
      { consentValue: 'ad_storage' },
      { consentValue: 'analytics_storage' },
      { consentValue: 'global_privacy_control' }
    ];
    assertThat(runCode(mockData)).isEqualTo({
      ad_storage: 'denied',
      analytics_storage: 'granted',
      global_privacy_control: 'opted-out'
    });

    mockData.gcdValues = [{ consentValue: 'ad_storage' }, { consentValue: 'ad_storage' }];
    assertThat(runCode(mockData)).isEqualTo('denied');
- name: '[Selected values] gcd keeps the empty object and the error object'
  code: |-
    mockData.returnMode = 'selected';
    mockData.gcdValues = [{ consentValue: 'ad_storage' }];

    assertThat(runCode(mockData)).isEqualTo({});

    eventData.gcd = '13v3v3v3v5l';
    assertThat(runCode(mockData)).isEqualTo({ code: 400, type: 'error', message: 'invalid consent mode string' });

    eventData.gcd = '13v3v3v3v5l1';
    mockData.gcdValues = [];
    assertThat(runCode(mockData)).isEqualTo({});
- name: '[Selected values] gcs returns one value or an object'
  code: |-
    mockData.consentSource = 'gcs';
    mockData.returnMode = 'selected';

    mockData.gcsValues = [{ consentValue: 'ad_storage' }];
    assertThat(runCode(mockData)).isEqualTo({});

    eventData['x-ga-gcs'] = 'G1-1';
    assertThat(runCode(mockData)).isEqualTo('-');

    mockData.gcsValues = [{ consentValue: 'analytics_storage' }, { consentValue: 'ad_storage' }];
    assertThat(runCode(mockData)).isEqualTo({ analytics_storage: 'granted', ad_storage: '-' });
- name: '[Selected values] Data Tag returns one value or an object, with - for missing types'
  code: |-
    mockData.consentSource = 'consent_state';
    mockData.returnMode = 'selected';

    mockData.consentStateValues = [{ consentValue: 'security_storage' }];
    assertThat(runCode(mockData)).isEqualTo({});

    eventData.consent_state = { ad_storage: true, security_storage: false };
    assertThat(runCode(mockData)).isEqualTo('denied');

    mockData.consentStateValues = [{ consentValue: 'ad_storage' }, { consentValue: 'functionality_storage' }];
    assertThat(runCode(mockData)).isEqualTo({ ad_storage: 'granted', functionality_storage: '-' });
- name: '[All] Ignores the selected values settings'
  code: |-
    mockData.consentSource = 'all';
    mockData.returnMode = 'selected';
    mockData.gcdValues = [{ consentValue: 'ad_storage' }];
    mockData.gcsValues = [{ consentValue: 'ad_storage' }];
    mockData.consentStateValues = [{ consentValue: 'ad_storage' }];
    eventData = { 'x-ga-gcs': 'G110', consent_state: { ad_storage: false } };

    assertThat(runCode(mockData)).isEqualTo({
      gcd: {},
      gcs: { ad_storage: 'granted', analytics_storage: 'denied' },
      consent_state: { ad_storage: 'denied' }
    });
setup: |-
  const JSON = require('JSON');
  const getType = require('getType');

  const mockData = {
    consentSource: 'gcd',
    returnMode: 'string'
  };

  let eventData = {};
  let queryParameters = {};

  mock('getEventData', (key) => eventData[key]);
  mock('getRequestQueryParameter', (key) => queryParameters[key]);

  const toState = (states) => ({ default: states[0], update: states[1] });

  const buildGcdOutput = (gcd, adStorage, analyticsStorage, adUserData, adPersonalization, adsSignals, gpc) => ({
    query: { consent_string: gcd },
    result: {
      ad_storage: toState(adStorage),
      analytics_storage: toState(analyticsStorage),
      ad_user_data: toState(adUserData),
      ad_personalization: toState(adPersonalization),
      allow_ad_personalization_signals: adsSignals,
      global_privacy_control: gpc
    }
  });


___NOTES___

2026-11-26 - Change Notes:
  - Decode the gcd string locally with bitwise operations instead of calling the Analytics Debugger API, so the variable no longer depends on an external endpoint. The gcd output is the same JSON string the API returned, byte for byte, including its error object for invalid gcd strings (checked against the live API on 1389 strings)
  - Add a Consent Source dropdown (default gcd, so existing variables keep their behavior) and also read gcd from the x-ga-gcd Event Data. The dropdown can also read the Data Tag consent_state, the x-ga-gcs Event Data or gcs query parameter, or all sources at once. The template description and help text now cover every source, not only Google Consent Mode v2
  - Add a Return option: the full output as an object (UI default for new variables), the legacy JSON string (what variables saved before this option keep returning), or selected values only. One selected value returns that value on its own, which can be used directly in a trigger, and two or more return an object. For gcd, a gcd State option picks the effective, update, default or both states
  - Remove the send_http and template storage permissions, and allow reading the gcs query parameter and the x-ga-gcd, x-ga-gcs and consent_state Event Data
  - Add unit tests for every source

2026-05-21 Change Notes:
 - Console logging removal.

Created on 06/09/2024, 18:41:28

