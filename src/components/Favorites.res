@react.component
let make = (~favorites : array<Meal.mealSummary>, ~removeFromFavorites, ~setSelectedMeal, ~setShowModal) => {
  let _ = Context.useGlobalContext()
  let handleImageClick = (meal: Meal.mealSummary, _) => {
    setSelectedMeal(_ => meal.id)
    setShowModal(_ => true)
  }
  let handleRemoveClick = (meal, _) => {
    removeFromFavorites(meal)
  }
  <section className="favorites">
    <div className="favorites-content">
      <h5>{"Favorites" -> React.string}</h5>
      <div className="favorites-container">
      {favorites -> Belt.Array.map(fav => {
        <div key={fav.id -> Belt.Int.toString} id={fav.id -> Belt.Int.toString} className="favorites-item">
          <img src={fav.thumbnail} className="favorites-img img" onClick={handleImageClick(fav)} title={fav.mealName} />
          <button className="remove-btn" onClick={handleRemoveClick(fav)}>{"remove" -> React.string}</button>
        </div>
      }) -> React.array}
      </div>
    </div>
  </section>
}