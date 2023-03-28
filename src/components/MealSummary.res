open ReactIcons

@react.component
let make = (~meals: array<Meal.mealSummary>, ~setSelectedMeal) => {
  let handleClick = (event: ReactEvent.Mouse.t) => {
    let id = ReactEvent.Mouse.currentTarget(event)["id"] 
    Js.Console.log(`Selected Meal {id -> Belt.Int.toString}`)
    setSelectedMeal(_ => id)
  }
  <section className="section-center">
  {meals 
  -> Js.Array2.map(meal => 
      <article key={meal.id -> Belt.Int.toString} id={meal.id -> Belt.Int.toString} className="single-meal">
        <img src={meal.thumbnail} className="img" onClick={handleClick} />
        <footer>
          <h5>{meal.mealName -> React.string}</h5>
          <button className="like-btn"><BsHandThumbsUpFill /></button>
        </footer>
      </article>
    ) 
  -> React.array}
  </section>
}