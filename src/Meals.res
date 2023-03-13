@react.component
let make = () => {
  let context = ThemeContext.useGlobalContext()
  Js.Console.log(`Inside Meals Context is: ${context}`)
  <div>{"Meals" -> React.string}</div>
}