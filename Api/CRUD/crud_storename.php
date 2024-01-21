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
        $sql = "SELECT * FROM storename";
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
            $response['message'] = "Failed to fetch store names: " . mysqli_error($conn);
        }
        break;

    case 'POST':
        $data = json_decode(file_get_contents("php://input"), true);
        $storeName = sanitize_input($data['storeName']);
        $typeCode = sanitize_input($data['typeCode']);

        // ดึงค่า storeCode ล่าสุดจากฐานข้อมูล
        $getLastStoreCodeSql = "SELECT MAX(storeCode) AS maxStoreCode FROM storename";
        $result = mysqli_query($conn, $getLastStoreCodeSql);

        if ($result) {
            $row = mysqli_fetch_assoc($result);
            $maxStoreCode = $row['maxStoreCode'];

            // เพิ่ม 1 เข้าไปใน storeCode ใหม่
            $newStoreCode = $maxStoreCode + 1;

            // เพิ่มข้อมูลเข้าฐานข้อมูล
            $sql = "INSERT INTO storename (storeCode, storeName, typeCode) VALUES ('$newStoreCode', '$storeName', '$typeCode')";

            if (mysqli_query($conn, $sql)) {
                $response['status'] = 200;
                $response['message'] = "Store name added successfully";
            } else {
                $response['status'] = 500;
                $response['message'] = "Failed to add store name: " . mysqli_error($conn);
            }
        } else {
            $response['status'] = 500;
            $response['message'] = "Failed to get last storeCode: " . mysqli_error($conn);
        }
        break;

    case 'PUT':
        $data = json_decode(file_get_contents("php://input"), true);
        $storeCode = sanitize_input($data['storeCode']);
        $storeName = sanitize_input($data['storeName']);
        $typeCode = sanitize_input($data['typeCode']);

        $sql = "UPDATE storename SET storeName='$storeName', typeCode='$typeCode' WHERE storeCode='$storeCode'";

        if (mysqli_query($conn, $sql)) {
            $response['status'] = 200;
            $response['message'] = "Store name updated successfully";
        } else {
            $response['status'] = 500;
            $response['message'] = "Failed to update store name: " . mysqli_error($conn);
        }
        break;

    case 'DELETE':
        $data = json_decode(file_get_contents("php://input"), true);
        $storeCode = sanitize_input($data['storeCode']);

        $sql = "DELETE FROM storename WHERE storeCode='$storeCode'";

        if (mysqli_query($conn, $sql)) {
            $response['status'] = 200;
            $response['message'] = "Store name deleted successfully";
        } else {
            $response['status'] = 500;
            $response['message'] = "Failed to delete store name: " . mysqli_error($conn);
        }
        break;

    default:
        $response['status'] = 400;
        $response['message'] = "Invalid request method";
        break;
}

echo json_encode($response);
mysqli_close($conn);
