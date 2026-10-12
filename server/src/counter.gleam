// IMPORTS ---------------------------------------------------------------------

import gleam/int
import gleam/result
import lustre
import lustre/attribute.{type Attribute}
import lustre/component
import lustre/effect.{type Effect}
import lustre/element.{type Element}
import lustre/element/html
import lustre/event

// MAIN ------------------------------------------------------------------------

pub fn component() -> lustre.App(_, Model, Message) {
  lustre.component(init, update, view, [
    component.on_attribute_change("value", fn(value) {
      int.parse(value) |> result.map(ParentChangedValue)
    }),
  ])
}

pub fn value(value: Int) -> Attribute(message) {
  attribute.value(int.to_string(value))
}

// MODEL -----------------------------------------------------------------------

pub type Model =
  Int

fn init(_) -> #(Model, Effect(Message)) {
  #(0, effect.none())
}

// UPDATE ----------------------------------------------------------------------

pub opaque type Message {
  ParentChangedValue(Int)
  UserClickedIncrement
  UserClickedDecrement
}

fn update(model: Model, message: Message) -> #(Model, Effect(Message)) {
  case message {
    ParentChangedValue(value) -> #(value, effect.none())
    UserClickedIncrement -> #(model + 1, effect.none())
    UserClickedDecrement -> #(model - 1, effect.none())
  }
}

// VIEW ------------------------------------------------------------------------

fn view(model: Model) -> Element(Message) {
  let count = int.to_string(model)
  let styles = [#("display", "flex"), #("justify-content", "space-between")]

  html.div([attribute.styles(styles)], [
    view_button(label: "-", on_click: UserClickedDecrement),
    html.p([], [html.text("Count: "), html.text(count)]),
    view_button(label: "+", on_click: UserClickedIncrement),
  ])
}

fn view_button(
  label label: String,
  on_click handle_click: message,
) -> Element(message) {
  html.button([event.on_click(handle_click)], [html.text(label)])
}
