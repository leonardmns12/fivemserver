﻿CREATE TABLE `pk_casas` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `propietarioID` varchar(255) DEFAULT NULL,
  `propietarioNombre` varchar(255) DEFAULT NULL,
  `propiedad` varchar(255) DEFAULT NULL,
  `estado` int(11) DEFAULT NULL,
  `enventa` int(11) DEFAULT NULL,
  `cochera` int(11) DEFAULT NULL,
  `vehicle` longtext,
  `ArmarioDinero` int(11) DEFAULT NULL,
  `ArmarioArmas` int(11) DEFAULT NULL,
  `ArmarioItems` int(11) DEFAULT NULL,
  `cordsvehiculo` varchar(255) DEFAULT NULL,
  `barrio` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=55 DEFAULT CHARSET=utf8mb4;

INSERT INTO `pk_casas` VALUES (1,NULL,NULL,'West Mirror Street',0,0,0,'0',0,0,0,'{\"x\":1106.01,\"y\":-399.15,\"z\":67.98,\"h\":303.5}',1),(3,NULL,NULL,'Bridge Street 1',0,0,0,'0',0,0,0,'{\"x\":1099.83,\"y\":-429.47,\"z\":67.39,\"h\":303.5}',1),(4,NULL,NULL,'Bridge Street 2',0,0,0,'0',0,0,0,'{\"x\":1060.7,\"y\":-445.44,\"z\":65.93,\"h\":303.5}',1),(5,NULL,NULL,'Bridge Street 3',0,0,0,'0',0,0,0,'{\"x\":1047.64,\"y\":-487.4,\"z\":63.92,\"h\":303.5}',1),(6,NULL,NULL,'West Mirror Drive 1',0,0,0,'0',0,0,0,'{\"x\":1020.16,\"y\":-461.43,\"z\":63.9,\"h\":303.5}',1),(7,NULL,NULL,'West Mirror Drive 2',0,0,0,'0',0,0,0,'{\"x\":961.54,\"y\":-503.3,\"z\":61.6,\"h\":303.5}',1),(8,NULL,NULL,'West Mirror Drive 3',0,0,0,'0',0,0,0,'{\"x\":916.65,\"y\":-524.38,\"z\":58.97,\"h\":303.5}',1),(10,NULL,NULL,'Nikola Avenue 1',0,0,0,'0',0,0,0,'{\"x\":918.89,\"y\":-533.63,\"z\":60.09,\"h\":303.5}',1),(11,NULL,NULL,'Nikola Avenue 2',0,0,0,'0',0,0,0,'{\"x\":927.46,\"y\":-568.6,\"z\":57.97,\"h\":303.5}',1),(12,NULL,NULL,'West Mirror Drive 9',0,0,0,'0',0,0,0,'{\"x\":844.05,\"y\":-562.97,\"z\":57.83,\"h\":303.5}',1),(13,NULL,NULL,'Bridge Street 4',0,0,0,'0',0,0,0,'{\"x\":1056.2,\"y\":-386.48,\"z\":67.85,\"h\":303.5}',1),(14,NULL,NULL,'West Mirror Drive 4',0,0,0,'0',0,0,0,'{\"x\":1021.44,\"y\":-417.31,\"z\":65.95,\"h\":303.5}',1),(15,NULL,NULL,'West Mirror Drive 5',0,0,0,'0',0,0,0,'{\"x\":989.98,\"y\":-436.68,\"z\":63.74,\"h\":303.5}',1),(16,NULL,NULL,'West Mirror Drive 6',0,0,0,'0',0,0,0,'{\"x\":942.51,\"y\":-468.57,\"z\":61.25,\"h\":303.5}',1),(17,NULL,NULL,'West Mirror Drive 7',0,0,0,'0',0,0,0,'{\"x\":913.81,\"y\":-488.64,\"z\":59.04,\"h\":303.5}',1),(18,NULL,NULL,'West Mirror Drive 8',0,0,0,'0',0,0,0,'{\"x\":857.98,\"y\":-521.08,\"z\":57.3,\"h\":303.5}',1),(19,NULL,NULL,'Nikola Place 1',0,0,0,'0',0,0,0,'{\"x\":1308.87,\"y\":-533.53,\"z\":71.31,\"h\":303.5}',1),(20,NULL,NULL,'Nikola Place 2',0,0,0,'0',0,0,0,'{\"x\":1317.8,\"y\":-535.15,\"z\":72.05,\"h\":303.5}',1),(21,NULL,NULL,'Nikola Place 3',0,0,0,'0',0,0,0,'{\"x\":1353.92,\"y\":-553.07,\"z\":74.0,\"h\":303.5}',1),(22,NULL,NULL,'Nikola Place 4',0,0,0,'0',0,0,0,'{\"x\":1362.99,\"y\":-553.09,\"z\":74.34,\"h\":303.5}',1),(23,NULL,NULL,'Nikola Place 5',0,0,0,'0',0,0,0,'{\"x\":1388.23,\"y\":-577.86,\"z\":74.34,\"h\":303.5}',1),(24,NULL,NULL,'Nikola Place 6',0,0,0,'0',0,0,0,'{\"x\":1378.58,\"y\":-596.45,\"z\":74.34,\"h\":303.5}',1),(25,NULL,NULL,'Nikola Place 7',0,0,0,'0',0,0,0,'{\"x\":1349.28,\"y\":-603.18,\"z\":74.36,\"h\":303.5}',1),(26,NULL,NULL,'Nikola Place 8',0,0,0,'0',0,0,0,'{\"x\":1318.44,\"y\":-576.43,\"z\":73.01,\"h\":303.5}',1),(27,NULL,NULL,'Nikola Place 9',0,0,0,'0',0,0,0,'{\"x\":1294.77,\"y\":-568.2,\"z\":71.23,\"h\":303.5}',1),(28,NULL,NULL,'GroveStreet1',0,0,0,'0',0,0,0,'{\"x\":16.17,\"y\":-1884.11,\"z\":23.25,\"h\":303.5}',2),(29,NULL,NULL,'GroveStreet2',0,0,0,'0',0,0,0,'{\"x\":34.42,\"y\":-1893.47,\"z\":22.21,\"h\":303.5}',2),(30,NULL,NULL,'GroveStreet3',0,0,0,'0',0,0,0,'{\"x\":47.72,\"y\":-1914.04,\"z\":21.66,\"h\":303.5}\r\n',2),(31,NULL,NULL,'GroveStreet4',0,0,0,'0',0,0,0,'{\"x\":81.53,\"y\":-1932.26,\"z\":20.73,\"h\":303.5}',2),(32,NULL,NULL,'GroveStreet5',0,0,0,'0',0,0,0,'{\"x\":68.41,\"y\":-1921.38,\"z\":21.33,\"h\":303.5}',2),(33,NULL,NULL,'GroveStreet6',0,0,0,'0',0,0,0,'{\"x\":89.28,\"y\":-1941.74,\"z\":20.7,\"h\":303.5}',2),(34,NULL,NULL,'GroveStreet7',0,0,0,'0',0,0,0,'{\"x\":94.65,\"y\":-1961.35,\"z\":20.75,\"h\":303.5}',2),(35,NULL,NULL,'GroveStreet8',0,0,0,'0',0,0,0,'{\"x\":116.35,\"y\":-1949.67,\"z\":20.72,\"h\":303.5}',2),(36,NULL,NULL,'GroveStreet9',0,0,0,'0',0,0,0,'{\"x\":119.75,\"y\":-1940.57,\"z\":20.72,\"h\":303.5}',2),(37,NULL,NULL,'GroveStreet10',0,0,0,'0',0,0,0,'{\"x\":109.5,\"y\":-1925.27,\"z\":20.75,\"h\":303.5}',2),(38,NULL,NULL,'GroveStreet11',0,0,0,'0',0,0,0,'{\"x\":89.46,\"y\":-1917.07,\"z\":20.73,\"h\":303.5}',2),(39,NULL,NULL,'GroveStreet12',0,0,0,'0',0,0,0,'{\"x\":52.2,\"y\":-1878.8,\"z\":22.2,\"h\":303.5}',2),(40,NULL,NULL,'GroveStreet13',0,0,0,'0',0,0,0,'{\"x\":32.79,\"y\":-1862.0,\"z\":23.03,\"h\":303.5}',2),(41,NULL,NULL,'Grove Street 541',0,0,0,'0',0,0,0,'{\"x\":21.13,\"y\":-1855.43,\"z\":23.68,\"h\":303.5}',2),(42,NULL,NULL,'Covenant Avenue 1',0,0,0,'0',0,0,0,'{\"x\":109.14,\"y\":-1878.11,\"z\":23.88,\"h\":303.5}',2),(43,NULL,NULL,'Covenant Avenue 2',0,0,0,'0',0,0,0,'{\"x\":126.8,\"y\":-1882.61,\"z\":23.57,\"h\":303.5}',2),(44,NULL,NULL,'Covenant Avenue 3',0,0,0,'0',0,0,0,'{\"x\":138.99,\"y\":-1893.87,\"z\":23.53,\"h\":303.5}',2),(45,NULL,NULL,'Strawberry1',0,0,0,'0',0,0,0,'{\"x\":335.39,\"y\":-1281.8,\"z\":31.92,\"h\":303.5}',3),(46,NULL,NULL,'Strawberry2',0,0,0,'0',0,0,0,'{\"x\":335.08,\"y\":-1259.45,\"z\":31.66,\"h\":303.5}',3),(47,NULL,NULL,'Vespucci Boulevard 1',0,0,0,'0',0,0,0,'{\"x\":-1024.4,\"y\":-888.56,\"z\":5.76,\"h\":303.5}',3),(48,NULL,NULL,'Vespucci Boulevard 2',0,0,0,'0',0,0,0,'{\"x\":-1035.37,\"y\":-897.58,\"z\":4.55,\"h\":303.5}',3),(49,NULL,NULL,'Vespucci Boulevard 3',0,0,0,'0',0,0,0,'{\"x\":-1053.94,\"y\":-905.35,\"z\":4.37,\"h\":303.5}',3),(50,NULL,NULL,'Vespucci Boulevard 4',0,0,0,'0',0,0,0,'{\"x\":-1082.03,\"y\":-919.86,\"z\":3.51,\"h\":303.5}',3),(51,NULL,NULL,'Vespucci Boulevard 5',0,0,0,'0',0,0,0,'{\"x\":-1093.81,\"y\":-889.12,\"z\":3.59,\"h\":303.5}',3),(52,NULL,NULL,'Imagination Court 1',0,0,0,'0',0,0,0,'{\"x\":-1041.12,\"y\":-1020.44,\"z\":2.12,\"h\":303.5}',3),(53,NULL,NULL,'Imagination Court 2',0,0,0,'0',0,0,0,'{\"x\":-1023.97,\"y\":-1015.09,\"z\":2.15,\"h\":303.5}',3),(54,NULL,NULL,'Imagination Court 3',0,0,0,'0',0,0,0,'{\"x\":-1044.34,\"y\":-1008.37,\"z\":2.15,\"h\":303.5}',3);