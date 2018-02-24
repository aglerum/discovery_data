# CSV Files isbn_201802_test.csv  isbn_not_match_test.csv
# Attribution: https://www.daniweb.com/programming/software-development/threads/515345/python-compare-two-csv-files-output-differences-additions

# Read in the original and new file
# orig = open('isbn_not_match_test.csv', 'r')
# new = open('isbn_201802_test.csv', 'r')
#orig = open('isbn_201712.csv', 'r')
#new = open('isbn_201802.csv', 'r')

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




