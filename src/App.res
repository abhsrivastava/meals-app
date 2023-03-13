%%raw("import './styles/App.css'")

@react.component
let make = () => {
  <main>
    <Search />
    <Favorites />
    <Meals />
    <Modal />
  </main>
}