@react.component
let make = () => {
  let _ = Context.useGlobalContext()
  <div>{"Favorites"->React.string}</div>
}