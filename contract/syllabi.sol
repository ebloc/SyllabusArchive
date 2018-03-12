pragma solidity ^0.4.18;

contract Syllabi {

    University[] universities;
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
        bytes32 fileHash;
    }

    function addUniversity(string _name) external {
        uint id = universities.push(University(_name, []));
        uniNameToId[_name] = id;
    }

    function addSemester(string _uniName, string _semesterName) external {
        University memory uni = universities[uniNameToId[_uniName]];
        uint id = uni.semesters.push(_semesterName, []);
        uni.semesterNameToId[_semesterName] = id;
    }

    function addDepartment(string _uniName, string _semesterName, string _departmentName) external {
        University memory uni = universities[uniNameToId[_uniName]];
        Semester memory semester = uni.semesters[uni.semesterNameToId[_semesterName]];
        uint id = semester.departments.push(_departmentName, []);
        semester.departmentNameToId[_departmentName] = id;
    }

    function addCourse(string _uniName, string _semesterName, string _departmentName, string _courseName, bytes32 _hash) external {
        University memory uni = universities[uniNameToId[_uniName]];
        Semester memory semester = uni.semesters[uni.semesterNameToId[_semesterName]];
        Department memory department = semester.departments[semester.departmentNameToId[_departmentName]];
        uint id = department.courses.push(_courseName, _hash);
        department.courseNameToId[_courseName] = id;
    }
}