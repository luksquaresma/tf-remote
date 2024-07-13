use axum::{
    body::Body,
    routing::get,
    response::Json,
    Router,
};
use serde_json::{Value, json};

// `&'static str` becomes a `200 OK` with `content-type: text/plain; charset=utf-8`
async fn plain_text() -> &'static str {
    "foo"
}

// `Json` gives a content-type of `application/json` and works with any type
// that implements `serde::Serialize`
async fn json() -> Json<Value> {
    Json(json!({ "data": 42 }))
}

let app = Router::new()
    .route("/plain_text", get(plain_text))
    .route("/json", get(json));