# v inicial é -65
# u inicial é -13 

# tonic spiking -> c = -65, d = 8, a = 0.02, b = 0.2;
# tonic bursting -> c = -50, d = 2, a = 0.02, b = 0.2;

v = -65
u = -13

sel = int(input("Digite 0 para Tonic Spiking e 1 para Tonic Bursting: "))

if sel == 0:
    print("Tonic Spiking")
    c = -65
    d = 8
    a = 0.02
    b = 0.2
elif sel == 1:
    print("Tonic Bursting")
    c = -50
    d = 2
    a = 0.02
    b = 0.2

vth = 30 # tensão limite para disparo
I = 0.5 # corrente de entrada

while v < vth:
    if sel == 0:
        v = (0.04 * v ** 2 + 5 * v + 140 - u + I) / 1000 + v
        u = u + a * (b * v - u) / 1000 + u
    else:
        v = (0.04 * v ** 2 + 5 * v + 140 - u + I) / 1000 + v
        u = u + a * (b * v - u) / 1000 + u
    print(v, u)
    if v >= vth:
        v = c
        u = u + d
        break


