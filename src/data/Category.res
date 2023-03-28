open Js.Json

type category = {
  id: int,
  categoryName: string,
  categoryDescription: string,
  categoryThumbnail: string
}

let getValue = (json: Js.Dict.t<Js.Json.t>, key: string) : Belt.Result.t<string, string> => {
  switch json -> Js.Dict.get(key) {
  | Some(value) => 
    switch value -> classify {
    | JSONString(strValue) => Belt.Result.Ok(strValue)
    | _ => Belt.Result.Error(`key: ${key} value is not a string`)
    }
  | None => Belt.Result.Error(`key: ${key} not found in json`)
  }
}
let parseResponse = (json: Js.Json.t) : Belt.Result.t<array<category>, string> => {
  open Belt.Result
  switch json -> classify {
  | JSONObject(obj) => 
    switch obj -> Js.Dict.get("categories") {
    | Some(categoryListObj) => 
      switch categoryListObj -> classify {
      | JSONArray(categoryList) => 
        let result : array<Belt.Result.t<category, string>> = categoryList -> Belt.Array.map(categoryObj => {
          switch categoryObj -> classify {
          | JSONObject(category) => 
            switch category -> getValue("idCategory") {
            | Ok(idCategory) => 
              switch category -> getValue("strCategory") {
              | Ok(categoryName) => 
                switch category -> getValue("strCategoryThumb") {
                | Ok(categoryThumbnail) => 
                  switch category -> getValue("strCategoryDescription") {
                  | Ok(categoryDescription) => 
                    Ok({
                      id: idCategory -> Belt.Int.fromString->Belt.Option.getExn,
                      categoryName,
                      categoryDescription,
                      categoryThumbnail
                    })
                  | Error(e) => Error(e)
                  }
                | Error(e) => Error(e)
                }
              | Error(e) => Error(e)
              }
            | Error(e) => Error(e)
            }
          | _ => Error("category should be an object")
          }
        }) // end of array map
        // if any item in the array is an error then return error. if all items are success then return success.
        let flag = result -> Belt.Array.every(element => {
          switch element {
          | Belt.Result.Ok(_) => true
          | Belt.Result.Error(_) => false
          }
        })
        if (flag) {
          Ok(result -> Belt.Array.map(mealResult => 
          switch mealResult {
          | Ok(meal) => meal
          | _ => failwith("cannot come here because we already checked if every item is a success")
          }
          ))
        } else {
          Error("Json parse failed for one of the meal items")
        }
      | _ => Error("categories should be an array")
      } 
    | None => Error("categories key not found in resonse")
    }
  | _ => Error("Passed json is not an object")
  }
}

let getCategoryList = () : promise<result<array<category>, string>> => {
  open Fetch
  open Js.Promise2
  "https://www.themealdb.com/api/json/v1/1/categories.php"
  -> get
  -> then(Response.json)
  -> then(json => parseResponse(json) -> resolve)
}