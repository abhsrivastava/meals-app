@react.component
let make = (~msg: string) => {
    <div>
        <h5>{`Could not fetch data from api ${msg}` -> React.string}</h5>
    </div>
}