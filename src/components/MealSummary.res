open ReactIcons

@react.component
let make = (~meals: array<Meal.mealSummary>, ~setSelectedMeal, ~setShowModal, ~addToFavorites) => {
  let handleClick = (id: int, _) => {
    setSelectedMeal(_ => id)
    setShowModal(_ => true)
  }
  let handleFavoriteClick = (meal: Meal.mealSummary, _) => {
    addToFavorites({meal})    
  }
  <section className="section-center">
  {meals 
  -> Js.Array2.map(meal => 
      <article key={meal.id -> Belt.Int.toString} id={meal.id -> Belt.Int.toString} className="single-meal">
        <img src={meal.thumbnail} className="img" onClick={handleClick(meal.id)} />
        <footer>
          <h5>{meal.mealName -> React.string}</h5>
          <button className="like-btn" onClick={handleFavoriteClick(meal)}><BsHandThumbsUpFill /></button>
        </footer>
      </article>
    ) 
  -> React.array}
  </section>
}