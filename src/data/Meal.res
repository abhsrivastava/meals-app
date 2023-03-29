open Js.Json
open Js.Promise2
open Fetch

type mealDetail = {
  id: int,
  mealName: string,
  category: string,
  area: string,
  instructions: string,
  thumbnail: string,
  tags: array<string>,
  youtubeLink: option<string>,
  ingredientAndMeasures: array<(string, string)>
}

type mealSummary = {
  id: int, 
  mealName: string,
  thumbnail: string
}

exception PARSE_FAILED(string)

let getValue = (obj: Js.Dict.t<Js.Json.t>, key: string) : string => {
  switch obj -> Js.Dict.get(key) {
  | Some(valueObj) => 
    switch valueObj -> classify {
    | JSONString(value) => value
    | JSONNull => ""
    | _ => raise(PARSE_FAILED(`value of ${key} is not a string`))
    }
  | None => raise(PARSE_FAILED(`${key} not found in meal json`))
  }
}

let parseMealSummary = (json: Js.Json.t) : mealSummary => {
  switch json -> classify {
  | JSONObject(obj) => 
    let id = obj -> getValue("idMeal") -> Belt.Int.fromString -> Belt.Option.getExn
    let mealName = obj -> getValue("strMeal")
    let thumbnail = obj -> getValue("strMealThumb")
    {id, mealName, thumbnail}
  | _ => raise(PARSE_FAILED("Meals is not an object"))
  }
}

let parseMealSummaryArray = (json: Js.Json.t) : result<array<mealSummary>, string> => {
  switch json -> classify {
  | JSONArray(array) => 
    Ok(array -> Belt.Array.map(jsonItem => parseMealSummary(jsonItem)))
  | _ => Error("an array of meal summary objects was expected")
  }
}

let parseMealDetail = (json: Js.Json.t): mealDetail => {
  switch json -> classify {
  | JSONObject(obj) => 
    let id = obj -> getValue("idMeal") -> Belt.Int.fromString -> Belt.Option.getExn
    let mealName = obj -> getValue("strMeal")
    let area = obj -> getValue("strArea")
    let category = obj -> getValue("strCategory")
    let instructions = obj -> getValue("strInstructions")
    let thumbnail = obj -> getValue("strMealThumb")
    let tags = obj -> getValue("strTags") -> Js.String2.split(",")
    let youtubeLinkStr = obj -> getValue("strYoutube")
    let youtubeLink = if (youtubeLinkStr == "") {None} else {Some(youtubeLinkStr)}
    let ingredientAndMeasures = [
      (obj -> getValue("strIngredient1"), obj -> getValue("strMeasure1")),
      (obj -> getValue("strIngredient2"), obj -> getValue("strMeasure2")),      
      (obj -> getValue("strIngredient3"), obj -> getValue("strMeasure3")),
      (obj -> getValue("strIngredient4"), obj -> getValue("strMeasure4")),
      (obj -> getValue("strIngredient5"), obj -> getValue("strMeasure5")),
      (obj -> getValue("strIngredient6"), obj -> getValue("strMeasure6")),
      (obj -> getValue("strIngredient7"), obj -> getValue("strMeasure7")),
      (obj -> getValue("strIngredient8"), obj -> getValue("strMeasure8")),
      (obj -> getValue("strIngredient9"), obj -> getValue("strMeasure9")),
      (obj -> getValue("strIngredient10"), obj -> getValue("strMeasure10")),
      (obj -> getValue("strIngredient11"), obj -> getValue("strMeasure11")),
      (obj -> getValue("strIngredient12"), obj -> getValue("strMeasure12")),
      (obj -> getValue("strIngredient13"), obj -> getValue("strMeasure13")),
      (obj -> getValue("strIngredient14"), obj -> getValue("strMeasure14")),
      (obj -> getValue("strIngredient15"), obj -> getValue("strMeasure15")),
      (obj -> getValue("strIngredient16"), obj -> getValue("strMeasure16")),
      (obj -> getValue("strIngredient17"), obj -> getValue("strMeasure17")),
      (obj -> getValue("strIngredient18"), obj -> getValue("strMeasure18")),
      (obj -> getValue("strIngredient19"), obj -> getValue("strMeasure19")),
      (obj -> getValue("strIngredient20"), obj -> getValue("strMeasure20"))
    ]
    {id, mealName, area, category, instructions, thumbnail, tags, youtubeLink, ingredientAndMeasures}
  | _ => raise(PARSE_FAILED("Meal is not an object"))
  }
}
let parseResponse = (json: Js.Json.t, func: Js.Json.t => 'a) : result<array<'a>, string> => {
  try {
  switch json -> classify {
  | JSONObject(obj) =>
    switch obj -> Js.Dict.get("meals") {
    | Some(mealsArray) => 
      switch mealsArray -> classify {
      | JSONArray(array) => 
        array -> Js.Array2.map(meal => {
          meal -> func
        }) -> Ok
      | _ => raise(PARSE_FAILED("Value of meals key should be an array"))
      }
    | None => raise(PARSE_FAILED("Input JSON doesn't have a meals key"))
    }
  | _ => raise(PARSE_FAILED("A Json Object was expected as input"))
  }
  } 
  catch {
  | PARSE_FAILED(msg) => Error(msg)
  }
}

let getRandomMeal = () : promise<result<array<mealSummary>, string>> => {
  "https://www.themealdb.com/api/json/v1/1/random.php" 
  -> get 
  -> then(Response.json) 
  -> then(json => {parseResponse(json, json => parseMealSummary(json)) -> resolve})
}

let getMealsForIngredient = (ingredient: string) : promise<result<array<mealSummary>, string>> => {
  `https://www.themealdb.com/api/json/v1/1/filter.php?i=${ingredient}`
  -> get
  -> then(Response.json)
  -> then(json => {parseResponse(json, json => parseMealSummary(json)) -> resolve})
}

let getMealById = (id: int) : promise<result<mealDetail, string>> => {
  `https://www.themealdb.com/api/json/v1/1/lookup.php?i=${id -> Belt.Int.toString}`
  -> get
  -> then(Response.json)
  -> then (json => {
      switch parseResponse(json, json => parseMealDetail(json)) {
      | Ok(mealsArray) => Ok(mealsArray -> Belt.Array.get(0) -> Belt.Option.getExn)
      | Error(e) => Error(e)
      } -> resolve})
}