@react.component
let make = () => {
  switch Context.useGlobalContext() {
  | GotResult(mealsArray) =>
    {
      `Size of Array ${mealsArray -> Js.Array2.length -> Belt.Int.toString}`->Js.Console.log
      mealsArray 
      -> Js.Array2.mapi((meal, i) => 
          <div key={i -> Belt.Int.toString} id={i -> Belt.Int.toString}>
            <p>{meal.mealName -> React.string}</p>
            <img src={meal.thumbnail} />
          </div>
        ) 
      -> React.array
    }
  | _ => failwith("should not come here as App is called only on Success")
  }
}