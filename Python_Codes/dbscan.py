import numpy as np
from sklearn.cluster import DBSCAN
import matplotlib.pyplot as plt

# Sample dataset: Student scores
data = np.array([
    [85, 90],
    [88, 92],
    [82, 88],
    [45, 50],
    [42, 48],
    [40, 45],
    [70, 75],
    [72, 78],
    [30, 35],
    [28, 32]
])

# Apply DBSCAN clustering
dbscan = DBSCAN(eps=10, min_samples=2)
clusters = dbscan.fit_predict(data)

# Print results
print("DBSCAN Clustering Results:")
print("-" * 40)
for i, cluster in enumerate(clusters):
    print(f"Student {i+1}: Cluster {cluster}")

print(f"\nNumber of clusters: {len(set(clusters)) - (1 if -1 in clusters else 0)}")
print(f"Number of noise points: {list(clusters).count(-1)}")

# Visualize clusters
plt.figure(figsize=(8, 6))
scatter = plt.scatter(data[:, 0], data[:, 1], c=clusters, cmap='viridis', s=100)
plt.xlabel('Ecommerce Score')
plt.ylabel('DWDM Score')
plt.title('DBSCAN Clustering')
plt.colorbar(scatter, label='Cluster')
plt.grid(True)
plt.show()