@react.component
let make = (~meals: array<Meal.meal>) => {
  `Size of Array ${meals -> Js.Array2.length -> Belt.Int.toString}`->Js.Console.log
  meals 
  -> Js.Array2.mapi((meal, i) => 
      <div key={i -> Belt.Int.toString} id={i -> Belt.Int.toString}>
        <p>{meal.mealName -> React.string}</p>
        <img src={meal.thumbnail} />
      </div>
    ) 
  -> React.array
}