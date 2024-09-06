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
  "description": "Returns a decoded Consent Mode v2 string",
  "containerContexts": [
    "SERVER"
  ]
}


___TEMPLATE_PARAMETERS___

[]


___SANDBOXED_JS_FOR_SERVER___

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
          "key": "headerWhitelist",
          "value": {
            "type": 2,
            "listItem": [
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "headerName"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "trace-id"
                  }
                ]
              }
            ]
          }
        },
        {
          "key": "queryParametersAllowed",
          "value": {
            "type": 8,
            "boolean": true
          }
        },
        {
          "key": "headersAllowed",
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
              }
            ]
          }
        },
        {
          "key": "headerAccess",
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
  },
  {
    "instance": {
      "key": {
        "publicId": "logging",
        "versionId": "1"
      },
      "param": [
        {
          "key": "environments",
          "value": {
            "type": 1,
            "string": "all"
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
        "publicId": "access_template_storage",
        "versionId": "1"
      },
      "param": []
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "read_container_data",
        "versionId": "1"
      },
      "param": []
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
  },
  {
    "instance": {
      "key": {
        "publicId": "send_http",
        "versionId": "1"
      },
      "param": [
        {
          "key": "allowedUrls",
          "value": {
            "type": 1,
            "string": "specific"
          }
        },
        {
          "key": "urls",
          "value": {
            "type": 2,
            "listItem": [
              {
                "type": 1,
                "string": "https://openapi.analytics-debugger.com/*"
              }
            ]
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

scenarios: []


___NOTES___

Created on 06/09/2024, 18:41:28


