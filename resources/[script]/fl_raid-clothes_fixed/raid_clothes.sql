ALTER TABLE `users`
ADD COLUMN  `model` longtext DEFAULT NULL,
ADD COLUMN  `drawables` longtext DEFAULT NULL,
ADD COLUMN  `props` longtext DEFAULT NULL,
ADD COLUMN  `drawtextures` longtext DEFAULT NULL,
ADD COLUMN  `proptextures` longtext DEFAULT NULL,
ADD COLUMN  `hairColor` longtext DEFAULT '[]',
ADD COLUMN  `headBlend` longtext DEFAULT '[]',
ADD COLUMN  `headOverlay` longtext DEFAULT '[]',
ADD COLUMN  `headStructure` longtext DEFAULT '[]',


CREATE TABLE IF NOT EXISTS `character_current` (
  `cid` varchar(255) NOT NULL,
  `model` longtext NOT NULL DEFAULT '',
  `drawables` longtext NOT NULL DEFAULT '',
  `props` longtext NOT NULL DEFAULT '',
  `drawtextures` longtext NOT NULL DEFAULT '',
  `proptextures` longtext NOT NULL DEFAULT ''
);




CREATE TABLE IF NOT EXISTS `character_face` (
  `identifier` varchar(255) NOT NULL,
  `hairColor` varchar(255) NOT NULL DEFAULT '',
  `headBlend` varchar(255) NOT NULL DEFAULT '',
  `headStructure` varchar(255) NOT NULL DEFAULT '',
  `headOverlay` varchar(255) NOT NULL DEFAULT ''
);

CREATE TABLE IF NOT EXISTS `playerstattoos` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `identifier` varchar(255) NOT NULL,
  `tattoos` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
); 