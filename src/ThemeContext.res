let context = React.createContext("test")
// wrapped in provider so that we can use this as an element
module Provider = {
  let make = React.Context.provider(context)
}
// encapsulates the context object.
let useGlobalContext = () => {
  React.useContext(context)
}