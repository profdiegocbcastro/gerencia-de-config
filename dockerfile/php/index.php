<?php
if ($_SERVER['REQUEST_METHOD'] === 'GET' && $_SERVER['REQUEST_URI'] === '/') {
    header('Content-Type: text/plain');
    echo 'Hello World';
    exit;
}

http_response_code(404);
echo 'Not Found';
