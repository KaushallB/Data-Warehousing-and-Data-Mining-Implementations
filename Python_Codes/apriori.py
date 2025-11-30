from itertools import combinations

# Transaction database
transactions = [
    {'Laptop', 'Mouse', 'Keyboard'},
    {'Mouse', 'Headphone'},
    {'Laptop', 'Keyboard', 'USB'},
    {'Laptop', 'Mouse', 'Keyboard', 'USB'},
    {'Mouse', 'Headphone'},
    {'Laptop', 'Mouse', 'Keyboard'},
    {'Laptop', 'Keyboard', 'USB'},
    {'Mouse', 'Headphone'},
]

min_support = 2  # Minimum support count

def get_support(itemset, transactions):
    """Count how many transactions contain the itemset"""
    count = 0
    for transaction in transactions:
        if itemset.issubset(transaction):
            count += 1
    return count

def apriori(transactions, min_support):
    """Generate frequent itemsets using Apriori algorithm"""
    
    # Getting all unique items
    all_items = set()
    for transaction in transactions:
        all_items.update(transaction)
    
    # Finding frequent 1-itemsets
    frequent_itemsets = {}
    print("Finding Frequent 1-Itemsets:")
    print("-" * 40)
    for item in all_items:
        itemset = frozenset([item])
        support = get_support(itemset, transactions)
        if support >= min_support:
            frequent_itemsets[itemset] = support
            print(f"{set(itemset)}: Support = {support}")
    
    # Finding frequent 2-itemsets
    print("\nFinding Frequent 2-Itemsets:")
    print("-" * 40)
    items_list = [set(itemset) for itemset in frequent_itemsets.keys()]
    for combo in combinations(items_list, 2):
        itemset = frozenset(combo[0] | combo[1])
        if len(itemset) == 2:
            support = get_support(itemset, transactions)
            if support >= min_support:
                frequent_itemsets[itemset] = support
                print(f"{set(itemset)}: Support = {support}")
    
    # Finding frequent 3-itemsets
    print("\nFinding Frequent 3-Itemsets:")
    print("-" * 40)
    two_itemsets = [itemset for itemset in frequent_itemsets.keys() if len(itemset) == 2]
    for combo in combinations(two_itemsets, 2):
        itemset = frozenset(combo[0] | combo[1])
        if len(itemset) == 3:
            support = get_support(itemset, transactions)
            if support >= min_support:
                frequent_itemsets[itemset] = support
                print(f"{set(itemset)}: Support = {support}")
    
    return frequent_itemsets

# Running Apriori algorithm
print("Apriori Algorithm - Frequent Itemset Generation")
print("=" * 40)
print(f"Minimum Support: {min_support}")
print(f"Total Transactions: {len(transactions)}\n")

frequent_itemsets = apriori(transactions, min_support)

print("\n" + "=" * 40)
print("All Frequent Itemsets:")
print("=" * 40)
for itemset, support in sorted(frequent_itemsets.items(), key=lambda x: (len(x[0]), x[1]), reverse=True):
    print(f"{set(itemset)}: Support = {support}")