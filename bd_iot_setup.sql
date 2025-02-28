-- --------------------------------------------------------
-- 호스트:                          127.0.0.1
-- 서버 버전:                        10.4.12-MariaDB - mariadb.org binary distribution
-- 서버 OS:                        Win64
-- HeidiSQL 버전:                  10.2.0.5599
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;


-- bdtec_client_m1 데이터베이스 구조 내보내기
CREATE DATABASE IF NOT EXISTS `bdtec_client_m2` /*!40100 DEFAULT CHARACTER SET latin1 */;
USE `bdtec_client_m2`;

-- 테이블 bdtec_client_m1.average_data 구조 내보내기
CREATE TABLE IF NOT EXISTS `average_data` (
  `Idx` bigint(20) DEFAULT NULL,
  `SaveTime` datetime NOT NULL,
  `Category` char(3) NOT NULL DEFAULT '0',
  `ChimneyCode` char(3) NOT NULL DEFAULT '1',
  `CH` int(5) NOT NULL DEFAULT 1,
  `DataCode` varchar(50) NOT NULL DEFAULT '0',
  `ItemCode` varchar(50) NOT NULL DEFAULT '0',
  `AvgValue` double NOT NULL DEFAULT 0,
  `DataState` int(11) NOT NULL DEFAULT 0,
  `RunState` int(11) NOT NULL DEFAULT 0,
  `PreState` int(11) NOT NULL DEFAULT 0,
  `SendState` bit(1) NOT NULL DEFAULT b'0',
  `Ack` bit(1) NOT NULL DEFAULT b'1',
  PRIMARY KEY (`SaveTime`,`Category`,`CH`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- 내보낼 데이터가 선택되어 있지 않습니다.

-- 테이블 bdtec_client_m1.day_data 구조 내보내기
CREATE TABLE IF NOT EXISTS `day_data` (
  `Idx` bigint(20) DEFAULT NULL,
  `SaveDate` date NOT NULL,
  `ChimneyCode` char(3) NOT NULL DEFAULT '1',
  `Category` char(3) NOT NULL DEFAULT 'FIV',
  `DataCode` char(5) NOT NULL DEFAULT '0',
  `ItemCode` char(1) NOT NULL DEFAULT '0',
  `TDAH` int(11) NOT NULL DEFAULT 0,
  `TOFH` int(11) NOT NULL DEFAULT 0,
  `Status0` int(11) NOT NULL DEFAULT 0,
  `Status1` int(11) NOT NULL DEFAULT 0,
  `Status2` int(11) NOT NULL DEFAULT 0,
  `Status4` int(11) NOT NULL DEFAULT 0,
  `Status8` int(11) NOT NULL DEFAULT 0,
  `SendState` bit(1) NOT NULL DEFAULT b'0',
  `Ack` bit(1) NOT NULL DEFAULT b'1',
  PRIMARY KEY (`SaveDate`,`ChimneyCode`,`Category`,`DataCode`,`ItemCode`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
-- 내보낼 데이터가 선택되어 있지 않습니다.

-- 테이블 bdtec_client_m1.log_table 구조 내보내기
CREATE TABLE IF NOT EXISTS `log_table` (
  `LogID` int(11) NOT NULL AUTO_INCREMENT,
  `LogTime` datetime DEFAULT current_timestamp(),
  `LogMessage` varchar(255) DEFAULT NULL,
  `SaveTime` datetime DEFAULT current_timestamp(),
  PRIMARY KEY (`LogID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- 내보낼 데이터가 선택되어 있지 않습니다.

-- 테이블 bdtec_client_m1.pow_off_data 구조 내보내기
CREATE TABLE IF NOT EXISTS `pow_off_data` (
  `Idx` bigint(20) DEFAULT NULL,
  `SaveTime` datetime NOT NULL,
  `ChimneyCode` char(3) NOT NULL DEFAULT '1',
  `Category` char(3) NOT NULL DEFAULT '0',
  `SendState` bit(1) NOT NULL DEFAULT b'0',
  `Ack` bit(1) NOT NULL DEFAULT b'1',
  PRIMARY KEY (`SaveTime`,`ChimneyCode`,`Category`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- 내보낼 데이터가 선택되어 있지 않습니다.
DROP PROCEDURE IF EXISTS `SP_All_Data_Delete`;
-- 프로시저 bdtec_client_m1.SP_All_Data_Delete 구조 내보내기
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_All_Data_Delete`()
BEGIN
	DELETE FROM average_data WHERE 1=1;
	ALTER TABLE average_data AUTO_INCREMENT = 1;
	DELETE FROM day_data WHERE 1=1;
	ALTER TABLE day_data AUTO_INCREMENT = 1;
	DELETE FROM pow_off_data WHERE 1=1;
	ALTER TABLE pow_off_data AUTO_INCREMENT = 1;
END//
DELIMITER ;
DROP PROCEDURE IF EXISTS `SP_AverageData_Delete1`;
-- 프로시저 bdtec_client_m1.SP_AverageData_Delete1 구조 내보내기
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_AverageData_Delete1`(
	IN `_from` DATETIME
)
BEGIN
	DELETE FROM average_data WHERE SaveTime < _from;
END//
DELIMITER ;
DROP PROCEDURE IF EXISTS `SP_AverageData_Delete2`;
-- 프로시저 bdtec_client_m1.SP_AverageData_Delete2 구조 내보내기
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_AverageData_Delete2`(
	IN `_from` DATETIME
)
BEGIN
	DELETE FROM average_data WHERE SaveTime >= _from;
END//
DELIMITER ;
DROP PROCEDURE IF EXISTS `SP_AverageData_Delete3`;
-- 프로시저 bdtec_client_m1.SP_AverageData_Delete3 구조 내보내기
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_AverageData_Delete3`(
	IN `_time` DATETIME
)
BEGIN
	DELETE FROM average_data WHERE SaveTime = _time;
END//
DELIMITER ;
DROP PROCEDURE IF EXISTS `SP_AverageData_Delete4`;
-- 프로시저 bdtec_client_m1.SP_AverageData_Delete4 구조 내보내기
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_AverageData_Delete4`(
	IN `_Category` VARCHAR(50),
	IN `_time` DATETIME
)
BEGIN
	DELETE FROM average_data WHERE SaveTime = _time AND Category = _Category;
END//
DELIMITER ;
DROP PROCEDURE IF EXISTS `SP_AverageData_Insert`;
-- 프로시저 bdtec_client_m1.SP_AverageData_Insert 구조 내보내기
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_AverageData_Insert`(
	IN `_ChimneyCode` VARCHAR(50),
	IN `_Category` VARCHAR(50),
	IN `_CH` INT,
	IN `_DataCode` VARCHAR(50),
	IN `_ItemCode` VARCHAR(50),
	IN `_SaveTime` DATETIME,
	IN `_AvgValue` DOUBLE,
	IN `_DataState` INT,
	IN `_RunState` INT,
	IN `_PreState` INT
)
BEGIN
	DECLARE data_exists INT DEFAULT 0;

    SELECT COUNT(*) INTO data_exists
    FROM pow_off_data
    WHERE SaveTime = _SaveTime
      AND Category = _Category
      AND ChimneyCode = _ChimneyCode;

    IF  data_exists = 0 THEN
        SELECT COUNT(*) INTO data_exists
		  FROM average_data
        WHERE ChimneyCode = _ChimneyCode
        AND Category = _Category
        AND CH = _CH
        AND DataCode = _DataCode
        AND ItemCode = _ItemCode
        AND SaveTime = _SaveTime;
    END IF;
    
    IF data_exists = 0 THEN
        INSERT INTO average_data (ChimneyCode, Category, CH, DataCode, ItemCode, SaveTime, AvgValue, DataState, RunState, PreState)
        VALUES (_ChimneyCode, _Category, _CH, _DataCode, _ItemCode, _SaveTime, _AvgValue, _DataState, _RunState, _PreState);
    END IF;
END//
DELIMITER ;
DROP PROCEDURE IF EXISTS `SP_AverageData_Last`;
-- 프로시저 bdtec_client_m1.SP_AverageData_Last 구조 내보내기
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_AverageData_Last`(
	IN `_ChimneyCode` VARCHAR(50),
	IN `_Category` VARCHAR(50),
	IN `_from` DATETIME,
	IN `_to` DATETIME	
)
BEGIN
	SELECT * FROM average_data
	WHERE (ChimneyCode = _ChimneyCode)
	AND (Category = _Category)
	AND (SaveTime >= _from)
	AND (SaveTime < _to)
	ORDER BY SaveTime DESC LIMIT 1;
END//
DELIMITER ;
DROP PROCEDURE IF EXISTS `SP_AverageData_NoSend_Emi`;
-- 프로시저 bdtec_client_m1.SP_AverageData_NoSend_Emi 구조 내보내기
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_AverageData_NoSend_Emi`(
	IN `_ChimneyCode` VARCHAR(50),
	IN `_Category` VARCHAR(50),
	IN `_SaveTime` DATETIME
)
BEGIN
	SELECT Category, ChimneyCode, DataCode, ItemCode, SaveTime, AvgValue, DataState, RunState, PreState
 	FROM average_data
 	WHERE (SendState = 0)
 	AND (Ack = 1)
 	AND (DataCode LIKE "E%")
 	AND (ChimneyCode = _ChimneyCode)
 	AND (Category = _Category)
	AND (SaveTime = _SaveTime);
END//
DELIMITER ;
DROP PROCEDURE IF EXISTS `SP_AverageData_NoSend_Fan`;
-- 프로시저 bdtec_client_m1.SP_AverageData_NoSend_Fan 구조 내보내기
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_AverageData_NoSend_Fan`(
	IN `_ChimneyCode` VARCHAR(50),
	IN `_Category` VARCHAR(50),
	IN `_SaveTime` DATETIME
)
BEGIN	
	SELECT Category, ChimneyCode, DataCode, ItemCode, SaveTime, AvgValue, DataState, RunState, PreState
 	FROM average_data
 	WHERE (SendState = 0)
 	AND (Ack = 1)
 	AND (DataCode LIKE "F%")
 	AND (ChimneyCode = _ChimneyCode)
 	AND (Category = _Category)
	AND (SaveTime = _SaveTime);
END//
DELIMITER ;
DROP PROCEDURE IF EXISTS `SP_AverageData_NoSend_Pre`;
-- 프로시저 bdtec_client_m1.SP_AverageData_NoSend_Pre 구조 내보내기
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_AverageData_NoSend_Pre`(
	IN `_ChimneyCode` VARCHAR(50),
	IN `_Category` VARCHAR(50),
	IN `_SaveTime` DATETIME
)
BEGIN	
	SELECT Category, ChimneyCode, DataCode, ItemCode, SaveTime, AvgValue, DataState, RunState, PreState
	FROM average_data
 	WHERE (SendState = 0)
 	AND (Ack = 1)
 	AND (DataCode LIKE "P%")
 	AND (ChimneyCode = _ChimneyCode)
 	AND (Category = _Category)
	AND (SaveTime = _SaveTime);
END//
DELIMITER ;
DROP PROCEDURE IF EXISTS `SP_AverageData_NoSend_Time`;
-- 프로시저 bdtec_client_m1.SP_AverageData_NoSend_Time 구조 내보내기
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_AverageData_NoSend_Time`(
	IN `_ChimneyCode` VARCHAR(50),
	IN `_Category` VARCHAR(50),
	IN `_SaveTime` DATETIME
)
BEGIN
	SELECT Category, ChimneyCode, DataCode, ItemCode, SaveTime, AvgValue, DataState, RunState, PreState
 	FROM average_data
 	WHERE (SendState = 0)
 	AND (ChimneyCode = _ChimneyCode)
 	AND (Category = _Category)
	AND (SaveTime >= _SaveTime);
END//
DELIMITER ;
DROP PROCEDURE IF EXISTS `SP_AverageData_PowOn`;
-- 프로시저 bdtec_client_m1.SP_AverageData_PowOn 구조 내보내기
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_AverageData_PowOn`(
	IN `_ChimneyCode` VARCHAR(50),
	IN `_Category` VARCHAR(50),
	IN `_from` DATETIME,
	IN `_to` DATETIME
)
BEGIN
	SELECT DISTINCT ChimneyCode, Category, SaveTime, DataState FROM average_data    
	WHERE (average_data.SaveTime BETWEEN _from AND _to)
	AND ChimneyCode = _ChimneyCode
	AND Category = _Category
	AND DataState != 4
	ORDER BY SaveTime ASC;
END//
DELIMITER ;
DROP PROCEDURE IF EXISTS `SP_AverageData_Query`;
-- 프로시저 bdtec_client_m1.SP_AverageData_Query 구조 내보내기
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_AverageData_Query`(
	IN `_ChimneyCode` VARCHAR(50),
	IN `_Category` VARCHAR(50),
	IN `_from` DATETIME,
	IN `_to` DATETIME
)
BEGIN
	SELECT CH, SaveTime, AvgValue FROM average_data
	WHERE (ChimneyCode = _ChimneyCode)
	AND (Category = _Category)
	AND (SaveTime BETWEEN _from AND _to)
	ORDER BY SaveTime DESC;
END//
DELIMITER ;
DROP PROCEDURE IF EXISTS `SP_AverageData_Select`;
-- 프로시저 bdtec_client_m1.SP_AverageData_Select 구조 내보내기
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_AverageData_Select`(
	IN `_ChimneyCode` VARCHAR(50),
	IN `_Category` VARCHAR(50),
	IN `_from` DATETIME,
	IN `_to` DATETIME
)
BEGIN
	SELECT * FROM average_data
	WHERE (ChimneyCode = _ChimneyCode)          
	AND	(Category = _Category)
	AND	(SaveTime BETWEEN _from AND _to);
END//
DELIMITER ;
DROP PROCEDURE IF EXISTS `SP_AverageData_Select_FIV`;
-- 프로시저 bdtec_client_m1.SP_AverageData_Select_FIV 구조 내보내기
DELIMITER //
CREATE PROCEDURE `SP_AverageData_Select_FIV`(
	IN `_ChimneyCode` VARCHAR(50),
	IN `_Category` VARCHAR(50),
	IN `_CH` INT,
	IN `_DataCode` VARCHAR(50),
	IN `_ItemCode` VARCHAR(50),
	IN `_from` DATETIME,
	IN `_to` DATETIME
)
BEGIN
	SELECT * FROM average_data
	WHERE (ChimneyCode = _ChimneyCode)          
	AND	(Category = _Category)
	AND   (CH = _CH)
	AND	(DataCode = _DataCode)
	AND	(ItemCode = _ItemCode)
	AND	(SaveTime BETWEEN _from AND _to);
END//
DELIMITER ;
DROP PROCEDURE IF EXISTS `SP_AverageData_UpdateCode`;
-- 프로시저 bdtec_client_m1.SP_AverageData_UpdateCode 구조 내보내기
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_AverageData_UpdateCode`(
	IN `_DataCode` VARCHAR(50),
	IN `_CH` INT
)
BEGIN
	UPDATE average_data SET DataCode = _DataCode WHERE CH = _CH AND DataCode != _DataCode;
END//
DELIMITER ;
DROP PROCEDURE IF EXISTS `SP_AverageData_Update_ACK`;
-- 프로시저 bdtec_client_m1.SP_AverageData_Update_ACK 구조 내보내기
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_AverageData_Update_ACK`(
	IN `_ChimneyCode` VARCHAR(50),
	IN `_Category` VARCHAR(50),
	IN `_SaveTime` DATETIME
)
BEGIN
	UPDATE average_data SET SendState = 1
	WHERE (ChimneyCode = _ChimneyCode)
	AND (Category = _Category)
	AND (SaveTime = _SaveTime);
END//
DELIMITER ;
DROP PROCEDURE IF EXISTS `SP_AverageData_Update_NAK`;
-- 프로시저 bdtec_client_m1.SP_AverageData_Update_NAK 구조 내보내기
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_AverageData_Update_NAK`(
	IN `_ChimneyCode` VARCHAR(50),
	IN `_Category` VARCHAR(50),
	IN `_SaveTime` DATETIME
)
BEGIN
	UPDATE average_data SET Ack = 0
	WHERE (ChimneyCode = _ChimneyCode)
	AND (Category = _Category)
	AND (SaveTime = _SaveTime);
END//
DELIMITER ;
DROP PROCEDURE IF EXISTS `SP_DayData_Delete1`;
-- 프로시저 bdtec_client_m1.SP_DayData_Delete1 구조 내보내기
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_DayData_Delete1`(
	IN `_from` DATETIME
)
BEGIN
	DELETE FROM day_data WHERE SaveDate < _from;
END//
DELIMITER ;
DROP PROCEDURE IF EXISTS `SP_DayData_Delete2`;
-- 프로시저 bdtec_client_m1.SP_DayData_Delete2 구조 내보내기
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_DayData_Delete2`(
	IN `_from` DATETIME
)
BEGIN
	DELETE FROM day_data WHERE SaveDate >= _from;
END//
DELIMITER ;
DROP PROCEDURE IF EXISTS `SP_DayData_Insert`;
-- 프로시저 bdtec_client_m1.SP_DayData_Insert 구조 내보내기
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_DayData_Insert`(
	IN `_ChimneyCode` VARCHAR(50),
	IN `_Category` VARCHAR(50),
	IN `_SaveDate` DATE,
	IN `_DataCode` VARCHAR(50),
	IN `_ItemCode` VARCHAR(50),
	IN `_TDAH` INT,
	IN `_TOFH` INT,
	IN `_Status0` INT,
	IN `_Status1` INT,
	IN `_Status2` INT,
	IN `_Status4` INT,
	IN `_Status8` INT



)
BEGIN
	INSERT INTO day_data (ChimneyCode, Category, SaveDate, DataCode, ItemCode, TDAH, TOFH, Status0, Status1, Status2, Status4, Status8)
	VALUES (_ChimneyCode, _Category, _SaveDate, _DataCode, _ItemCode, _TDAH, _TOFH, _Status0, _Status1, _Status2, _Status4, _Status8);
END//
DELIMITER ;
DROP PROCEDURE IF EXISTS `SP_DayData_Select`;
-- 프로시저 bdtec_client_m1.SP_DayData_Select 구조 내보내기
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_DayData_Select`(
	IN `_ChimneyCode` INT,
	IN `_Category` VARCHAR(50),
	IN `_from` DATE,
	IN `_to` VARCHAR(50)
)
BEGIN
	SELECT * FROM day_data
	WHERE ChimneyCode = _ChimneyCode
	AND Category = _Category
	AND (SaveDate BETWEEN _from AND _to)
	ORDER BY SaveDate;
END//
DELIMITER ;
DROP PROCEDURE IF EXISTS `SP_DayData_Update_ACK`;
-- 프로시저 bdtec_client_m1.SP_DayData_Update_ACK 구조 내보내기
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_DayData_Update_ACK`(
	IN `_ChimneyCode` VARCHAR(50),
	IN `_Category` VARCHAR(50),
	IN `_SaveDate` DATE
)
BEGIN
	UPDATE day_data SET SendState = 1 
	WHERE (ChimneyCode = _ChimneyCode)
	AND (Category = _Category)
	AND (SaveDate = _SaveDate);
END//
DELIMITER ;
DROP PROCEDURE IF EXISTS `SP_DayData_Update_NAK`;
-- 프로시저 bdtec_client_m1.SP_DayData_Update_NAK 구조 내보내기
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_DayData_Update_NAK`(
	IN `_ChimneyCode` VARCHAR(50),
	IN `_Category` VARCHAR(50),
	IN `_SaveDate` DATE
)
BEGIN
	UPDATE day_data SET Ack = 0 
	WHERE (ChimneyCode = _ChimneyCode)
	AND (Category = _Category)
	AND (SaveDate = _SaveDate);
END//
DELIMITER ;
DROP PROCEDURE IF EXISTS `SP_PowOffData_Delete1`;
-- 프로시저 bdtec_client_m1.SP_PowOffData_Delete1 구조 내보내기
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_PowOffData_Delete1`(
	IN `_from` DATETIME
)
BEGIN
	DELETE FROM pow_off_data WHERE SaveTime < _from;
END//
DELIMITER ;
DROP PROCEDURE IF EXISTS `SP_PowOffData_Delete2`;
-- 프로시저 bdtec_client_m1.SP_PowOffData_Delete2 구조 내보내기
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_PowOffData_Delete2`(
	IN `_from` DATETIME
)
BEGIN
	DELETE FROM pow_off_data WHERE SaveTime >= _from;
END//
DELIMITER ;
DROP PROCEDURE IF EXISTS `SP_PowOffData_Delete3`;
-- 프로시저 bdtec_client_m1.SP_PowOffData_Delete3 구조 내보내기
DELIMITER //
CREATE PROCEDURE `SP_PowOffData_Delete3`(
	IN `_time` DATETIME
)
BEGIN
DELETE FROM pow_off_data WHERE SaveTime = _time;
END//
DELIMITER ;
DROP PROCEDURE IF EXISTS `SP_PowOffData_Delete4`;
-- 프로시저 bdtec_client_m1.SP_PowOffData_Delete4 구조 내보내기
DELIMITER //
CREATE PROCEDURE `SP_PowOffData_Delete4`(
	IN `_Category` VARCHAR(50),
	IN `_time` DATETIME
)
BEGIN
DELETE FROM pow_off_data WHERE SaveTime = _time AND Category = _Category;
END//
DELIMITER ;
DROP PROCEDURE IF EXISTS `SP_PowOffData_Fill`;
-- 프로시저 bdtec_client_m1.SP_PowOffData_Fill 구조 내보내기
DELIMITER //
CREATE PROCEDURE `SP_PowOffData_Fill`()
BEGIN
    DECLARE now_time DATETIME;
    DECLARE last_fiv_time DATETIME;
    DECLARE last_haf_time DATETIME;
    DECLARE check_time DATETIME;
    DECLARE ok_count INT;
    -- Get the current time
    SET now_time = NOW();
 
    -- Get the most recent time for Category 'FIV'
    SELECT MAX(SaveTime) INTO last_fiv_time FROM average_data WHERE Category = 'FIV';
 
    -- Get the most recent time for Category 'HAF'
    SELECT MAX(SaveTime) INTO last_haf_time FROM average_data WHERE Category = 'HAF';
 
    -- Step 1: Fill missing 5-minute intervals for 'FIV'
    SET check_time = last_fiv_time + INTERVAL 5 MINUTE;
    WHILE check_time <= now_time DO
    		/*
        INSERT INTO average_data (SaveTime, Category, ChimneyCode, CH, DataCode, ItemCode, AvgValue, DataState, RunState, PreState, SendState, Ack)
        SELECT check_time, t.Category, t.ChimneyCode, t.CH, t.DataCode, t.ItemCode, 0, 4, 0, 3, 0, 1
        FROM (
            SELECT DISTINCT Category, ChimneyCode, CH, DataCode, ItemCode
            FROM average_data
            WHERE SaveTime = last_fiv_time AND Category = 'FIV'
        ) t
        WHERE NOT EXISTS (
            SELECT 1
            FROM average_data a
            WHERE a.SaveTime = check_time AND a.Category = t.Category AND a.ChimneyCode = t.ChimneyCode AND a.CH = t.CH AND a.DataCode = t.DataCode AND a.ItemCode = t.ItemCode
        );
        */
			-- Insert into pow_off_data table
        INSERT INTO pow_off_data (SaveTime, ChimneyCode, Category, SendState, Ack)
        SELECT check_time, t.ChimneyCode, 'FIV', 0, 1
        FROM (
            SELECT DISTINCT ChimneyCode
            FROM average_data
            WHERE Category = 'FIV'
        ) t
        WHERE NOT EXISTS (
            SELECT 1
            FROM pow_off_data p
            WHERE p.SaveTime = check_time AND p.ChimneyCode = t.ChimneyCode AND p.Category = 'FIV'
        );
        SET check_time = check_time + INTERVAL 5 MINUTE;
    END WHILE;
 
    -- Step 2: Fill missing 30-minute intervals for 'HAF'
    SET check_time = last_haf_time + INTERVAL 30 MINUTE;
    WHILE check_time <= now_time DO
			SET ok_count = (SELECT COUNT(*) FROM average_data AS z WHERE z.SaveTime BETWEEN DATE_SUB(check_time, INTERVAL 30 MINUTE) AND DATE_SUB(check_time, INTERVAL 1 MINUTE) AND z.Category = 'FIV');
 
			IF ok_count > 0
				THEN
					INSERT INTO average_data (SaveTime, Category, ChimneyCode, CH, DataCode, ItemCode, AvgValue, DataState, RunState, PreState, SendState, Ack)
			        SELECT check_time, t.Category, t.ChimneyCode, t.CH, t.DataCode, t.ItemCode, 		  
					  CASE 
							WHEN 
								(SELECT 
									COUNT(*) 
								FROM 
									average_data AS z 
								WHERE 
									z.SaveTime BETWEEN DATE_SUB(check_time, INTERVAL 30 MINUTE) AND DATE_SUB(check_time, INTERVAL 1 MINUTE) 
									AND z.Category = 'FIV' 
									AND z.ChimneyCode = t.ChimneyCode 
									AND z.CH = t.CH
								) >= 3
							THEN -- 3개이상이면 / 유효수
								(SELECT 
									SUM(AvgValue)/COUNT(*)
								FROM 
									average_data AS z 
								WHERE 
									z.SaveTime BETWEEN DATE_SUB(check_time, INTERVAL 30 MINUTE) AND DATE_SUB(check_time, INTERVAL 1 MINUTE) 
									AND z.Category = 'FIV' 
									AND z.ChimneyCode = t.ChimneyCode 
									AND z.CH = t.CH
								)		
					  		ELSE -- 3개 미만이면 /6
								(SELECT 
									SUM(AvgValue)/6
								FROM 
									average_data AS z 
								WHERE 
									z.SaveTime BETWEEN DATE_SUB(check_time, INTERVAL 30 MINUTE) AND DATE_SUB(check_time, INTERVAL 1 MINUTE) 
									AND z.Category = 'FIV' 
									AND z.ChimneyCode = t.ChimneyCode 
									AND z.CH = t.CH
								)
						END, 
					  4, 0, 3, 0, 1
			        FROM (
			            SELECT DISTINCT Category, ChimneyCode, CH, DataCode, ItemCode
			            FROM average_data
			            WHERE SaveTime = last_haf_time AND Category = 'HAF'
			        ) t
			        WHERE NOT EXISTS (
			            SELECT 1
			            FROM average_data a
			            WHERE a.SaveTime = check_time AND a.Category = t.Category AND a.ChimneyCode = t.ChimneyCode AND a.CH = t.CH AND a.DataCode = t.DataCode AND a.ItemCode = t.ItemCode
			        );	
				ELSE -- 5분데이터가 1도 없으면 pow_off_data insert
						-- Insert into pow_off_data table
			        INSERT INTO pow_off_data (SaveTime, ChimneyCode, Category, SendState, Ack)
			        SELECT check_time, t.ChimneyCode, 'HAF', 0, 1
			        FROM (
			            SELECT DISTINCT ChimneyCode
			            FROM average_data
			            WHERE Category = 'HAF'
			        ) t
			        WHERE NOT EXISTS (
			            SELECT 1
			            FROM pow_off_data p
			            WHERE p.SaveTime = check_time AND p.ChimneyCode = t.ChimneyCode AND p.Category = 'HAF'
			        );
			END IF;
 
        SET check_time = check_time + INTERVAL 30 MINUTE;
    END WHILE;
 
    UPDATE average_data
	 SET PreState = 1
	 WHERE SaveTime > last_fiv_time AND Category = 'FIV' AND DataCode LIKE 'E%' AND ItemCode LIKE 'A';
END//
DELIMITER ;
DROP PROCEDURE IF EXISTS `SP_PowOffData_Fill_2`;
-- 프로시저 bdtec_client_m1.SP_PowOffData_Fill_2 구조 내보내기
DELIMITER //
CREATE PROCEDURE `SP_PowOffData_Fill_2`(
	IN `_to` DATETIME
)
BEGIN
    DECLARE now_time DATETIME;
    DECLARE last_fiv_time DATETIME;
    DECLARE last_haf_time DATETIME;
    DECLARE check_time DATETIME;
    DECLARE ok_count INT;

    -- Set the current time to the provided input parameter
    SET now_time = _to;
    INSERT INTO log_table (LogMessage) VALUES (CONCAT('Step 1: Set now_time - _to: ', _to, ', now_time: ', now_time));

    -- Get the most recent time for Category 'FIV'
    SELECT MAX(SaveTime) INTO last_fiv_time FROM average_data WHERE Category = 'FIV';
    INSERT INTO log_table (LogMessage) VALUES (CONCAT('Step 2: Get last_fiv_time - last_fiv_time: ', last_fiv_time));

    -- Get the most recent time for Category 'HAF'
    SELECT MAX(SaveTime) INTO last_haf_time FROM average_data WHERE Category = 'HAF';
    INSERT INTO log_table (LogMessage) VALUES (CONCAT('Step 3: Get last_haf_time - last_haf_time: ', last_haf_time));

    -- Step 1: Fill missing 5-minute intervals for 'FIV'
    SET check_time = last_fiv_time + INTERVAL 5 MINUTE;
    INSERT INTO log_table (LogMessage) VALUES (CONCAT('Step 4: Set check_time for FIV - now_time: ', now_time, ', last_fiv_time: ', last_fiv_time, ', check_time: ', check_time));
    
    WHILE check_time <= now_time DO
        INSERT INTO log_table (LogMessage) VALUES (CONCAT('Step 5: Before INSERT into pow_off_data (FIV) - now_time: ', now_time, ', check_time: ', check_time));
        
        INSERT INTO pow_off_data (SaveTime, ChimneyCode, Category, SendState, Ack)
        SELECT check_time, t.ChimneyCode, 'FIV', 0, 1
        FROM (
            SELECT DISTINCT ChimneyCode
            FROM average_data
            WHERE Category = 'FIV'
        ) t
        WHERE NOT EXISTS (
            SELECT 1
            FROM pow_off_data p
            WHERE p.SaveTime = check_time AND p.ChimneyCode = t.ChimneyCode AND p.Category = 'FIV'
        );
        
        INSERT INTO log_table (LogMessage) VALUES (CONCAT('Step 6: After INSERT into pow_off_data (FIV) - now_time: ', now_time, ', check_time: ', check_time));
        SET check_time = check_time + INTERVAL 5 MINUTE;
    END WHILE;

    -- Step 2: Fill missing 30-minute intervals for 'HAF'
    SET check_time = last_haf_time + INTERVAL 30 MINUTE;
    INSERT INTO log_table (LogMessage) VALUES (CONCAT('Step 7: Set check_time for HAF - now_time: ', now_time, ', last_haf_time: ', last_haf_time, ', check_time: ', check_time));
    
    WHILE check_time <= now_time DO
        SET ok_count = (SELECT COUNT(*) FROM average_data AS z WHERE z.SaveTime BETWEEN DATE_SUB(check_time, INTERVAL 30 MINUTE) AND DATE_SUB(check_time, INTERVAL 1 MINUTE) AND z.Category = 'FIV');
        INSERT INTO log_table (LogMessage) VALUES (CONCAT('Step 8: Check ok_count for HAF - now_time: ', now_time, ', check_time: ', check_time, ', ok_count: ', ok_count));
        
        IF ok_count > 0 THEN
            INSERT INTO average_data (SaveTime, Category, ChimneyCode, CH, DataCode, ItemCode, AvgValue, DataState, RunState, PreState, SendState, Ack)
            SELECT check_time, t.Category, t.ChimneyCode, t.CH, t.DataCode, t.ItemCode, 
                CASE 
                    WHEN 
                        (SELECT COUNT(*) 
                         FROM average_data AS z 
                         WHERE z.SaveTime BETWEEN DATE_SUB(check_time, INTERVAL 30 MINUTE) AND DATE_SUB(check_time, INTERVAL 1 MINUTE) 
                         AND z.Category = 'FIV' 
                         AND z.ChimneyCode = t.ChimneyCode 
                         AND z.CH = t.CH) >= 3
                    THEN 
                        (SELECT SUM(AvgValue)/COUNT(*)
                         FROM average_data AS z 
                         WHERE z.SaveTime BETWEEN DATE_SUB(check_time, INTERVAL 30 MINUTE) AND DATE_SUB(check_time, INTERVAL 1 MINUTE) 
                         AND z.Category = 'FIV' 
                         AND z.ChimneyCode = t.ChimneyCode 
                         AND z.CH = t.CH)
                    ELSE 
                        (SELECT SUM(AvgValue)/6
                         FROM average_data AS z 
                         WHERE z.SaveTime BETWEEN DATE_SUB(check_time, INTERVAL 30 MINUTE) AND DATE_SUB(check_time, INTERVAL 1 MINUTE) 
                         AND z.Category = 'FIV' 
                         AND z.ChimneyCode = t.ChimneyCode 
                         AND z.CH = t.CH)
                END, 
                4, 0, 3, 0, 1
            FROM (
                SELECT DISTINCT Category, ChimneyCode, CH, DataCode, ItemCode
                FROM average_data
                WHERE SaveTime = last_haf_time AND Category = 'HAF'
            ) t
            WHERE NOT EXISTS (
                SELECT 1
                FROM average_data a
                WHERE a.SaveTime = check_time AND a.Category = t.Category AND a.ChimneyCode = t.ChimneyCode AND a.CH = t.CH AND a.DataCode = t.DataCode AND a.ItemCode = t.ItemCode
            );	
            INSERT INTO log_table (LogMessage) VALUES (CONCAT('Step 9: After INSERT into average_data (HAF) - now_time: ', now_time, ', check_time: ', check_time, ', ok_count: ', ok_count));
        ELSE
            -- Insert into pow_off_data table
            INSERT INTO log_table (LogMessage) VALUES (CONCAT('Step 10: Before INSERT into pow_off_data (HAF) - now_time: ', now_time, ', check_time: ', check_time, ', ok_count: ', ok_count));
            INSERT INTO pow_off_data (SaveTime, ChimneyCode, Category, SendState, Ack)
            SELECT check_time, t.ChimneyCode, 'HAF', 0, 1
            FROM (
                SELECT DISTINCT ChimneyCode
                FROM average_data
                WHERE Category = 'HAF'
            ) t
            WHERE NOT EXISTS (
                SELECT 1
                FROM pow_off_data p
                WHERE p.SaveTime = check_time AND p.ChimneyCode = t.ChimneyCode AND p.Category = 'HAF'
            );
            INSERT INTO log_table (LogMessage) VALUES (CONCAT('Step 11: After INSERT into pow_off_data (HAF) - now_time: ', now_time, ', check_time: ', check_time, ', ok_count: ', ok_count));
        END IF;

        SET check_time = check_time + INTERVAL 30 MINUTE;
    END WHILE;

    -- Update average_data table
    UPDATE average_data
    SET PreState = 1
    WHERE SaveTime > last_fiv_time AND Category = 'FIV' AND DataCode LIKE 'E%' AND ItemCode LIKE 'A';
    INSERT INTO log_table (LogMessage) VALUES (CONCAT('Step 12: After UPDATE average_data - now_time: ', now_time, ', last_fiv_time: ', last_fiv_time));
END//
DELIMITER ;
DROP PROCEDURE IF EXISTS `SP_PowOffData_Fill_3`;
-- 프로시저 bdtec_client_m1.SP_PowOffData_Fill_3 구조 내보내기
DELIMITER //
CREATE PROCEDURE `SP_PowOffData_Fill_3`(
	IN `_to` DATETIME
)
BEGIN
    DECLARE now_time DATETIME;
    DECLARE last_fiv_time DATETIME;
    DECLARE last_haf_time DATETIME;
    DECLARE check_time DATETIME;
    DECLARE ok_count INT;
    
    DECLARE data_state INT;
    DECLARE run_state INT;
    DECLARE pre_state INT;
	 DECLARE avg_value Double;
    
    -- Set the current time to the provided input parameter
    SET now_time = _to;
    -- INSERT INTO log_table (LogMessage) VALUES (CONCAT('Step 1: Set now_time - _to: ', _to, ', now_time: ', now_time));

    -- Get the most recent time for Category 'FIV'
    SELECT MAX(SaveTime) INTO last_fiv_time FROM average_data WHERE Category = 'FIV';
    -- INSERT INTO log_table (LogMessage) VALUES (CONCAT('Step 2: Get last_fiv_time - last_fiv_time: ', last_fiv_time));

    -- Get the most recent time for Category 'HAF'
    SELECT MAX(SaveTime) INTO last_haf_time FROM average_data WHERE Category = 'HAF';
    INSERT INTO log_table (LogMessage) VALUES (CONCAT('Step 3: Get last_haf_time - last_haf_time: ', last_haf_time));

    -- Step 1: Fill missing 5-minute intervals for 'FIV'
    SET check_time = last_fiv_time + INTERVAL 5 MINUTE;
    INSERT INTO log_table (LogMessage) VALUES (CONCAT('Step 4: Set check_time for FIV - now_time: ', now_time, ', last_fiv_time: ', last_fiv_time, ', check_time: ', check_time));
    
    WHILE check_time <= now_time DO
        INSERT INTO log_table (LogMessage) VALUES (CONCAT('Step 5: Before INSERT into pow_off_data (FIV) - now_time: ', now_time, ', check_time: ', check_time));
        
        INSERT INTO pow_off_data (SaveTime, ChimneyCode, Category, SendState, Ack)
        SELECT check_time, t.ChimneyCode, 'FIV', 0, 1
        FROM (
            SELECT DISTINCT ChimneyCode
            FROM average_data
            WHERE Category = 'FIV'
        ) t
        WHERE NOT EXISTS (
            SELECT 1
            FROM pow_off_data p
            WHERE p.SaveTime = check_time AND p.ChimneyCode = t.ChimneyCode AND p.Category = 'FIV'
        );
        
        -- INSERT INTO log_table (LogMessage) VALUES (CONCAT('Step 6: After INSERT into pow_off_data (FIV) - now_time: ', now_time, ', check_time: ', check_time));
        SET check_time = check_time + INTERVAL 5 MINUTE;
    END WHILE;

    -- Step 2: Fill missing 30-minute intervals for 'HAF'
    SET check_time = last_haf_time + INTERVAL 30 MINUTE;
    INSERT INTO log_table (LogMessage) VALUES (CONCAT('Step 7: Set check_time for HAF - now_time: ', now_time, ', last_haf_time: ', last_haf_time, ', check_time: ', check_time));
    
    WHILE check_time <= now_time DO
        SET ok_count = (SELECT COUNT(*) FROM average_data AS z WHERE z.SaveTime BETWEEN DATE_SUB(check_time, INTERVAL 30 MINUTE) AND DATE_SUB(check_time, INTERVAL 1 MINUTE) AND z.Category = 'FIV');
        INSERT INTO log_table (LogMessage) VALUES (CONCAT('Step 8: Check ok_count for HAF - now_time: ', now_time, ', check_time: ', check_time, ', ok_count: ', ok_count));
        
        IF ok_count > 0 THEN
        
                -- Calculate RunState based on priority 8, 4, 2, 1
		        SET run_state = (
		            SELECT LEAST(6, SUM(RunState))
		            FROM average_data
		            WHERE SaveTime BETWEEN DATE_SUB(check_time, INTERVAL 30 MINUTE) AND DATE_SUB(check_time, INTERVAL 1 MINUTE)
		            AND Category = 'FIV'
		        );
		        
		        -- Calculate PreState based on priority 9, 8, 0, 1
		        SET pre_state = (
		            SELECT MAX(CASE 
		                WHEN PreState = 9 THEN 9
		                WHEN PreState = 8 THEN 8
		                WHEN PreState = 0 THEN 0
		                WHEN PreState = 1 THEN 1
		                WHEN PreState = 3 THEN 3		                
		                ELSE 0
		            END)
		            FROM average_data AS z 
		            WHERE z.SaveTime BETWEEN DATE_SUB(check_time, INTERVAL 30 MINUTE) AND DATE_SUB(check_time, INTERVAL 1 MINUTE) 
		            AND z.Category = 'FIV'
		            AND z.ChimneyCode = t.ChimneyCode 
		            AND z.CH = t.CH
		        );
		
		        -- SET data_state = 4; -- Your original logic for DataState
		        SET data_state = (
		            SELECT 
		                MAX(CASE 
		                    WHEN DataState = 8 THEN 8
		                    WHEN DataState = 4 THEN 4
		                    WHEN DataState = 2 THEN 2
		                    WHEN DataState = 1 THEN 1
		                    ELSE 0
		                END)
		            FROM average_data 
		            WHERE z.SaveTime BETWEEN DATE_SUB(check_time, INTERVAL 30 MINUTE) AND DATE_SUB(check_time, INTERVAL 1 MINUTE) 
		            AND z.Category = 'FIV'
		            AND z.ChimneyCode = t.ChimneyCode 
		            AND z.CH = t.CH
		        );
		        SET avg_value = (
		            CASE 
		                WHEN (
		                    SELECT COUNT(*) 
		                    FROM average_data AS z 
		                    WHERE z.SaveTime BETWEEN DATE_SUB(check_time, INTERVAL 30 MINUTE) AND DATE_SUB(check_time, INTERVAL 1 MINUTE) 
		                    AND z.Category = 'FIV' 
		                    AND z.ChimneyCode = t.ChimneyCode 
		                    AND z.CH = t.CH
		                ) >= 3 THEN 
		                    (
		                        SELECT SUM(AvgValue)/COUNT(*)
		                        FROM average_data AS z 
		                        WHERE z.SaveTime BETWEEN DATE_SUB(check_time, INTERVAL 30 MINUTE) AND DATE_SUB(check_time, INTERVAL 1 MINUTE) 
		                        AND z.Category = 'FIV' 
		                        AND z.ChimneyCode = t.ChimneyCode 
		                        AND z.CH = t.CH
		                    )
		                ELSE 
		                    (
		                        SELECT SUM(AvgValue)/6
		                        FROM average_data AS z 
		                        WHERE z.SaveTime BETWEEN DATE_SUB(check_time, INTERVAL 30 MINUTE) AND DATE_SUB(check_time, INTERVAL 1 MINUTE) 
		                        AND z.Category = 'FIV' 
		                        AND z.ChimneyCode = t.ChimneyCode 
		                        AND z.CH = t.CH
		                    )
		            END
		        );
            INSERT INTO average_data (SaveTime, Category, ChimneyCode, CH, DataCode, ItemCode, AvgValue, DataState, RunState, PreState, SendState, Ack)
        		SELECT 
	            check_time, 
	            t.Category, 
	            t.ChimneyCode, 
	            t.CH, 
	            t.DataCode, 
	            t.ItemCode, 
	            avg_value, 
	            data_state, 
	            run_state, 
	            pre_state, 
	            0, 
	            1
            FROM (
                SELECT DISTINCT Category, ChimneyCode, CH, DataCode, ItemCode
                FROM average_data
                WHERE SaveTime = last_haf_time AND Category = 'HAF'
            ) t
            WHERE NOT EXISTS (
                SELECT 1
                FROM average_data a
                WHERE a.SaveTime = check_time AND a.Category = t.Category AND a.ChimneyCode = t.ChimneyCode AND a.CH = t.CH AND a.DataCode = t.DataCode AND a.ItemCode = t.ItemCode
            );	
            INSERT INTO log_table (LogMessage) VALUES (CONCAT('Step 9: After INSERT into average_data (HAF) - now_time: ', now_time, ', check_time: ', check_time, ', ok_count: ', ok_count));
        ELSE
            -- Insert into pow_off_data table
            INSERT INTO log_table (LogMessage) VALUES (CONCAT('Step 10: Before INSERT into pow_off_data (HAF) - now_time: ', now_time, ', check_time: ', check_time, ', ok_count: ', ok_count));
            INSERT INTO pow_off_data (SaveTime, ChimneyCode, Category, SendState, Ack)
            SELECT check_time, t.ChimneyCode, 'HAF', 0, 1
            FROM (
                SELECT DISTINCT ChimneyCode
                FROM average_data
                WHERE Category = 'HAF'
            ) t
            WHERE NOT EXISTS (
                SELECT 1
                FROM pow_off_data p
                WHERE p.SaveTime = check_time AND p.ChimneyCode = t.ChimneyCode AND p.Category = 'HAF'
            );
            INSERT INTO log_table (LogMessage) VALUES (CONCAT('Step 11: After INSERT into pow_off_data (HAF) - now_time: ', now_time, ', check_time: ', check_time, ', ok_count: ', ok_count));
        END IF;

        SET check_time = check_time + INTERVAL 30 MINUTE;
    END WHILE;

    -- Update average_data table
    UPDATE average_data
    SET PreState = 1
    WHERE SaveTime > last_fiv_time AND Category = 'FIV' AND DataCode LIKE 'E%' AND ItemCode LIKE 'A';
    INSERT INTO log_table (LogMessage) VALUES (CONCAT('Step 12: After UPDATE average_data - now_time: ', now_time, ', last_fiv_time: ', last_fiv_time));
END//
DELIMITER ;
DROP PROCEDURE IF EXISTS `SP_PowOffData_Insert`;
-- 프로시저 bdtec_client_m1.SP_PowOffData_Insert 구조 내보내기
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_PowOffData_Insert`(
	IN `_ChimneyCode` VARCHAR(50),
	IN `_Category` VARCHAR(50),
	IN `_SaveTime` DATETIME
)
BEGIN
    DECLARE data_exists INT DEFAULT 0;

    -- Check if the data already exists in pow_off_data
    SELECT COUNT(*) INTO data_exists
    FROM pow_off_data
    WHERE SaveTime = _SaveTime
      AND Category = _Category
      AND ChimneyCode = _ChimneyCode;

    -- Check if the data already exists in average_data
    IF data_exists = 0 THEN
        SELECT COUNT(*) INTO data_exists
        FROM average_data
        WHERE SaveTime = _SaveTime
          AND Category = _Category
          AND ChimneyCode = _ChimneyCode;
    END IF;

    -- Insert data if it does not exist in both tables
    IF data_exists = 0 THEN
        INSERT INTO pow_off_data (ChimneyCode, Category, SaveTime)
        VALUES (_ChimneyCode, _Category, _SaveTime);
    END IF;
END//
DELIMITER ;
DROP PROCEDURE IF EXISTS `SP_PowOffData_Last`;
-- 프로시저 bdtec_client_m1.SP_PowOffData_Last 구조 내보내기
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_PowOffData_Last`(
	IN `_ChimneyCode` VARCHAR(50),
	IN `_Category` VARCHAR(50),
	IN `_from` DATETIME,
	IN `_to` DATETIME	
)
BEGIN
	SELECT * FROM pow_off_data
	WHERE (ChimneyCode = _ChimneyCode)
	AND (Category = _Category)
	AND (SaveTime >= _from)
	AND (SaveTime < _to)
	ORDER BY SaveTime DESC LIMIT 1;
END//
DELIMITER ;
DROP PROCEDURE IF EXISTS `SP_PowOffData_Select`;
-- 프로시저 bdtec_client_m1.SP_PowOffData_Select 구조 내보내기
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_PowOffData_Select`(
	IN `_ChimneyCode` VARCHAR(50),
	IN `_Category` VARCHAR(50),
	IN `_from` DATETIME,
	IN `_to` DATETIME
)
BEGIN
	SELECT * FROM pow_off_data
	WHERE (ChimneyCode = _ChimneyCode)
	AND (Category = _Category)
	AND (SaveTime BETWEEN _from AND _to)
	ORDER BY SaveTime;
END//
DELIMITER ;
DROP PROCEDURE IF EXISTS `SP_PowOffData_Select_Count`;
-- 프로시저 bdtec_client_m1.SP_PowOffData_Select_Count 구조 내보내기
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_PowOffData_Select_Count`(
	IN `_ChimneyCode` VARCHAR(50),
	IN `_Category` VARCHAR(50),
	IN `_from` DATETIME,
	IN `_to` DATETIME
)
BEGIN
	SELECT Count(*) FROM pow_off_data
	WHERE (ChimneyCode = _ChimneyCode)
	AND (Category = _Category)
	AND (SaveTime BETWEEN _from AND _to)
	ORDER BY SaveTime;
END//
DELIMITER ;
DROP PROCEDURE IF EXISTS `SP_PowOffData_Select_NoSend`;
-- 프로시저 bdtec_client_m1.SP_PowOffData_Select_NoSend 구조 내보내기
DELIMITER //
CREATE PROCEDURE `SP_PowOffData_Select_NoSend`(
	IN `_ChimneyCode` VARCHAR(50),
	IN `_Category` VARCHAR(50),
	IN `_from` DATETIME,
	IN `_to` DATETIME
)
BEGIN
	SELECT * FROM pow_off_data
	WHERE (ChimneyCode = _ChimneyCode)
	AND (SendState = 0)
	AND (Category = _Category)
	AND (SaveTime BETWEEN _from AND _to)
	ORDER BY SaveTime;
END//
DELIMITER ;
DROP PROCEDURE IF EXISTS `SP_PowOffData_Select_Send`;
-- 프로시저 bdtec_client_m1.SP_PowOffData_Select_Send 구조 내보내기
DELIMITER //
CREATE PROCEDURE `SP_PowOffData_Select_Send`()
BEGIN

END//
DELIMITER ;

DROP PROCEDURE IF EXISTS `SP_PowOffData_Select_TDUH`;
-- 프로시저 bdtec_client_m1.SP_PowOffData_Select_TDUH 구조 내보내기
DELIMITER //
CREATE  DEFINER=`root`@`localhost`PROCEDURE `SP_PowOffData_Select_TDUH`(
	IN `_ChimneyCode` VARCHAR(50),
	IN `_Category` VARCHAR(50),
	IN `_from` DATETIME,
	IN `_to` DATETIME
)
BEGIN
	SELECT * FROM pow_off_data
	WHERE (ChimneyCode = _ChimneyCode)
	AND (SendState = 1)
	AND (Category = _Category)
	AND (SaveTime BETWEEN _from AND _to)
	ORDER BY SaveTime;
END//
DELIMITER ;
DROP PROCEDURE IF EXISTS `SP_PowOffData_Update_ACK`;
-- 프로시저 bdtec_client_m1.SP_PowOffData_Update_ACK 구조 내보내기
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_PowOffData_Update_ACK`(
	IN `_ChimneyCode` VARCHAR(50),
	IN `_Category` VARCHAR(50),
	IN `_SaveTime` DATETIME
)
BEGIN
	UPDATE pow_off_data SET SendState = 1
	WHERE (ChimneyCode = _ChimneyCode)
	AND (Category = _Category)	
	AND (SaveTime = _SaveTime);
END//
DELIMITER ;
DROP PROCEDURE IF EXISTS `SP_PowOffData_Update_NAK`;
-- 프로시저 bdtec_client_m1.SP_PowOffData_Update_NAK 구조 내보내기
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_PowOffData_Update_NAK`(
	IN `_ChimneyCode` VARCHAR(50),
	IN `_Category` VARCHAR(50),
	IN `_SaveTime` DATETIME
)
BEGIN
	UPDATE pow_off_data SET Ack = 0
	WHERE (ChimneyCode = _ChimneyCode)
	AND (Category = _Category)
	AND (SaveTime = _SaveTime);
END//
DELIMITER ;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
