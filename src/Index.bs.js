// Generated by ReScript, PLEASE EDIT WITH CARE

import * as App from "./App.bs.js";
import * as User from "./data/User.bs.js";
import * as Curry from "rescript/lib/es6/curry.js";
import * as $$Error from "./components/Error.bs.js";
import * as React from "react";
import * as Context from "./Context.bs.js";
import * as Spinner from "./components/Spinner.bs.js";
import * as Js_promise2 from "rescript/lib/es6/js_promise2.js";
import * as Client from "react-dom/client";

function Index$Root(props) {
  var match = React.useState(function () {
        return /* NotAsked */0;
      });
  var setState = match[1];
  var state = match[0];
  React.useEffect((function () {
          Js_promise2.then(User.getUser(undefined), (function (user) {
                  return Promise.resolve(Curry._1(setState, (function (param) {
                                    return {
                                            TAG: /* GotResult */1,
                                            _0: user
                                          };
                                  })));
                }));
        }), []);
  if (typeof state === "number") {
    return React.createElement(Spinner.make, {});
  } else if (state.TAG === /* GotError */0) {
    return React.createElement($$Error.make, {
                msg: state._0
              });
  } else {
    return React.createElement(Context.Provider.make, {
                value: state,
                children: React.createElement(App.make, {})
              });
  }
}

var Root = {
  make: Index$Root
};

var rootElement = document.querySelector("#main");

if (rootElement == null) {
  console.log("Could not find the main div");
} else {
  Client.createRoot(rootElement).render(React.createElement(React.StrictMode, {
            children: React.createElement(Index$Root, {})
          }));
}

export {
  Root ,
}
/* rootElement Not a pure module */
