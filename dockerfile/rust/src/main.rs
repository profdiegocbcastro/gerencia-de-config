use std::io::{Read, Write};
use std::net::TcpListener;

fn main() {
    let listener = TcpListener::bind("0.0.0.0:8088").unwrap();

    for stream in listener.incoming() {
        if let Ok(mut stream) = stream {
            let mut buffer = [0; 1024];
            let _ = stream.read(&mut buffer);
            let request = String::from_utf8_lossy(&buffer);

            if request.starts_with("GET / HTTP/1.1") || request.starts_with("GET / HTTP/1.0") {
                let response = "HTTP/1.1 200 OK\r\nContent-Type: text/plain\r\nContent-Length: 11\r\n\r\nHello World";
                let _ = stream.write_all(response.as_bytes());
            } else {
                let response = "HTTP/1.1 404 Not Found\r\nContent-Length: 0\r\n\r\n";
                let _ = stream.write_all(response.as_bytes());
            }
        }
    }
}
