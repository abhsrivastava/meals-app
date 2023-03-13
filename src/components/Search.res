@react.component
let make = () => {
  let context = Context.useGlobalContext()
  Js.Console.log(`Inside Search Context is: ${context}`)
  <div>{"Search"->React.string}</div>
}