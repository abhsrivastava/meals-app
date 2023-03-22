open Js.Json
open Js.Promise2
open Fetch

let parseResponseJson = (json: Js.Json.t) : result<array<string>, string> => {
  switch json -> classify {
  | JSONObject(rootObj) =>
    switch rootObj -> Js.Dict.get("meals") {
    | Some(mealsObj) => 
      switch mealsObj -> classify {
      | JSONArray(areaObjArray) =>
        let areaResultArray = areaObjArray -> Belt.Array.map(areaJson => {
          switch areaJson -> classify {
          | JSONObject(areaObj) =>
            switch areaObj -> Js.Dict.get("strArea") {
            | Some(strAreaObj) => 
              switch strAreaObj -> classify {
              | JSONString(strArea) => Ok(strArea)
              | _ => Error("strArea value should be a string")
              }
            | None => Error("strArea key not found")
            }
          | _ => Error("Meals array does not contain an object")
          }
        })
        if (areaResultArray -> Belt.Array.every(areaResult => {
          switch areaResult {
          | Ok(_) => true
          | Error(_) => false
          }
        })) {
          Ok(areaResultArray -> Belt.Array.map(areaResult => {
            switch areaResult {
            | Ok(strArea) => strArea
            | _ => failwith("should not come here because of every")
            }
          }))
        } else {
          Error("Json Parse failed")
        }
      | _ => Error("meals is not an array")
      }
    | None => Error("JSON doesn't contain a key for meals")
    }
  | _ => Error("passed JSON is not an object")
  }
}

let getAreaList = () : promise<result<array<string>, string>> => {
  "https://www.themealdb.com/api/json/v1/1/list.php?a=list"
  -> get
  -> then(Response.json)
  -> then(json => parseResponseJson(json) -> resolve)
}