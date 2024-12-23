just always add one set at a time and reconsider
add sets until the programgroup is no longer the one with the biggest deficit

indeed. i have made those tweaks. i think when adding exercises, we should try to add only the minimum amount of sets until the respective programgroup is no longer the one with the biggest deficit. we can then add some exercises with some sets, and potentially even come back and add more sets of the same exercise we have already added before

i think first of all we can use rankExercises() like in v1 to choose initial exercises, and at least initially pick out compounds (like in v1) for our initial selections.  we should then look for those programGroups that have the highest requirements. we start by picking one of those programGroups, and then "descend into the solution tree" by branching out, trying a branch for each "well fitting exercise", which is an exercise that is compound, highly ranked, and achieves a recruitment of one, for that muscle group. we increase the setcount until it is no longer the highest required programGroup. at that point we pick another programGroup and do the same. this will continue for a while

TODO: if volume reqs > 2, just calc for 2 and then scale up
- Alternative : just pick best exercises from get go. Non negotiables and high scoring ones, then ... Fill in gaps somehow and/or try adjustments
TODO: exit when cost is 0?

- Min and max num exercises that target same muscle
- Always do calc wrt 2 sets and then just scale. Be more aggro with exercise selection ? Eg top 2 or force compound in beginning
- Actually let's run it with 1 set to see if it can do a perfect score

- Add bicep curls first, but this can probably be generalized if we make sure to cover training at all muscle lengths etc
## ideas for future optimizations
- Explore most promising child first?
- if we plot score over time, perhaps we'll realize we can stop searching earlier

TODO: cost for overshooting front delt is not so high, more important to get your side delt and pec volume in