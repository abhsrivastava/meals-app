%%raw("import '../styles/Spinner.css'")

@react.component
let make = () => {
    <div className="loader-container">
      <div className="loader" />
      <h1>{"Loading...." -> React.string}</h1>
    </div>
}