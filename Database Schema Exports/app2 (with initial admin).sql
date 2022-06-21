CREATE DATABASE  IF NOT EXISTS `app2` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `app2`;
-- MySQL dump 10.13  Distrib 8.0.29, for Win64 (x86_64)
--
-- Host: localhost    Database: app2
-- ------------------------------------------------------
-- Server version	8.0.29

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `admin`
--

DROP TABLE IF EXISTS `admin`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `admin` (
  `admin_id` int NOT NULL,
  `password` varchar(128) NOT NULL,
  `admin_name` varchar(50) NOT NULL,
  `attempt_left` int NOT NULL DEFAULT '3',
  PRIMARY KEY (`admin_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `admin`
--

LOCK TABLES `admin` WRITE;
/*!40000 ALTER TABLE `admin` DISABLE KEYS */;
INSERT INTO `admin` VALUES (1,'54b31552121fe5a1fbd98701c9ce26921ca206ee003eca9e48263f4cd9c40aba93bb207ebaefc9df5e9a40b6cd0db8567bee12d25cff31c5ee0ace6ffd08f8dd','System Admin',3);
/*!40000 ALTER TABLE `admin` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `lecturer`
--

DROP TABLE IF EXISTS `lecturer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `lecturer` (
  `lecturer_id` int NOT NULL,
  `password` varchar(128) NOT NULL,
  `lecturer_name` varchar(50) NOT NULL,
  `modified_by` int NOT NULL,
  `modified_on` datetime NOT NULL,
  `attempt_left` int NOT NULL DEFAULT '3',
  PRIMARY KEY (`lecturer_id`),
  KEY `pk_lecturer_modified_by_idx` (`modified_by`),
  CONSTRAINT `fk_lecturer_modified_by` FOREIGN KEY (`modified_by`) REFERENCES `admin` (`admin_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `lecturer`
--

LOCK TABLES `lecturer` WRITE;
/*!40000 ALTER TABLE `lecturer` DISABLE KEYS */;
/*!40000 ALTER TABLE `lecturer` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `log`
--

DROP TABLE IF EXISTS `log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `log` (
  `log_id` int NOT NULL AUTO_INCREMENT,
  `type` varchar(15) NOT NULL,
  `description` text NOT NULL,
  PRIMARY KEY (`log_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `log`
--

LOCK TABLES `log` WRITE;
/*!40000 ALTER TABLE `log` DISABLE KEYS */;
/*!40000 ALTER TABLE `log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `quiz_obj`
--

DROP TABLE IF EXISTS `quiz_obj`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `quiz_obj` (
  `quiz_obj_id` int NOT NULL AUTO_INCREMENT,
  `workload_id` int NOT NULL,
  `question` text NOT NULL,
  `choice_a` text NOT NULL,
  `choice_b` text NOT NULL,
  `choice_c` text NOT NULL,
  `choice_d` text NOT NULL,
  `answer` char(1) NOT NULL,
  `modified_by` int NOT NULL,
  `modified_on` datetime NOT NULL,
  PRIMARY KEY (`quiz_obj_id`),
  KEY `fk_quiz_obj__idx` (`workload_id`),
  KEY `fk_quiz_obj_modified_by_idx` (`modified_by`),
  CONSTRAINT `fk_quiz_obj_modified_by` FOREIGN KEY (`modified_by`) REFERENCES `lecturer` (`lecturer_id`),
  CONSTRAINT `fk_quiz_obj_workload_id` FOREIGN KEY (`workload_id`) REFERENCES `workload` (`workload_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `quiz_obj`
--

LOCK TABLES `quiz_obj` WRITE;
/*!40000 ALTER TABLE `quiz_obj` DISABLE KEYS */;
/*!40000 ALTER TABLE `quiz_obj` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `quiz_tf`
--

DROP TABLE IF EXISTS `quiz_tf`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `quiz_tf` (
  `quiz_tf_id` int NOT NULL AUTO_INCREMENT,
  `workload_id` int NOT NULL,
  `question` text NOT NULL,
  `answer` bit(1) NOT NULL,
  `modified_by` int NOT NULL,
  `modified_on` datetime NOT NULL,
  PRIMARY KEY (`quiz_tf_id`),
  KEY `fk_quiz_tf_workload_id_idx` (`workload_id`),
  KEY `fk_quiz_tf__idx` (`modified_by`),
  CONSTRAINT `fk_quiz_tf_modified_by` FOREIGN KEY (`modified_by`) REFERENCES `lecturer` (`lecturer_id`),
  CONSTRAINT `fk_quiz_tf_workload_id` FOREIGN KEY (`workload_id`) REFERENCES `workload` (`workload_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `quiz_tf`
--

LOCK TABLES `quiz_tf` WRITE;
/*!40000 ALTER TABLE `quiz_tf` DISABLE KEYS */;
/*!40000 ALTER TABLE `quiz_tf` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `reg_subject`
--

DROP TABLE IF EXISTS `reg_subject`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `reg_subject` (
  `reg_subject_id` int NOT NULL AUTO_INCREMENT,
  `student_id` varchar(8) NOT NULL,
  `workload_id` int NOT NULL,
  `quiz_tf_mark` int DEFAULT NULL,
  `quiz_obj_mark` int DEFAULT NULL,
  PRIMARY KEY (`reg_subject_id`),
  KEY `fk_workload__idx` (`student_id`),
  KEY `fk_workload__idx1` (`workload_id`),
  CONSTRAINT `fk_reg_student_student_id` FOREIGN KEY (`student_id`) REFERENCES `student` (`student_id`),
  CONSTRAINT `fk_reg_student_workload_id` FOREIGN KEY (`workload_id`) REFERENCES `workload` (`workload_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reg_subject`
--

LOCK TABLES `reg_subject` WRITE;
/*!40000 ALTER TABLE `reg_subject` DISABLE KEYS */;
/*!40000 ALTER TABLE `reg_subject` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `student`
--

DROP TABLE IF EXISTS `student`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `student` (
  `student_id` varchar(8) NOT NULL,
  `password` varchar(128) NOT NULL,
  `student_name` varchar(50) NOT NULL,
  `student_email` varchar(50) NOT NULL,
  `modified_by` int NOT NULL,
  `modified_on` datetime NOT NULL,
  `attempt_left` int NOT NULL DEFAULT '3',
  PRIMARY KEY (`student_id`),
  KEY `fj__idx` (`modified_by`),
  CONSTRAINT `fk_student_modified_by` FOREIGN KEY (`modified_by`) REFERENCES `admin` (`admin_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `student`
--

LOCK TABLES `student` WRITE;
/*!40000 ALTER TABLE `student` DISABLE KEYS */;
/*!40000 ALTER TABLE `student` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `subject`
--

DROP TABLE IF EXISTS `subject`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `subject` (
  `subject_id` varchar(8) NOT NULL,
  `subject_name` varchar(30) NOT NULL,
  `modified_by` int NOT NULL,
  `modified_on` datetime NOT NULL,
  PRIMARY KEY (`subject_id`),
  KEY `fk_subject__idx` (`modified_by`),
  CONSTRAINT `fk_subject_modified_by` FOREIGN KEY (`modified_by`) REFERENCES `admin` (`admin_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `subject`
--

LOCK TABLES `subject` WRITE;
/*!40000 ALTER TABLE `subject` DISABLE KEYS */;
/*!40000 ALTER TABLE `subject` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `submission`
--

DROP TABLE IF EXISTS `submission`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `submission` (
  `submission_id` int NOT NULL AUTO_INCREMENT,
  `task_id` int NOT NULL,
  `student_id` varchar(8) NOT NULL,
  `submission_file_name` varchar(50) NOT NULL,
  `submission_file_hash` varchar(64) NOT NULL,
  PRIMARY KEY (`submission_id`),
  KEY `fk_submission__idx` (`task_id`),
  KEY `fk_submission__idx1` (`student_id`),
  CONSTRAINT `fk_submission_student_id` FOREIGN KEY (`student_id`) REFERENCES `student` (`student_id`),
  CONSTRAINT `fk_submission_task_id` FOREIGN KEY (`task_id`) REFERENCES `task` (`task_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `submission`
--

LOCK TABLES `submission` WRITE;
/*!40000 ALTER TABLE `submission` DISABLE KEYS */;
/*!40000 ALTER TABLE `submission` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `task`
--

DROP TABLE IF EXISTS `task`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `task` (
  `task_id` int NOT NULL AUTO_INCREMENT,
  `workload_id` int NOT NULL,
  `task_name` varchar(50) NOT NULL,
  `task_file_name` varchar(50) NOT NULL,
  `modified_by` int NOT NULL,
  `modified_on` datetime NOT NULL,
  PRIMARY KEY (`task_id`),
  KEY `fk_task__idx` (`workload_id`),
  KEY `fk_task_modified_by_idx` (`modified_by`),
  CONSTRAINT `fk_task_modified_by` FOREIGN KEY (`modified_by`) REFERENCES `lecturer` (`lecturer_id`),
  CONSTRAINT `fk_task_workload_id` FOREIGN KEY (`workload_id`) REFERENCES `workload` (`workload_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `task`
--

LOCK TABLES `task` WRITE;
/*!40000 ALTER TABLE `task` DISABLE KEYS */;
/*!40000 ALTER TABLE `task` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `workload`
--

DROP TABLE IF EXISTS `workload`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `workload` (
  `workload_id` int NOT NULL AUTO_INCREMENT,
  `lecturer_id` int NOT NULL,
  `subject_id` varchar(8) NOT NULL,
  `modified_by` int NOT NULL,
  `modified_on` datetime NOT NULL,
  PRIMARY KEY (`workload_id`),
  KEY `fk_workload__idx` (`lecturer_id`),
  KEY `fk_workload_subject_id_idx` (`subject_id`),
  KEY `fk_workload_modified_by_idx` (`modified_by`),
  CONSTRAINT `fk_workload_lecturer_id` FOREIGN KEY (`lecturer_id`) REFERENCES `lecturer` (`lecturer_id`),
  CONSTRAINT `fk_workload_modified_by` FOREIGN KEY (`modified_by`) REFERENCES `admin` (`admin_id`),
  CONSTRAINT `fk_workload_subject_id` FOREIGN KEY (`subject_id`) REFERENCES `subject` (`subject_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `workload`
--

LOCK TABLES `workload` WRITE;
/*!40000 ALTER TABLE `workload` DISABLE KEYS */;
/*!40000 ALTER TABLE `workload` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2022-06-21 23:48:10
