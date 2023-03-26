open ReactIcons

@react.component
let make = (~meals: array<Meal.mealSummary>) => {
  <section className="section-center">
  {meals 
  -> Js.Array2.map(meal => 
      <article key={meal.id -> Belt.Int.toString} id={meal.id -> Belt.Int.toString} className="single-meal">
        <img src={meal.thumbnail} className="img" />
        <footer>
          <h5>{meal.mealName -> React.string}</h5>
          <button className="like-btn"><BsHandThumbsUpFill /></button>
        </footer>
      </article>
    ) 
  -> React.array}
  </section>
}