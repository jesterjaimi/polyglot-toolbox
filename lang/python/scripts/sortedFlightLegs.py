## This is the text editor interface. 
## Anything you type or change here will be seen by the other person in real time.

## INPUT::

## ATL - NC
## EWR - DAL
## NC - FL
## DAL - ATL

## OUTPUT::

## EWR - DAL
## DAL - ATL
## ATL - NC
## NC - FL


# FUNCTION CALL: sortFlightLegs('EWR', 'FL', [('ATL', 'NC'), ('EWR', 'DAL'), ('NC', 'FL'), ('DAL', 'ATL')])

# EXPECTED RETURN VALUE: [('EWR', 'DAL'), ('DAL', 'ATL'), ('ATL', 'NC'), ('NC', 'FL')]


# origin: String
# destination: String
# flightLegs: List of Tuple(origin: String, destination: String)

"""
f_leg_dest = next_leg[0]
leg_dest = next_leg[1]
print("leg_orig: ", leg_orig)
print("leg_dest: ", leg_dest)
for leg3 in flightLegs:
"""
def sortFlightLegs(origin, destination, flightLegs):
    sortedLegs = []
    prev_leg = ('', '')
    leg_dest = ''
    
    for leg in flightLegs:
        if leg[0] == origin:
            first_leg = leg
            leg_dest = leg[1]
            sortedLegs.append(first_leg)
        else:
            for next_leg in flightLegs:
                if next_leg[0] == leg_dest:
                    leg_dest = next_leg[1]
                    sortedLegs.append(next_leg)
                        
    return sortedLegs

print (sortFlightLegs('EWR', 'FL', [('ATL', 'NC'), ('EWR', 'DAL'), ('NC', 'FL'), ('DAL', 'ATL')]))