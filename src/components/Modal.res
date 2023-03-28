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
            switch md.youtubeLink {
            | Some(link) => 
              <div>
                <p>{"youtube" -> React.string}</p>
                <a href={link} target="_blank" />
              </div>
            | None => <div />
            }
          }
          <p>{"Ingredients and Measures" -> React.string}</p>
          <ul>
          {md.ingredientAndMeasures -> Belt.Array.map(((ingredient, measure)) => 
            <li>{ingredient -> React.string} {" " -> React.string}<b>{measure -> React.string}</b></li>
           ) -> React.array}
          </ul>
          <button type_="button" onClick={handleClick}>{"Close" -> React.string}</button>
        </div>
      </div>
    </aside>
  }
  }
}