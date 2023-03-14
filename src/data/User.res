type user = {
 fullName: string,
 thumbnail: string
}

let getKeyValue = (json: Js.Json.t, key: string) : string => {
  switch json -> Js.Json.classify {
  | Js.Json.JSONObject(obj) => 
    switch (obj -> Js.Dict.get(key)) {
    | Some(value) => 
      switch value -> Js.Json.classify {
      | Js.Json.JSONString(value) => value
      | _ => failwith(`${key} is not a string`)
      }
    | None => failwith(`${key} not found`)
    }
  | _ => failwith("could not parse Json")
  }
}

let getKeyObject = (json: Js.Json.t, key: string) : Js.Json.t => {
  switch json -> Js.Json.classify {
  | Js.Json.JSONObject(obj) => 
    switch obj -> Js.Dict.get(key) {
    | Some(value) => value
    | None => failwith(`${key} not found`)
    }
  | _ => failwith("could not parse Json")
  }
}

let getKeyArray = (json: Js.Json.t, key: string) : array<Js.Json.t> => {
  switch json -> Js.Json.classify {
  | Js.Json.JSONObject(obj) => 
    switch (obj -> Js.Dict.get(key)) {
    | Some(value) => 
      switch value -> Js.Json.classify {
      | Js.Json.JSONArray(array) => array
      | _ => failwith(`${key} is not an array`)
      }
    | None => failwith(`${key} not found`)
    }
  | _ => failwith("could not parse json")
  }
}
let getUser = () : promise<array<user>>  => {
  open Fetch
  open Js.Promise2
  let response = get("https://randomuser.me/api/")
  response -> then (Response.json) -> then (json => {
    Js.log(json)
    json 
      -> getKeyArray("results") 
      -> Js.Array2.map(json => {
        (json -> getKeyObject("name"), json -> getKeyObject("picture"))
      })
      -> Js.Array2.map(((name, picture)) => {
        let first = name -> getKeyValue("first")
        let last = name -> getKeyValue("last")
        let fullName = `${first} ${last}`
        let thumbnail = picture -> getKeyValue("thumbnail")
        {fullName, thumbnail}
      })
      -> resolve
  })
}