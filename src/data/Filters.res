/** This is a helper module which helps us get list of areas from the meals db */
type area = {
  strArea: string
}

type category = {
  strCategory: string
}

type ingredient = {
  strIngrediant: string
}

type filter = 
| Area(area)
| Category(category)
| Ingredient(ingredient)
| Error(string)

let parseFilter = (json: Js.Json.t, key: string) : filter => {
  open Js.Json
  switch json -> classify {
  | JSONObject(obj) => 
    switch obj -> Js.Dict.get(key) {
    | Some(valueObj) => 
      switch valueObj->classify {
      | JSONString(s) => 
        switch key {
        | "strArea" => Area({strArea: s})
        | "strIngredient" => Ingredient({strIngrediant: s})
        | "strCategory" => Category({strCategory: s})
        | _ => Error(`unknown filter ${key}`)
        }
      | _ => Error(`${key} must be string`)
      }
    | None => Error(`${key} not found`)
    }
  | _ => Error(`input json is not an object`)
  }
}

let parseJson = (json: Js.Json.t, key: string) : array<filter> => {
  open Js.Json
  switch json -> classify {
  | JSONObject(obj) => 
    switch obj->Js.Dict.get("meals") {
    | Some(arrayObj) =>
      switch arrayObj -> classify {
      | JSONArray(array) => 
        array -> Js.Array2.map(json => {
          parseFilter(json, key)
        })
      | _ => [Error("Failed to parse Json. Meals should be an array")]
      }
    | None => [Error("Failed to parse Json. Response doesn't contain meals key")]
    }
  | _ => [Error("Failed to parse Json")]
  }
}

open Fetch
open Js.Promise2

let getData = (url: string, key: string) : promise<array<filter>> => {
  url 
  -> get 
  -> then(Response.json)
  -> then(json => json -> parseJson(key) -> resolve)
}

let getFilter = (key: string) : promise<array<filter>> => {
  let url = "https://www.themealdb.com/api/json/v1/1/list.php?"
  switch key {
  | "strArea" => getData(`${url}a=list`, "strArea")
  | "strCategory" => getData(`${url}c=list`, "strCategory")
  | "strIngredient" => getData(`${url}i=list`, "strIngredient")
  | _ => [Error(`Unknown Filter ${key}`)] -> resolve
  }
}