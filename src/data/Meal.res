open Js.Json

type meal = {
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
exception PARSE_FAILED(string)

let getValue = (obj: Js.Dict.t<Js.Json.t>, key: string) : string => {
  switch obj -> Js.Dict.get(key) {
  | Some(valueObj) => 
    switch valueObj -> classify {
    | JSONString(value) => value
    | _ => raise(PARSE_FAILED(`value of ${key} is not a string`))
    }
  | None => raise(PARSE_FAILED(`${key} not found in meal json`))
  }
}

let parseMeal = (json: Js.Json.t): meal => {
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
let parseResponse = (json: Js.Json.t) : Belt.Result.t<array<meal>, string> => {
  // first let us log the json as-is
  json -> Js.Json.stringify -> Js.Console.log
  try {
  switch json -> classify {
  | JSONObject(obj) =>
    switch obj -> Js.Dict.get("meals") {
    | Some(mealsArray) => 
      switch mealsArray -> classify {
      | JSONArray(array) => 
        array -> Js.Array2.map(meal => {
          meal -> parseMeal
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

let getRandomMeal = () : promise<Belt.Result.t<array<meal>, string>> => {
  open Js.Promise2
  open Fetch
  "https://www.themealdb.com/api/json/v1/1/random.php" 
  -> get 
  -> then(Response.json) 
  -> then(json => {parseResponse(json) -> resolve})
}