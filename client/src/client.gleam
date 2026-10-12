// IMPORTS ---------------------------------------------------------------------

import gleam/int
import lustre
import lustre/attribute
import lustre/element.{text}
import lustre/element/html.{button, div}
import lustre/event.{on_click}
import lustre/server_component

// MAIN ------------------------------------------------------------------------

pub fn main() -> Nil {
  let app = lustre.simple(init, update, view)
  let assert Ok(_) = lustre.start(app, "#app", Nil)

  Nil
}

// MODEL -----------------------------------------------------------------------

pub type Model {
  Model(view: Int)
}

fn init(_flags) -> Model {
  Model(1)
}

// UPDATE ----------------------------------------------------------------------

type Message {
  View1
  View2
  View3
}

fn update(_model: Model, message: Message) -> Model {
  case message {
    View1 -> Model(1)
    View2 -> Model(2)
    View3 -> Model(3)
  }
}

// VIEW ------------------------------------------------------------------------

fn view(model: Model) -> element.Element(Message) {
  div([], [
    html.p([], [
      html.text(
        "There are two registered server components, counter1 and counter2. "
        <> "Both use the same counter server component. "
        <> "For some reason, when switching between component counter1 and counter2, "
        <> "the \"on_attribute_change\" event is not triggered: "
        <> "View 1 -> View 2 ✅, View 2 -> View 1 ✅, View 1/2 -> View 3 ❌, "
        <> " View 3 -> View 1/2 ❌.",
      ),
    ]),
    html.div([], [
      button([on_click(View1)], [text("View 1")]),
      button([on_click(View2)], [text("View 2")]),
      button([on_click(View3)], [text("View 3")]),
    ]),
    case model.view {
      1 -> view_counter_1()
      2 -> view_counter_2()
      3 -> view_counter_3()
      _ -> html.text("Invalid view")
    },
  ])
}

fn view_counter_1() -> element.Element(Message) {
  let value = 10

  html.div([], [
    view_counter_info(value, "counter1"),
    server_component.element(
      [
        server_component.route("/ws/counter1"),
        attribute.attribute("value", int.to_string(value)),
      ],
      [],
    ),
  ])
}

fn view_counter_2() -> element.Element(Message) {
  let value = 20

  html.div([], [
    view_counter_info(value, "counter1"),
    server_component.element(
      [
        server_component.route("/ws/counter1"),
        attribute.attribute("value", int.to_string(value)),
      ],
      [],
    ),
  ])
}

fn view_counter_3() -> element.Element(Message) {
  let value = 30

  html.div([], [
    view_counter_info(value, "counter2"),
    // NOTE: Uncommenting the line below resolves the issue
    // html.text(""),
    server_component.element(
      [
        server_component.route("/ws/counter2"),
        attribute.attribute("value", int.to_string(value)),
      ],
      [],
    ),
  ])
}

fn view_counter_info(
  value: Int,
  component_name: String,
) -> element.Element(Message) {
  html.p([], [
    html.text(
      "attribute \"value\" set to \""
      <> int.to_string(value)
      <> "\" on \""
      <> component_name
      <> "\" -> Count should be \""
      <> int.to_string(value)
      <> "\"",
    ),
  ])
}
