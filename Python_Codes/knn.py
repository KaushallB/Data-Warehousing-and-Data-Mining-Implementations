import numpy as np
from sklearn.neighbors import KNeighborsClassifier
from sklearn.model_selection import train_test_split
from sklearn.metrics import accuracy_score, confusion_matrix

# Sample dataset: Student data
X = np.array([
    [85, 78, 82],
    [45, 52, 48],
    [72, 68, 75],
    [38, 42, 40],
    [90, 88, 92],
    [65, 70, 68],
    [55, 60, 58],
    [78, 75, 80],
    [42, 48, 45],
    [88, 85, 90]
])

# Labels: Pass (1) or Fail (0)
y = np.array([1, 0, 1, 0, 1, 1, 0, 1, 0, 1])

# Split data into training and testing sets
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.3, random_state=42)

# Create and train KNN classifier with K=3
knn = KNeighborsClassifier(n_neighbors=3)
knn.fit(X_train, y_train)

# Make predictions
y_pred = knn.predict(X_test)

# Print results
print("KNN Classification Results:")
print("-" * 40)
print(f"K value: 3")
print(f"\nTest Data:")
for i, (test, pred, actual) in enumerate(zip(X_test, y_pred, y_test)):
    result = "Pass" if pred == 1 else "Fail"
    actual_result = "Pass" if actual == 1 else "Fail"
    print(f"Student {i+1}: Scores {test} -> Predicted: {result}, Actual: {actual_result}")

# Calculate accuracy
accuracy = accuracy_score(y_test, y_pred)
print(f"\nAccuracy: {accuracy * 100:.2f}%")

# Confusion Matrix
cm = confusion_matrix(y_test, y_pred)
print("\nConfusion Matrix:")
print(cm)

# Predict for new student
new_student = np.array([[75, 70, 78]])
prediction = knn.predict(new_student)
result = "Pass" if prediction[0] == 1 else "Fail"
print(f"\nNew Student Prediction:")
print(f"Scores: {new_student[0]} -> Predicted Result: {result}")