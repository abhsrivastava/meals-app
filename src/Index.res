switch ReactDOM.querySelector("#main") {
| Some(rootElement) => 
  ReactDOM.Client.Root.render(
    ReactDOM.Client.createRoot(rootElement), 
    <React.StrictMode>
      <ThemeContext.Provider value="Hello World">
        <App />
      </ThemeContext.Provider>
    </React.StrictMode>
  )
| None => Js.Console.log("Could not find the main div")
}