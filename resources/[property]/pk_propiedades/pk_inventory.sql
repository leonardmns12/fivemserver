CREATE TABLE IF NOT EXISTS `pk_inventariocasas` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `propiedad` varchar(255) NOT NULL,
  `data` text NOT NULL,
  `propietarioID` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `propiedad` (`propiedad`)
) ENGINE=InnoDB AUTO_INCREMENT=52 DEFAULT CHARSET=utf8;
