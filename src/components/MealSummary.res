@react.component
let make = (~meals: array<Meal.mealSummary>) => {
  `Size of Array ${meals -> Js.Array2.length -> Belt.Int.toString}`->Js.Console.log
  <section className="section-center">
  {meals 
  -> Js.Array2.mapi((meal, i) => 
      <article key={i -> Belt.Int.toString} id={i -> Belt.Int.toString} className="single-meal">
        <h4>{meal.mealName -> React.string}</h4>
        <img src={meal.thumbnail} style={{width: "200px"}}/>
      </article>
    ) 
  -> React.array}
  </section>
}