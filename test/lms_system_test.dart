import 'package:lms_layered_architecture_example/model/course.dart';
import 'package:lms_layered_architecture_example/model/result.dart';
import 'package:lms_layered_architecture_example/model/student.dart';
import 'package:test/test.dart';

import '../lib/service/lms_system.dart';

void main() {
  test('creates a student', () {
    final lms = LmsSystem();

    lms.addStudent(studentId: 'S1', studentName: "ronan");

    expect(lms.students.first.name, 'ronan');
    expect(lms.students.first.id, "S1");
  });

  test("remove a valid student should remove the student", () {
    final LmsSystem lms = LmsSystem();

    lms.addStudent(studentId: 'S1', studentName: "ronan");
    lms.removeStudent(studentId: 'S1');

    expect(lms.students.length, 0);
  });

  test("create a valid course should have the course", () {
    final LmsSystem lms = LmsSystem();

    lms.addCourse(courseId: "C1", courseName: "mobile dev");

    expect(lms.courses.first.id, "C1");
    expect(lms.courses.first.name, "mobile dev");
  });

  test("create a course with duplicate id should throw an exception", () {
    final LmsSystem lms = LmsSystem();

    lms.addCourse(courseId: "C1", courseName: "hello");
    expect(() => lms.addCourse(courseId: "c1", courseName: "hello"),
        throwsException);
  });

  test("delete a valid course should remove the course", () {
    final LmsSystem lms = LmsSystem();

    lms.addCourse(courseId: "C1", courseName: "mobile dev");
    lms.addCourse(courseId: "C2", courseName: "mobile dev");
    lms.removeCourse(courseId: "C2");

    expect(lms.courses.length, 1);
  });

  test("delete a course that doesn't exist should throw an exception", () {
    final LmsSystem lms = LmsSystem();

    expect(() => lms.removeCourse(courseId: "hahaha"), throwsException);
  });

  test(
      "enroll valid student into valid course should enroll student into course",
      () {
    final LmsSystem lms = LmsSystem();
    final Student s = Student(id: "S1", name: "mememe");
    final Course c = Course(id: "C1", name: "me course");

    lms.addCourse(courseId: c.id, courseName: c.name);
    lms.addStudent(studentId: s.id, studentName: s.name);
    lms.enrollStudent(s.id, c.id);

    expect(lms.courses.first.studentIds.first, s.id);
  });

  test(
      "enroll student that doesn't exist into valid course should throw exception",
      () {
    final LmsSystem lms = LmsSystem();
    final Course c = Course(id: "C1", name: "me course");

    lms.addCourse(courseId: c.id, courseName: c.name);

    expect(() => lms.enrollStudent("S1", c.id), throwsException);
  });

  test("enroll student into course that doesn't exist should throw exception",
      () {
    final LmsSystem lms = LmsSystem();
    final Student s = Student(id: "S1", name: "mememe");

    lms.addStudent(studentId: s.id, studentName: s.name);

    expect(() => lms.enrollStudent(s.id, "C1"), throwsException);
  });

  test(
      "enroll student into course that the student already enroll should throw exception",
      () {
    final LmsSystem lms = LmsSystem();
    final Student s = Student(id: "S1", name: "mememe");
    final Course c = Course(id: "C1", name: "me course");

    lms.addCourse(courseId: c.id, courseName: c.name);
    lms.addStudent(studentId: s.id, studentName: s.name);
    lms.enrollStudent(s.id, c.id);

    expect(() => lms.enrollStudent(s.id, c.id), throwsException);
  });

  test(
      "add valid score of valid student into valid course should store the scores",
      () {
    final LmsSystem lms = LmsSystem();
    final Student s = Student(id: "S1", name: "mememe");
    final Course c = Course(id: "C1", name: "me course");
    final Score sc = Score(id: "SC1", score: 100);

    lms.addCourse(courseId: c.id, courseName: c.name);
    lms.addStudent(studentId: s.id, studentName: s.name);
    lms.enrollStudent(s.id, c.id);
    lms.addResult(s.id, c.id, sc.id, sc.score);

    expect(lms.scores.first.id, sc.id);
    expect(lms.scores.first.score, sc.score);
    expect(lms.courses.first.scoreIds.first, sc.id);
    expect(lms.students.first.scoreIds.first, sc.id);
  });

  test(
      "add invalid score of valid student into valid course should throw exception",
      () {
    final LmsSystem lms = LmsSystem();
    final Student s = Student(id: "S1", name: "mememe");
    final Course c = Course(id: "C1", name: "me course");
    final double score = 101;

    lms.addCourse(courseId: c.id, courseName: c.name);
    lms.addStudent(studentId: s.id, studentName: s.name);
    lms.enrollStudent(s.id, c.id);

    expect(() => lms.addResult(s.id, c.id, "S1", score), throwsRangeError);
  });

  test(
      "add valid score for valid student into course that doesn't exist should throw exception",
      () {
    final LmsSystem lms = LmsSystem();
    final Student s = Student(id: "S1", name: "mememe");
    final Course c = Course(id: "C1", name: "me course");
    final double score = 100;

    lms.addCourse(courseId: c.id, courseName: c.name);
    lms.addStudent(studentId: s.id, studentName: s.name);
    lms.enrollStudent(s.id, c.id);

    expect(() => lms.addResult(s.id, "C2", "SC1", score), throwsException);
  });

  test(
      "add valid score for non existing student into valid course should throws exception",
      () {
    final LmsSystem lms = LmsSystem();
    final Student s = Student(id: "S1", name: "mememe");
    final Course c = Course(id: "C1", name: "me course");
    final double score = 100;

    lms.addCourse(courseId: c.id, courseName: c.name);
    lms.addStudent(studentId: s.id, studentName: s.name);
    lms.enrollStudent(s.id, c.id);

    expect(() => lms.addResult("S2", c.id, "SC1", score), throwsException);
  });

  test(
      "add valid score for student that hasn't enroll into course should throws exception",
      () {
    final LmsSystem lms = LmsSystem();
    final Student s = Student(id: "S1", name: "mememe");
    final Course c = Course(id: "C1", name: "me course");
    final double score = 100;

    lms.addCourse(courseId: c.id, courseName: c.name);
    lms.addStudent(studentId: s.id, studentName: s.name);

    expect(() => lms.addResult(s.id, c.id, "SC1", score), throwsException);
  });
}
