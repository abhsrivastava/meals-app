open Js.Promise2
User.getUser() -> then(user => {
  Js.Console.log(user)
  switch ReactDOM.querySelector("#main") {
  | Some(rootElement) => 
    ReactDOM.Client.Root.render(
      ReactDOM.Client.createRoot(rootElement), 
      <React.StrictMode>
        <Context.Provider value={user}>
          <App />
        </Context.Provider>
      </React.StrictMode>
    ) -> resolve
  | None => 
    Js.Console.log("Could not find the main div") -> resolve
  }
}) -> ignore
