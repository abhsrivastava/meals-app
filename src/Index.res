
module Root = {
  @react.component
  let make = () => {
    let (state, setState) = React.useState(() => Context.NotAsked)
    let _ = React.useEffect0(() => {
      open Js.Promise2
      let sequence = () => User.getUser()
      sequence() -> then(user => setState(_ => GotResult(user)) -> resolve) -> ignore
      None
    })    
    switch state {
    | NotAsked => <Spinner />
    | GotError(e) => <Error msg={e} />
    | GotResult(_) => <Context.Provider value={state}><App /></Context.Provider>
    }
  }
}

switch ReactDOM.querySelector("#main") {
| Some(rootElement) => 
  ReactDOM.Client.Root.render(
    ReactDOM.Client.createRoot(rootElement), 
    <React.StrictMode>
        <Root />
    </React.StrictMode>
  )
| None => Js.Console.log("Could not find the main div")
}