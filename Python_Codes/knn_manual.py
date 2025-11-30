import numpy as np

# Training dataset: [Ecommerce, DWDM, Operations Management]
X_train = np.array([
    [85, 78, 82],
    [45, 52, 48],
    [72, 68, 75],
    [38, 42, 40],
    [90, 88, 92],
    [65, 70, 68],
    [55, 60, 58]
])

# Training labels: 1=Pass, 0=Fail
y_train = np.array([1, 0, 1, 0, 1, 1, 0])

# Test dataset
X_test = np.array([
    [78, 75, 80],
    [42, 48, 45],
])

# Actual test labels (for comparison)
y_test = np.array([1, 0, 1])

def euclidean_distance(point1, point2):
    """Calculate Euclidean distance between two points"""
    return np.sqrt(np.sum((point1 - point2) ** 2))

def knn_predict(X_train, y_train, test_point, k):
    """ KNN prediction for a single test point"""
    distances = []
    
    # Calculating distance from test point to all training points
    for i in range(len(X_train)):
        dist = euclidean_distance(test_point, X_train[i])
        distances.append((dist, y_train[i]))
    
    # Sorting by distance
    distances.sort(key=lambda x: x[0])
    
    # Getting K nearest neighbors
    k_nearest = distances[:k]
    
    # Counting votes for each class
    votes = {}
    for dist, label in k_nearest:
        votes[label] = votes.get(label, 0) + 1
    
    # Returning class with most votes
    predicted_class = max(votes, key=votes.get)
    return predicted_class, k_nearest

# Setting K value
k = 3

print("=" * 60)
print("K-Nearest Neighbors Classification ")
print("=" * 60)
print(f"K value: {k}")
print(f"Training samples: {len(X_train)}")
print(f"Test samples: {len(X_test)}\n")

# Making predictions
predictions = []
correct = 0

print("Prediction Results:")
print("-" * 60)

for i, test_point in enumerate(X_test):
    predicted, neighbors = knn_predict(X_train, y_train, test_point, k)
    predictions.append(predicted)
    
    pred_label = "Pass" if predicted == 1 else "Fail"
    actual_label = "Pass" if y_test[i] == 1 else "Fail"
    
    print(f"\nTest Point {i+1}: {test_point}")
    print(f"  K Nearest Neighbors:")
    for j, (dist, label) in enumerate(neighbors):
        label_text = "Pass" if label == 1 else "Fail"
        print(f"    Neighbor {j+1}: Distance={dist:.2f}, Class={label_text}")
    
    print(f"  Predicted: {pred_label}")
    print(f"  Actual: {actual_label}")
    
    if predicted == y_test[i]:
        correct += 1
        print(f"  Result:  Correct")
    else:
        print(f"  Result:  Incorrect")

# Calculating accuracy
accuracy = (correct / len(X_test)) * 100
print(f"\n{'=' * 60}")
print(f"Accuracy: {correct}/{len(X_test)} = {accuracy:.2f}%")

# Testing with new student
print(f"\n{'=' * 60}")
print("Prediction for New Student:")
print("-" * 60)
new_student = np.array([75, 70, 78])
prediction, neighbors = knn_predict(X_train, y_train, new_student, k)
result = "Pass" if prediction == 1 else "Fail"

print(f"New Student Scores: {new_student}")
print(f"K Nearest Neighbors:")
for j, (dist, label) in enumerate(neighbors):
    label_text = "Pass" if label == 1 else "Fail"
    print(f"  Neighbor {j+1}: Distance={dist:.2f}, Class={label_text}")
print(f"\nPredicted Result: {result}")