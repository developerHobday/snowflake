
## Quickstart
These queries can be run on the sample database

E.g. run the following command at the start of the worksheet - 
```sql
USE SCHEMA SNOWFLAKE_SAMPLE_DATA.TPCDS_SF10TCL;
```

The default warehouse - small - will take a long time to run the queries.
Recommended to create another virtual warehouse for optimal runtime.


## Future Queries

Report the increase of weekly store sales from one year to the next year for each store and day


Display all customers with specific buy potentials and whose dependent count to vehicle count ratio is larger
than 1.2, who in three consecutive years made purchases with between 15 and 20 items in the beginning or the
end of each month in stores located in 8 counties.


Produce a count of web sales and total shipping cost and net profit in a given 60 day period to customers in a
given state from a named web site for non returned orders shipped from more than one warehouse.


Find those stores that sold more cross-sales items from one year to another. Cross-sale items are items that are
sold over the Internet, by catalog and in store.


Compute store sales gross profit margin ranking for items, grouping by category and class, in a given year for a given list of states.


Find frequently sold items that were sold more than 4 times on any day during four consecutive years through
the store sales channel. Compute the maximum store sales made by any given customer in a period of four
consecutive years (same as above). Compute the best store customers that are in the 5th percentile of sales.
Finally, compute the total web and catalog sales in a particular month made by our best store customers buying
our most frequent store items.

