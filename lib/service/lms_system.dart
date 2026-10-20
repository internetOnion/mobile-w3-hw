import "package:lms_layered_architecture_example/model/result.dart";

import "../model/student.dart";
import "../model/course.dart";

class LmsSystem {
  final List<Student> students = [];
  final List<Course> courses = [];
  final List<Score> scores = [];

  void removeResult(String resultId) {
    // validate input
    if (resultId.trim().isEmpty) {
      throw ArgumentError.value(resultId, "cannot be empty");
    }

    // check if result exist
    Score? sc = scores.where((s) => s.id == resultId).firstOrNull;
    if (sc == null) {
      throw Exception("Score doesn't exists");
    }

    // check if any course contain result
    Course? c = courses.where((c) => c.scoreIds.contains(sc.id)).firstOrNull;
    if (c == null) {
      throw Exception("Cannot find course that contains that result");
    }
    // check if any student has that result
    Student? s = students.where((s) => s.scoreIds.contains(sc.id)).firstOrNull;
    if (s == null) {
      throw Exception("Cannot find student that has that result");
    }

    // remove score
    s.scoreIds.remove(sc.id);
    c.scoreIds.remove(sc.id);
    scores.removeWhere((s) => s.id == sc.id);
  }

  void addResult(
      String studentId, String courseId, String scoreId, double score) {
    // validate input
    if (studentId.trim().isEmpty) {
      throw ArgumentError.value(studentId, "cannot be empty");
    }
    if (courseId.trim().isEmpty) {
      throw ArgumentError.value(courseId, "cannot be empty");
    }
    if (score < 0 || score > 100) {
      throw RangeError("score must be between 0 and 100 inclusively");
    }

    // check if studentId exist
    Student? student = students.where((s) => s.id == studentId).firstOrNull;
    if (student == null) {
      throw Exception("Student doesn't exist");
    }

    // check if courseId exist
    Course? course = courses.where((c) => c.id == courseId).firstOrNull;
    if (course == null) {
      throw Exception("Course doesn't exist");
    }

    // check if student is in the course
    bool isEnrollInCourse = course.studentIds.contains(studentId);
    if (!isEnrollInCourse) {
      throw Exception("Student is not enrolled in course");
    }

    // check if scoreId already exist
    bool isScoreAlreadyExists = scores.any((s) => s.id == scoreId);
    if (isScoreAlreadyExists) {
      throw Exception("Score id already exist");
    }

    // add score
    Score sc = Score(id: scoreId, score: score);
    scores.add(sc);
    course.scoreIds.add(sc.id);
    student.scoreIds.add(sc.id);
  }

  void enrollStudent(String studentId, String courseId) {
    // validate input
    if (studentId.trim().isEmpty) {
      throw ArgumentError.value(studentId, "cannot be empty");
    }
    if (courseId.trim().isEmpty) {
      throw ArgumentError.value(courseId, "cannot be empty");
    }

    // check if student exist
    Student? student = students.where((s) => s.id == studentId).firstOrNull;
    if (student == null) {
      throw Exception("Student doesn't exist");
    }

    // check if course exist
    Course? course = courses.where((c) => c.id == courseId).firstOrNull;
    if (course == null) {
      throw Exception("Course doesn't exist");
    }

    // check if student not already in the course
    bool isAlreadyInCourse = course.studentIds.contains(studentId);
    if (isAlreadyInCourse) {
      throw Exception("Student already in course");
    }

    // enroll student into course
    course.studentIds.add(studentId);
  }

  void addCourse({required String courseId, required String courseName}) {
    // validate input
    if (courseId.trim().isEmpty) {
      throw ArgumentError.value(courseId, "cannot be empty");
    }
    if (courseName.trim().isEmpty) {
      throw ArgumentError.value(courseName, "cannot be empty");
    }

    // check if courseId unique
    bool isExist =
        courses.any((c) => c.id.toLowerCase() == courseId.toLowerCase());
    if (isExist) {
      throw Exception("Course already existed");
    }

    // create a new Course
    Course newCourse = Course(id: courseId, name: courseName);

    // add new Course to courses list
    courses.add(newCourse);
  }

  void removeCourse({required String courseId}) {
    // validate input
    if (courseId.trim().isEmpty) {
      throw ArgumentError.value(courseId, "cannot be empty");
    }

    // check if courseId exist
    Course? courseToDelete = courses
        .where((c) => c.id.toLowerCase() == courseId.toLowerCase())
        .firstOrNull;

    // if yes delete else throw error
    if (courseToDelete == null) {
      throw Exception("Course doesn't exist");
    }

    courses.remove(courseToDelete);
  }

  void addStudent({required String studentId, required String studentName}) {
    // ! Student shall not exist already
    Student? student = _findStudentOrNull(studentId);
    if (student != null) {
      throw Exception('Student $student already exists');
    }

    students.add(Student(id: studentId, name: studentName));
  }

  void removeStudent({required String studentId}) {
    Student? student = _findStudentOrNull(studentId);
    if (student == null) {
      throw Exception('Student $studentId not found');
    }
    // 1- Remove student from the students list
    students.removeWhere((student) => student.id == studentId);
  }

  Student? _findStudentOrNull(String studentId) {
    for (Student s in students) {
      if (s.id == studentId) {
        return s;
      }
    }
    return null; // not found
  }
}
