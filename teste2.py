import numpy as np
import matplotlib.pyplot as plt

# Parâmetros do modelo Izhikevich (mesmos do hardware)
a = 0.02
b = 0.2
c = -65
d = 8

# Parâmetros de simulação
T = 5000  # Tempo total de simulação em ciclos (como no testbench)
dt = 0.1  # Um ciclo por iteração
time = np.arange(0, T, dt)  # Vetor de tempo -> 0 a 200 de 1 em 1 (ciclos)
dt_real = 0.001  # Passo de tempo real para as equações diferenciais

# Corrente de entrada constante (aumentada para provocar disparos)
I = np.zeros_like(time)
I[1000:50000] = 10

# Inicializando as variáveis
v = np.full_like(time, c)  # Potencial de membrana
u = np.full_like(time, -13)  # Variável de recuperação (valor inicial do hardware)

# Loop de integração
for t in range(1, len(time)):
    #if (t-1) % 6 == 0:  # Atualiza apenas a cada 6 ciclos como no hardware
        # Calcular apenas nos ciclos múltiplos de 6
        dv = (0.04 * v[t-1]**2 + 5 * v[t-1] + 140 - u[t-1] + I[t-1]) * dt_real
        du = (a * (b * v[t-1] - u[t-1])) * dt_real

        v[t] = v[t-1] + dv
        u[t] = u[t-1] + du

        if v[t] >= 30:  # Disparo (vth = 30)
            v[t] = c
            u[t] = u[t] + d
    #else:
        # Manter valores anteriores nos ciclos intermediários
     #   v[t] = v[t-1]
     #   u[t] = u[t-1]

# Filtrar apenas os pontos a cada 6 ciclos (como no testbench)
indices = np.arange(0, T, 6)
time_filtered = time[indices]
v_filtered = v[indices]
u_filtered = u[indices]

# Plotando os resultados
plt.figure(figsize=(10, 6))
plt.plot(time_filtered, v_filtered, 'o-', label="Potencial de Membrana (v)")
plt.plot(time_filtered, u_filtered, 'o-', label="Variável de Recuperação (u)")
plt.xlabel("Ciclos")
plt.ylabel("v (mV)  /   u (mV)")
plt.title("Modelo do Neurônio de Izhikevich (Simulação aproximada ao hardware)")
plt.legend()
plt.grid(True)
plt.show()

# Salvar os dados em um arquivo para comparação com o hardware
'''with open('saida_simulacao.txt', 'w') as f:
    f.write("Ciclo,v_n,u_n\n")
    for i, t in enumerate(time_filtered):
        f.write(f"{int(t)},{v_filtered[i]},{u_filtered[i]}\n")'''