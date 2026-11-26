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
