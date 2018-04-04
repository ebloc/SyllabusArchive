pragma solidity ^0.4.18;

contract Syllabi {

    University[] universities;
    University uniGlobal;
    Department departmentGlobal;
    Semester semesterGlobal;
    Course courseGlobal;
    mapping(string => uint) uniNameToId;

    struct University {
        string name;
        Semester[] semesters;
        mapping(string => uint) semesterNameToId;
    }

    struct Semester {
        string name;
        Department[] departments;
        mapping(string => uint) departmentNameToId;
    }

    struct Department {
        string name;
        Course[] courses;
        mapping(string => uint) courseNameToId;
    }

    struct Course {
        string name;
        string syllabusHash;
        address instructor;
        address[] students;
        address[] graduates;
    }
    
    function addStudentToCourse(address _student,string _uniName, string _semesterName, string _departmentName, string _courseName) external{
        University storage uni = universities[uniNameToId[_uniName]];
        Semester storage semester = uni.semesters[uni.semesterNameToId[_semesterName]];
        Department storage department = semester.departments[semester.departmentNameToId[_departmentName]];
        department.courses[department.courseNameToId[_courseName]].students.push(_student);
    }
    
    function verifyThatStudentGraduatedFromCourse(address _student,string _uniName, string _semesterName, string _departmentName, string _courseName) external{
        University storage uni = universities[uniNameToId[_uniName]];
        Semester storage semester = uni.semesters[uni.semesterNameToId[_semesterName]];
        Department storage department = semester.departments[semester.departmentNameToId[_departmentName]];
        if(department.courses[department.courseNameToId[_courseName]].instructor == msg.sender){
            department.courses[department.courseNameToId[_courseName]].graduates.push(_student);
        }
    }

    function addUniversity(string _name) external {
        uniGlobal.name = _name;
        uint id = universities.push(uniGlobal);
        uniNameToId[_name] = id - 1;
    }

    function addSemester(string _uniName, string _semesterName) external {
        University storage uni = universities[uniNameToId[_uniName]];
        semesterGlobal.name = _semesterName;
        uint id = uni.semesters.push(semesterGlobal);
        uni.semesterNameToId[_semesterName] = id - 1;
    }

    function addDepartment(string _uniName, string _semesterName, string _departmentName) external {
        University storage uni = universities[uniNameToId[_uniName]];
        departmentGlobal.name = _departmentName;
        uint id = uni.semesters[uni.semesterNameToId[_semesterName]].departments.push(departmentGlobal);
        uni.semesters[uni.semesterNameToId[_semesterName]].departmentNameToId[_departmentName] = id - 1;
    }

    function addCourse(string _uniName, string _semesterName, string _departmentName, string _courseName, string _hash) external {
        University storage uni = universities[uniNameToId[_uniName]];
        Semester storage semester = uni.semesters[uni.semesterNameToId[_semesterName]];
        Department storage department = semester.departments[semester.departmentNameToId[_departmentName]];
        courseGlobal.name = _courseName;
        courseGlobal.syllabusHash = _hash;
        uint id = department.courses.push(courseGlobal);
        department.courseNameToId[_courseName] = id - 1;
    }

    function getUniversity(string _uniName) external view returns (string){
        return universities[uniNameToId[_uniName]].name;
    }
    
    function getDepartment(string _uniName, string _semesterName, string _departmentName) external view returns(string){
        University storage uni = universities[uniNameToId[_uniName]];
        Semester storage semester = uni.semesters[uni.semesterNameToId[_semesterName]];
        Department storage department = semester.departments[semester.departmentNameToId[_departmentName]];
        return department.name;
    }
    
    function getSyllabusHash(string _uniName, string _semesterName, string _departmentName, string _courseName) external view returns (string) {
        University storage uni = universities[uniNameToId[_uniName]];
        Semester storage semester = uni.semesters[uni.semesterNameToId[_semesterName]];
        Department storage department = semester.departments[semester.departmentNameToId[_departmentName]];
        return department.courses[department.courseNameToId[_courseName]].syllabusHash;
    }
}