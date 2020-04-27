-- phpMyAdmin SQL Dump
-- version 4.8.5
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Apr 27, 2020 at 01:36 PM
-- Server version: 10.1.38-MariaDB
-- PHP Version: 7.3.4

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `fivemserver`
--

-- --------------------------------------------------------

--
-- Table structure for table `addon_account`
--

CREATE TABLE `addon_account` (
  `name` varchar(60) NOT NULL,
  `label` varchar(100) NOT NULL,
  `shared` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `addon_account_data`
--

CREATE TABLE `addon_account_data` (
  `id` int(11) NOT NULL,
  `account_name` varchar(100) DEFAULT NULL,
  `money` int(11) NOT NULL,
  `owner` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `addon_inventory`
--

CREATE TABLE `addon_inventory` (
  `name` varchar(60) NOT NULL,
  `label` varchar(100) NOT NULL,
  `shared` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `addon_inventory_items`
--

CREATE TABLE `addon_inventory_items` (
  `id` int(11) NOT NULL,
  `inventory_name` varchar(100) NOT NULL,
  `name` varchar(100) NOT NULL,
  `count` int(11) NOT NULL,
  `owner` varchar(60) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `billing`
--

CREATE TABLE `billing` (
  `id` int(11) NOT NULL,
  `identifier` varchar(40) NOT NULL,
  `sender` varchar(40) NOT NULL,
  `target_type` varchar(50) NOT NULL,
  `target` varchar(40) NOT NULL,
  `label` varchar(255) NOT NULL,
  `amount` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `characters`
--

CREATE TABLE `characters` (
  `id` int(11) NOT NULL,
  `identifier` varchar(255) NOT NULL,
  `firstname` varchar(255) NOT NULL,
  `lastname` varchar(255) NOT NULL,
  `dateofbirth` varchar(255) NOT NULL,
  `sex` varchar(1) NOT NULL DEFAULT 'M',
  `height` varchar(128) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `characters`
--

INSERT INTO `characters` (`id`, `identifier`, `firstname`, `lastname`, `dateofbirth`, `sex`, `height`) VALUES
(1, 'steam:11000010e80e775', 'Leonard', 'Monosa', '2000082000', 'm', '180'),
(2, 'steam:11000011bbeb00b', 'Leonaard', 'Ganteng', '2000082000', 'm', '165');

-- --------------------------------------------------------

--
-- Table structure for table `datastore`
--

CREATE TABLE `datastore` (
  `name` varchar(60) NOT NULL,
  `label` varchar(100) NOT NULL,
  `shared` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `datastore_data`
--

CREATE TABLE `datastore_data` (
  `id` int(11) NOT NULL,
  `name` varchar(60) NOT NULL,
  `owner` varchar(60) DEFAULT NULL,
  `data` longtext
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `items`
--

CREATE TABLE `items` (
  `name` varchar(50) NOT NULL,
  `label` varchar(50) NOT NULL,
  `limit` int(11) NOT NULL DEFAULT '-1',
  `rare` int(11) NOT NULL DEFAULT '0',
  `can_remove` int(11) NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `items`
--

INSERT INTO `items` (`name`, `label`, `limit`, `rare`, `can_remove`) VALUES
('bread', 'Roti', 10, 0, 1),
('water', 'Air', 5, 0, 1);

-- --------------------------------------------------------

--
-- Table structure for table `jobs`
--

CREATE TABLE `jobs` (
  `name` varchar(50) NOT NULL,
  `label` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `jobs`
--

INSERT INTO `jobs` (`name`, `label`) VALUES
('unemployed', 'Unemployed');

-- --------------------------------------------------------

--
-- Table structure for table `job_grades`
--

CREATE TABLE `job_grades` (
  `id` int(11) NOT NULL,
  `job_name` varchar(50) DEFAULT NULL,
  `grade` int(11) NOT NULL,
  `name` varchar(50) NOT NULL,
  `label` varchar(50) NOT NULL,
  `salary` int(11) NOT NULL,
  `skin_male` longtext NOT NULL,
  `skin_female` longtext NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `job_grades`
--

INSERT INTO `job_grades` (`id`, `job_name`, `grade`, `name`, `label`, `salary`, `skin_male`, `skin_female`) VALUES
(1, 'unemployed', 0, 'unemployed', 'Unemployed', 200, '{}', '{}');

-- --------------------------------------------------------

--
-- Table structure for table `society_moneywash`
--

CREATE TABLE `society_moneywash` (
  `id` int(11) NOT NULL,
  `identifier` varchar(60) NOT NULL,
  `society` varchar(60) NOT NULL,
  `amount` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `identifier` varchar(50) COLLATE utf8mb4_bin DEFAULT NULL,
  `license` varchar(50) COLLATE utf8mb4_bin DEFAULT NULL,
  `money` int(11) DEFAULT NULL,
  `name` varchar(50) COLLATE utf8mb4_bin DEFAULT '',
  `skin` longtext COLLATE utf8mb4_bin,
  `job` varchar(50) COLLATE utf8mb4_bin DEFAULT 'unemployed',
  `job_grade` int(11) DEFAULT '0',
  `loadout` longtext COLLATE utf8mb4_bin,
  `position` varchar(36) COLLATE utf8mb4_bin DEFAULT NULL,
  `bank` int(11) DEFAULT NULL,
  `permission_level` int(11) DEFAULT NULL,
  `group` varchar(50) COLLATE utf8mb4_bin DEFAULT NULL,
  `firstname` varchar(50) COLLATE utf8mb4_bin DEFAULT '',
  `lastname` varchar(50) COLLATE utf8mb4_bin DEFAULT '',
  `dateofbirth` varchar(25) COLLATE utf8mb4_bin DEFAULT '',
  `sex` varchar(10) COLLATE utf8mb4_bin DEFAULT '',
  `height` varchar(5) COLLATE utf8mb4_bin DEFAULT '',
  `status` longtext COLLATE utf8mb4_bin
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`identifier`, `license`, `money`, `name`, `skin`, `job`, `job_grade`, `loadout`, `position`, `bank`, `permission_level`, `group`, `firstname`, `lastname`, `dateofbirth`, `sex`, `height`, `status`) VALUES
('steam:1100001116dfeb2', 'license:91be536483b511daa6160ed03d588f3769600253', 0, 'Kanan Kiri', NULL, 'unemployed', 0, '[]', '{\"z\":29.2,\"y\":-880.1,\"x\":272.0}', 200, 0, 'user', '', '', '', '', '', NULL),
('steam:11000010deed507', 'license:44292180ed1286953e17e8e226b4359073e617c4', 0, 'Butterfly', NULL, 'unemployed', 0, '[]', '{\"z\":30.4,\"y\":-805.4,\"x\":238.0}', 200, 0, 'user', '', '', '', '', '', NULL),
('steam:11000010e80e775', 'license:d4ff6a38b92b98d3b80d4f41bbb0622b059d7378', 0, 'LeonarD', '{\"blush_3\":0,\"sun_1\":0,\"blush_2\":0,\"sex\":0,\"glasses_1\":0,\"hair_color_2\":0,\"eyebrows_1\":0,\"hair_color_1\":0,\"sun_2\":0,\"lipstick_4\":0,\"torso_1\":0,\"bracelets_1\":-1,\"hair_2\":0,\"blemishes_2\":0,\"arms\":0,\"chest_1\":0,\"glasses_2\":0,\"decals_2\":0,\"lipstick_1\":0,\"helmet_2\":0,\"bproof_2\":0,\"age_2\":0,\"ears_1\":-1,\"beard_2\":0,\"pants_1\":0,\"bodyb_1\":0,\"shoes_1\":0,\"makeup_1\":0,\"bracelets_2\":0,\"eyebrows_4\":0,\"chain_2\":0,\"lipstick_3\":0,\"torso_2\":0,\"bags_2\":0,\"lipstick_2\":0,\"ears_2\":0,\"decals_1\":0,\"beard_3\":0,\"tshirt_1\":0,\"watches_1\":-1,\"bags_1\":0,\"chest_2\":0,\"shoes_2\":0,\"moles_2\":0,\"mask_1\":0,\"beard_1\":0,\"moles_1\":0,\"blush_1\":0,\"tshirt_2\":0,\"arms_2\":0,\"eye_color\":0,\"eyebrows_3\":0,\"skin\":0,\"beard_4\":0,\"makeup_2\":0,\"age_1\":0,\"complexion_1\":0,\"hair_1\":0,\"chain_1\":0,\"watches_2\":0,\"makeup_3\":0,\"face\":0,\"pants_2\":0,\"complexion_2\":0,\"helmet_1\":-1,\"bodyb_2\":0,\"bproof_1\":0,\"chest_3\":0,\"blemishes_1\":0,\"eyebrows_2\":0,\"mask_2\":0,\"makeup_4\":0}', 'unemployed', 0, '[]', '{\"x\":38.4,\"y\":15.0,\"z\":69.8}', 1600, 0, 'user', 'Leonard', 'Monosa', '2000082000', 'm', '180', '[{\"percent\":23.07,\"val\":230700,\"name\":\"hunger\"},{\"percent\":42.3025,\"val\":423025,\"name\":\"thirst\"}]'),
('steam:11000011bbeb00b', 'license:d4ff6a38b92b98d3b80d4f41bbb0622b059d7378', 0, 'M.rivai', '{\"eyebrows_4\":0,\"makeup_4\":0,\"arms_2\":0,\"age_1\":0,\"bodyb_2\":0,\"eyebrows_1\":0,\"mask_2\":0,\"sun_1\":0,\"complexion_2\":0,\"watches_2\":0,\"shoes_1\":0,\"makeup_3\":0,\"moles_1\":0,\"pants_1\":0,\"chain_1\":0,\"helmet_2\":0,\"bproof_1\":0,\"arms\":0,\"hair_1\":0,\"bags_2\":0,\"decals_2\":0,\"age_2\":0,\"makeup_2\":0,\"watches_1\":-1,\"bags_1\":0,\"sun_2\":0,\"eyebrows_3\":0,\"hair_color_2\":0,\"bproof_2\":0,\"chest_1\":0,\"hair_color_1\":0,\"blemishes_1\":0,\"blush_2\":0,\"beard_2\":0,\"hair_2\":0,\"chest_2\":0,\"bodyb_1\":0,\"beard_4\":0,\"tshirt_2\":0,\"lipstick_1\":0,\"blush_1\":0,\"moles_2\":0,\"torso_1\":0,\"skin\":0,\"beard_1\":0,\"face\":0,\"blush_3\":0,\"lipstick_4\":0,\"decals_1\":0,\"torso_2\":0,\"beard_3\":0,\"glasses_2\":0,\"helmet_1\":-1,\"shoes_2\":0,\"bracelets_1\":-1,\"ears_2\":0,\"chest_3\":0,\"eye_color\":0,\"glasses_1\":0,\"complexion_1\":0,\"blemishes_2\":0,\"bracelets_2\":0,\"lipstick_3\":0,\"pants_2\":0,\"mask_1\":0,\"eyebrows_2\":0,\"lipstick_2\":0,\"makeup_1\":0,\"chain_2\":0,\"ears_1\":-1,\"tshirt_1\":0,\"sex\":0}', 'unemployed', 0, '[]', '{\"x\":202.5,\"z\":32.2,\"y\":-798.2}', 2000, 0, 'user', 'Leonaard', 'Ganteng', '2000082000', 'm', '165', '[{\"val\":28200,\"name\":\"hunger\",\"percent\":2.82},{\"val\":271150,\"name\":\"thirst\",\"percent\":27.115}]');

-- --------------------------------------------------------

--
-- Table structure for table `user_accounts`
--

CREATE TABLE `user_accounts` (
  `id` int(11) NOT NULL,
  `identifier` varchar(22) NOT NULL,
  `name` varchar(50) NOT NULL,
  `money` double NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `user_accounts`
--

INSERT INTO `user_accounts` (`id`, `identifier`, `name`, `money`) VALUES
(1, 'steam:11000010e80e775', 'black_money', 0),
(2, 'steam:1100001116dfeb2', 'black_money', 0),
(3, 'steam:11000010deed507', 'black_money', 0),
(4, 'steam:11000011bbeb00b', 'black_money', 0);

-- --------------------------------------------------------

--
-- Table structure for table `user_inventory`
--

CREATE TABLE `user_inventory` (
  `id` int(11) NOT NULL,
  `identifier` varchar(22) NOT NULL,
  `item` varchar(50) NOT NULL,
  `count` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `user_inventory`
--

INSERT INTO `user_inventory` (`id`, `identifier`, `item`, `count`) VALUES
(1, 'steam:11000010e80e775', 'bread', 0),
(2, 'steam:11000010e80e775', 'water', 0),
(3, 'steam:11000011bbeb00b', 'water', 0),
(4, 'steam:11000011bbeb00b', 'bread', 0);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `addon_account`
--
ALTER TABLE `addon_account`
  ADD PRIMARY KEY (`name`);

--
-- Indexes for table `addon_account_data`
--
ALTER TABLE `addon_account_data`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `index_addon_account_data_account_name_owner` (`account_name`,`owner`),
  ADD KEY `index_addon_account_data_account_name` (`account_name`);

--
-- Indexes for table `addon_inventory`
--
ALTER TABLE `addon_inventory`
  ADD PRIMARY KEY (`name`);

--
-- Indexes for table `addon_inventory_items`
--
ALTER TABLE `addon_inventory_items`
  ADD PRIMARY KEY (`id`),
  ADD KEY `index_addon_inventory_items_inventory_name_name` (`inventory_name`,`name`),
  ADD KEY `index_addon_inventory_items_inventory_name_name_owner` (`inventory_name`,`name`,`owner`),
  ADD KEY `index_addon_inventory_inventory_name` (`inventory_name`);

--
-- Indexes for table `billing`
--
ALTER TABLE `billing`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `characters`
--
ALTER TABLE `characters`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `datastore`
--
ALTER TABLE `datastore`
  ADD PRIMARY KEY (`name`);

--
-- Indexes for table `datastore_data`
--
ALTER TABLE `datastore_data`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `index_datastore_data_name_owner` (`name`,`owner`),
  ADD KEY `index_datastore_data_name` (`name`);

--
-- Indexes for table `items`
--
ALTER TABLE `items`
  ADD PRIMARY KEY (`name`);

--
-- Indexes for table `jobs`
--
ALTER TABLE `jobs`
  ADD PRIMARY KEY (`name`);

--
-- Indexes for table `job_grades`
--
ALTER TABLE `job_grades`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `society_moneywash`
--
ALTER TABLE `society_moneywash`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `user_accounts`
--
ALTER TABLE `user_accounts`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `user_inventory`
--
ALTER TABLE `user_inventory`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `addon_account_data`
--
ALTER TABLE `addon_account_data`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `addon_inventory_items`
--
ALTER TABLE `addon_inventory_items`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `billing`
--
ALTER TABLE `billing`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `characters`
--
ALTER TABLE `characters`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `datastore_data`
--
ALTER TABLE `datastore_data`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `job_grades`
--
ALTER TABLE `job_grades`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `society_moneywash`
--
ALTER TABLE `society_moneywash`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `user_accounts`
--
ALTER TABLE `user_accounts`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `user_inventory`
--
ALTER TABLE `user_inventory`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
