%%raw("import './styles/App.css'")

@react.component
let make = () => {
  switch Context.useGlobalContext() {
  | GotResult({meals, _}) => 
    <main>
      <Search />
      <Favorites />
      <Meals meals/>
      <Modal />
    </main>
  | _ => failwith("cannot come here as the root component does not send the call here if we didn't get result")
  }
}