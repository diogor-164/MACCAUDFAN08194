<?php
// Database connection parameters
$servername = "localhost";
$username = "root"; // Replace with your MySQL username
$password = "root"; // Replace with your MySQL password
$database = "fcmonthey_caisse";

// Create connection
$conn = new mysqli($servername, $username, $password, $database);

// Check connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

// Get the SQL query from POST data
$query = $_POST['query'];

// Execute the SQL query
if ($conn->query($query) === TRUE) {
    echo "Query executed successfully.";
} else {
    echo "Error executing query: " . $conn->error;
}

// Close the database connection
$conn->close();
?>