import pymysql

# Database connection configuration
# Connecting as root locally (no password set by default in this lab setup)
connection = pymysql.connect(
    host='localhost',
    user='root',
    password='',
    database='homework_db',
    cursorclass=pymysql.cursors.DictCursor
)

def get_all_students():
    """
    Retrieve and display all students from the database.
    """
    print("\n--- Current Students List ---")
    try:
        with connection.cursor() as cursor:
            sql = "SELECT * FROM students"
            cursor.execute(sql)
            result = cursor.fetchall()
            for row in result:
                print(f"ID: {row['id']}, Name: {row['name']}, Age: {row['age']}")
    except Exception as e:
        print(f"Error retrieving students: {e}")

def add_student(name, age):
    """
    Add a new student to the database.
    """
    print(f"\n--- Adding Student: {name} ---")
    try:
        with connection.cursor() as cursor:
            sql = "INSERT INTO students (name, age) VALUES (%s, %s)"
            cursor.execute(sql, (name, age))
        connection.commit()
        print("Student added successfully.")
    except Exception as e:
        print(f"Error adding student: {e}")

def update_student_age(student_id, new_age):
    """
    Update the age of a specific student by ID.
    """
    print(f"\n--- Updating Student ID {student_id} to Age {new_age} ---")
    try:
        with connection.cursor() as cursor:
            sql = "UPDATE students SET age = %s WHERE id = %s"
            cursor.execute(sql, (new_age, student_id))
        connection.commit()
        print("Student updated successfully.")
    except Exception as e:
        print(f"Error updating student: {e}")

def delete_student(student_id):
    """
    Delete a student from the database by ID.
    """
    print(f"\n--- Deleting Student ID {student_id} ---")
    try:
        with connection.cursor() as cursor:
            sql = "DELETE FROM students WHERE id = %s"
            cursor.execute(sql, (student_id,))
        connection.commit()
        print("Student deleted successfully.")
    except Exception as e:
        print(f"Error deleting student: {e}")

# --- Main Execution Block ---
if __name__ == "__main__":
    try:
        # 1. Retrieve initial list
        get_all_students()

        # 2. Add a new student (David, 30)
        add_student("David", 30)
        get_all_students() # Show list after adding

        # 3. Update a student (Update Alice (id 1) to age 23)
        update_student_age(1, 23)
        get_all_students() # Show list after update

        # 4. Delete a student (Delete Bob, id 2)
        delete_student(2)
        get_all_students() # Show list after delete

    finally:
        connection.close()
        print("\nConnection closed.")