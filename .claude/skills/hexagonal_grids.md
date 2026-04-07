---
name: hexagonal-grids
description: Definition on manipulation data in hexagonal grids. Use when code is represented in hexagonal grids, or operations are being done with hexagonal grids.
---

# Coordinates

Hexagonal grids can have multiple coordinate systems, cube coordinates are good for algorithms and axial or double coordinates are good for storage.

## Cube Coordinates
Taking a 3 dimensional cube and slicing it diagonally where `x + y + z = 0` allow us to use a 3 dimensional cartesian plane to work with coordinates.
Keeping the naming mentioned above, we have cols (q), rows (r), and a new dimension (s), where q + r + s = 0.

## Axial Coordinates
The axial coordinate system, sometimes called "trapezoidal" or "oblique" or "skewed", is the same as the cube system except we don't store the s coordinate.
Since we have a constraint q + r + s = 0, we can calculate s = -q-r when we need it.

The axial/cube system allows us to add, subtract, multiply, and divide with hex coordinates. The offset coordinate systems do not allow this, and that's part of what makes algorithms simpler with axial/cube coordinates. 

# Coordinate conversion
Converting between Axial and Cube coordinates is just a matter of calculating the value of `s` using the formula: `s = -r-q`

# Hexagonal directions vectors
Hexes have 6 sides, so we can create a path from them moving in the direction of one of each of those 6 sides.
We have vectors to express each one of the 6 sides:
- (1,0,-1)
- (1,-1,0)
- (0,-1,1)
- (-1,0,1)
- (-1,1,0)
- (0,1,-1)

# Neighbor hexes

## Cube Coordinates
The neighbor of a hex in cube coordinates can be found changing in one unit, one of the three coordinates of the system, and reducing other one, also by one unit, so the sum can remain 0.
Example: for a hex at (0,0,0) we have the following neighbors:
- (1,0,-1)
- (1,-1,0)
- (0,-1,1)
- (-1,0,1)
- (-1,1,0)
- (0,1,-1)

## Axial Coordinates
Same as cube coordinates but without the third coordinate

# Distances

## Cube coordinates
Distance between two hexes, `a` and `b`, can be found using the formula: `(abs(a.q - b.q) + abs(a.r - b.r) + abs(a.s - b.s)) / 2`

## Axial coordinates
Just convert the axial coordinates to cube coordinates using the forumula: `s = -r-q` and then calculate the distance using Cube coordinates.

# Movement Range
Given a hex as origin point, and an integer range N, we can find all hexes within that range from the origin, with the following pseudo code:
```
var results = []
for each -N ≤ q ≤ +N:
    for each max(-N, -q-N) ≤ r ≤ min(+N, -q+N):
        var s = -q-r
        results.append(cube_add(origin, (q, r, s)))
```

where q, r, s are the cube coordinates of the origin hex, named `origin` and `cube_add` is a function that adds the vectors of both hexes coordinates.

# Rotation
Use these steps to rotate a hex named `origin`, based on another hex named `center`, to new coordinates, named `rotated`:
1. Convert `origin` and `center` coordinates to cube coordinates
2. Calculate a vector subtracting the center: (origin.q - center.q, origin.r - center.r, origin.s - center.s)
3. Rotate the vector, in steps of 60 degrees by applying: `rotated_vector.q = -vector.r; rotated_vector.r = -vector.s; rotated_vector.s = -vector.q;`
4. Convert the vector back to a position by adding the center cube coordinates again: (rotated_vector.q + center.q, rotated_vector.r + center.r, rotated_vector.s + center.s)
5. IF NEEDED, convert the cube coordinates back to the original coordinate system that was passed

# Rings
A ring is defined by a list of hexes that have the same distance N, from a `center` hex. We call this distance N, `radius`.

## Ring pertinence
To find if a given `hex` is on a ring of a given `radius`, calculate the distance from that `hex` to the given center, and check if its equal to `radius`.

## Get hex list for Ring with radius N > 0
To list all hexes in a ring with `radius` > 0, around a hex `center`, follow the steps:
1. Convert `center` coordinates to cube coordinates
2. Find direction vector, by arbitrarily taking one of the six hexagonal directions, and scaling it to the `radius`, with: `(vector.q * radius, vector.r * radius, vector.s * radius)`
3. Convert the direction vector back to a position, by adding the center coordinates to it: `(center.q + direction_vector.q, center.r + direction_vector.r, center.s + direction_vector.s)`, this will be the first hex in the ring
4. For each hexagonal direction, and for each number J in the range 0 <= J < `radius`, add the current hex to the list of results, and replace the current hex, with the neighbor hex in the current hexagonal direction, with: (current_hex.q + hexagonal_direction.q, current_hex.r+hexagonal_direction.r, current_hex.s+hexagonal_direction.s)

# Reference
More information can be found [here](https://www.redblobgames.com/grids/hexagons/)
