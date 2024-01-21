-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jan 18, 2024 at 05:18 AM
-- Server version: 10.4.28-MariaDB
-- PHP Version: 8.0.28

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `tourlism_project`
--

-- --------------------------------------------------------

--
-- Table structure for table `bustable`
--

CREATE TABLE `bustable` (
  `no` int(5) NOT NULL,
  `time` time NOT NULL,
  `codeLo` varchar(5) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Dumping data for table `bustable`
--

INSERT INTO `bustable` (`no`, `time`, `codeLo`) VALUES
(1, '08:00:00', '001'),
(2, '10:30:00', '002'),
(3, '14:45:00', '003');

-- --------------------------------------------------------

--
-- Table structure for table `location`
--

CREATE TABLE `location` (
  `codeLo` varchar(5) NOT NULL,
  `nameLo` varchar(100) NOT NULL,
  `details` varchar(255) NOT NULL,
  `latitude` float NOT NULL,
  `longitude` float NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Dumping data for table `location`
--

INSERT INTO `location` (`codeLo`, `nameLo`, `details`, `latitude`, `longitude`) VALUES
('001', 'สวนสาธารณะ', 'สวยงาม', 13.7563, 100.502),
('002', 'วัด', 'โบราณสถาน', 14.0583, 99.3628),
('003', 'ทะเล', 'ทะเลสวยงาม', 7.8804, 98.3923);

-- --------------------------------------------------------

--
-- Table structure for table `storename`
--

CREATE TABLE `storename` (
  `storeCode` varchar(5) NOT NULL,
  `storeName` varchar(100) NOT NULL,
  `typeCode` varchar(5) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Dumping data for table `storename`
--

INSERT INTO `storename` (`storeCode`, `storeName`, `typeCode`) VALUES
('1001', 'ร้านอาหาร', '101'),
('1002', 'ร้านเสื้อผ้า', '102'),
('1003', 'ร้านหนังสือ', '103');

-- --------------------------------------------------------

--
-- Table structure for table `storetype`
--

CREATE TABLE `storetype` (
  `typeCode` varchar(5) NOT NULL,
  `typeName` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Dumping data for table `storetype`
--

INSERT INTO `storetype` (`typeCode`, `typeName`) VALUES
('101', 'อาหาร'),
('102', 'เสื้อผ้า'),
('103', 'หนังสือ');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `user_id` varchar(5) NOT NULL,
  `firstname` varchar(30) NOT NULL,
  `lastname` varchar(30) NOT NULL,
  `email` varchar(30) NOT NULL,
  `password` varchar(20) NOT NULL,
  `phone` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`user_id`, `firstname`, `lastname`, `email`, `password`, `phone`) VALUES
('', 'AA', 'BB', 'admin', '123', '099999999'),
('00001', 'Narongrit', 'Suaysom', '641463014@crru.ac.th', 'save12345', '0621653986');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `bustable`
--
ALTER TABLE `bustable`
  ADD PRIMARY KEY (`no`);

--
-- Indexes for table `location`
--
ALTER TABLE `location`
  ADD PRIMARY KEY (`codeLo`);

--
-- Indexes for table `storename`
--
ALTER TABLE `storename`
  ADD PRIMARY KEY (`storeCode`);

--
-- Indexes for table `storetype`
--
ALTER TABLE `storetype`
  ADD PRIMARY KEY (`typeCode`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`user_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
