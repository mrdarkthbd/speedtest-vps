#!/bin/bash

# Verificar se o usuário é root
if [ "$(id -u)" != "0" ]; then
    echo "Este script precisa ser executado com permissões de root."
    echo "Por favor, execute-o novamente usando 'sudo'."
    exit 1
fi

# Definir cores
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color

# Função para desenhar um retângulo com o texto centralizado
function draw_rectangle {
    local text="$1"
    local length=${#text}
    local total_length=50
    local side_length=$(( (total_length - length) / 2 ))
    printf "\n${WHITE}┌─"
    for ((i = 0; i < side_length; i++)); do
        printf "─"
    done
    printf "${GREEN}$text${WHITE}"
    for ((i = 0; i < side_length; i++)); do
        printf "─"
    done
    if (( (total_length - length) % 2 != 0 )); then
        printf "─"
    fi
    printf "─┐${NC}\n"
}

# Verificar se o speedtest-cli já está instalado
if [ -f "speedtest-cli" ]; then
    echo -e "${YELLOW}O script de teste de velocidade já está instalado.${NC}"
else
    echo "================================================="
    echo "            Baixando script de teste de velocidade"
    echo "================================================="
    wget -O speedtest-cli https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py
    chmod +x speedtest-cli
    echo "Script de teste de velocidade instalado com sucesso!"
fi

# Função para testar a velocidade da internet e exibir o link
function test_speed {
    echo -e "${GREEN}Testando velocidade da internet...${NC}"
    speedtest_result=$(./speedtest-cli --simple)
    server_id=$(echo "$speedtest_result" | grep -oP 'Hosted by \K.+(?= \()')
    server_ip=$(echo "$speedtest_result" | grep -oP '\((\d{1,3}\.){3}\d{1,3}\)')
    echo -e "${GREEN}Utilizando o servidor $server_id ($server_ip)${NC}"
    echo "$speedtest_result"
    echo -e "${GREEN}Link do resultado: https://www.speedtest.net/result/$(./speedtest-cli --share | grep -oP 'https://www.speedtest.net/result/\S+')${NC}"
    read -p "${YELLOW}Pressione Enter para retornar ao menu principal...${NC}" enter
}

# Exibir menu
function show_menu {
    clear
    draw_rectangle "Speedtest Menu"
    echo -e "${YELLOW}Selecione uma opção:${NC}"
    echo -e "${YELLOW}1. Testar velocidade da internet${NC}"
    echo -e "${YELLOW}2. Sair${NC}"
    read -p "${YELLOW}Opção: ${NC}" option

    # Executar a ação baseada na opção escolhida
    case $option in
        1)
            test_speed
            ;;
        2)
            echo -e "${YELLOW}Saindo do script...${NC}"
            exit 0
            ;;
        *)
            echo -e "${YELLOW}Opção inválida. Por favor, escolha uma opção válida.${NC}"
            read -p "${YELLOW}Pressione Enter para retornar ao menu principal...${NC}" enter
            ;;
    esac
}

# Mensagem de boas-vindas
echo -e "${YELLOW}Bem-vindo ao Speedtest CLI!${NC}"

# Executar o menu
while true; do
    show_menu
done
