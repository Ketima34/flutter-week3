import 'package:test/test.dart';

import 'package:lms_layered_architecture_example/service/lms_system.dart';

void main() {
  late LmsSystem lms;

  setUp(() {
    lms = LmsSystem();
  });

  group('students', () {
    test('creates a student', () {
      lms.addStudent(studentId: 'S1', studentName: 'ronan');

      expect(lms.students.length, 1);
      expect(lms.students.first.id, 'S1');
      expect(lms.students.first.name, 'ronan');
    });

    test('rejects a duplicate student id', () {
      lms.addStudent(studentId: 'S1', studentName: 'ronan');

      expect(
        () => lms.addStudent(studentId: 'S1', studentName: 'other'),
        throwsException,
      );
      expect(lms.students.length, 1);
    });

    test('removes a student', () {
      lms.addStudent(studentId: 'S1', studentName: 'ronan');

      lms.removeStudent(studentId: 'S1');

      expect(lms.students, isEmpty);
    });

    test('throws when removing an unknown student', () {
      expect(() => lms.removeStudent(studentId: 'nope'), throwsException);
    });

    test('removing a student also removes enrollment and results', () {
      lms.addStudent(studentId: 'S1', studentName: 'ronan');
      lms.addStudent(studentId: 'S2', studentName: 'mia');
      lms.addCourse(id: 'C1', name: 'Flutter');
      lms.addStudentToCourse(coursId: 'C1', studentId: 'S1');
      lms.addStudentToCourse(coursId: 'C1', studentId: 'S2');
      lms.addCourseResult(courseId: 'C1', studentId: 'S1', score: 90);
      lms.addCourseResult(courseId: 'C1', studentId: 'S2', score: 80);

      lms.removeStudent(studentId: 'S1');

      expect(lms.courses.first.studentIds, ['S2']);
      expect(lms.courseResult.length, 1);
      expect(lms.courseResult.first.studentId, 'S2');
    });
  });

  group('courses', () {
    test('creates a course', () {
      lms.addCourse(id: 'C1', name: 'Flutter');

      expect(lms.courses.length, 1);
      expect(lms.courses.first.id, 'C1');
      expect(lms.courses.first.name, 'Flutter');
    });

    test('rejects a duplicate course name, ignoring case', () {
      lms.addCourse(id: 'C1', name: 'Flutter');

      expect(() => lms.addCourse(id: 'C2', name: 'flutter'), throwsException);
      expect(lms.courses.length, 1);
    });
  });

  group('enrollment', () {
    setUp(() {
      lms.addStudent(studentId: 'S1', studentName: 'ronan');
      lms.addCourse(id: 'C1', name: 'Flutter');
    });

    test('enrolls a student in a course', () {
      lms.addStudentToCourse(coursId: 'C1', studentId: 'S1');

      expect(lms.courses.first.studentIds, ['S1']);
    });

    test('rejects enrolling the same student twice', () {
      lms.addStudentToCourse(coursId: 'C1', studentId: 'S1');

      expect(
        () => lms.addStudentToCourse(coursId: 'C1', studentId: 'S1'),
        throwsException,
      );
      expect(lms.courses.first.studentIds.length, 1);
    });

    test('throws when the course does not exist', () {
      expect(
        () => lms.addStudentToCourse(coursId: 'missing', studentId: 'S1'),
        throwsException,
      );
    });
  });

  group('course results', () {
    setUp(() {
      lms.addStudent(studentId: 'S1', studentName: 'ronan');
      lms.addCourse(id: 'C1', name: 'Flutter');
    });

    test('records a result', () {
      lms.addCourseResult(courseId: 'C1', studentId: 'S1', score: 85.5);

      expect(lms.courseResult.length, 1);
      expect(lms.courseResult.first.courseId, 'C1');
      expect(lms.courseResult.first.studentId, 'S1');
      expect(lms.courseResult.first.score, 85.5);
    });

    test('throws when the student does not exist', () {
      expect(
        () => lms.addCourseResult(courseId: 'C1', studentId: 'X', score: 50),
        throwsException,
      );
    });

    test('throws when the course does not exist', () {
      expect(
        () => lms.addCourseResult(courseId: 'X', studentId: 'S1', score: 50),
        throwsException,
      );
    });
  });
}
