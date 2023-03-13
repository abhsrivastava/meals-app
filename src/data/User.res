let getUser = ()  => {
  open Fetch
  open Js.Promise2
  let response = get("https://randomuser.me/api/")
  response -> then (Response.json) -> then (json => {
    switch json -> Js.Json.stringifyAny {
    | Some (x) => 
      x -> resolve
    | None => 
      Js.Console.log("no object")
      "" -> resolve
    }
   })
}