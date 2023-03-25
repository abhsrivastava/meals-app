@react.component
let make = (~handleSearchTermChange, ~searchTerm) => {
  let _ = Context.useGlobalContext()
  let (text, setText) = React.useState(() => searchTerm)
  
  let handleTextChange = (event) => {
    let newText = ReactEvent.Form.currentTarget(event)["value"]
    setText(_ => newText)
  }

  let handleSubmit = (event) => {
    ReactEvent.Form.preventDefault(event)
    handleSearchTermChange(Context.Ingredient(text))
  }

  let handleClick = (_) => {
    Js.Console.log("going to get random meal")
    handleSearchTermChange(Context.RandomMeal)
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
        onClick={handleClick}
        className="btn btn-hipster">{"surprise me"->React.string}</button>
    </form>
  </header>
}