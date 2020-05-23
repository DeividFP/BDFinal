-- phpMyAdmin SQL Dump
-- version 5.0.2
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 23-05-2020 a las 06:34:25
-- Versión del servidor: 10.4.11-MariaDB
-- Versión de PHP: 7.4.6

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `c_d`
--

DELIMITER $$
--
-- Procedimientos
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `BusqAct` (`busq` VARCHAR(20))  BEGIN
  SELECT * FROM actividad WHERE (act_cod LIKE CONCAT('%', busq, '%') OR act_descr LIKE CONCAT('%', busq, '%') OR act_prof LIKE CONCAT('%', busq, '%'));
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `BusqMat` (`busq` VARCHAR(20))  BEGIN
  SELECT * FROM material WHERE (mat_sku LIKE CONCAT('%', busq, '%') OR mat_nombre LIKE CONCAT('%', busq, '%') OR mat_descr LIKE CONCAT('%', busq, '%'));
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `BusqUsr` (IN `busq` VARCHAR(20))  BEGIN
  SELECT reg_mb, reg_pri, reg_seg, reg_nom, usr_statuss FROM registro join usr on (usr_mb LIKE CONCAT('%', busq, '%') OR reg_pri LIKE CONCAT('%', busq, '%') OR reg_seg LIKE CONCAT('%', busq, '%') OR reg_nom LIKE CONCAT('%', busq, '%')) AND usr.usr_mb=registro.reg_mb;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `DatReg` (`mabo` VARCHAR(15))  BEGIN
  SELECT * FROM registro WHERE reg_mb = mabo;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `DescAct` (`des` VARCHAR(20))  BEGIN
  SELECT * FROM actividad WHERE act_descr = des;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `actividad`
--

CREATE TABLE `actividad` (
  `act_cod` varchar(5) NOT NULL,
  `act_tipo` int(11) NOT NULL,
  `act_descr` varchar(20) NOT NULL,
  `act_prof` varchar(15) NOT NULL,
  `act_lugar` varchar(20) NOT NULL,
  `act_li` varchar(6) DEFAULT NULL,
  `act_lf` varchar(6) DEFAULT NULL,
  `act_mi` varchar(6) DEFAULT NULL,
  `act_mf` varchar(6) DEFAULT NULL,
  `act_mii` varchar(6) DEFAULT NULL,
  `act_mif` varchar(6) DEFAULT NULL,
  `act_ji` varchar(6) DEFAULT NULL,
  `act_jf` varchar(6) DEFAULT NULL,
  `act_vi` varchar(6) DEFAULT NULL,
  `act_vf` varchar(6) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `actividad`
--

INSERT INTO `actividad` (`act_cod`, `act_tipo`, `act_descr`, `act_prof`, `act_lugar`, `act_li`, `act_lf`, `act_mi`, `act_mf`, `act_mii`, `act_mif`, `act_ji`, `act_jf`, `act_vi`, `act_vf`) VALUES
('BC123', 1, 'FUTBOL AMERICANO', '2014110374', 'CANCHAS', '14:30', '16:00', '10:00', '11:30', '', '', '10:00', '11:30', '', '');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `carrera`
--

CREATE TABLE `carrera` (
  `carr_id` int(11) NOT NULL,
  `carr_descr` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `carrera`
--

INSERT INTO `carrera` (`carr_id`, `carr_descr`) VALUES
(1, 'BIÓNICA'),
(2, 'ENERGÍA'),
(3, 'ISISA'),
(4, 'MECATRÓNICA'),
(5, 'TELEMÁTICA'),
(6, 'NO APLICA');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `inscritos`
--

CREATE TABLE `inscritos` (
  `ins_id_mb` varchar(15) NOT NULL,
  `ins_id_act` varchar(5) NOT NULL,
  `ins_creditos` int(11) DEFAULT NULL CHECK (`ins_creditos` >= 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `inscritos`
--

INSERT INTO `inscritos` (`ins_id_mb`, `ins_id_act`, `ins_creditos`) VALUES
('kldsanjsakns', 'BC123', 0),
('2014110374', 'BC123', 0);

--
-- Disparadores `inscritos`
--
DELIMITER $$
CREATE TRIGGER `cred_aI` BEFORE INSERT ON `inscritos` FOR EACH ROW BEGIN
  SET NEW.ins_creditos=0;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `cred_aU` BEFORE UPDATE ON `inscritos` FOR EACH ROW BEGIN
  IF NEW.ins_creditos < 0 THEN
    SET NEW.ins_creditos=0;
  END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `material`
--

CREATE TABLE `material` (
  `mat_sku` varchar(12) NOT NULL,
  `mat_nombre` varchar(15) NOT NULL,
  `mat_descr` varchar(30) NOT NULL,
  `mat_costo` varchar(10) NOT NULL CHECK (`mat_costo` >= 0),
  `mat_tipo_ingreso` varchar(12) NOT NULL,
  `mat_fecha_ingreso` date NOT NULL,
  `mat_statuss` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `material`
--

INSERT INTO `material` (`mat_sku`, `mat_nombre`, `mat_descr`, `mat_costo`, `mat_tipo_ingreso`, `mat_fecha_ingreso`, `mat_statuss`) VALUES
('S025D78T13', 'BALON', 'BALÓN DE BASKETBALL', '223', 'DONACIÓN', '2020-05-07', 2);

--
-- Disparadores `material`
--
DELIMITER $$
CREATE TRIGGER `Ncost_mat` BEFORE UPDATE ON `material` FOR EACH ROW BEGIN
  IF NEW.mat_costo < 0 THEN
    SET NEW.mat_costo=0;
  END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `costo_mat` BEFORE INSERT ON `material` FOR EACH ROW BEGIN
  IF NEW.mat_costo < 0 THEN
    SET NEW.mat_costo=1;
  END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `m_status`
--

CREATE TABLE `m_status` (
  `m_sta_id` int(11) NOT NULL,
  `m_sta_descr` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `m_status`
--

INSERT INTO `m_status` (`m_sta_id`, `m_sta_descr`) VALUES
(1, 'EN PRÉSTAMO'),
(2, 'DISPONIBLE');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `registro`
--

CREATE TABLE `registro` (
  `reg_id` int(11) NOT NULL,
  `reg_mb` varchar(15) NOT NULL,
  `reg_pri` varchar(20) NOT NULL,
  `reg_seg` varchar(20) NOT NULL,
  `reg_nom` varchar(20) NOT NULL,
  `reg_f_nac` date NOT NULL,
  `reg_nss` varchar(15) NOT NULL,
  `reg_calle` varchar(20) NOT NULL,
  `reg_col` varchar(20) NOT NULL,
  `reg_am` varchar(20) NOT NULL,
  `reg_exte` varchar(8) NOT NULL,
  `reg_inte` varchar(8) DEFAULT NULL,
  `reg_email` varchar(50) NOT NULL,
  `reg_tel` varchar(10) NOT NULL,
  `reg_carrera` int(11) NOT NULL,
  `reg_rol` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `registro`
--

INSERT INTO `registro` (`reg_id`, `reg_mb`, `reg_pri`, `reg_seg`, `reg_nom`, `reg_f_nac`, `reg_nss`, `reg_calle`, `reg_col`, `reg_am`, `reg_exte`, `reg_inte`, `reg_email`, `reg_tel`, `reg_carrera`, `reg_rol`) VALUES
(6, 'kldsanjsakns', 'NEQUE', 'RESENTIDO', 'ELCHA', '2002-10-08', 'DFFDS152', 'MOCTEZUMA II', 'ARENAL 4TA SECCIÓN', 'VENUSTIANO CARRANZA', '151', '', 'jep@prueba.com', '5549119712', 1, 1),
(7, '2014110374', 'FARELAS', 'PERALTA', 'JESÚS DAVID', '1998-05-01', 'SAASFFSA', 'MOCTEZUMA II', 'ARENAL 4TA SECC', 'VENUSTIANO CARRANZA', '151', '', 'farelasdavid.98@gmail.com', '5549119712', 5, 2);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `rol`
--

CREATE TABLE `rol` (
  `rol_id` int(11) NOT NULL,
  `rol_descr` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `rol`
--

INSERT INTO `rol` (`rol_id`, `rol_descr`) VALUES
(1, 'ALUMNO'),
(2, 'PROFESOR'),
(3, 'ADMINISTRADOR');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `sessions`
--

CREATE TABLE `sessions` (
  `session_id` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `expires` int(11) UNSIGNED NOT NULL,
  `data` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `sessions`
--

INSERT INTO `sessions` (`session_id`, `expires`, `data`) VALUES
('p7p0UJh7JHiLoW7e85JPz2t4bbqAHHeO', 1590294626, '{\"cookie\":{\"originalMaxAge\":null,\"expires\":null,\"httpOnly\":true,\"path\":\"/\"},\"flash\":{},\"passport\":{}}');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tipo_act`
--

CREATE TABLE `tipo_act` (
  `t_act_id` int(11) NOT NULL,
  `t_act_descr` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `tipo_act`
--

INSERT INTO `tipo_act` (`t_act_id`, `t_act_descr`) VALUES
(1, 'DEPORTIVA'),
(2, 'CULTURAL');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usr`
--

CREATE TABLE `usr` (
  `usr_id` int(11) NOT NULL,
  `usr_mb` varchar(15) NOT NULL,
  `usr_pass` varchar(60) NOT NULL,
  `usr_hashh` varchar(60) DEFAULT NULL,
  `usr_statuss` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `usr`
--

INSERT INTO `usr` (`usr_id`, `usr_mb`, `usr_pass`, `usr_hashh`, `usr_statuss`) VALUES
(7, '2014110374', '$2a$10$VNoVV0yRYY3mCtl5l4DyfeyyJ1bougaCdcmh8xI9oWuK4FvSvvV3y', '', 2),
(6, 'kldsanjsakns', '', '$2a$10$dbEg/wL.9hs4y0rTaCC3x.G2C.dgO4aLIbHomO3.ZS0M4mHoTWWAq', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `u_status`
--

CREATE TABLE `u_status` (
  `u_sta_id` int(11) NOT NULL,
  `u_sta_descr` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `u_status`
--

INSERT INTO `u_status` (`u_sta_id`, `u_sta_descr`) VALUES
(1, 'INACTIVO'),
(2, 'ACTIVO');

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `actividad`
--
ALTER TABLE `actividad`
  ADD PRIMARY KEY (`act_cod`),
  ADD KEY `fk_act_tipo` (`act_tipo`),
  ADD KEY `fk_act_prof` (`act_prof`);

--
-- Indices de la tabla `carrera`
--
ALTER TABLE `carrera`
  ADD PRIMARY KEY (`carr_id`);

--
-- Indices de la tabla `inscritos`
--
ALTER TABLE `inscritos`
  ADD KEY `fk_ins_mb` (`ins_id_mb`),
  ADD KEY `fk_ins_act` (`ins_id_act`);

--
-- Indices de la tabla `material`
--
ALTER TABLE `material`
  ADD PRIMARY KEY (`mat_sku`),
  ADD UNIQUE KEY `uk_mat_sku` (`mat_sku`),
  ADD KEY `fk_mat_stat` (`mat_statuss`);

--
-- Indices de la tabla `m_status`
--
ALTER TABLE `m_status`
  ADD PRIMARY KEY (`m_sta_id`);

--
-- Indices de la tabla `registro`
--
ALTER TABLE `registro`
  ADD PRIMARY KEY (`reg_id`),
  ADD UNIQUE KEY `uk_reg_mb` (`reg_mb`),
  ADD KEY `fk_reg_carrera` (`reg_carrera`),
  ADD KEY `fk_reg_rol` (`reg_rol`);

--
-- Indices de la tabla `rol`
--
ALTER TABLE `rol`
  ADD PRIMARY KEY (`rol_id`);

--
-- Indices de la tabla `sessions`
--
ALTER TABLE `sessions`
  ADD PRIMARY KEY (`session_id`);

--
-- Indices de la tabla `tipo_act`
--
ALTER TABLE `tipo_act`
  ADD PRIMARY KEY (`t_act_id`);

--
-- Indices de la tabla `usr`
--
ALTER TABLE `usr`
  ADD PRIMARY KEY (`usr_mb`),
  ADD UNIQUE KEY `uk_usr_id` (`usr_id`),
  ADD KEY `fk_usr_stat` (`usr_statuss`);

--
-- Indices de la tabla `u_status`
--
ALTER TABLE `u_status`
  ADD PRIMARY KEY (`u_sta_id`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `carrera`
--
ALTER TABLE `carrera`
  MODIFY `carr_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT de la tabla `m_status`
--
ALTER TABLE `m_status`
  MODIFY `m_sta_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `registro`
--
ALTER TABLE `registro`
  MODIFY `reg_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT de la tabla `rol`
--
ALTER TABLE `rol`
  MODIFY `rol_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `tipo_act`
--
ALTER TABLE `tipo_act`
  MODIFY `t_act_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `u_status`
--
ALTER TABLE `u_status`
  MODIFY `u_sta_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `actividad`
--
ALTER TABLE `actividad`
  ADD CONSTRAINT `fk_act_prof` FOREIGN KEY (`act_prof`) REFERENCES `registro` (`reg_mb`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_act_tipo` FOREIGN KEY (`act_tipo`) REFERENCES `tipo_act` (`t_act_id`) ON UPDATE CASCADE;

--
-- Filtros para la tabla `inscritos`
--
ALTER TABLE `inscritos`
  ADD CONSTRAINT `fk_ins_act` FOREIGN KEY (`ins_id_act`) REFERENCES `actividad` (`act_cod`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_ins_mb` FOREIGN KEY (`ins_id_mb`) REFERENCES `registro` (`reg_mb`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `material`
--
ALTER TABLE `material`
  ADD CONSTRAINT `fk_mat_stat` FOREIGN KEY (`mat_statuss`) REFERENCES `m_status` (`m_sta_id`) ON UPDATE CASCADE;

--
-- Filtros para la tabla `registro`
--
ALTER TABLE `registro`
  ADD CONSTRAINT `fk_reg_carrera` FOREIGN KEY (`reg_carrera`) REFERENCES `carrera` (`carr_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_reg_rol` FOREIGN KEY (`reg_rol`) REFERENCES `rol` (`rol_id`) ON UPDATE CASCADE;

--
-- Filtros para la tabla `usr`
--
ALTER TABLE `usr`
  ADD CONSTRAINT `fk_usr_mb` FOREIGN KEY (`usr_mb`) REFERENCES `registro` (`reg_mb`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_usr_stat` FOREIGN KEY (`usr_statuss`) REFERENCES `u_status` (`u_sta_id`) ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
