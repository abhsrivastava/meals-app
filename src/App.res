%%raw("import './styles/App.css'")

@react.component
let make = (~handleSearchTermChange, ~searchTerm, ~showModal, ~setShowModal, ~selectedMeal, ~setSelectedMeal) => {
  switch Context.useGlobalContext() {
  | GotResult({meals, _}) => 
    <main>
      <Search handleSearchTermChange searchTerm />
      <Favorites />
      <MealSummary meals setSelectedMeal setShowModal />
      { if (showModal) { <Modal selectedMeal setShowModal /> } else {<div></div>}}
    </main>
  | _ => failwith("cannot come here as the root component does not send the call here if we didn't get result")
  }
}