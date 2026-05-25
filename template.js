const encodeUriComponent = require('encodeUriComponent');
const getEventData = require('getEventData');
const getRequestQueryParameter = require('getRequestQueryParameter');
const getType = require('getType');
const JSON = require('JSON');
const makeString = require('makeString');
const sendHttpRequest = require('sendHttpRequest');
const templateDataStorage = require('templateDataStorage');

/*==============================================================================
==============================================================================*/

const consentString = getEventData('gcd') || getRequestQueryParameter('gcd');
if (!consentString) {
  return {};
}

const url = 'https://openapi.analytics-debugger.com/v1/google/consent/decode/' + enc(consentString);

if (templateDataStorage.getItemCopy(consentString)) {
  return JSON.parse(templateDataStorage.getItemCopy(consentString));
} else {
  return sendHttpRequest(url, {
    method: 'GET',
    timeout: 3000
  }).then((result) => {
    templateDataStorage.setItemCopy(consentString, JSON.stringify(result.body));
    return result.body;
  });
}

/*==============================================================================
  Helpers
==============================================================================*/

function enc(data) {
  if (['null', 'undefined'].indexOf(getType(data)) !== -1) data = '';
  return encodeUriComponent(makeString(data));
}
