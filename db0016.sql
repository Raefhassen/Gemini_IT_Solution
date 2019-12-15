CREATE TABLE `gemini_core_db_0016`.`its_roles` (
  `id` CHAR(36) NOT NULL,
  `Role` VARCHAR(45) NOT NULL,   
  `Description` MEDIUMTEXT NULL,  
  PRIMARY KEY (`id`),  
  UNIQUE INDEX `id_UNIQUE` (`id` ASC),   
  UNIQUE INDEX `Role_UNIQUE` (`Role` ASC))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1
COLLATE = latin1_general_ci;

DROP TRIGGER IF EXISTS `gemini_core_db_0016`.`role_uniq_id`;

DELIMITER $$
USE `gemini_core_db_0016`$$
CREATE DEFINER = CURRENT_USER TRIGGER `gemini_core_db_0016`.`role_uniq_id` BEFORE INSERT ON `its_roles` FOR EACH ROW
	BEGIN
	  IF new.id IS NULL THEN
	    SET new.id = uuid();
	  END IF;
	END$$
DELIMITER ;


INSERT INTO `gemini_core_db_0016`.`its_roles` (`Role`) VALUES ('SuperUser');
INSERT INTO `gemini_core_db_0016`.`its_roles` (`Role`) VALUES ('Administrator');
INSERT INTO `gemini_core_db_0016`.`its_roles` (`Role`) VALUES ('Manager');
INSERT INTO `gemini_core_db_0016`.`its_roles` (`Role`) VALUES ('Validator');
INSERT INTO `gemini_core_db_0016`.`its_roles` (`Role`) VALUES ('Approver');
INSERT INTO `gemini_core_db_0016`.`its_roles` (`Role`) VALUES ('User');

#############################################

CREATE TABLE `gemini_core_db_0016`.`its_users` (
    `id` CHAR(36) NOT NULL,
    `unb` INT(10) ZEROFILL NOT NULL AUTO_INCREMENT,
    `FirstName` CHAR(45) NULL,
    `LastName` CHAR(45) NULL,
    `eMailAdresse` CHAR(45) NULL,
    `Login` CHAR(45) NOT NULL,
    `Role` CHAR(36) NULL,
    `Passwordhash` LONGTEXT NOT NULL,
    `Creation` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `PasswordSetDate` TIMESTAMP NOT NULL,
	`BadPassCount` TINYINT(1) UNSIGNED NULL DEFAULT 0,
	`Enabled` TINYINT(1) NULL DEFAULT 1,
	`Locked` TINYINT(1) NULL DEFAULT 0,
	PRIMARY KEY (`id`),  
	UNIQUE INDEX `id_UNIQUE` (`id` ASC),  
	UNIQUE INDEX `unb_UNIQUE` (`unb` ASC),  
	UNIQUE INDEX `Login_UNIQUE` (`Login` ASC))

ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1
COLLATE = latin1_general_ci;

ALTER TABLE `gemini_core_db_0016`.`its_users` ADD INDEX `AppRole_idx` (`Role` ASC);
ALTER TABLE `gemini_core_db_0016`.`its_users` ADD CONSTRAINT `AppRole`   FOREIGN KEY (`Role`)   
REFERENCES `gemini_core_db_0016`.`its_roles` (`Role`)   ON DELETE NO ACTION   ON UPDATE NO ACTION;

DROP TRIGGER IF EXISTS `gemini_core_db_0016`.`OI_new_user`;
DELIMITER $$
	USE `gemini_core_db_0016`$$
	CREATE DEFINER = CURRENT_USER TRIGGER `gemini_core_db_0016`.`OI_new_user` 
		BEFORE INSERT ON `its_users` FOR EACH ROW
	   	BEGIN  
			IF new.id IS NULL THEN     
			   SET new.id = uuid();   
			   SET new.passwordhash = password(new.passwordhash);
			END IF;
			IF new.passwordhash is null then
				SET new.passwordhash = password (new.id);
			END IF;
		END$$
DELIMITER ;

DROP TRIGGER IF EXISTS `gemini_core_db_0016`.`BU_users`;
DELIMITER $$
	USE `gemini_core_db_0016`$$
	CREATE DEFINER = CURRENT_USER TRIGGER `gemini_core_db_0016`.`BU_users` 
		BEFORE UPDATE ON `its_users` FOR EACH ROW
		BEGIN
			IF LENGTH(new.passwordhash)>0 then
				SET new.passwordhash = password(new.passwordhash);
				SET new.Passwordsetdate = CURRENT_TIMESTAMP;
			ELSE
				SET new.passwordhash = password(id);
			END IF;
		END$$
DELIMITER ;




INSERT INTO `gemini_core_db_0016`.`its_users` (`FirstName`, `LastName`, `eMailAdresse`, `Login`, `Role`, `Passwordhash`) 
VALUES ('Administrator', 'Gemini Super User', 'Admin@gemini.com', 'Admin@gemini.com', 'SuperUser', 'Gemini@dmin1');


