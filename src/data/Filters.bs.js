// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Js_dict from "rescript/lib/es6/js_dict.js";
import * as Js_json from "rescript/lib/es6/js_json.js";
import * as Caml_option from "rescript/lib/es6/caml_option.js";
import * as Js_promise2 from "rescript/lib/es6/js_promise2.js";

function parseFilter(json, key) {
  var obj = Js_json.classify(json);
  if (typeof obj === "number") {
    return {
            TAG: /* Error */3,
            _0: "input json is not an object"
          };
  }
  if (obj.TAG !== /* JSONObject */2) {
    return {
            TAG: /* Error */3,
            _0: "input json is not an object"
          };
  }
  var valueObj = Js_dict.get(obj._0, key);
  if (valueObj === undefined) {
    return {
            TAG: /* Error */3,
            _0: "" + key + " not found"
          };
  }
  var s = Js_json.classify(Caml_option.valFromOption(valueObj));
  if (typeof s === "number") {
    return {
            TAG: /* Error */3,
            _0: "" + key + " must be string"
          };
  }
  if (s.TAG !== /* JSONString */0) {
    return {
            TAG: /* Error */3,
            _0: "" + key + " must be string"
          };
  }
  var s$1 = s._0;
  switch (key) {
    case "strArea" :
        return {
                TAG: /* Area */0,
                _0: {
                  strArea: s$1
                }
              };
    case "strCategory" :
        return {
                TAG: /* Category */1,
                _0: {
                  strCategory: s$1
                }
              };
    case "strIngredient" :
        return {
                TAG: /* Ingredient */2,
                _0: {
                  strIngrediant: s$1
                }
              };
    default:
      return {
              TAG: /* Error */3,
              _0: "unknown filter " + key + ""
            };
  }
}

function parseJson(json, key) {
  var obj = Js_json.classify(json);
  if (typeof obj === "number") {
    return [{
              TAG: /* Error */3,
              _0: "Failed to parse Json"
            }];
  }
  if (obj.TAG !== /* JSONObject */2) {
    return [{
              TAG: /* Error */3,
              _0: "Failed to parse Json"
            }];
  }
  var arrayObj = Js_dict.get(obj._0, "meals");
  if (arrayObj === undefined) {
    return [{
              TAG: /* Error */3,
              _0: "Failed to parse Json. Response doesn't contain meals key"
            }];
  }
  var array = Js_json.classify(Caml_option.valFromOption(arrayObj));
  if (typeof array === "number") {
    return [{
              TAG: /* Error */3,
              _0: "Failed to parse Json. Meals should be an array"
            }];
  } else if (array.TAG === /* JSONArray */3) {
    return array._0.map(function (json) {
                return parseFilter(json, key);
              });
  } else {
    return [{
              TAG: /* Error */3,
              _0: "Failed to parse Json. Meals should be an array"
            }];
  }
}

function getData(url, key) {
  return Js_promise2.then(Js_promise2.then(fetch(url), (function (prim) {
                    return prim.json();
                  })), (function (json) {
                return Promise.resolve(parseJson(json, key));
              }));
}

function getFilter(key) {
  var url = "https://www.themealdb.com/api/json/v1/1/list.php?";
  switch (key) {
    case "strArea" :
        return getData("" + url + "a=list", "strArea");
    case "strCategory" :
        return getData("" + url + "c=list", "strCategory");
    case "strIngredient" :
        return getData("" + url + "i=list", "strIngredient");
    default:
      return Promise.resolve([{
                    TAG: /* Error */3,
                    _0: "Unknown Filter " + key + ""
                  }]);
  }
}

export {
  parseFilter ,
  parseJson ,
  getData ,
  getFilter ,
}
/* No side effect */
