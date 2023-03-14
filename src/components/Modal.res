@react.component
let make = () => {
  let _ = Context.useGlobalContext()
  <div>{"Modal"->React.string}</div>
}