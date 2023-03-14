@react.component
let make = (~msg: string) => {
    <div>
        {`Could not fetch data from api ${msg}` -> React.string}
    </div>
}