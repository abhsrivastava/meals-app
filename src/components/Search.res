@react.component
let make = (~handleSearchTermChange) => {
  let _ = Context.useGlobalContext()
  let (text, setText) = React.useState(() => "")
  
  let handleTextChange = (event) => {
    let newText = ReactEvent.Form.currentTarget(event)["value"]
    setText(_ => newText)
  }

  let handleSubmit = (event) => {
    Js.Console.log("came inside handle submit event")
    ReactEvent.Form.preventDefault(event)
    handleSearchTermChange(text)
  }

  <header className="search-container">
    <form onSubmit={handleSubmit}>
      <input 
        type_="text" 
        value={text}
        placeholder="type your favorite meal" 
        className="form-input"
        onChange={handleTextChange}></input>
      <button 
        type_="submit" 
        onSubmit={handleSubmit}
        className="btn">{"search"->React.string}</button>
      <button 
        type_="button" 
        onSubmit={handleSubmit}
        className="btn">{"surprise me1"->React.string}</button>
    </form>
  </header>
}