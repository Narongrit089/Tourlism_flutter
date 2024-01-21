<?php
include '../conn.php';

header("Content-Type: application/json");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, PUT, DELETE");
header("Access-Control-Allow-Headers: Origin, X-Requested-With, Content-Type, Accept");

function sanitize_input($data)
{
    return htmlspecialchars(strip_tags(trim($data)));
}

$response = array();
$request_method = $_SERVER["REQUEST_METHOD"];

switch ($request_method) {
    case 'GET':
        $sql = "SELECT * FROM bustable";
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
            $response['message'] = "Failed to fetch bus information: " . mysqli_error($conn);
        }
        break;

    case 'POST':
        $data = json_decode(file_get_contents("php://input"), true);
        $time = sanitize_input($data['time']);
        $codeLo = sanitize_input($data['codeLo']);

        // Get the latest no and increment it by 1
        $getLastNoQuery = "SELECT MAX(`no`) AS maxNo FROM bustable";
        $lastNoResult = mysqli_query($conn, $getLastNoQuery);

        if ($lastNoResult) {
            $lastNoRow = mysqli_fetch_assoc($lastNoResult);
            $latestNo = $lastNoRow['maxNo'];
            $newNo = $latestNo + 1;
        } else {
            $newNo = 1; // Default value if no data in the table
        }

        $sql = "INSERT INTO bustable (`no`, `time`, `codeLo`) VALUES ('$newNo', '$time', '$codeLo')";

        if (mysqli_query($conn, $sql)) {
            $response['status'] = 200;
            $response['message'] = "Bus information added successfully";
        } else {
            $response['status'] = 500;
            $response['message'] = "Failed to add bus information: " . mysqli_error($conn);
        }
        break;

    case 'PUT':
        $data = json_decode(file_get_contents("php://input"), true);
        $no = sanitize_input($data['no']);
        $time = sanitize_input($data['time']);
        $codeLo = sanitize_input($data['codeLo']);

        $sql = "UPDATE bustable SET time='$time', codeLo='$codeLo' WHERE no='$no'";

        if (mysqli_query($conn, $sql)) {
            $response['status'] = 200;
            $response['message'] = "Bus information updated successfully";
        } else {
            $response['status'] = 500;
            $response['message'] = "Failed to update bus information: " . mysqli_error($conn);
        }
        break;

    case 'DELETE':
        $data = json_decode(file_get_contents("php://input"), true);
        $no = sanitize_input($data['no']);

        $sql = "DELETE FROM bustable WHERE no='$no'";

        if (mysqli_query($conn, $sql)) {
            $response['status'] = 200;
            $response['message'] = "Bus information deleted successfully";
        } else {
            $response['status'] = 500;
            $response['message'] = "Failed to delete bus information: " . mysqli_error($conn);
        }
        break;

    default:
        $response['status'] = 400;
        $response['message'] = "Invalid request method";
        break;
}

echo json_encode($response);
mysqli_close($conn);
