@react.component
let make = () => {
  let context = ThemeContext.useGlobalContext()
  Js.Console.log(`Inside Search Context is: ${context}`)
  <div>{"Search"->React.string}</div>
}