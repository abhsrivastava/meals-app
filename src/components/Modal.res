@react.component
let make = () => {
  let context = Context.useGlobalContext()
  Js.Console.log(`insise Modal Context is: ${context}`)
  <div>{"Modal"->React.string}</div>
}