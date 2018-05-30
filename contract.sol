pragma solidity ^0.4.18;

contract Syllabi {

    University[] universities;
    University uniGlobal;
    Department departmentGlobal;
    Semester semesterGlobal;
    Course courseGlobal;
    mapping(string => uint) uniNameToId;
    mapping(string => bool) uniExists;

    struct University {
        string name;
        uint semesterNumber ;
        Semester[] semesters;
        mapping(string => bool) semesterExists;
        mapping(string => uint) semesterNameToId;
    }

    struct Semester {
        string name;
        Department[] departments;
        mapping(string => bool) departmentExists;
        mapping(string => uint) departmentNameToId;
    }

    struct Department {
        string name;
        Course[] courses;
        mapping(string => bool) courseExists;
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
        if(!uniExists[_name]){
        uniGlobal.name = _name;
        uint id = universities.push(uniGlobal);
        uniNameToId[_name] = id - 1;
        uniExists[_name] = true;
        }
    }
    
    

    function addSemester(string _uniName, string _semesterName) external {
        
        University storage uni = universities[uniNameToId[_uniName]];
        if(!uni.semesterExists[_semesterName]){
        semesterGlobal.name = _semesterName;
        uint id = uni.semesters.push(semesterGlobal);
        uni.semesterNameToId[_semesterName] = id - 1;
        uni.semesterExists[_semesterName] = true;
        }
    }

    function addDepartment(string _uniName, string _semesterName, string _departmentName) external {
        University storage uni = universities[uniNameToId[_uniName]];
        Semester storage semester = uni.semesters[uni.semesterNameToId[_semesterName]];
        if(!semester.departmentExists[_departmentName]){
        departmentGlobal.name = _departmentName;
        uint id = uni.semesters[uni.semesterNameToId[_semesterName]].departments.push(departmentGlobal);
        uni.semesters[uni.semesterNameToId[_semesterName]].departmentNameToId[_departmentName] = id - 1;
        semester.departmentExists[_departmentName] = true;
            
        }
            
    }

    function addCourse(string _uniName, string _semesterName, string _departmentName, string _courseName, string _hash) external {
        University storage uni = universities[uniNameToId[_uniName]];
        Semester storage semester = uni.semesters[uni.semesterNameToId[_semesterName]];
        Department storage department = semester.departments[semester.departmentNameToId[_departmentName]];
        if(!department.courseExists[_courseName]){
        courseGlobal.name = _courseName;
        courseGlobal.syllabusHash = _hash;
        uint id = department.courses.push(courseGlobal);
        department.courseNameToId[_courseName] = id - 1;
        department.courseExists[_courseName] = true ;
        }
    }

    function getUniversity(string _uniName) external view returns (string){
        return universities[uniNameToId[_uniName]].name;
    }
    
    function getUniversityById(uint _uniID) external view returns (string){
        return universities[_uniID].name;
    }
    
    function getSemesterById(uint _uniID,uint _semID) external view returns (string){
        return universities[_uniID].semesters[_semID].name;
    }
    
    function getDepartmentById(uint _uniID,uint _semID,uint _depID) external view returns (string){
        return universities[_uniID].semesters[_semID].departments[_depID].name;
    }
    
    function getCourseById(uint _uniID,uint _semID,uint _depID,uint _courseID) external view returns (string){
        return universities[_uniID].semesters[_semID].departments[_depID].courses[_courseID].name;
    }
    
    function getUniNumber() external view returns (uint){
        return universities.length;
    }
    
    function getSemesterNumber(uint uniId) external view returns (uint){
        return universities[uniId].semesters.length;
    }
    
    function getDepartmentNumber(uint uniId,uint semID) external view returns (uint){
        return universities[uniId].semesters[semID].departments.length;
    }
    
    function getCourseNumber(uint uniId, uint semID, uint depID) external view returns (uint){
        return universities[uniId].semesters[semID].departments[depID].courses.length;
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
    
    function getHash(uint uniId, uint semId, uint depId, uint courseId) external view returns (string) {
        University storage uni = universities[uniId];
        Semester storage semester = uni.semesters[semId];
        Department storage department = semester.departments[depId];
        return department.courses[courseId].syllabusHash;
    }
}
