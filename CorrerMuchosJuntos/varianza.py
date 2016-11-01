import math

with open('goyo.txt') as f:
    lines = f.readlines()


print
print

promedio256 = 0 
for i in xrange(1000) :
	promedio256 = promedio256 + int(lines[i]) 

promedio256 = promedio256 / 1000

print "promedio256 " + str(promedio256)

varianza256 = 0;
lines2 = 1000
for i in xrange(1000):
	varianza256 =  (promedio256 - int(lines[i])) * (promedio256 - int (lines[i]))

print "varianza256 = " + str(varianza256/ 999)
print "desvio estandar256 = " + str(math.sqrt(varianza256/999))

print "casos  : " + str(lines2)

print
print



promedio512 = 0 
for i in xrange(1000) :
	promedio512 = promedio512 + int(lines[i+1000]) 

promedio512 = promedio512 / 1000

print "promedio512 " + str(promedio512)

varianza512 = 0;
lines2 = 1000
for i in xrange(1000):
	varianza512 =  (promedio512 - int(lines[i+1000])) * (promedio512 - int (lines[i+1000]))

print "varianza512 = " + str(varianza512/ 999)
print "desvio estandar512 = " + str(math.sqrt(varianza512/999))

print "casos  : " + str(lines2)


print
print


promedio1024 = 0 
for i in xrange(1000) :
	promedio1024 = promedio1024 + int(lines[i+2000]) 

promedio1024 = promedio1024 / 1000

print "promedio1024 " + str(promedio1024)

varianza1024 = 0;
lines2 = 1000
for i in xrange(1000):
	varianza1024 =  (promedio1024 - int(lines[i+2000])) * (promedio1024 - int (lines[i+2000]))

print "varianza1024 = " + str(varianza1024/ 999)
print "desvio estandar1024 = " + str(math.sqrt(varianza1024/999))

print "casos  : " + str(lines2)



print
print