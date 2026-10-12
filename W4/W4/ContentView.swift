import SwiftUI

// MARK: - 1. Data Models
struct StudentModel: Identifiable, Hashable {
    var id: String
    var name: String
    var className: String
}

struct SubjectModel: Identifiable, Hashable {
    var id: String
    var name: String
    var credits: Int
}

struct CourseRegistration: Identifiable {
    var id = UUID()
    var studentId: String
    var subjectId: String
    var semester: String
    var grade: Double?
}

// MARK: - 2. Main View
struct ContentView: View {
    @State private var students: [StudentModel] = [
        StudentModel(id: "SV001", name: "Lê Minh", className: "21KTPM1"),
        StudentModel(id: "SV002", name: "Phạm Hoa", className: "21KTPM1"),
        StudentModel(id: "SV003", name: "Trần An", className: "21KTPM2")
    ]
    
    @State private var subjects: [SubjectModel] = [
        SubjectModel(id: "CSE101", name: "iOS Programming", credits: 3),
        SubjectModel(id: "CSE201", name: "Cấu trúc dữ liệu", credits: 4),
        SubjectModel(id: "CSE301", name: "Giải thuật", credits: 3)
    ]
    
    @State private var registrations: [CourseRegistration] = [
        CourseRegistration(studentId: "SV001", subjectId: "CSE101", semester: "HK1", grade: 8.5),
        CourseRegistration(studentId: "SV001", subjectId: "CSE201", semester: "HK1", grade: 9.0),
        CourseRegistration(studentId: "SV002", subjectId: "CSE101", semester: "HK1", grade: 4.0),
        CourseRegistration(studentId: "SV003", subjectId: "CSE201", semester: "HK1", grade: 3.5)
    ]

    var body: some View {
        TabView {
            StudentManagementView(students: $students, subjects: subjects, registrations: $registrations)
                .tabItem {
                    Label("Sinh viên", systemImage: "person.crop.circle")
                }

            SubjectManagementView(subjects: $subjects)
                .tabItem {
                    Label("Môn học", systemImage: "book.closed")
                }

            GradeEntryView(registrations: $registrations, students: students, subjects: subjects)
                .tabItem {
                    Label("Nhập điểm", systemImage: "square.and.pencil")
                }

            StatisticsView(students: students, subjects: subjects, registrations: registrations)
                .tabItem {
                    Label("Thống kê", systemImage: "chart.bar.xaxis")
                }
        }
    }
}

// MARK: - 3. Tab 1: Sinh viên & Đăng ký môn (Nền: "bg")
struct StudentManagementView: View {
    @Binding var students: [StudentModel]
    let subjects: [SubjectModel]
    @Binding var registrations: [CourseRegistration]

    @State private var newId = ""
    @State private var newName = ""
    @State private var newClass = ""
    @State private var showingAddStudent = false
    @State private var showingEnrollSheet = false
    @State private var selectedStudent: StudentModel?

    var body: some View {
        NavigationStack {
            List {
                // Đệm nhẹ một khoảng cách nhỏ đầu trang để không chạm thanh bar
                Color.clear.frame(height: 8)
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)

                ForEach(students) { student in
                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            Text(student.name)
                                .font(.headline)
                            Spacer()
                            Text(student.className)
                                .font(.caption)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 3)
                                .background(Color.blue.opacity(0.15))
                                .cornerRadius(6)
                        }
                        Text("MSSV: \(student.id)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        let registeredList = registrations.filter { $0.studentId == student.id }
                        if !registeredList.isEmpty {
                            Text("Môn đã đăng ký: " + registeredList.map { reg in
                                let sName = subjects.first(where: { $0.id == reg.subjectId })?.name ?? reg.subjectId
                                return "\(sName) (\(reg.grade != nil ? "\(reg.grade!)đ" : "Chưa nhập"))"
                            }.joined(separator: ", "))
                            .font(.caption)
                            .foregroundColor(.secondary)
                        }
                    }
                    .padding()
                    .background(Color.white.opacity(0.85))
                    .cornerRadius(12)
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets(top: 6, leading: 16, bottom: 6, trailing: 16))
                    .swipeActions {
                        Button {
                            selectedStudent = student
                            showingEnrollSheet = true
                        } label: {
                            Label("Đăng ký môn", systemImage: "plus.circle")
                        }
                        .tint(.green)
                    }
                }
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
            .background(
                Image("bg")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
            )
            .navigationTitle("Danh sách sinh viên")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button { showingAddStudent = true } label: {
                        Image(systemName: "person.badge.plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddStudent) {
                NavigationStack {
                    Form {
                        TextField("Mã sinh viên (MSSV)", text: $newId)
                        TextField("Họ và tên", text: $newName)
                        TextField("Lớp học", text: $newClass)
                    }
                    .navigationTitle("Thêm sinh viên")
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Hủy") { showingAddStudent = false }
                        }
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Lưu") {
                                if !newId.isEmpty && !newName.isEmpty {
                                    students.append(StudentModel(id: newId, name: newName, className: newClass))
                                    newId = ""; newName = ""; newClass = ""
                                    showingAddStudent = false
                                }
                            }
                        }
                    }
                }
            }
            .sheet(item: $selectedStudent) { student in
                EnrollSubjectView(student: student, subjects: subjects, registrations: $registrations)
            }
        }
    }
}

// Dialog chọn môn học
struct EnrollSubjectView: View {
    let student: StudentModel
    let subjects: [SubjectModel]
    @Binding var registrations: [CourseRegistration]
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            List(subjects) { subject in
                let isEnrolled = registrations.contains { $0.studentId == student.id && $0.subjectId == subject.id }
                HStack {
                    VStack(alignment: .leading) {
                        Text(subject.name).font(.headline)
                        Text("Mã: \(subject.id) - \(subject.credits) tín chỉ").font(.caption).foregroundColor(.secondary)
                    }
                    Spacer()
                    if isEnrolled {
                        Text("Đã đăng ký").foregroundColor(.secondary).font(.caption)
                    } else {
                        Button("Thêm vào kỳ") {
                            registrations.append(CourseRegistration(studentId: student.id, subjectId: subject.id, semester: "HK1", grade: nil))
                        }
                        .buttonStyle(.borderedProminent)
                        .font(.caption)
                    }
                }
            }
            .navigationTitle("Đăng ký môn cho \(student.name)")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Xong") { dismiss() }
                }
            }
        }
    }
}

// MARK: - 4. Tab 2: Thêm & Quản lý môn học (Nền: "bg1")
struct SubjectManagementView: View {
    @Binding var subjects: [SubjectModel]
    @State private var showingAdd = false
    @State private var id = ""
    @State private var name = ""
    @State private var credits = 3

    var body: some View {
        NavigationStack {
            List {
                Color.clear.frame(height: 8)
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)

                ForEach(subjects) { subject in
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(subject.name).font(.headline)
                            Text("Mã môn: \(subject.id)").font(.subheadline).foregroundColor(.secondary)
                        }
                        Spacer()
                        Text("\(subject.credits) tín chỉ")
                            .font(.caption)
                            .padding(6)
                            .background(Color.orange.opacity(0.2))
                            .foregroundColor(.orange)
                            .cornerRadius(6)
                    }
                    .padding()
                    .background(Color.white.opacity(0.85))
                    .cornerRadius(12)
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets(top: 6, leading: 16, bottom: 6, trailing: 16))
                }
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
            .background(
                Image("bg1")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
            )
            .navigationTitle("Danh sách môn học")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button { showingAdd = true } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAdd) {
                NavigationStack {
                    Form {
                        TextField("Mã môn học (vd: CSE101)", text: $id)
                        TextField("Tên môn học", text: $name)
                        Stepper("Số tín chỉ: \(credits)", value: $credits, in: 1...10)
                    }
                    .navigationTitle("Thêm môn học mới")
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) { Button("Hủy") { showingAdd = false } }
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Lưu") {
                                if !id.isEmpty && !name.isEmpty {
                                    subjects.append(SubjectModel(id: id, name: name, credits: credits))
                                    id = ""; name = ""; credits = 3
                                    showingAdd = false
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

// MARK: - 5. Tab 3: Cập nhật điểm cho từng môn (Nền: "bg2")
struct GradeEntryView: View {
    @Binding var registrations: [CourseRegistration]
    let students: [StudentModel]
    let subjects: [SubjectModel]
    
    @State private var editingItem: CourseRegistration?
    @State private var inputScore = ""

    var body: some View {
        NavigationStack {
            List {
                Color.clear.frame(height: 8)
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)

                ForEach($registrations) { $reg in
                    let studentName = students.first(where: { $0.id == reg.studentId })?.name ?? reg.studentId
                    let subjectName = subjects.first(where: { $0.id == reg.subjectId })?.name ?? reg.subjectId

                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(studentName).font(.headline)
                            Text("Môn: \(subjectName) (\(reg.semester))")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                        if let grade = reg.grade {
                            Text("\(String(format: "%.1f", grade)) đ")
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(grade >= 5.0 ? .blue : .red)
                        } else {
                            Text("Chưa nhập")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                    .padding()
                    .background(Color.white.opacity(0.85))
                    .cornerRadius(12)
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets(top: 6, leading: 16, bottom: 6, trailing: 16))
                    .contentShape(Rectangle())
                    .onTapGesture {
                        editingItem = reg
                        inputScore = reg.grade != nil ? "\(reg.grade!)" : ""
                    }
                }
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
            .background(
                Image("bg2")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
            )
            .navigationTitle("Cập nhật điểm")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(item: $editingItem) { item in
                NavigationStack {
                    Form {
                        Section("Nhập điểm thi (thang 10)") {
                            TextField("Ví dụ: 8.5", text: $inputScore)
                                .keyboardType(.decimalPad)
                        }
                    }
                    .navigationTitle("Cập nhật điểm")
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) { Button("Hủy") { editingItem = nil } }
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Lưu điểm") {
                                if let score = Double(inputScore), score >= 0 && score <= 10 {
                                    if let index = registrations.firstIndex(where: { $0.id == item.id }) {
                                        registrations[index].grade = score
                                    }
                                }
                                editingItem = nil
                            }
                        }
                    }
                }
            }
        }
    }
}

// MARK: - 6. Tab 4: Thống kê (Nền: "bg3")
struct StatisticsView: View {
    let students: [StudentModel]
    let subjects: [SubjectModel]
    let registrations: [CourseRegistration]

    func calculateGPA(for studentId: String) -> Double? {
        let studentRegs = registrations.filter { $0.studentId == studentId && $0.grade != nil }
        guard !studentRegs.isEmpty else { return nil }

        var totalPoints = 0.0
        var totalCredits = 0

        for reg in studentRegs {
            let credits = subjects.first(where: { $0.id == reg.subjectId })?.credits ?? 3
            if let grade = reg.grade {
                totalPoints += grade * Double(credits)
                totalCredits += credits
            }
        }
        return totalCredits > 0 ? (totalPoints / Double(totalCredits)) : nil
    }

    var body: some View {
        NavigationStack {
            List {
                Color.clear.frame(height: 8)
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)

                // a) Sinh viên có GPA > 8.0
                Section {
                    let topStudents = students.filter { (calculateGPA(for: $0.id) ?? 0.0) > 8.0 }
                    if topStudents.isEmpty {
                        Text("Chưa có sinh viên nào GPA > 8.0")
                            .foregroundColor(.secondary)
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.white.opacity(0.85))
                            .cornerRadius(12)
                    } else {
                        ForEach(topStudents) { student in
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(student.name).font(.headline)
                                    Text("MSSV: \(student.id)").font(.caption).foregroundColor(.secondary)
                                }
                                Spacer()
                                if let gpa = calculateGPA(for: student.id) {
                                    Text("GPA: \(String(format: "%.2f", gpa))")
                                        .font(.headline)
                                        .foregroundColor(.green)
                                }
                            }
                            .padding()
                            .background(Color.white.opacity(0.85))
                            .cornerRadius(12)
                        }
                    }
                } header: {
                    Label("a) Sinh viên GPA > 8.0", systemImage: "star.fill")
                        .font(.headline)
                        .foregroundColor(.primary)
                        .padding(.vertical, 4)
                }
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
                .listRowInsets(EdgeInsets(top: 4, leading: 16, bottom: 4, trailing: 16))

                // b) Danh sách sinh viên rớt từng môn (< 5.0)
                Section {
                    ForEach(subjects) { subject in
                        let failedRegs = registrations.filter { $0.subjectId == subject.id && ($0.grade ?? 10.0) < 5.0 }
                        VStack(alignment: .leading, spacing: 6) {
                            Text(subject.name)
                                .font(.headline)
                            
                            if failedRegs.isEmpty {
                                Text("Không có sinh viên nào rớt môn này")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            } else {
                                ForEach(failedRegs) { reg in
                                    let sName = students.first(where: { $0.id == reg.studentId })?.name ?? reg.studentId
                                    HStack {
                                        Text("• \(sName) (\(reg.studentId))")
                                        Spacer()
                                        Text("\(String(format: "%.1f", reg.grade ?? 0.0)) đ")
                                            .foregroundColor(.red)
                                            .fontWeight(.bold)
                                    }
                                    .font(.subheadline)
                                }
                            }
                        }
                        .padding()
                        .background(Color.white.opacity(0.85))
                        .cornerRadius(12)
                    }
                } header: {
                    Label("b) Sinh viên rớt môn (< 5.0)", systemImage: "exclamationmark.triangle.fill")
                        .font(.headline)
                        .foregroundColor(.primary)
                        .padding(.vertical, 4)
                }
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
                .listRowInsets(EdgeInsets(top: 4, leading: 16, bottom: 4, trailing: 16))
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
            .background(
                Image("bg3")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
            )
            .navigationTitle("Báo cáo & Thống kê")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    ContentView()
}
