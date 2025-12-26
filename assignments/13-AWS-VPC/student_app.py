from flask import Flask, jsonify, request
import pymysql

app = Flask(__name__)

# Database Configuration
DB_HOST = 'homework-rds.c0t8k4mimblw.us-east-1.rds.amazonaws.com'
DB_USER = 'admin'
DB_PASSWORD = 'password123'
DB_NAME = 'homework_db'

def get_db_connection():
    return pymysql.connect(
        host=DB_HOST,
        user=DB_USER,
        password=DB_PASSWORD,
        database=DB_NAME,
        cursorclass=pymysql.cursors.DictCursor
    )

@app.route('/students', methods=['GET'])
def get_students():
    try:
        connection = get_db_connection()
        with connection.cursor() as cursor:
            cursor.execute("SELECT * FROM students")
            result = cursor.fetchall()
        connection.close()
        return jsonify(result), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/students', methods=['POST'])
def add_student():
    try:
        data = request.json
        name = data['name']
        age = data['age']
        connection = get_db_connection()
        with connection.cursor() as cursor:
            cursor.execute("INSERT INTO students (name, age) VALUES (%s, %s)", (name, age))
        connection.commit()
        connection.close()
        return jsonify({'message': 'Student added successfully'}), 201
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/students/<int:id>', methods=['PUT'])
def update_student(id):
    try:
        data = request.json
        new_age = data['age']
        connection = get_db_connection()
        with connection.cursor() as cursor:
            cursor.execute("UPDATE students SET age = %s WHERE id = %s", (new_age, id))
        connection.commit()
        connection.close()
        return jsonify({'message': 'Student updated successfully'}), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/students/<int:id>', methods=['DELETE'])
def delete_student(id):
    try:
        connection = get_db_connection()
        with connection.cursor() as cursor:
            cursor.execute("DELETE FROM students WHERE id = %s", (id,))
        connection.commit()
        connection.close()
        return jsonify({'message': 'Student deleted successfully'}), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500

if __name__ == '__main__':
    # Run on all interfaces (0.0.0.0) so we can access it
    app.run(host='0.0.0.0', port=5000)