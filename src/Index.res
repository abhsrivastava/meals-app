
module Root = {
  @react.component
  let make = () => {
    let (state, setState) = React.useState(() => Context.NotAsked)
    let _ = React.useEffect0(() => {
      open Js.Promise2
      Meal.getMealsForCategory("Lamb") -> then(mealResponse => {
        switch mealResponse {
        | Belt.Result.Ok(mealsArray) => // so the calls for meals array is successful. now let's make the call for Categories
          Category.getCategoryList() -> then (categoryResponse => {
            switch categoryResponse {
            | Belt.Result.Ok(categoryArray) => 
              Area.getAreaList() -> then(areaResponse => {
                switch areaResponse {
                | Ok(areaArray) =>
                  Context.GotResult({
                    meals: mealsArray,
                    categories: categoryArray,
                    areas: areaArray
                  }) -> resolve
                | Error(e) => Context.GotError(e) -> resolve
                }
              })
            | Belt.Result.Error(e) => Context.GotError(e) -> resolve
            }
          })
        | Belt.Result.Error(msg) => Context.GotError(msg) -> resolve
        }
      })
      -> then(contextResult => setState(_ => contextResult) -> resolve) 
      -> ignore
      None
    })
    switch state {
    | NotAsked => <Spinner />
    | GotError(e) => <Error msg={e} />
    | _ => <Context.Provider value={state}><App /></Context.Provider>
    }
  }
}

switch ReactDOM.querySelector("#main") {
| Some(rootElement) => 
  ReactDOM.Client.Root.render(
    ReactDOM.Client.createRoot(rootElement), 
    <React.StrictMode>
        <Root />
    </React.StrictMode>
  )
| None => Js.Console.log("Could not find the main div")
}