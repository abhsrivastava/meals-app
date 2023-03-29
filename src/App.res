%%raw("import './styles/App.css'")

@react.component
let make = (~handleSearchTermChange, ~searchTerm, ~showModal, ~setShowModal, ~selectedMeal, ~setSelectedMeal, ~favorites: array<Meal.mealSummary>, ~addToFavorites, ~removeFromFavorites) => {
  switch Context.useGlobalContext() {
  | GotResult({meals, _}) => 
    <main>
      <Search handleSearchTermChange searchTerm />
      { if (favorites -> Belt.Array.length == 0) {
        <div />
      } else {
        <Favorites favorites removeFromFavorites setShowModal setSelectedMeal/>
      }}
      <MealSummary meals setSelectedMeal setShowModal addToFavorites/>
      { if (showModal) { <Modal selectedMeal setShowModal /> } else {<div />}}
    </main>
  | _ => failwith("cannot come here as the root component does not send the call here if we didn't get result")
  }
}