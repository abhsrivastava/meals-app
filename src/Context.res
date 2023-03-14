type state = 
  | NotAsked
  | GotError(string)
  | GotResult(array<User.user>)

let context = React.createContext(NotAsked)
// wrapped in provider so that we can use this as an element
module Provider = {
  let make = React.Context.provider(context)
}
// encapsulates the context object.
let useGlobalContext = () => {
  React.useContext(context)
}