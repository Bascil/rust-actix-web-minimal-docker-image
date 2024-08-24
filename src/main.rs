use actix_web::{get, web, App, HttpServer, Responder};

#[get("/")]
async fn index() -> impl Responder {
    "Hello, Guest!"
}

#[get("/{name}")]
async fn hello(name: web::Path<String>) -> impl Responder {
    format!("Greetings {}!", &name)
}

#[actix_web::main]
async fn main() -> std::io::Result<()> {

    let port:String = match std::env::var("PORT"){
        Ok(port) => port,
        _ => String::from("8080")
    };

    // bind to any underlying ip address
    let address: String = format!("0.0.0.0:{}", port);

    //add service binding
    HttpServer::new(|| App::new().service(index).service(hello))
        .bind(address.clone())?
        .run()
        .await
}