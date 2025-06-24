import numpy as np
from sklearn.metrics import mean_absolute_error, mean_squared_error
import matplotlib.pyplot as plt
import sys

# --- Funções de Carregamento e Seções Anteriores do Código ---
# (Nenhuma mudança nas seções de carregamento de dados, verificação e cálculo de métricas)

def carregar_dados_vhdl(caminho_arquivo):
    valores_v = []
    valores_u = []
    print(f"Lendo arquivo VHDL: {caminho_arquivo}")
    with open(caminho_arquivo, 'r') as f:
        for num_linha, linha in enumerate(f, 1):
            if not linha.strip(): continue
            try:
                partes = linha.split()
                valor_v = float(partes[-2])
                valor_u = float(partes[-1])
                valores_v.append(valor_v)
                valores_u.append(valor_u)
            except (ValueError, IndexError) as e:
                print(f"Aviso: Não foi possível processar a linha {num_linha} do arquivo VHDL.")
                continue
    print(f"Leitura do VHDL concluída. {len(valores_v)} pontos de dados carregados.")
    return np.array(valores_v), np.array(valores_u)

def carregar_dados_python(caminho_arquivo):
    print(f"Lendo arquivo Python: {caminho_arquivo}")
    try:
        dados = np.loadtxt(caminho_arquivo, skiprows=1).T
        print(f"Leitura do Python concluída. {len(dados[0])} pontos de dados carregados.")
        return dados[0], dados[1]
    except Exception as e:
        print(f"Erro fatal ao ler o arquivo Python '{caminho_arquivo}'.")
        sys.exit(1)

arquivo_vhdl = 'C:\\Users\\kamek\\Desktop\\FCCordic_VHDL\\saida_VHDL_decimal.txt'
arquivo_python = 'C:\\Users\\kamek\\Desktop\\FCCordic_VHDL\\saida_Python_reduzida.txt'

try:
    vhdl_v, vhdl_u = carregar_dados_vhdl(arquivo_vhdl)
    python_v, python_u = carregar_dados_python(arquivo_python)
except FileNotFoundError as e:
    print(f"Erro: Arquivo não encontrado. Detalhes: {e}")
    sys.exit()

if vhdl_v.shape != python_v.shape or vhdl_u.shape != python_u.shape:
    print("\nErro: Os conjuntos de dados têm tamanhos diferentes!")
    sys.exit()

mae_v = mean_absolute_error(python_v, vhdl_v)
mse_v = mean_squared_error(python_v, vhdl_v)
mae_u = mean_absolute_error(python_u, vhdl_u)
mse_u = mean_squared_error(python_u, vhdl_u)

print("\n--- Métricas de Erro para a variável V_n ---")
print(f"Erro Médio Absoluto (MAE) para V_n: {mae_v:.6f}")
print(f"Erro Quadrático Médio (MSE) para V_n: {mse_v:.6f}")
print("\n--- Métricas de Erro para a variável U_n ---")
print(f"Erro Médio Absoluto (MAE) para U_n: {mae_u:.6f}")
print(f"Erro Quadrático Médio (MSE) para U_n: {mse_u:.6f}")
print("-------------------------------------------")

# --- NOVA SEÇÃO DE ANÁLISE VISUAL (1 GRÁFICO POR IMAGEM) ---

print("\nGerando gráficos individuais...")

# Calcula os erros para usar nos gráficos
erro_v = python_v - vhdl_v
erro_u = python_u - vhdl_u
erro_quadratico_v = erro_v ** 2
erro_quadratico_u = erro_u ** 2

# --- Gráficos para V_n ---

# 1. Gráfico de Comparação de V_n
plt.figure(figsize=(10, 6))
plt.plot(python_v, color='blue', linestyle='-', label='V_n Python (Referência)', lw=2)
plt.plot(vhdl_v, color='red', linestyle='--', label='V_n VHDL (Teste)', lw=2)
plt.title('Comparação da Variável V_n')
plt.xlabel('Índice da Amostra')
plt.ylabel('Valores de Saída')
plt.grid(True)
plt.legend()
plt.savefig('comparacao_Vn.png')
plt.close() # Fecha a figura para liberar memória

# 2. Gráfico de Erro (base MAE) para V_n
plt.figure(figsize=(10, 6))
plt.plot(erro_v, color='red', label=f'Erro em V_n (MAE: {mae_v:.4f})')
plt.axhline(0, color='k', linestyle=':', lw=1)
plt.title('Erro na Variável V_n (Base para MAE)')
plt.xlabel('Índice da Amostra')
plt.ylabel('Erro (Python - VHDL)')
plt.grid(True)
plt.legend()
plt.savefig('erro_absoluto_Vn.png')
plt.close()

# 3. Gráfico de Erro Quadrático (base MSE) para V_n
plt.figure(figsize=(10, 6))
plt.plot(erro_quadratico_v, color='purple', label=f'Erro Quadrático em V_n (MSE: {mse_v:.4f})')
plt.axhline(0, color='k', linestyle=':', lw=1)
plt.title('Erro Quadrático na Variável V_n (Base para MSE)')
plt.xlabel('Índice da Amostra')
plt.ylabel('Erro ao Quadrado')
plt.grid(True)
plt.legend()
plt.savefig('erro_quadratico_Vn.png')
plt.close()

# --- Gráficos para U_n ---

# 4. Gráfico de Comparação de U_n
plt.figure(figsize=(10, 6))
plt.plot(python_u, color='green', linestyle='-', label='U_n Python (Referência)', lw=2)
plt.plot(vhdl_u, color='orange', linestyle='--', label='U_n VHDL (Teste)', lw=2)
plt.title('Comparação da Variável U_n')
plt.xlabel('Índice da Amostra')
plt.ylabel('Valores de Saída')
plt.grid(True)
plt.legend()
plt.savefig('comparacao_Un.png')
plt.close()

# 5. Gráfico de Erro (base MAE) para U_n
plt.figure(figsize=(10, 6))
plt.plot(erro_u, color='orange', label=f'Erro em U_n (MAE: {mae_u:.4f})')
plt.axhline(0, color='k', linestyle=':', lw=1)
plt.title('Erro na Variável U_n (Base para MAE)')
plt.xlabel('Índice da Amostra')
plt.ylabel('Erro (Python - VHDL)')
plt.grid(True)
plt.legend()
plt.savefig('erro_absoluto_Un.png')
plt.close()

# 6. Gráfico de Erro Quadrático (base MSE) para U_n
plt.figure(figsize=(10, 6))
plt.plot(erro_quadratico_u, color='brown', label=f'Erro Quadrático em U_n (MSE: {mse_u:.4f})')
plt.axhline(0, color='k', linestyle=':', lw=1)
plt.title('Erro Quadrático na Variável U_n (Base para MSE)')
plt.xlabel('Índice da Amostra')
plt.ylabel('Erro ao Quadrado')
plt.grid(True)
plt.legend()
plt.savefig('erro_quadratico_Un.png')
plt.close()

print("Seis arquivos de imagem foram gerados com sucesso.")