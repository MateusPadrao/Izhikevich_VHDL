# Implementação de Neurônio de Izhikevich em VHDL

Este projeto implementa uma arquitetura multiciclo de um modelo de neurônio de Izhikevich em hardware usando VHDL. O modelo é baseado nas equações diferenciais que descrevem o comportamento de um neurônio biológico, implementadas usando técnicas de hardware digital como shifts e somas para aproximar operações matemáticas complexas.

## Estrutura do Projeto

- **topo.vhd**: Implementação principal do neurônio, contendo todos os registradores e lógica para calcular as equações do modelo
- **(NÃO UTILIZADO) fc_cordic.vhd**: Módulo para cálculo de multiplicação usando o algoritmo CORDIC 
- **tb_topo.vhd**: Testbench para simulação do neurônio
- **teste.py**: Simulação em software do modelo de neurônio usando Python
- **teste2.py**: Simulação em software do modelo de neurônio usando Python (*segunda versão*)
- **circuito_FCCordic.png**: Diagrama do circuito implementado
- **circ.circ**: Diagrama do Logisim de uma versão com mais registradores alcançando uma latência de 6 ciclos
- **circ_original.circ**: Diagrama do Logisim com menos registradores e uma latência de 5 ciclos

## Modelo de Neurônio

O modelo de Izhikevich é descrito pelas seguintes equações:

```
dv/dt = 0.04v² + 5v + 140 - u + I
du/dt = a(bv - u)
```

Com a condição de reset:
```
if v ≥ 30 mV, then v ← c, u ← u + d
```

Onde:
- v: potencial de membrana com valor inicial em -65
- u: variável de recuperação com valor inicial em -13
- a, b, c, d: parâmetros que determinam o tipo de neurônio
- I: corrente de entrada

## Implementação em Hardware

A implementação em hardware usa:

- Representação em ponto fixo de 33 bits (1 bit de sinal, 16 bits de parte inteira, 16 bits de parte fracionária)
- Aproximação de multiplicações por constantes usando shifts e somas
- Caminho de dados com latência de 6 ciclos de clock
- Registradores para armazenar estados intermediários

## Simulação

O testbench simula o neurônio por 200 ciclos de clock (verificar se 200 são suficientes), coletando dados a cada 6 ciclos (correspondendo ao caminho crítico da arquitetura). Os resultados são gravados em um arquivo de texto para análise posterior.

## Parâmetros do Modelo

O modelo está configurado para exibir comportamento de "tonic spiking" com os seguintes parâmetros:
- a = 0.02
- b = 0.2
- c = -65 (potencial de reset)
- d = 8 (incremento de recuperação após spike)
- vth = 30 (limiar de disparo)
- I = 10