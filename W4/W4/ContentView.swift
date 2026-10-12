import SwiftUI

struct ContentView: View {
    // 1. Dữ liệu môn học
    private let subjects: [Subject] = [
        Subject(id: "CSE101", name: "iOS Programming", credits: 3, semester: 1),
        Subject(id: "CSE201", name: "Data Structures", credits: 4, semester: 2),
        Subject(id: "CSE301", name: "Algorithms", credits: 3, semester: 3)
    ]
    
    // 2. Dữ liệu giáo viên
    private var teachers: [Teacher] {
        [
            Teacher(id: "T001", name: "Nguyen Van A", subjects: [subjects[0], subjects[1]], department: "IT"),
            Teacher(id: "T002", name: "Tran Thi B", subjects: [subjects[2]], department: "CS")
        ]
    }
    
    // 3. Dữ liệu sinh viên
    private let students: [Student] = [
        Student(id: "SV001", name: "Le Minh", year: 1, gpa: 3.2),
        Student(id: "SV002", name: "Pham Hoa", year: 2, gpa: 3.6),
        Student(id: "SV003", name: "Tran An", year: 1, gpa: 3.0)
    ]
    
    // 4. Bảng điểm
    private let marks: [StudentSubject] = [
        StudentSubject(studentId: "SV001", subjectId: "CSE101", year: 2026, mark: 8.5),
        StudentSubject(studentId: "SV002", subjectId: "CSE201", year: 2026, mark: 7.0),
        StudentSubject(studentId: "SV002", subjectId: "CSE101", year: 2026, mark: 9.0)
    ]

    var body: some View {
        NavigationStack {
            List {
                // Section 1: Teachers
                Section(header: Label("Giáo viên (Teachers)", systemImage: "person.crop.rectangle.stack")) {
                    ForEach(teachers) { teacher in
                        VStack(alignment: .leading, spacing: 6) {
                            HStack {
                                Text(teacher.getName())
                                    .font(.headline)
                                Spacer()
                                Text(teacher.getDepartment())
                                    .font(.caption)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 2)
                                    .background(Color.blue.opacity(0.1))
                                    .foregroundColor(.blue)
                                    .cornerRadius(6)
                            }
                            Text("Mã GV: \(teacher.getId())")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            
                            Text("Môn dạy: " + teacher.getSubjects().map { "\($0.getId()) - \($0.getName())" }.joined(separator: ", "))
                                .font(.caption)
                                .foregroundColor(.primary)
                        }
                        .padding(.vertical, 4)
                    }
                }

                // Section 2: Students
                Section(header: Label("Sinh viên (Students)", systemImage: "graduationcap")) {
                    ForEach(students) { student in
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(student.getName())
                                    .font(.headline)
                                Text("Mã SV: \(student.getId()) • Năm \(student.getYear())")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                            VStack(alignment: .trailing) {
                                Text("GPA")
                                    .font(.caption2)
                                    .foregroundColor(.secondary)
                                Text(String(format: "%.1f", student.getGpa()))
                                    .font(.headline)
                                    .foregroundColor(student.getGpa() >= 3.5 ? .green : .primary)
                            }
                        }
                        .padding(.vertical, 2)
                    }
                }

                // Section 3: Student Marks
                Section(header: Label("Bảng điểm (Marks)", systemImage: "list.clipboard")) {
                    ForEach(marks.indices, id: \.self) { index in
                        let record = marks[index]
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Mã SV: \(record.getStudentId())")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                Text("Môn: \(record.getSubjectId()) • Năm học: \(record.getYear())")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                            Text("\(String(format: "%.1f", record.getMark())) đ")
                                .font(.headline)
                                .foregroundColor(.orange)
                        }
                        .padding(.vertical, 2)
                    }
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("School Management")
        }
    }
}

#Preview {
    ContentView()
}
