@react.component
let make = () => {
  let context = Context.useGlobalContext()
  switch context {
  | GotResult(data) =>
    {
      `Size of Array ${data -> Js.Array2.length -> Belt.Int.toString}`->Js.Console.log
      data 
      -> Js.Array2.mapi((user, i) => 
          <div key={i -> Belt.Int.toString} id={i -> Belt.Int.toString}>
            <p>{user.fullName -> React.string}</p>
            <img src={user.thumbnail} />
          </div>
        ) 
      -> React.array
    }
  | _ => failwith("should not come here as App is called only on Success")
  }
}