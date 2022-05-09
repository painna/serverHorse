-- --------------------------------------------------------
-- Servidor:                     127.0.0.1
-- Versão do servidor:           5.1.73-community - MySQL Community Server (GPL)
-- OS do Servidor:               Win64
-- HeidiSQL Versão:              11.3.0.6295
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

-- Copiando estrutura para tabela horse.cliente
CREATE TABLE IF NOT EXISTS `cliente` (
  `id` int(11) NOT NULL,
  `nome` varchar(120) DEFAULT NULL,
  `cpfcnpj` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Copiando dados para a tabela horse.cliente: ~5 rows (aproximadamente)
/*!40000 ALTER TABLE `cliente` DISABLE KEYS */;
INSERT INTO `cliente` (`id`, `nome`, `cpfcnpj`) VALUES
	(1, 'Antonio', '11111111111'),
	(2, 'Benedito', '22222222222'),
	(3, 'Carlos', '33333333333'),
	(4, 'Daniel', '44444444444'),
	(5, 'Edivaldo', '55555555555');
/*!40000 ALTER TABLE `cliente` ENABLE KEYS */;

-- Copiando estrutura para tabela horse.familiares
CREATE TABLE IF NOT EXISTS `familiares` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `idcliente` int(11) NOT NULL,
  `nome` varchar(120) DEFAULT NULL,
  `parentesco` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idcliente` (`idcliente`),
  CONSTRAINT `FK_familiares_cliente` FOREIGN KEY (`idcliente`) REFERENCES `cliente` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;

-- Copiando dados para a tabela horse.familiares: ~4 rows (aproximadamente)
/*!40000 ALTER TABLE `familiares` DISABLE KEYS */;
INSERT INTO `familiares` (`id`, `idcliente`, `nome`, `parentesco`) VALUES
	(1, 1, 'Familiar Antonio', 'Pai'),
	(2, 1, 'Familiar Antonio', 'Mae'),
	(3, 1, 'Familiar Antonio', 'Filho'),
	(4, 4, 'Familiar Daniel', 'Esposa');
/*!40000 ALTER TABLE `familiares` ENABLE KEYS */;

-- Copiando estrutura para tabela horse.grupo
CREATE TABLE IF NOT EXISTS `grupo` (
  `id` int(11) NOT NULL,
  `descricao` varchar(120) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Copiando dados para a tabela horse.grupo: ~3 rows (aproximadamente)
/*!40000 ALTER TABLE `grupo` DISABLE KEYS */;
INSERT INTO `grupo` (`id`, `descricao`) VALUES
	(1, 'Produtos Higiene'),
	(2, 'Frutaria'),
	(3, 'Padaria');
/*!40000 ALTER TABLE `grupo` ENABLE KEYS */;

-- Copiando estrutura para tabela horse.usuario
CREATE TABLE IF NOT EXISTS `usuario` (
  `id` int(11) NOT NULL DEFAULT '0',
  `USER` varchar(120) DEFAULT NULL,
  `email` varchar(200) DEFAULT NULL,
  `PASSWORD` varchar(20) DEFAULT NULL,
  `issuer` varchar(120) DEFAULT NULL,
  `NAME` varchar(120) DEFAULT NULL,
  `subject` varchar(120) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Copiando dados para a tabela horse.usuario: ~0 rows (aproximadamente)
/*!40000 ALTER TABLE `usuario` DISABLE KEYS */;
INSERT INTO `usuario` (`id`, `USER`, `email`, `PASSWORD`, `issuer`, `NAME`, `subject`) VALUES
	(1, 'horse', 'horse@horse.com.br', '1234', 'Hashload LTDA', 'horse', 'horse');
/*!40000 ALTER TABLE `usuario` ENABLE KEYS */;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
