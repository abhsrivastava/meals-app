@react.component
let make = () => {
  let context = ThemeContext.useGlobalContext()
  Js.Console.log(`insise Modal Context is: ${context}`)
  <div>{"Modal"->React.string}</div>
}