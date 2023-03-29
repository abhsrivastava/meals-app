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
                    areas: areaArray,
                    favorites: []
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
    let (showModal, setShowModal) = React.useState(() => false)
    let (selectedMeal, setSelectedMeal) = React.useState(() => 0)
    let (favorites, setFavorites) = React.useState(() => [])

    let addToFavorites = (meal: Meal.mealSummary) => {
      setFavorites(_ => {
        if (favorites -> Belt.Array.some((m: Meal.mealSummary) => m.id == meal.id)) {
          favorites
        } else {
          favorites -> Belt.Array.concat([meal])
        }
      })
    }

    let removeFromFavorites = (meal: Meal.mealSummary) => {
      setFavorites(_ => favorites -> Belt.Array.keep(x => x.id != meal.id))
    }
    let handleSearchTermChange = (msg: Context.msg) => {
      switch msg {
        | Context.RandomMeal => setSearchTerm(_ => "")
        | Context.Ingredient(ingredient) => setSearchTerm(_ => ingredient)
        | Context.SelectedMeal(id) => 
          setShowModal(_ => true)
          setSelectedMeal(_ => id)
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
    | _ => 
      <Context.Provider value={state}>
        <App handleSearchTermChange searchTerm showModal setShowModal selectedMeal setSelectedMeal favorites addToFavorites removeFromFavorites/>
      </Context.Provider>
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
| None => 
  Js.Console.log("Could not find the main div") -> ignore
  failwith("Could not find the main div")
}