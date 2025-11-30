import numpy as np
import matplotlib.pyplot as plt

# Sample dataset: Student scores [Ecommerce, DWDM]
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
    [28, 32],
    [95, 30],  
    [15, 85]   
])

# DBSCAN Parameters
eps = 10        
min_pts = 2     

def euclidean_distance(point1, point2):
    """Calculate Euclidean distance between two points"""
    return np.sqrt(np.sum((point1 - point2) ** 2))

def get_neighbors(data, point_idx, eps):
    """Find all neighbors within eps distance"""
    neighbors = []
    for i in range(len(data)):
        if euclidean_distance(data[point_idx], data[i]) <= eps:
            neighbors.append(i)
    return neighbors

def dbscan(data, eps, min_pts):
    """ DBSCAN implementation"""
    n = len(data)
    labels = [-1] * n  # -1 meaning unclassified
    cluster_id = 0
    
    for i in range(n):
        # Skip if already classified
        if labels[i] != -1:
            continue
        
        # Get neighbors
        neighbors = get_neighbors(data, i, eps)
        
        # Check if core point
        if len(neighbors) < min_pts:
            labels[i] = -1  # Mark as noise
            continue
        
        # Start new cluster
        labels[i] = cluster_id
        
        # Expand cluster
        seed_set = neighbors.copy()
        seed_set.remove(i)
        
        while seed_set:
            current_point = seed_set.pop(0)
            
            # Change noise to border point
            if labels[current_point] == -1:
                labels[current_point] = cluster_id
            
            # Skip if already processed
            if labels[current_point] != -1:
                continue
            
            labels[current_point] = cluster_id
            
            # Find neighbors of current point
            current_neighbors = get_neighbors(data, current_point, eps)
            
            # If core point, add its neighbors to seed set
            if len(current_neighbors) >= min_pts:
                for neighbor in current_neighbors:
                    if labels[neighbor] == -1 or neighbor not in seed_set:
                        seed_set.append(neighbor)
        
        cluster_id += 1
    
    return labels

# Applying DBSCAN
print("=" * 50)
print("DBSCAN Clustering ")
print("=" * 50)
print(f"Epsilon (eps): {eps}")
print(f"Minimum Points (min_pts): {min_pts}")
print(f"Total Data Points: {len(data)}\n")

clusters = dbscan(data, eps, min_pts)

# Printing results
print("Clustering Results:")
print("-" * 50)
for i, cluster in enumerate(clusters):
    cluster_name = f"Cluster {cluster}" if cluster != -1 else "Noise"
    print(f"Point {i+1} {data[i]}: {cluster_name}")

num_clusters = len(set(clusters)) - (1 if -1 in clusters else 0)
num_noise = clusters.count(-1)
print(f"\nTotal Clusters Found: {num_clusters}")
print(f"Noise Points: {num_noise}")

# Visualizing
plt.figure(figsize=(8, 6))
colors = ['red', 'blue', 'green', 'yellow', 'purple']
for i, point in enumerate(data):
    if clusters[i] == -1:
        plt.scatter(point[0], point[1], c='black', marker='x', s=100, label='Noise' if i == 0 else '')
    else:
        color = colors[clusters[i] % len(colors)]
        plt.scatter(point[0], point[1], c=color, s=100)

plt.xlabel('Ecommerce Score')
plt.ylabel('DWDM Score')
plt.title('DBSCAN Clustering ')
plt.grid(True)
plt.show()