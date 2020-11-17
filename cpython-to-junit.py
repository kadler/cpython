import xml.etree.ElementTree as ET
import sys

if len(sys.argv) < 3:
    print(f'{sys.argv} [input xml] [output xml]')
    exit(1)

dom = ET.parse(sys.argv[1])
testsuites = dom.getroot()

remove = []

for testsuite in testsuites:
    testsuite.attrib['timestamp'] = testsuite.attrib['start']
    del testsuite.attrib['start']

    # We can't remove the testcases in a direct for loop since that
    # messes up the iterator, so we use a list comprehension and a
    # tuple to process it completely before entering this loop
    for testcase in ([_ for _ in testsuite if 'name' not in _.attrib]):
        testsuite.remove(testcase)

    if len(testsuite) == 0:
        # We can't remove now or it will mess up the outer loop
        # So we save it off to be removed later
        remove.append((testsuites, testsuite))
        continue
    
    for testcase in testsuite:
        tokens = testcase.attrib['name'].split('.')

        try:
            classname = tokens[-2]

            if classname[0].isupper():
                tokens = tokens[:-2]
            else:
                tokens = tokens[:-1]
            
            break
        except IndexError:
            continue

    testsuite.attrib['name'] = '.'.join(tokens)


    for testcase in testsuite:
        for attr in tuple(testcase.attrib.keys()):
            if attr not in ('name', 'time', 'classname', 'group'):
                testcase.attrib.pop(attr)
        
        for elem in testcase:
            if elem.tag == 'output':
                elem.tag = 'failure'
        
for parent, child in remove:
    parent.remove(child)

    
with open(sys.argv[2], 'wb') as out:
    out.write(ET.tostring(testsuites))
