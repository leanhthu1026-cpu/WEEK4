import Foundation

class Teacher: Identifiable {
    var id: String { getId() } // Khớp với yêu cầu của Identifiable
    private var teacherId: String
    private var name: String
    private var subjects: [Subject]
    private var department: String

    init(id: String = "", name: String = "", subjects: [Subject] = [], department: String = "") {
        self.teacherId = id
        self.name = name
        self.subjects = subjects
        self.department = department
    }

    func getId() -> String { return teacherId }
    func getName() -> String { return name }
    func getSubjects() -> [Subject] { return subjects }
    func getDepartment() -> String { return department }

    func addSubject(_ subject: Subject) {
        self.subjects.append(subject)
    }

    func removeSubject(id: String) {
        self.subjects.removeAll { $0.getId() == id }
    }

    func displayInfo() {
        print("ID: \(teacherId), Name: \(name), Department: \(department)")
    }
}
