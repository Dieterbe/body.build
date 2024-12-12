# Program Generator V1 - Notes and Learnings

Note: not aware of filters and exclusions

## Current Approach
1. Exercise Selection
   - Rank exercises by total recruitment
   - Filter to compound exercises (rank > 1.25) (the idea was to focus on compounds first and see how far that gets us)
   - Split into disjoint components based on muscle groups

2. Set Count Optimization
   - For each component:
     - Try combinations of exercises (minExercises to minExercises + 2)
     - For each combination:
       - Try all possible set counts (1-4 sets per exercise)
       - Calculate cost for each combination
       - Keep track of best solution

3. Matrix-Based Cost Calculation
   - Use recruitment matrix [exercises × program_groups]
   - Calculate total recruitment via matrix operations
   - Compare with target vector
   - Apply penalties for overshoot (3x)

## Optimizations Attempted
1. Component Splitting
   - Split exercises into disjoint groups
   - Reduced problem size significantly (from 288M combo's to 9k and 220k for the respective components)
   - Still not enough for reasonable performance. would take days

2. Matrix Operations
   - used ml_linalg for matrix operations to try to speed it up. 
   - would have still taken around a day or so.
   - Switched to direct array access in calculateCost instead of creating new vectors/matrices.
   this made it maybe 2-3x faster, but still way too slow overall

3. Data Structure Optimization
   - Cached matrix data as lists
   - Tried flattened arrays for better locality (not committed. not sure if it helped)
   - Still >95% time spent in calculateCost

## Performance Issues
1. Combinatorial Explosion
   - For n exercises, we try all combinations of size k to k+2
   - For each combination, we try 4^m possibilities (m = selected exercises)
   - Results in millions of cost calculations

2. Cost Calculation Overhead
   - Each cost calculation requires O(exercises × groups) operations
   - Called extremely frequently (millions of times)
   - Even optimized calculations too slow at this frequency

3. Estimated Performance
   - Current approach would take hours/days for realistic input sizes
   - Not practical for interactive use
   - Need fundamental algorithmic changes
