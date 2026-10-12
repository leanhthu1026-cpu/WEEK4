
import Foundation

class StudentSubject {
    private var studentId: String
    private var subjectId: String
    private var year: Int
    private var mark: Double

    init(studentId: String = "", subjectId: String = "", year: Int = 2026, mark: Double = 0.0) {
        self.studentId = studentId
        self.subjectId = subjectId
        self.year = year
        self.mark = mark
    }

    func getStudentId() -> String { return studentId }
    func getSubjectId() -> String { return subjectId }
    func getYear() -> Int { return year }
    func getMark() -> Double { return mark }

    func setMark(_ newMark: Double) {
        self.mark = newMark
    }

    func displayInfo() {
        print("\(studentId) - \(subjectId) - Year: \(year), Mark: \(mark)")
    }
}
