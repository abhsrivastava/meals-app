open Js.Promise2

type mealResult = 
| Asked
| GotError(string)
| GotResult(Meal.mealDetail)

@react.component
let make = (~selectedMeal:int, ~setShowModal) => {
  let handleClick = (_) => {
    setShowModal(_ => false)
  }

  let (mealDetailResult, setMealDetailResult) = React.useState(() => Asked)
  let _ = React.useEffect0(() => {
    Meal.getMealById(selectedMeal)
    -> then(result => 
      setMealDetailResult(_ => switch result {
      | Ok(mealDetail) => GotResult(mealDetail)
      | Error(e) => GotError(e)
      }) -> resolve)
    -> ignore
    None
  })
  let nullOrEmpty = (item: option<string>) : bool => {
    switch item {
    | Some(x) => 
      if (x == "") { false } else { true }
    | None => false
    }
  } 
  switch mealDetailResult {
  | Asked => <Spinner />
  | GotError(e) => <Error msg={e} />
  | GotResult(md) => {
    <aside className="modal-overlay">
      <div className="modal-container">
        <img src={md.thumbnail} alt={md.mealName} className="img modal-img" />
        <div className="modal-content">
          <h4>{md.mealName -> React.string}</h4>
          <p>{"Cooking Instructions"->React.string}</p>
          <p>{md.instructions -> React.string}</p>
          {
            switch nullOrEmpty(md.youtubeLink) {
            | true => 
              <div>
                <a href={md.youtubeLink -> Belt.Option.getExn} target="_blank">
                  {"youtube" -> React.string}
                </a>
              </div>
            | false => <div />
            }
          }
          <p>{"Ingredients and Measures" -> React.string}</p>
          <ul>
          {md.ingredientAndMeasures -> Belt.Array.mapWithIndex((index, (ingredient, measure)) => 
            <li key={index -> Belt.Int.toString}>
              {ingredient -> React.string} {" " -> React.string}<b>{measure -> React.string}</b>
            </li>
           ) -> React.array}
          </ul>
          <button type_="button" onClick={handleClick} className="btn btn-hipster close-btn">{"Close" -> React.string}</button>
        </div>
      </div>
    </aside>
  }
  }
}