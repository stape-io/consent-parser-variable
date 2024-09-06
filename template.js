const sendHttpRequest = require('sendHttpRequest');
const getRequestHeader = require('getRequestHeader');
const getContainerVersion = require('getContainerVersion');
const encodeUriComponent = require('encodeUriComponent');
const logToConsole = require('logToConsole');
const templateDataStorage = require('templateDataStorage');
const getEventData = require('getEventData');
const JSON = require('JSON');
const getRequestQueryParameter = require('getRequestQueryParameter');

const isLoggingEnabled = determinateIsLoggingEnabled();
const traceId = isLoggingEnabled ? getRequestHeader('trace-id') : undefined;

const consentString = getEventData('gcd') || getRequestQueryParameter('gcd');
if (!consentString) {
  return {};
}

const url = 'https://openapi.analytics-debugger.com/v1/google/consent/decode/'+enc(consentString);

if (templateDataStorage.getItemCopy(consentString)) {
  return JSON.parse(templateDataStorage.getItemCopy(consentString));
} else {
  if (isLoggingEnabled) {
    logToConsole(
      JSON.stringify({
        Name: 'ConsentParser',
        Type: 'Request',
        TraceId: traceId,
        EventName: 'Lookup',
        RequestMethod: 'GET',
        RequestUrl: url,
      })
    );
  }

  return sendHttpRequest(url, {
    method: 'GET',
    timeout: 3000,
  }).then((result) => {
    if (isLoggingEnabled) {
      logToConsole(
        JSON.stringify({
          Name: 'ConsentParser',
          Type: 'Response',
          TraceId: traceId,
          EventName: 'Lookup',
          ResponseStatusCode: result.statusCode,
          ResponseHeaders: result.headers,
          ResponseBody: result.body,
        })
      );
    }

    templateDataStorage.setItemCopy(consentString, JSON.stringify(result.body));

    return result.body;
  });
}


function enc(data) {
  data = data || '';
  return encodeUriComponent(data);
}

function determinateIsLoggingEnabled() {
  const containerVersion = getContainerVersion();
  const isDebug = !!(containerVersion && (containerVersion.debugMode || containerVersion.previewMode));

  if (!data.logType) {
    return isDebug;
  }

  if (data.logType === 'no') {
    return false;
  }

  if (data.logType === 'debug') {
    return isDebug;
  }

  return data.logType === 'always';
}
