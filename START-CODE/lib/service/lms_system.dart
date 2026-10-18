import 'dart:math';

import '../model/student.dart';
import '../model/course.dart';
import '../model/course_result.dart';
class LmsSystem {
  final List<Student> students = [];
  final List<Course> courses = [];
  final List<CourseResult> courseResult =[];

  void addStudent({required String studentId, required String studentName}) {
    // ! Student shall not exist already
    Student? student = _findStudentOrNull(studentId);
    if (student != null) {
      throw Exception('Student $student already exists');
    }

    students.add(Student(id: studentId, name: studentName));
  }
 

void addCourse({required String id , required String name}){
Course? course = _findCourseOrNull(courseName: name);

if(course != null){
        throw Exception('Student $course already exists');
}
courses.add(Course(id: id, name: name));

}




void addStudentToCourse({required String coursId , required String studentId}){

Course? course = _findCourseOrNull(courseId: coursId);

if(course != null ){
  if(_isStudentExsit(coure: course, studentId: studentId) == false){
    course.studentIds.add(studentId);
  }else{
    throw Exception('Student already enrolled');
  }
  
}else{
  throw Exception('course not found');
}

}


void addCourseResult({required String courseId , required String studentId , required double score}){
 Course? course = _findCourseOrNull(courseId: courseId);
 Student? student = _findStudentOrNull(studentId );

if(student != null && course != null){
    CourseResult result = CourseResult(courseId: courseId, studentId: studentId, score: score);
    courseResult.add(result);

  }else{
    throw Exception('student or course not exsit');
}
}


void removeStudent({required String studentId}) {
    Student? student = _findStudentOrNull(studentId);
    if (student == null) {
      throw Exception('Student $studentId not found');
    }
    // 1- Remove student from the students list
    students.removeWhere((student) => student.id == studentId);

   for (final c in courses) {
  c.studentIds.remove(studentId);
}

    
    courseResult.removeWhere((e) => e.studentId == studentId);

  }

  


  Student? _findStudentOrNull(String studentId) {
    for (Student s in students) {
      if (s.id == studentId) {
        return s;
      }
    }
    return null; // not found
  } 
  
  

  bool _isStudentExsit({ required Course coure , required String studentId}){
     var exsit = coure.studentIds.contains(studentId);
     return exsit;

  }

Course? _findCourseOrNull({String? courseName, String? courseId}) {
  for (final c in courses) {
    if (courseName != null && c.name.toLowerCase() == courseName.toLowerCase()) return c;
    if (courseId != null && c.id == courseId) return c;
  }
  return null;
}

}

