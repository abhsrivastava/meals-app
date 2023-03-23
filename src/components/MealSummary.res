open ReactIcons

@react.component
let make = (~meals: array<Meal.mealSummary>) => {
  `Size of Array ${meals -> Js.Array2.length -> Belt.Int.toString}`->Js.Console.log
  <section className="section-center">
  {meals 
  -> Js.Array2.mapi((meal, i) => 
      <article key={i -> Belt.Int.toString} id={i -> Belt.Int.toString} className="single-meal">
        <img src={meal.thumbnail} className="img" />
        <footer>
          <h5>{meal.mealName -> React.string}</h5>
          <button className="like-btn"><BsHandsThumbsUp /></button>
        </footer>
      </article>
    ) 
  -> React.array}
  </section>
}