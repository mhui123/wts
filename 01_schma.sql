Enter password: 
-- MySQL dump 10.13  Distrib 8.4.7, for Linux (x86_64)
--
-- Host: localhost    Database: stockdb
-- ------------------------------------------------------
-- Server version	8.4.7

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


--
-- Table structure for table `kiwoom_api_keys`
--

DROP TABLE IF EXISTS `kiwoom_api_keys`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `kiwoom_api_keys` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `created_at` datetime(6) NOT NULL,
  `encrypted_app_key` varchar(255) NOT NULL,
  `encrypted_secret_key` varchar(255) NOT NULL,
  `is_active` bit(1) DEFAULT NULL,
  `update_at` datetime(6) DEFAULT NULL,
  `user_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_user_id_active` (`user_id`,`is_active`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;


--
-- Table structure for table `kiwoom_audit_logs`
--

DROP TABLE IF EXISTS `kiwoom_audit_logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `kiwoom_audit_logs` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `api_endpoint` varchar(255) NOT NULL,
  `error_message` varchar(255) DEFAULT NULL,
  `execution_time` bigint DEFAULT NULL,
  `status` enum('ERROR','SUCCESS','TIMEOUT') DEFAULT NULL,
  `timestamp` datetime(6) NOT NULL,
  `user_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_user_timestamp` (`user_id`,`timestamp`),
  KEY `idx_api_endpoint` (`api_endpoint`)
) ENGINE=InnoDB AUTO_INCREMENT=72 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;


--
-- Table structure for table `kiwoom_permissions`
--

DROP TABLE IF EXISTS `kiwoom_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `kiwoom_permissions` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `current_request_count` int DEFAULT NULL,
  `daily_request_limit` int DEFAULT NULL,
  `last_reset_date` date DEFAULT NULL,
  `permission_level` enum('ADMIN_USER','BASIC_USER','TRADING_USER') DEFAULT NULL,
  `user_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `ux_kiwoom_permission_unique` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;



--
-- Table structure for table `kiwoom_stock_master`
--

DROP TABLE IF EXISTS `kiwoom_stock_master`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `kiwoom_stock_master` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `active` bit(1) DEFAULT NULL,
  `created_at` datetime(6) NOT NULL,
  `market` varchar(50) DEFAULT NULL,
  `stock_cd` varchar(6) DEFAULT NULL,
  `stock_nm` varchar(100) DEFAULT NULL,
  `update_at` datetime(6) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `ux_kiwoom_stock_master_unique` (`stock_cd`),
  KEY `idx_stock_name` (`stock_nm`)
) ENGINE=InnoDB AUTO_INCREMENT=4376 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;


--
-- Table structure for table `kiwoom_tokens`
--

DROP TABLE IF EXISTS `kiwoom_tokens`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `kiwoom_tokens` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `created_at` datetime(6) DEFAULT NULL,
  `encrypted_token` text NOT NULL,
  `expires_at` datetime(6) NOT NULL,
  `is_active` bit(1) NOT NULL,
  `token_id` varchar(36) NOT NULL,
  `updated_at` datetime(6) DEFAULT NULL,
  `user_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UKsqnql7jlh97oa6mufgm7j7gb4` (`token_id`)
) ENGINE=InnoDB AUTO_INCREMENT=110 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;


--
-- Table structure for table `monthly_cashflow_detail`
--

DROP TABLE IF EXISTS `monthly_cashflow_detail`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `monthly_cashflow_detail` (
  `detail_id` bigint NOT NULL AUTO_INCREMENT,
  `balance_krw` decimal(19,2) DEFAULT NULL,
  `balance_usd` decimal(19,2) DEFAULT NULL,
  `created_at` datetime(6) DEFAULT NULL,
  `flow_type` enum('BUY','DEPOSIT','DIVIDEND','DIVIDEND_CANCEL','FEE','FX_GAIN','FX_LOSS','INTEREST','SELL','STOCK_REWARD','TAX_ACCRUED','TAX_PAID','WITHDRAW') DEFAULT NULL,
  `fx_rate` decimal(10,2) DEFAULT NULL,
  `item_amount_krw` decimal(19,2) DEFAULT NULL,
  `item_amount_usd` decimal(19,2) DEFAULT NULL,
  `item_date` date NOT NULL,
  `item_name` varchar(50) DEFAULT NULL,
  `main_category` enum('IN','OUT') DEFAULT NULL,
  `updated_at` datetime(6) DEFAULT NULL,
  `cf_id` bigint DEFAULT NULL,
  PRIMARY KEY (`detail_id`),
  KEY `FKe1s41fmlmns7sakrs8ptfkhvr` (`cf_id`),
  CONSTRAINT `FKe1s41fmlmns7sakrs8ptfkhvr` FOREIGN KEY (`cf_id`) REFERENCES `monthly_cashflow_master` (`cf_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3354 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `monthly_cashflow_master`
--

DROP TABLE IF EXISTS `monthly_cashflow_master`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `monthly_cashflow_master` (
  `cf_id` bigint NOT NULL AUTO_INCREMENT,
  `account` enum('KIWOOM','TOSS') DEFAULT NULL,
  `base_ym` date NOT NULL,
  `calculate_flag` enum('N','Y') DEFAULT NULL,
  `created_at` datetime(6) DEFAULT NULL,
  `currency` enum('KRW','USD') DEFAULT NULL,
  `end_amount` decimal(19,4) DEFAULT NULL,
  `inflow_amount_krw` decimal(19,0) DEFAULT NULL,
  `inflow_amount_usd` decimal(19,2) DEFAULT NULL,
  `net_cashflow_krw` decimal(19,0) DEFAULT NULL,
  `net_cashflow_usd` decimal(19,2) DEFAULT NULL,
  `outflow_amount_krw` decimal(19,0) DEFAULT NULL,
  `outflow_amount_usd` decimal(19,2) DEFAULT NULL,
  `start_amount` decimal(19,4) DEFAULT NULL,
  `updated_at` datetime(6) DEFAULT NULL,
  `user_id` bigint DEFAULT NULL,
  PRIMARY KEY (`cf_id`),
  UNIQUE KEY `ux_cashflow_master` (`user_id`,`account`,`currency`,`base_ym`),
  CONSTRAINT `FKcpy9vyfx3huybmm8y04jc0b4a` FOREIGN KEY (`user_id`) REFERENCES `wts_users` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=61 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pending_distributions_table`
--

DROP TABLE IF EXISTS `pending_distributions_table`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pending_distributions_table` (
  `pending_id` bigint NOT NULL AUTO_INCREMENT,
  `created_at` datetime(6) DEFAULT NULL,
  `status` enum('N','Y') NOT NULL,
  `ticker` varchar(16) DEFAULT NULL,
  `updated_at` datetime(6) DEFAULT NULL,
  PRIMARY KEY (`pending_id`),
  UNIQUE KEY `pending_dividend_history_unique` (`ticker`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `portfolio_item`
--

DROP TABLE IF EXISTS `portfolio_item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `portfolio_item` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `avg_buy_price` decimal(19,4) DEFAULT NULL,
  `avg_sell_price` decimal(19,4) DEFAULT NULL,
  `buy_qty` decimal(20,6) DEFAULT NULL,
  `company_name` varchar(255) NOT NULL,
  `created_at` datetime(6) DEFAULT NULL,
  `currency` enum('KRW','USD') DEFAULT NULL,
  `current_price` decimal(19,4) DEFAULT NULL,
  `dividend` decimal(19,4) DEFAULT NULL,
  `fee` decimal(19,4) DEFAULT NULL,
  `holding_amount` decimal(19,4) DEFAULT NULL,
  `holding_price` decimal(19,4) DEFAULT NULL,
  `profit` decimal(19,4) DEFAULT NULL,
  `profit_rate` decimal(19,4) DEFAULT NULL,
  `quantity` decimal(20,6) DEFAULT NULL,
  `sector` varchar(30) DEFAULT NULL,
  `sell_qty` decimal(20,6) DEFAULT NULL,
  `symbol` varchar(100) DEFAULT NULL,
  `tax` decimal(19,4) DEFAULT NULL,
  `total_buy` decimal(19,4) DEFAULT NULL,
  `total_sell` decimal(19,4) DEFAULT NULL,
  `updated_at` datetime(6) DEFAULT NULL,
  `user_id` bigint NOT NULL,
  `weight` decimal(7,4) DEFAULT NULL,
  `broker_type` enum('KIWOOM','TOSS') DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `ux_user_trade_symbol` (`user_id`,`company_name`)
) ENGINE=InnoDB AUTO_INCREMENT=233 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;



--
-- Table structure for table `stock_distributions`
--

DROP TABLE IF EXISTS `stock_distributions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `stock_distributions` (
  `dist_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `ticker` varchar(16) NOT NULL,
  `distribution_per_share` decimal(16,6) NOT NULL,
  `declared_date` date NOT NULL,
  `ex_date` date NOT NULL,
  `record_date` date NOT NULL,
  `payable_date` date NOT NULL,
  `roc_pct` decimal(10,4) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`dist_id`),
  UNIQUE KEY `ux_ticker_declareddate` (`ticker`,`declared_date`),
  KEY `idx_ticker_declareddate` (`ticker`,`declared_date`),
  KEY `idx_declareddate` (`declared_date`)
) ENGINE=InnoDB AUTO_INCREMENT=25766 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;



--
-- Table structure for table `stock_nav_daily`
--

DROP TABLE IF EXISTS `stock_nav_daily`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `stock_nav_daily` (
  `nav_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `nav_date` date NOT NULL,
  `ticker` varchar(16) NOT NULL,
  `nav` decimal(16,6) NOT NULL,
  `close_price` decimal(16,6) NOT NULL,
  `premium_pct` decimal(10,4) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`nav_id`),
  UNIQUE KEY `ux_navdate_ticker` (`nav_date`,`ticker`)
) ENGINE=InnoDB AUTO_INCREMENT=553 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;



--
-- Table structure for table `symbol_ticker`
--

DROP TABLE IF EXISTS `symbol_ticker`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `symbol_ticker` (
  `st_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `isin` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `symbol_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ticker` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`st_id`),
  UNIQUE KEY `ux_symbol_isin` (`isin`),
  KEY `idx_st_id` (`st_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3976 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='종목명과 티커 ISIN코드 매핑테이블';
/*!40101 SET character_set_client = @saved_cs_client */;



--
-- Table structure for table `trade_history`
--

DROP TABLE IF EXISTS `trade_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `trade_history` (
  `tr_hist_id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint DEFAULT NULL,
  `trade_date` date NOT NULL COMMENT '거래일자 (거래일자)',
  `trade_type` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `symbol_name` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `fx_rate` decimal(38,6) DEFAULT NULL,
  `quantity` decimal(38,6) DEFAULT NULL,
  `amount_krw` decimal(38,6) DEFAULT NULL,
  `amount_usd` decimal(38,6) DEFAULT NULL,
  `price_krw` decimal(38,6) DEFAULT NULL,
  `price_usd` decimal(38,6) DEFAULT NULL,
  `fee_krw` decimal(38,6) DEFAULT NULL,
  `fee_usd` decimal(38,6) DEFAULT NULL,
  `tax_krw` decimal(38,6) DEFAULT NULL,
  `tax_usd` decimal(38,6) DEFAULT NULL,
  `repay_total_krw` decimal(38,6) DEFAULT NULL,
  `repay_total_usd` decimal(38,6) DEFAULT NULL,
  `balance_qty` decimal(38,6) DEFAULT NULL,
  `balance_krw` decimal(38,6) DEFAULT NULL,
  `balance_usd` decimal(38,6) DEFAULT NULL,
  `source_row` int DEFAULT NULL COMMENT '엑셀상 원본 row 번호(옵션)',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `isin` varchar(12) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `broker_name` enum('KIWOOM','TOSS') COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `trade_currency` enum('KRW','USD') COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`tr_hist_id`),
  UNIQUE KEY `uk_trade_history_unique` (`user_id`,`trade_date`,`trade_type`,`symbol_name`,`isin`,`quantity`,`amount_krw`,`balance_krw`),
  UNIQUE KEY `ux_trade_history_unique` (`user_id`,`trade_date`,`trade_type`,`symbol_name`,`isin`,`quantity`,`amount_krw`,`balance_krw`),
  KEY `idx_trade_date` (`trade_date`),
  KEY `idx_symbol_date` (`symbol_name`,`trade_date`),
  KEY `idx_type_date` (`trade_type`,`trade_date`),
  KEY `fk_trade_history_user` (`user_id`),
  CONSTRAINT `fk_trade_history_user` FOREIGN KEY (`user_id`) REFERENCES `wts_users` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=62542 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='엑셀 거래내역 이관 테이블';
/*!40101 SET character_set_client = @saved_cs_client */;



--
-- Table structure for table `user_permissions`
--

DROP TABLE IF EXISTS `user_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_permissions` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `current_request_count` int DEFAULT NULL,
  `daily_request_limit` int DEFAULT NULL,
  `last_reset_date` date DEFAULT NULL,
  `permission_level` enum('ADMIN_USER','BASIC_USER','TRADING_USER') DEFAULT NULL,
  `user_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `ux_user_permission_unique` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_permissions`
--

LOCK TABLES `user_permissions` WRITE;
/*!40000 ALTER TABLE `user_permissions` DISABLE KEYS */;
/*!40000 ALTER TABLE `user_permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_watch_group`
--

DROP TABLE IF EXISTS `user_watch_group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_watch_group` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `created_at` datetime(6) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `display_order` int DEFAULT NULL,
  `group_name` varchar(100) NOT NULL,
  `updated_at` datetime(6) DEFAULT NULL,
  `user_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `ux_user_watch_group_unique` (`user_id`,`group_name`),
  KEY `idx_user_watch_group_user_id` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;



--
-- Table structure for table `user_watch_list`
--

DROP TABLE IF EXISTS `user_watch_list`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_watch_list` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `created_at` datetime(6) NOT NULL,
  `stock_cd` varchar(6) NOT NULL,
  `updated_at` datetime(6) DEFAULT NULL,
  `user_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `ux_user_watch_list_unique` (`user_id`,`stock_cd`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_stock_cd` (`stock_cd`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;



--
-- Table structure for table `user_watch_list_item`
--

DROP TABLE IF EXISTS `user_watch_list_item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_watch_list_item` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `created_at` datetime(6) NOT NULL,
  `display_order` int DEFAULT NULL,
  `memo` varchar(500) DEFAULT NULL,
  `stock_cd` varchar(6) NOT NULL,
  `group_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `ux_user_watch_list_item_unique` (`group_id`,`stock_cd`),
  KEY `idx_user_watch_list_item_group_id` (`group_id`),
  KEY `idx_user_watch_list_item_stock_cd` (`stock_cd`),
  CONSTRAINT `FK3oomn8pwt2cqdyn4buukspkf9` FOREIGN KEY (`group_id`) REFERENCES `user_watch_group` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=49 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;



--
-- Table structure for table `wts_orders`
--

DROP TABLE IF EXISTS `wts_orders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `wts_orders` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `client_order_id` varchar(255) DEFAULT NULL,
  `created_at` datetime(6) NOT NULL,
  `price` double DEFAULT NULL,
  `qty` bigint NOT NULL,
  `side` varchar(255) NOT NULL,
  `status` varchar(255) NOT NULL,
  `symbol` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UKjx2li22mj04twe3p46spfa5he` (`client_order_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wts_orders`
--

LOCK TABLES `wts_orders` WRITE;
/*!40000 ALTER TABLE `wts_orders` DISABLE KEYS */;
/*!40000 ALTER TABLE `wts_orders` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wts_users`
--

DROP TABLE IF EXISTS `wts_users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `wts_users` (
  `user_id` bigint NOT NULL AUTO_INCREMENT,
  `created_at` datetime(6) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `enabled` bit(1) NOT NULL,
  `last_login_at` datetime(6) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `picture_url` varchar(255) DEFAULT NULL,
  `provider` varchar(255) DEFAULT NULL,
  `provider_id` varchar(255) DEFAULT NULL,
  `roles` varchar(255) DEFAULT NULL,
  `updated_at` datetime(6) DEFAULT NULL,
  `password` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `UK485442d10b3x0nhn2jgocf2oj` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;


/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-03-12  1:45:30
