# visnetmws
mwshiny-based network visualization of the Le Miserables characters using the visnetwork package

## Notes

* Multi-Window Shiny is implemented in the new `mwshiny` style
* Controller, Wall and Floor views are cut in, but only the Floor has content (14 Jun 2019)
* `closed.csv` provides initial state w.r.t. which groups are closed at start-up
* `nodes.csv` and `edges.csv` define the network
* Additional "group" nodes were added (one per group) for debugging; these could be deleted

## TODO
These are a few ideas...

* Implement group details on the Wall: when a group is selected, show color-coded profiles of the characters in that group
* Implement character details on the Left Monitor
* Provide a character highlight video on the Right Monitor

## Media Sources

* For selected characters we might provide links from this site: 
https://getyarn.io/yarn-find?text=:%22Les%20Miserables%20(2012)%22 
* ...Or (better) vector into this full-length concert video:
https://www.youtube.com/watch?v=0c2sx47p31M
