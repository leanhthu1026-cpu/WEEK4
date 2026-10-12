import Foundation

class Student: Identifiable {
    var id: String { getId() }
    private var studentId: String
    private var name: String
    private var year: Int
    private var gpa: Double

    init(id: String = "", name: String = "", year: Int = 1, gpa: Double = 0.0) {
        self.studentId = id
        self.name = name
        self.year = year
        self.gpa = gpa
    }

    func getId() -> String { return studentId }
    func getName() -> String { return name }
    func getYear() -> Int { return year }
    func getGpa() -> Double { return gpa }

    func setId(_ id: String) { self.studentId = id }
    func setName(_ name: String) { self.name = name }
    func setYear(_ year: Int) { self.year = year }
    func setGpa(_ gpa: Double) { self.gpa = gpa }

    func displayInfo() {
        print("ID: \(studentId), Name: \(name), Year: \(year), GPA: \(gpa)")
    }
}
