@react.component
let make = () => {
  let context = Context.useGlobalContext()
  Js.Console.log(`Inside Meals Context is: ${context}`)
  <div>{"Meals" -> React.string}</div>
}