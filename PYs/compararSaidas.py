import numpy as np
from sklearn.metrics import mean_absolute_error, mean_squared_error
import matplotlib.pyplot as plt
import sys

# --- Funções de Carregamento de Dados ---
# (As funções carregar_dados_vhdl e carregar_dados_python continuam as mesmas)

def carregar_dados_vhdl(caminho_arquivo):
    """
    Função personalizada para ler o arquivo de saída do VHDL.
    Ele extrai os dois últimos valores numéricos de cada linha.
    """
    valores_v = []
    valores_u = []
    print(f"Lendo arquivo VHDL: {caminho_arquivo}")
    with open(caminho_arquivo, 'r') as f:
        for num_linha, linha in enumerate(f, 1):
            if not linha.strip():
                continue
            try:
                partes = linha.split()
                valor_v = float(partes[-2])
                valor_u = float(partes[-1])
                valores_v.append(valor_v)
                valores_u.append(valor_u)
            except (ValueError, IndexError) as e:
                print(f"Aviso: Não foi possível processar a linha {num_linha} do arquivo VHDL.")
                print(f"  -> Linha: '{linha.strip()}'")
                print(f"  -> Erro: {e}")
                continue
    print(f"Leitura do VHDL concluída. {len(valores_v)} pontos de dados carregados.")
    return np.array(valores_v), np.array(valores_u)

def carregar_dados_python(caminho_arquivo):
    """
    Função para carregar o arquivo de saída do Python, pulando o cabeçalho.
    """
    print(f"Lendo arquivo Python: {caminho_arquivo}")
    try:
        dados = np.loadtxt(caminho_arquivo, skiprows=1).T
        print(f"Leitura do Python concluída. {len(dados[0])} pontos de dados carregados.")
        return dados[0], dados[1]
    except Exception as e:
        print(f"Erro fatal ao ler o arquivo Python '{caminho_arquivo}'. Verifique o formato.")
        print(f"  -> Erro: {e}")
        sys.exit(1)


# --- Configuração ---
arquivo_vhdl = 'saida_VHDL_decimal.txt'
arquivo_python = 'saida_Python_reduzida.txt'

# --- Carregamento dos Dados ---
try:
    vhdl_v, vhdl_u = carregar_dados_vhdl(arquivo_vhdl)
    python_v, python_u = carregar_dados_python(arquivo_python)
except FileNotFoundError as e:
    print(f"Erro: Arquivo não encontrado. Verifique o caminho. Detalhes: {e}")
    sys.exit()

# --- Verificação de Consistência ---
if vhdl_v.shape != python_v.shape or vhdl_u.shape != python_u.shape:
    print("\nErro: Os conjuntos de dados têm tamanhos diferentes após o carregamento!")
    print(f"Tamanho VHDL (V, U): ({vhdl_v.shape[0]}, {vhdl_u.shape[0]})")
    print(f"Tamanho Python (V, U): ({python_v.shape[0]}, {python_u.shape[0]})")
    sys.exit()

# --- Cálculo das Métricas (nenhuma mudança aqui) ---
print("\n--- Métricas de Erro para a variável V_n ---")
mae_v = mean_absolute_error(python_v, vhdl_v)
mse_v = mean_squared_error(python_v, vhdl_v)
print(f"Erro Médio Absoluto (MAE) para V_n: {mae_v:.6f}")
print(f"Erro Quadrático Médio (MSE) para V_n: {mse_v:.6f}")

print("\n--- Métricas de Erro para a variável U_n ---")
mae_u = mean_absolute_error(python_u, vhdl_u)
mse_u = mean_squared_error(python_u, vhdl_u)
print(f"Erro Médio Absoluto (MAE) para U_n: {mae_u:.6f}")
print(f"Erro Quadrático Médio (MSE) para U_n: {mse_u:.6f}")
print("-------------------------------------------")


# --- NOVA SEÇÃO DE ANÁLISE VISUAL (Gráficos separados por variável) ---

# Calcula os erros primeiro para usar nas legendas dos gráficos
erro_v = python_v - vhdl_v
erro_u = python_u - vhdl_u

# Cria uma figura com uma grade de 2x2 subplots
# Aumentamos o figsize para acomodar os 4 gráficos confortavelmente
fig, axs = plt.subplots(2, 2, figsize=(15, 10))
fig.suptitle('Análise Detalhada por Variável (VHDL vs. Python)', fontsize=16)

# --- Gráficos para V_n ---

# Gráfico 1 (Superior Esquerdo): Comparação de V_n
axs[0, 0].plot(python_v, color='blue', linestyle='-', label='V_n Python (Referência)', lw=2)
axs[0, 0].plot(vhdl_v, color='yellow', linestyle='--', label='V_n VHDL (Teste)', lw=2)
axs[0, 0].set_title('Comparação da Variável V_n')
axs[0, 0].set_ylabel('Valores de Saída')
axs[0, 0].grid(True)
axs[0, 0].legend()

# Gráfico 2 (Superior Direito): Erro em V_n
axs[0, 1].plot(erro_v, color='red', label=f'Erro em V_n (MAE: {mae_v:.4f})')
axs[0, 1].axhline(0, color='k', linestyle=':', lw=1) # Linha de erro zero
axs[0, 1].set_title('Erro na Variável V_n')
axs[0, 1].set_ylabel('Erro (Python - VHDL)')
axs[0, 1].grid(True)
axs[0, 1].legend()

# --- Gráficos para U_n ---

# Gráfico 3 (Inferior Esquerdo): Comparação de U_n
axs[1, 0].plot(python_u, color='green', linestyle='-', label='U_n Python (Referência)', lw=2)
axs[1, 0].plot(vhdl_u, color='orange', linestyle='--', label='U_n VHDL (Teste)', lw=2)
axs[1, 0].set_title('Comparação da Variável U_n')
axs[1, 0].set_xlabel('Índice da Amostra')
axs[1, 0].set_ylabel('Valores de Saída')
axs[1, 0].grid(True)
axs[1, 0].legend()

# Gráfico 4 (Inferior Direito): Erro em U_n
axs[1, 1].plot(erro_u, color='orange', label=f'Erro em U_n (MAE: {mae_u:.4f})')
axs[1, 1].axhline(0, color='k', linestyle=':', lw=1) # Linha de erro zero
axs[1, 1].set_title('Erro na Variável U_n')
axs[1, 1].set_xlabel('Índice da Amostra')
axs[1, 1].set_ylabel('Erro (Python - VHDL)')
axs[1, 1].grid(True)
axs[1, 1].legend()

# Ajusta o layout para evitar sobreposição de títulos e eixos
plt.tight_layout(rect=[0, 0.03, 1, 0.95])
plt.savefig('grafico_detalhado_por_variavel.png')

print("\nGráfico detalhado por variável salvo como 'grafico_detalhado_por_variavel.png'")