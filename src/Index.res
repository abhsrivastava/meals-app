switch ReactDOM.querySelector("#main") {
| Some(rootElement) => 
  ReactDOM.Client.Root.render(
    ReactDOM.Client.createRoot(rootElement), 
    <App />
  )
| None => Js.Console.log("Could not find the main div")
}