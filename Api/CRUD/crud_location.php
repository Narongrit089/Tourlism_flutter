<?php
include '../conn.php'; // Ensure that 'conn.php' contains your database connection logic

header("Content-Type: application/json");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, PUT, DELETE");
header("Access-Control-Allow-Headers: Origin, X-Requested-With, Content-Type, Accept");

// Function to sanitize and validate input data
function sanitize_input($data)
{
    return htmlspecialchars(strip_tags(trim($data)));
}

$response = array();

// Use $_SERVER['REQUEST_METHOD'] to get the request method
$request_method = $_SERVER["REQUEST_METHOD"];

// ใช้ $_REQUEST เพื่อรับค่า xcase
// $xcase = isset($_REQUEST['case']) ? sanitize_input($_REQUEST['case']) : null;

switch ($request_method) {
    case 'GET':
        // ตรวจสอบว่าเป็น GET request
        if ($request_method == 'GET') {
            // Retrieve locations
            $sql = "SELECT * FROM location";
            $result = mysqli_query($conn, $sql);

            if ($result) {
                $rows = array();
                while ($row = mysqli_fetch_assoc($result)) {
                    $rows[] = $row;
                }
                $response['status'] = 200;
                $response['data'] = $rows;
            } else {
                $response['status'] = 500;
                $response['message'] = "Failed to fetch locations: " . mysqli_error($conn);
            }
        } else {
            $response['status'] = 400;
            $response['message'] = "Invalid request method";
        }
        break;

    case 'POST':
        // ตรวจสอบว่าเป็น POST request
        if ($request_method == 'POST') {
            // ดึง codeLo ล่าสุด
            $query = "SELECT MAX(codeLo) AS maxCode FROM location";
            $result = mysqli_query($conn, $query);
            $row = mysqli_fetch_assoc($result);

            // ตรวจสอบว่ามีข้อมูลหรือไม่
            if ($row['maxCode'] !== null) {
                // มีข้อมูล
                $lastCode = $row['maxCode'];
            } else {
                // ไม่มีข้อมูล (ฐานข้อมูลว่าง)
                $lastCode = 0;
            }

            // นำ codeLo ล่าสุดมาบวก 1
            $newCodeLo = $lastCode + 1;

            // ทำการ INSERT ข้อมูล
            $data = json_decode(file_get_contents("php://input"), true);
            $nameLo = sanitize_input($data['nameLo']);
            $details = sanitize_input($data['details']);
            $latitude = floatval($data['latitude']);
            $longitude = floatval($data['longitude']);

            $sql = "INSERT INTO location (codeLo, nameLo, details, latitude, longitude)
                        VALUES ('$newCodeLo', '$nameLo', '$details', $latitude, $longitude)";

            if (mysqli_query($conn, $sql)) {
                $response['status'] = 201;
                $response['message'] = "Location added successfully";
            } else {
                $response['status'] = 500;
                $response['message'] = "Failed to add location: " . mysqli_error($conn);
            }
        } else {
            $response['status'] = 400;
            $response['message'] = "Invalid request method";
        }
        break;

    case 'PUT':
        // ตรวจสอบว่าเป็น PUT request
        if ($request_method == 'PUT') {
            // Update location
            $data = json_decode(file_get_contents("php://input"), true);

            // Extract data from the request
            $codeLo = sanitize_input($data['codeLo']);
            $nameLo = sanitize_input($data['nameLo']);
            $details = sanitize_input($data['details']);
            $latitude = floatval($data['latitude']);
            $longitude = floatval($data['longitude']);

            // Update location in the database using prepared statements
            // Update location in the database using prepared statements
            $sql = "UPDATE location
            SET nameLo=?, details=?, latitude=?, longitude=?
            WHERE codeLo=?";

            $stmt = mysqli_prepare($conn, $sql);

            mysqli_stmt_bind_param($stmt, "ssdds", $nameLo, $details, $latitude, $longitude, $codeLo);

            if (mysqli_stmt_execute($stmt)) {
                $response['status'] = 200;
                $response['message'] = "Location updated successfully";
            } else {
                $response['status'] = 500;
                $response['message'] = "Failed to update location: " . mysqli_stmt_error($stmt);

// บันทึกข้อผิดพลาดลงใน error logs
                error_log(mysqli_stmt_error($stmt));
            }

            mysqli_stmt_close($stmt);

        } else {
            $response['status'] = 400;
            $response['message'] = "Invalid request method";
        }

        break;

    case 'DELETE':

        $data = json_decode(file_get_contents("php://input"), true);

        // Extract data from the request
        $codeLo = sanitize_input($data['codeLo']);
        $sql = "DELETE FROM location WHERE codeLo='$codeLo'";

        if (mysqli_query($conn, $sql)) {
            $response['status'] = 200;
            $response['message'] = "User data deleted successfully";
        } else {
            $response['status'] = 500;
            $response['message'] = "Failed to delete user data: " . mysqli_error($conn);
        }
        break;

    default:
        $response['status'] = 400;
        $response['message'] = "Invalid request method";
        break;
}

echo json_encode($response);
mysqli_close($conn);
