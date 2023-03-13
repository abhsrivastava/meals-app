@react.component
let make = () => {
  let context = ThemeContext.useGlobalContext()
  Js.Console.log(`Inside Favorites Context is: ${context}`)
  <div>{"Favorites"->React.string}</div>
}