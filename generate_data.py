import csv
import random

random.seed(42)

subjects = ["Mathematics", "Science", "English", "History", "Computer Science"]
categories = ["Advanced", "Intermediate", "Beginner"]
genders = ["Male", "Female"]

# Category influences score range
category_ranges = {
    "Advanced":     (60, 100),
    "Intermediate": (40, 85),
    "Beginner":     (25, 70),
}

# Subject difficulty modifier (lower = harder)
subject_mod = {
    "Mathematics":      -5,
    "Science":          -3,
    "English":           2,
    "History":           3,
    "Computer Science": -2,
}

rows = []
student_id = 1001
for i in range(200):
    category = random.choice(categories)
    gender = random.choice(genders)
    grade_level = random.randint(9, 12)
    low, high = category_ranges[category]
    for subject in subjects:
        mod = subject_mod[subject]
        score = max(0, min(100, random.randint(low + mod, high + mod)))
        rows.append({
            "student_id": student_id,
            "gender": gender,
            "grade_level": grade_level,
            "student_category": category,
            "subject": subject,
            "score": score,
            "pass_fail": "Pass" if score >= 50 else "Fail"
        })
    student_id += 1

with open("data/students.csv", "w", newline="") as f:
    writer = csv.DictWriter(f, fieldnames=rows[0].keys())
    writer.writeheader()
    writer.writerows(rows)

print(f"Generated {len(rows)} records for {student_id - 1001} students.")
