# CSV Files isbn_20180.csv  isbn_not_match.csv
# Attribution: https://www.daniweb.com/programming/software-development/threads/515345/python-compare-two-csv-files-output-differences-additions

# Read in the original and new file

# Result: in_2018_not-in-2017.csv
# orig = open('isbn_201712.csv', 'r')
# new = open('isbn_201802.csv', 'r')

# Result: in_2017_not-in-2018.csv
orig = open('isbn_201802.csv', 'r')
new = open('isbn_201712.csv', 'r')

# In new but not in orig
bigb = set(new) - set(orig)

# To see results in console if desired
print(bigb)

# Write to output file
with open('in-2017_not-in-2018.csv', 'w') as file_out:
    for line in bigb:
        file_out.write(line)
# close the files
orig.close()
new.close()
# file_out.close()




