# Master Piano Institute Music Lesson & Studio Booking Database

This repository contains the SQL schema and Entity-Relationship Diagram (ERD) for a **Music Institute's Music Lesson & Studio Booking Database**. This database is designed to manage music lessons, studio bookings, payments, and customer details for the **Master Piano Institute**.

## 📌 Overview

The system allows customers to:

- Purchase lesson package tokens for **Private, Online, or Group** music lessons.
- Use lesson tokens to book **music lessons** with skilled music teachers.
- Purchase **studio credit tokens** to hire practice rooms with various musical instruments.
- Book **studio rooms** for practice sessions.
- Track **payments and transaction details**.

## 🛠️ Database Structure

The database consists of several tables to manage customers, teachers, lessons, studio bookings, payments, and tokens. Below are key entities in the system:

### 🎵 **Lesson & Studio Booking Management**
- **`LessonPackageToken`**: Stores details about lesson tokens purchased by customers.
- **`PrivateLesson`**: Records private lessons booked by customers.
- **`OnlineLesson`**: Manages online lessons with assigned teachers.
- **`GroupLessonAvailable`**: Stores available group lessons.
- **`CustomerGroupLesson`**: Tracks customer participation in group lessons.
- **`StudioCreditToken`**: Manages studio credits for customers.
- **`StudioBooking`**: Records studio room reservations.

### 👨‍🏫 **Teacher & Customer Management**
- **`Customer`**: Stores personal details and skill levels of customers.
- **`MusicTeacher`**: Contains teacher details and their expertise.

### 💰 **Payments & Transactions**
- **`Payment`**: Tracks customer payments for lessons and studio bookings.

### 🎹 **Music Studio & Instruments**
- **`MusicStudioInstrumentHire`**: Stores information on available studio rooms and instruments.

### 📌 **Views**
- **`TeacherPrivateLesson`**: A view that provides a summary of private lessons assigned to teachers.

## 🔗 Entity-Relationship Diagram (ERD)

The **ERD** (available in this repository) visually represents the relationships between the tables, showing how customers, teachers, payments, lessons, and studio bookings are connected.

## 📂 Files Included
- `master_piano_institute.sql` – SQL schema including table creation, constraints, and sample data.
- `ERD_Master_Piano_Institute.pdf` – Entity-Relationship Diagram of the database.



