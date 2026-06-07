-- MariaDB dump 10.19  Distrib 10.4.32-MariaDB, for Win64 (AMD64)
--
-- Host: localhost    Database: healthsync_login
-- ------------------------------------------------------
-- Server version	10.4.32-MariaDB

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(50) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'testuser','test@healthsync.de','$2b$12$Vkf0E0zMeg4P3eV.ZwpoZ.TCqFU7dj6MHOih2eq9Bw18q5ElMe.RC','2026-03-26 09:16:30'),(2,'testuser2','test2@healthsync.de','$2b$12$UqBG020K/..zhdG6R1OEwuT2dTY/hmYpXE3Avf9xWKolypcW7rk6C','2026-03-26 09:17:44'),(3,'Mohamad','fayad.m20@htlwienwest.at','$2b$12$PZ7FLN.fq5XdJbww8wbCMOyKuAcqITkOQY5soIax.BrJLrX.kmIma','2026-03-26 09:41:52'),(4,'Justus','justus@gmail.com','$2b$12$BZDS3a8Al4PF1VYY8r6L3uRLLtuPuHdKAGxJIRm4B9mBbQXc5pwk.','2026-03-26 09:44:50'),(5,'tristan','tristan@gmail.com','$2b$12$A9pmm4k8pCbRdcCCZs4qH.Cv2XqWGATbOvbulzXZA2fcni/qB6Wgi','2026-03-26 09:48:37'),(6,'mo','mo22@gmail.com','$2b$12$j.R5egFn.l0/Hs8S2NmOIuskxfsM0gMJ4Q.bQps4epyuyNU2IqzfW','2026-03-26 12:10:07'),(7,'alex','alex@gmail.com','$2b$12$SbD0GSHw.XdlTCDpfYYhpOfurcDnKLxN4F2wBhu21coYPwg7SOFU.','2026-04-09 12:01:53');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-04-16  8:07:09
