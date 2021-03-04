import xml.etree.ElementTree as ET
import sys

dom = ET.parse('test-results-raw.xml')
testsuites = dom.getroot()

remove = []

for testsuite in testsuites:
    testsuite.attrib['timestamp'] = testsuite.attrib['start']
    del testsuite.attrib['start']

    for testcase in testsuite:
        if testcase.get('name') is None:
            testsuite.remove(testcase)
            del testcase
    
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

    
with open('test-results.xml', 'wb') as out:
    out.write(ET.tostring(testsuites))
