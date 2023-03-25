%%raw("import './styles/App.css'")

@react.component
let make = (~handleSearchTermChange) => {
  switch Context.useGlobalContext() {
  | GotResult({meals, _}) => 
    <main>
      <Search handleSearchTermChange />
      <Favorites />
      <MealSummary meals/>
      <Modal />
    </main>
  | _ => failwith("cannot come here as the root component does not send the call here if we didn't get result")
  }
}