import numpy as np
import matplotlib.pyplot as plt

# Parâmetros do modelo Izhikevich
a = 0.02
b = 0.2
c = -65
d = 8

# Parâmetros de simulação
T = 100  # Tempo total de simulação em ms
dt = 0.001  # Passo de tempo
time = np.arange(0, T, dt)  # Vetor de tempo

# Corrente de entrada
I = np.full_like(time, 10)  # Corrente constante de 10 pA

# Inicializando as variáveis
v = np.full_like(time, c)  # Potencial de membrana
u = np.full_like(time, -13)  # Variável de recuperação

# Loop de integração
for t in range(1, len(time)):
    dv = (0.04 * v[t-1]**2 + 5 * v[t-1] + 140 - u[t-1] + I[t-1]) * 0.001
    du = (a * (b * v[t-1] - u[t-1])) * 0.001

    v[t] = v[t-1] + dv
    u[t] = u[t-1] + du

    if v[t] >= 30:  # Disparo
        v[t-1] = 30  # Corrigir o valor de v para o spike
        v[t] = c
        u[t] = u[t] + d

# Plotando os resultados de u, v e I
'''plt.figure(figsize=(10, 6))
plt.plot(time, v, label="Potencial de Membrana (v)")
plt.plot(time, u, label="Variável de Recuperação (u)")
plt.plot(time, I, label="Corrente de Entrada (I)", color='gray', linestyle='--')
plt.xlabel("Tempo (ms)")
plt.ylabel("v (mV)  /   u (mV)  /   I (pA)")
plt.title("Modelo do Neurônio de Izhikevich")
plt.legend()
plt.show()'''

# salvando os dados em um arquivo .txt
with open('saida_Python.txt', 'w') as f:
    for t in range(len(time)):
        f.write(f"{v[t]} {u[t]}\n")

