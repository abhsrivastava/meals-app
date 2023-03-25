open Js.Promise2
module Root = {
  let getDefaultState = (searchTerm) : promise<Context.state> => {
      if (searchTerm != "") {Meal.getMealsForIngredient(searchTerm)} else {Meal.getRandomMeal()}
      -> then(mealResponse => {
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
  }
  @react.component
  let make = () => {
    // state for search term
    let (searchTerm, setSearchTerm) = React.useState(() => "chicken")
    let handleSearchTermChange = (msg: Context.msg) => {
      switch msg {
        | Context.RandomMeal => setSearchTerm(_ => "")
        | Context.Ingredient(ingredient) => setSearchTerm(_ => ingredient)
      }
    }
    let (state, setState) = React.useState(() => Context.NotAsked)
    let _ = React.useEffect1(() => {
      getDefaultState(searchTerm)
      -> then(contextResult => setState(_ => contextResult) -> resolve) 
      -> ignore
      None
    }, [searchTerm])
    switch state {
    | NotAsked => <Spinner />
    | GotError(e) => <Error msg={e} />
    | _ => <Context.Provider value={state}><App handleSearchTermChange searchTerm/></Context.Provider>
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